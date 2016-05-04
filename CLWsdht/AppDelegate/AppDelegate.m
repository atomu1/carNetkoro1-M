//
//  AppDelegate.m
//  CLW
//
//  Created by majinyu on 16/1/9.
//  Copyright © 2016年 cn.com.cucsi. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "MacroUD.h"
#import "UserInfo.h"
#import "AddressGroupJSONModel.h"
#import "AddressJSONModel.h"
#import "MJYUtils.h"
#import "BaseHeader.h"
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>
#import "MacroNotification.h"
#import "UIViewController+WeChatAndAliPayMethod.h"
#import "JPUSHService.h"
#import "CeShiViewController.h"
#import "ReleaseMainOrderViewController.h"

@interface AppDelegate ()<
CLLocationManagerDelegate,WXApiDelegate
>{
    
    CLLocationManager *locationManager;
    BMKMapManager* _mapManager;
    
    NSMutableDictionary *_toUpdateNameDic;
    NSDictionary *_newVerDic;
    NSMutableDictionary *_toUpdateVerDic;
    NSMutableArray *cityInfoArr;//{经度、纬度、省、市、区}
}

@end

@implementation AppDelegate


- (NSDictionary *)preDealVers:(NSArray *)vers {
    
    NSMutableDictionary *verDic = [[NSMutableDictionary alloc] init];
    
    
    NSString *tempBrandVer = @"";
    NSString *tempModelVer = @"";
    
    
    for (NSDictionary *tempVerDic in vers) {
        
        NSString *name = tempVerDic[@"Name"];
        NSString *ver = tempVerDic[@"Ver"];
        
        if ([@"CarBrand" isEqualToString:name]) {
            
            tempBrandVer = ver;
        }
        else if ([@"CarModel" isEqualToString:name]) {
            
            tempModelVer = ver;
        }
        else {
            
            [verDic setValue:ver forKey:name];
        }
    }
    
    if (![@"" isEqualToString:tempBrandVer] && ![@"" isEqualToString:tempModelVer]) {
        
        NSString *name = @"CarBrandCarModel";
        NSString *ver = [NSString stringWithFormat:@"%@-%@", tempBrandVer, tempModelVer];
        [verDic setValue:ver forKey:name];
    }
    
    return verDic;
}

- (void)updateDataDictionary {
    
    
    _toUpdateNameDic = [[NSMutableDictionary alloc] init];
    _toUpdateVerDic = [[NSMutableDictionary alloc] init];
    
    [_toUpdateVerDic setObject:@"Dic.asmx/GetCarBrand" forKey:@"CarBrandCarModel"];
    [_toUpdateVerDic setObject:@"Dic.asmx/GetPartsUseFor" forKey:@"PartsUseFor"];
    [_toUpdateVerDic setObject:@"Dic.asmx/GetColour" forKey:@"Colour"];
    [_toUpdateVerDic setObject:@"Dic.asmx/GetPartsSrc" forKey:@"PartsSrc"];
    [_toUpdateVerDic setObject:@"Dic.asmx/GetPurity" forKey:@"Purity"];
    [_toUpdateVerDic setObject:@"Dic.asmx/GetProvincial" forKey:@"Provincial"];
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,k_url_Dic_GetDicVer];
    
    [self.httpManager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //http请求状态
        if (task.state == NSURLSessionTaskStateCompleted) {
            
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSString *dealedResponseString = [responseString stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
            NSData *responseData = [dealedResponseString dataUsingEncoding:NSUTF8StringEncoding];
            
            
            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseData];
            NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
            if ([status isEqualToString:@"1"]) {
                [SVProgressHUD showErrorWithStatus:@"接口应答成功"];
                
                // 各类字典数据的版本号集合
                NSArray *vers = jsonDic[@"Data"][@"DicVer"];
                NSDictionary *verDic = [self preDealVers:vers];
                // 缓存起来，待更新完成时，替换原文件
                _newVerDic = verDic;
                
                NSLog(@"verDic = %@", verDic);
                
                // 判断文档目录下的 dicVer.plist 是否存在
                NSString *verFilePath = [DocumentBasePath stringByAppendingString:@"/dicVer.plist"];
                NSLog(@"verFilePath = %@", verFilePath);
                BOOL result = [FileManager fileExistsAtPath:verFilePath];
                if (result) {
                    
                    // 存在，则对比哪些需要更新
                    NSDictionary *orgVerDic = [[NSDictionary alloc] initWithContentsOfFile:verFilePath];
                    for (NSString *key in [verDic allKeys]) {
                        
                        NSString *ver = verDic[key];
                        NSString *orgVer = orgVerDic[key];
                        
                        // 原版本号集合中没有这个分类，则一定要更新
                        // 原版本号与新版本号不同，则一定要更新
                        if (nil == orgVer || ![ver isEqualToString:orgVer]) {
                            
                            [_toUpdateNameDic setObject:@"" forKey:key];
                        }
                        
                    }
                    
                }
                else {
                    
                    // 不存在，则所有项一定要更新
                    [_toUpdateNameDic setDictionary:verDic];
                }
                
                
                // 根据 _toUpdateNameDic 中的分类名称来确定哪些需要更新
                for (NSString *key in [_toUpdateVerDic allKeys]) {
                    
                    [self downloadNewData:key];
                }
                
                
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:k_Error_Network];
    }];
}

- (void)downloadNewData:(NSString *)verName {
    
    NSString *dicName = verName;//@"CarBrandCarModel";
    if ([[_toUpdateNameDic allKeys] containsObject:dicName]) {
        
        NSString *partUrl = _toUpdateVerDic[verName];
        NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BASEURL,partUrl];
        NSLog(@"urlStr = %@", urlStr);
        
        [self.httpManager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //http请求状态
            if (task.state == NSURLSessionTaskStateCompleted) {
                
                NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSString *dealedResponseString = [responseString stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
                NSData *responseData = [dealedResponseString dataUsingEncoding:NSUTF8StringEncoding];
                
                
                NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseData];
                NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
                if ([status isEqualToString:@"1"]) {
                    [SVProgressHUD showErrorWithStatus:@"接口应答成功"];
                    
                    // 各类字典数据的版本号集合
                    NSArray *datas = jsonDic[@"Data"];
                    
                    
                    // 保存最新版本号
                    NSString *dataFilePath = [DocumentBasePath stringByAppendingFormat:@"/%@.plist", dicName];
                    NSLog(@"dataFilePath = %@", dataFilePath);
                    BOOL result = [datas writeToFile:dataFilePath atomically:YES];
                    if (result) {
                        
                        // 同步
                        @synchronized(self) {
                            
                            [self overrideVerFile:verName];
                        }
                    }
                    else {
                        
                        
                    }
                }
                
                
            }
            
            
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [SVProgressHUD showErrorWithStatus:k_Error_Network];
        }];
    }
    
}

- (void)overrideVerFile:(NSString *)verName {
    
    // 更新完一个移除一个
    [_toUpdateVerDic removeObjectForKey:verName];
    if ([_toUpdateVerDic allKeys].count == 0) {
        
        // 保存最新版本号
        NSString *verFilePath = [DocumentBasePath stringByAppendingString:@"/dicVer.plist"];
        BOOL result = [_newVerDic writeToFile:verFilePath atomically:YES];
        if (result) {
            
            
        }
        else {
            
            
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [WXApi registerApp:APP_ID withDescription:@"demo 2.0"];
    /**
     * 初始化首页(tabbarVC)
     */
    self.window  = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    BaseTabBarController *tabVC = [[BaseTabBarController alloc] init];
    self.window.rootViewController = tabVC;
    [self.window makeKeyAndVisible];
    
    _endLocaltion=0;
    [self initProperty];
    cityInfoArr=[[NSMutableArray alloc]initWithCapacity:6];
    
    [self updateDataDictionary];
    
    
    /**
     * 百度地图
     */
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    BOOL ret = [_mapManager start:k_BMAP_KEY  generalDelegate:nil];
    if (!ret) {
        NSLog(@"定位服务失败");
    } else {
        NSLog(@"定位服务正常");
    }
    
    [self loaction];
    
    //极光推送
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0){
            //可以添加自定义categories
            [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge|
                                                              UIUserNotificationTypeSound|
                                                              UIUserNotificationTypeAlert)categories:nil];
    }
    else {
            //categories 必须为nil
            [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|
                                                              UIRemoteNotificationTypeSound|
                                                              UIRemoteNotificationTypeAlert)categories:nil];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PushConfig" ofType:@"plist"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSString *channel = [dict objectForKey:@"CHANNEL"];
    NSString *appKey = [dict objectForKey:@"APP_KEY"];
    //JAppKey : 是你在极光推送申请下来的appKey Jchannel : 可以直接设置默认值即可 Publish channel
    [JPUSHService setupWithOption:launchOptions
                           appKey:appKey
                          channel:channel
                 apsForProduction:YES];//如果是生产环境应该设置为YES
    
    //获取自定义消息里的内容
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    return YES;
}

#pragma mark -- 获取自定义消息里的内容
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
    NSLog(@"推送内容 = %@",content);
    NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    _jPushDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if (_jPushDict != nil) {
        // 取得ios系统唯一的全局的广播站 通知中心
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        //设置广播内容
        //将内容封装到广播中 给ios系统发送广播
        // ChangeTheme频道
        [nc postNotificationName:@"ChangeTheme" object:self userInfo:_jPushDict];
    }
}


#pragma mark -- Jpush极光推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {    // Required
    [JPUSHService registerDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"推送消息"
                                                            message:alert
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService handleRemoteNotification:userInfo];
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    /*
     9000 订单支付成功
     8000 正在处理中
     4000 订单支付失败
     6001 用户中途取消
     6002 网络连接出错
     */
    //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
    if ([url.host isEqualToString:@"safepay"])
    {
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      NSLog(@"result = %@",resultDic);
                                                  }];
        
    }
    
    if ([url.host isEqualToString:@"platformapi"])
    {//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic)
         {
             NSLog(@"result = %@",resultDic);
         }];
    }
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay",APP_ID]].location != NSNotFound) {
        return  [WXApi handleOpenURL:url delegate:self];
    }else{
        return [ShareSDK handleOpenURL:url
                            wxDelegate:self];
    }
    return YES;
    
    
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "cn.com.cucsi.CLW" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CLW" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CLW.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - init Propertys

/**
 *  初始化应用程序的属性
 */
- (void) initProperty
{
    self.httpManager = [AFHTTPSessionManager manager];
    self.httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //self.currentCity = @"选择城市";
    [self std_readCityInfo];
    self.currentCityID = [self std_getCityId:self.currentCity];
}

/**
 *  开启定位服务
 */
- (void)loaction
{
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
}

#pragma mark - CoreLocation Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    
    NSString * longtmp = [NSString stringWithFormat:@"%g",currentLocation.coordinate.longitude];
    NSString * latitudetmp = [NSString stringWithFormat:@"%g",currentLocation.coordinate.latitude];
    cityInfoArr[0]=longtmp;
    cityInfoArr[1]=latitudetmp;
    //获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error) {
        if (_endLocaltion==0) {
            if (array.count >0) {
                CLPlacemark *placemark = [array objectAtIndex:0];
                //获取城市
                NSString *city = placemark.locality;
                NSLog(@"当前城市 = %@",city);
                _endLocaltion=1;
                NSString *province = placemark.administrativeArea;
                
                
                if (!city) {
                    //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                    city = placemark.administrativeArea;
                }
                [self std_readCityInfo];
                if (![_currentCity isEqualToString:city]) {
                    cityInfoArr[2]=province;
                    cityInfoArr[3]=city;
                    cityInfoArr[4]=placemark.subLocality;
                    [[[UIAlertView alloc] initWithTitle:@"提示：" message:k_HintMessage_Local_AppDelegate delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
                    
                    
                }
            } else if (error ==nil && [array count] ==0) {
                NSLog(@"No results were returned.");
            } else if (error !=nil) {
                NSLog(@"An error occurred = %@", error);
            }
        }
        
    }];
    
    /**
     * 初始化自身属性
     */
    
    
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        if ([alertView.message isEqualToString:k_HintMessage_Local_AppDelegate]) {//更换城市为自动定位获得的
            _currentLong= cityInfoArr[0];
            _currentLat= cityInfoArr[1];
            _currentProvince = cityInfoArr[2];
            _currentCity=cityInfoArr[3];
            [self std_setCityId:cityInfoArr[3]];//设置城市id
            [self std_saveCityInfo:cityInfoArr[3] MySubLocality:cityInfoArr[4]];//保存city和区
            [[NSNotificationCenter defaultCenter]postNotificationName:k_Notification_CityBtnName_Home object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:k_Notification_CityBtnName_Shop object:nil];
        }
    }
    else if(buttonIndex==0)//定位失败，需要手动设置
    {
        if ([alertView.message isEqualToString:k_HintMessage_NoLocal_AppDelegate])
            [[NSNotificationCenter defaultCenter]postNotificationName:k_Notification_CitySelect_Home object:nil];
    }
    
    
}
-(void)std_saveCityInfo:(NSString*)cityName MySubLocality:(NSString*)subStr{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:subStr forKey:@"area_country"];
    [defaults setObject:cityName forKey:@"city"];
    [defaults synchronize];
}
-(void)std_saveCityName:(NSString*)cityName{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:cityName forKey:@"city"];
    [defaults synchronize];
}

-(void)std_readCityInfo{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    _currentCity = [user objectForKey:@"city"];
}
-(void)std_setCityId:(NSString*)defaultCity{
    if (defaultCity) {
        self.currentCity=defaultCity;
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"提示：" message:k_HintMessage_NoLocal_AppDelegate delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
    }
    self.currentCityID=[self std_getCityId:self.currentCity];
}
-(NSString*)std_getCityId:(NSString*)cityName{
    NSMutableArray * maAddressInfos = [MJYUtils mjy_JSONAddressInfos];
    for (AddressGroupJSONModel *groupModel in maAddressInfos) {
        for (AddressJSONModel *address in groupModel.cities) {
            if ([address.city_name isEqualToString:_currentCity]) {
                return address.city_id;
            }
        }
    }
    return nil;
}
//检测是何种原因导致定位失败
- (void)locationManager: (CLLocationManager *)manager
       didFailWithError: (NSError *)error {
    
    NSString *errorString;
    [manager stopUpdatingLocation];
    NSLog(@"Error: %@",[error localizedDescription]);
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            errorString = @"Access to Location Services denied by user";
            //Do something...
            [[[UIAlertView alloc] initWithTitle:@"提示：" message:@"请打开该app的位置服务!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
            break;
        case kCLErrorLocationUnknown:
            [self std_setCityId:nil];
            //Probably temporary...
            //            errorString = @"Location data unavailable";
            //            [[[UIAlertView alloc] initWithTitle:@"提示：" message:@"位置服务不可用!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
            //Do something else...
            break;
        default:
            errorString = @"An unknown error has occurred";
            [[[UIAlertView alloc] initWithTitle:@"提示：" message:@"定位发生错误!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
            break;
    }
}
@end
