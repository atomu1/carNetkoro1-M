//
//  UserEditTelVC.h
//  CLWsdht
//
//  Created by clish on 16/4/18.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "BaseViewController.h"

@interface UserEditTelVC : BaseViewController
@property   UITextField * txtTel;
@property UIButton    *getPassWord;//获取验证码按钮
@property UITextField * txtCode;//验证码
-(void)getVerificationCodeAction:(id)sender;
@end
