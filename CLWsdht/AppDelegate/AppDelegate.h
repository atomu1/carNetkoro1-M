//
//  AppDelegate.h
//  CLW
//
//  Created by majinyu on 16/1/9.
//  Copyright © 2016年 cn.com.cucsi. All rights reserved.
//

//#define BASEURL @"http://192.168.0.237:8787/"
#define BASEURL @"http://115.28.133.3:9457/"
#define k_BMAP_KEY @"eIcyUlbCgFvAOnZL6jSIFiIy"//百度地图key



#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import "AFNetworking.h"//网络请求三方

@class UserInfo;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) UITabBarController *tabbarController;

/**
 *  网络请求单例
 */
@property (strong, nonatomic) AFHTTPSessionManager *httpManager;

/**
 *  是否登录的状态
 */
@property (assign, nonatomic) BOOL isLogin;
@property (weak, nonatomic) UIViewController *loginViewController;

/**
 *  用户信息
 */
@property (strong, nonatomic) UserInfo *userInfo;

/**
 *  当前城市
 */
@property (copy, nonatomic) NSString *currentCity;
/**
 *  当前城市ID
 */
@property (copy, nonatomic) NSString *currentCityID;

/**
 *  当前省
 */
@property (copy, nonatomic) NSString *currentProvince;

/**
 *  当前经度
 */
@property (copy, nonatomic) NSString *currentLong;

/**
 *  当前纬度
 */
@property (copy, nonatomic) NSString *currentLat;

/**
 *  推送获取的数据
 */
@property (copy, nonatomic) NSDictionary *jPushDict;


/*
 *定位代理去重计数
 */
@property (assign, nonatomic) NSInteger endLocaltion;

@property (readonly, strong, nonatomic) NSManagedObjectContext       *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel         *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(void)std_readCityInfo;
-(void)std_saveCityName:(NSString*)cityName;
@end

