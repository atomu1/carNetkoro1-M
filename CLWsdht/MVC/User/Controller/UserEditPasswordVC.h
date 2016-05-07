//
//  UserEditPasswordVC.h
//  CLWsdht
//
//  Created by clish on 16/4/18.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "BaseViewController.h"

@interface UserEditPasswordVC : BaseViewController
@property   UITextField * txtPwd;//密码
@property   UITextField * txtRePwd;//确认密码
@property   UITextField * txtInPutCode;//验证码
@property   UIButton * getCode;//获取验证码

@end
