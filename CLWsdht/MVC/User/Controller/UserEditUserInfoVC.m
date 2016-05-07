//
//  UserEditUserInfoVC.m
//  CLWsdht
//
//  Created by clish on 16/4/18.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "UserEditUserInfoVC.h"
#import "UserInfo.h"
#import "CityListVC.h"//城市选择
#import "AddressJSONModel.h"//地址信息模型

@interface UserEditUserInfoVC ()<
UITextViewDelegate,
UIAlertViewDelegate,
UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>
{
    UIView *picUVBase;//选择控件是容器视图
    NSString *city_Id;
    BOOL hasUserCity;
    UIButton *btnAddress;
    UserInfo * usInfo;
    UITextField * txtName;
    UIImage *UImgMyImg;//头像
    UIButton * btnMyImg;//头像按钮
    BOOL hasUserImage;//是否上传了头像
}


@end

@implementation UserEditUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"用户详细信息";
    usInfo = [[UserInfo alloc]init];
    usInfo.user_Id = [ApplicationDelegate.userInfo.user_Id mutableCopy];
    usInfo.CityId = [ApplicationDelegate.userInfo.CityId mutableCopy];
    usInfo.CityName = [ApplicationDelegate.userInfo.CityName mutableCopy];
    usInfo.Address = [ApplicationDelegate.userInfo.Address mutableCopy];
    usInfo.Name = [ApplicationDelegate.userInfo.Name mutableCopy];
    usInfo.Mobile = [ApplicationDelegate.userInfo.Mobile mutableCopy];
    city_Id = ApplicationDelegate.userInfo.CityId;
    
    //头像 按钮
    CGFloat MyImgSize = 50;
    NSString *url =ApplicationDelegate.userInfo.Url;
    UImgMyImg = [[UIImage  alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL  URLWithString:url]]];
    btnMyImg = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-MyImgSize)/2,20,MyImgSize,MyImgSize)];
    [btnMyImg setBackgroundImage:UImgMyImg forState:UIControlStateNormal];
    btnMyImg.layer.masksToBounds = YES;
    btnMyImg.layer.cornerRadius =MyImgSize/2;
    [btnMyImg addTarget:self action:@selector(BtnAction:) forControlEvents:UIControlEventTouchUpInside ];
    btnMyImg.tag = 0;
    [self.view addSubview:btnMyImg];
    
    
    //头像下在的线
    UIView *Line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 0.5)];
    Line1.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [self.view addSubview:Line1];
    
    UILabel *lblAddress = [[UILabel alloc]initWithFrame:CGRectMake(10, 105, 100, 30)];
    lblAddress.text = @"所在城市";
    [self.view addSubview:lblAddress];
    
    
    btnAddress = [[UIButton alloc]initWithFrame:CGRectMake(110, 105, self.view.frame.size.width-120, 30)];
    btnAddress.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btnAddress setTitle:ApplicationDelegate.userInfo.CityName forState:UIControlStateNormal];
    [btnAddress setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnAddress addTarget:self action:@selector(SelectCity:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnAddress];
    
    //城市下面的线
    UIView *Line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 140, self.view.frame.size.width, 0.5)];
    Line2.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [self.view addSubview:Line2];
    
    UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(10, 145, 50, 30)];
    lblName.text = @"姓名";
    [self.view addSubview:lblName];
    
    txtName = [[UITextField alloc]initWithFrame:CGRectMake(60, 145, self.view.frame.size.width-70, 30)];
    txtName.textAlignment = NSTextAlignmentRight;
    txtName.placeholder = @"请输入姓名";
    txtName.text = ApplicationDelegate.userInfo.Name;
    [self.view addSubview:txtName];
    
    //姓名下面的线
    UIView *Line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 180, self.view.frame.size.width, 0.5)];
    Line3.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [self.view addSubview:Line3];
    
    //保存按扭
    UIButton * btnOK= [[UIButton alloc]initWithFrame:CGRectMake(13, 185, self.view.frame.size.width - 26, 30)];
    [btnOK setTitle:@"保存" forState:UIControlStateNormal];
    [btnOK addTarget:self action:@selector(setOKAction:) forControlEvents:UIControlEventTouchUpInside];
    btnOK.backgroundColor = [UIColor grayColor];
    btnOK.layer.cornerRadius = 5.0;
    [self.view addSubview:btnOK];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserAddressInfo:)
                                                 name:k_Notification_UpdateUserAddressInfo_Home
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:k_Notification_UpdateUserAddressInfo_Home
                                                  object:nil];
}

#pragma mark *** 通知中心方法 ***
/**
 *  更新用户地址选择
 *
 *  @param noti
 */
- (void)updateUserAddressInfo:(NSNotification *)noti
{
    AddressJSONModel *addressModel = noti.object;
    city_Id = addressModel.city_id;
    [btnAddress setTitle:[NSString stringWithFormat:@"%@>",addressModel.city_name] forState:UIControlStateNormal];
    usInfo.CityId =addressModel.city_id;
    usInfo.CityName =addressModel.city_name;
    hasUserCity = YES;
}
/**
 *  头像选择
 *
 *  @param sender <#sender description#>
 */
-(void) BtnAction:(id)sender
{
    //创建对象
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"提示"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"照相机",@"相册",
                                  nil];
    //展示对象
    [actionSheet showInView:self.view];

    NSLog(@"头像按钮");
}
#pragma mark *** UIActionSheetDelegate ***
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //相机
        [self openPhotoWithCamera];
    } else if (buttonIndex == 1) {
        //相册
        [self openPhotoWithAlbum];
    } else {
        //取消
    }
}
#pragma mark *** 自定义方法 ***
//照相事件
- (void)openPhotoWithCamera {
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;//设置类型为相机
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;//设置代理
        picker.allowsEditing = YES;//设置照片可编辑
        picker.sourceType = sourceType;
        picker.videoQuality = UIImagePickerControllerQualityTypeLow;//分辨率(低)
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;//选择前置摄像头或后置摄像头
        [self presentViewController:picker animated:YES completion:^{}];
    } else {
        NSLog(@"该设备无相机");
    }
    
}

//打开相册
-(void)openPhotoWithAlbum{
    
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;//设置照片可编辑
    pickerImage.videoQuality =    UIImagePickerControllerQualityTypeLow;
    [self presentViewController:pickerImage animated:YES completion:^{}];
    
}
#pragma mark *** ImagePickerViewController Delegate ***
//从相册选择图片后操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    //保存裁剪图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //上传用户头像信息
    [self postUserHeadImageToNetworkWithImage:image];
    
}

/**
 *  城市选择
 *
 *  @param sender <#sender description#>
 */
-(void)SelectCity:(id)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    CityListVC *vc = [sb instantiateViewControllerWithIdentifier:@"CityListVC"];
    vc.vcType = 2;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{}];
 }

/**
 *  保存个人信息
 *
 *  @param sender
 */
-(void)setOKAction:(id) sender
{
    if(txtName.text.length<=0)
    {
        [SVProgressHUD showErrorWithStatus:@"姓名不能为空"];
    }
    usInfo.Name = txtName.text;
    [self setEditUserInfo];
    NSLog(@"保存");
}

/**
 *  上传用户头像信息
 */
- (void) postUserHeadImageToNetworkWithImage:(UIImage *)image
{
    [SVProgressHUD showWithStatus:k_Status_UpLoad maskType:SVProgressHUDMaskTypeBlack];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,k_url_AddImg];
    
    NSDictionary *paramDict = @{
                                @"Id":[MJYUtils mjy_uuid],//这个字段需要每次不同
                                @"dataId":ApplicationDelegate.userInfo.user_Id,//必须是用户的id
                                @"isSingle":@"true",
                                @"isFirst":@"true"
                                };
    [ApplicationDelegate.httpManager POST:urlStr parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
        [formData appendPartWithFileData:imageData name:ApplicationDelegate.userInfo.user_Id fileName:ApplicationDelegate.userInfo.user_Id mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //http请求状态
        if (task.state == NSURLSessionTaskStateCompleted) {
            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
            NSLog(@"%@",jsonDic);
            NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
            if ([status isEqualToString:@"1"]) {
                //成功返回
                [SVProgressHUD showSuccessWithStatus:@"图像上传成功"];
                
                hasUserImage = YES;
                UImgMyImg = image;
                [btnMyImg setBackgroundImage:UImgMyImg forState:UIControlStateNormal];
                ApplicationDelegate.userInfo.Url = jsonDic[@"Data"];
                
            } else {
                [SVProgressHUD showErrorWithStatus:jsonDic[@"Message"]];
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:k_Error_Network];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求异常
        [SVProgressHUD showErrorWithStatus:k_Error_Network];
    }];
    
}
/**
 *  修改个人信息
 */
- (void) setEditUserInfo
{
    //将User 信息转成 NSDictionary
    NSDictionary *userDic = @{
                              @"Id":usInfo.user_Id,
                              @"CityId":usInfo.CityId,
                              @"Address":usInfo.Address,
                              @"Name":usInfo.Name,
                              @"Mobile":usInfo.Mobile
                              };
    NSString * jsonStr = [JYJSON JSONStringWithDictionaryOrArray:userDic];
    NSLog(@"%@",jsonStr);
    
    
    
    
    [SVProgressHUD showWithStatus:k_Status_Upload];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,k_url_user_StoreUpd];
    
    NSDictionary *paramDict = @{
                                @"usrJson":jsonStr
                                };
    
    [ApplicationDelegate.httpManager POST:urlStr parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //http请求状态
        if (task.state == NSURLSessionTaskStateCompleted) {
            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
            NSLog(@"%@",jsonDic);
            NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
            if ([status isEqualToString:@"1"]) {
                //成功返回
                ApplicationDelegate.userInfo.CityId = usInfo.CityId;
                ApplicationDelegate.userInfo.CityName = usInfo.CityName;
                ApplicationDelegate.userInfo.Name = usInfo.Name;

                [SVProgressHUD showSuccessWithStatus:jsonDic[@"信息修改成功"]];
                [NSThread sleepForTimeInterval:2];
                [self.navigationController popViewControllerAnimated:true];//返回上一级页
                
            } else {
                //code =jsonDic[@"Message"];
                [SVProgressHUD showErrorWithStatus:jsonDic[@"Message"]];
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:k_Error_Network];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求异常
        [SVProgressHUD showErrorWithStatus:k_Error_Network];
    }];
    
}


@end
