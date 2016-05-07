//
//  UserEditPasswordVC.m
//  CLWsdht
//
//  Created by clish on 16/4/18.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "UserEditPasswordVC.h"
#import "UserInfo.h"

@interface UserEditPasswordVC ()
{
    NSTimer *_timer;//定时器
    NSInteger seconds;//时间
    NSInteger i_times;//验证码按钮点击次数
    NSString * code;//验证码
}
@end

@implementation UserEditPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"修改密码";
    
    // Dispose of any resources that can be recreated.
    //lable请输入密码
    UILabel * lbltitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 30)];
    lbltitle.text = @"登录密码";
    [self.view addSubview:lbltitle];
    
    //密码输入
    self.txtPwd = [[UITextField alloc]initWithFrame:CGRectMake(110, 5, self.view.frame.size.width-120, 30)];
    self.txtPwd.placeholder = @"请输入登录密码";
    self.txtPwd.secureTextEntry = YES;
    self.txtPwd.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.txtPwd];
    
    //上面线
    UIView *Line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 0.5)];
    Line1.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [self.view addSubview:Line1];
    
    //Lable 确认密码
    UILabel * lblRePwd = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, 100, 20)];
    lblRePwd.text = @"确认密码";
//    lblRePwd.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:lblRePwd];
    
    
    //手机号输入
    self.txtRePwd = [[UITextField alloc]initWithFrame:CGRectMake(110, 45, self.view.frame.size.width-120, 30)];
    self.txtRePwd.placeholder = @"请再次输入密码";
    self.txtRePwd.secureTextEntry = YES;
    self.txtRePwd.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.txtRePwd];
    
    //手机号面下线
    UIView *Line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 0.5)];
    Line3.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [self.view addSubview:Line3];
    
    //验证码输入框
    self.txtInPutCode = [[UITextField alloc]initWithFrame:CGRectMake(10, 85, self.view.frame.size.width-150, 30)];
    self.txtInPutCode.placeholder = @"验证码";
    [self.view addSubview:self.txtInPutCode];

    //获取验证码按钮
    self.getCode = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-135, 85, 130, 30)];
    [self.getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.getCode addTarget:self action:@selector(getVerificationCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    self.getCode.backgroundColor = [UIColor grayColor];
    self.getCode.layer.cornerRadius = 2.0;
    [self.view addSubview:self.getCode];
    
    //验证码下面的线
    UIView *Line4 = [[UIView alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 0.5)];
    Line4.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [self.view addSubview:Line4];
    
    //提交修改密码
    UIButton * btnNewTel= [[UIButton alloc]initWithFrame:CGRectMake(13, 125, self.view.frame.size.width - 26, 30)];
    [btnNewTel setTitle:@"确认修改" forState:UIControlStateNormal];
    [btnNewTel addTarget:self action:@selector(setNewPwd:) forControlEvents:UIControlEventTouchUpInside];
    btnNewTel.backgroundColor = [UIColor grayColor];
    btnNewTel.layer.cornerRadius = 5.0;
    [self.view addSubview:btnNewTel];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark *** 计时器的响应事件 ***
- (void)changeTheTime:(NSTimer *)timer {
    if (seconds > 1) {
        --seconds; //每次进入减一秒
        [self.getCode setTitle:[NSString stringWithFormat:@"发送验证码(%ld)", (long)seconds] forState:UIControlStateNormal];
        //设置button是否可以点击，默认是yes
        [self.getCode setEnabled:NO];
    } else {
        [self.getCode setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        //设置button是否可以点击
        [self.getCode setEnabled:YES];
        //关闭并删除计时器
        [_timer invalidate];
        seconds = 60;
    }
}

#pragma mark *** 获取验证码按钮 ***
-(void)getVerificationCodeAction:(id)sender
{
    [self getCodeFromNetwork];
    seconds = 60;
    [self.getCode setTitle:@"发送验证码(60)" forState:UIControlStateNormal];
    //设置计时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTheTime:) userInfo:nil repeats:YES];
}
#pragma mark *** 更新密码 ***
-(void)setNewPwd:(id)sender
{
    if(!code)//没有返回验证码
    {
        [SVProgressHUD showSuccessWithStatus:@"请先获取验证码"];
        return ;
    }
    if(![code isEqualToString:self.txtInPutCode.text])
    {
        [SVProgressHUD showSuccessWithStatus:@"验证码输入错误"];
        [self.txtInPutCode becomeFirstResponder];
        return ;
    }
    if (![self.txtPwd.text isEqualToString:self.txtRePwd.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致，请重新输入"];
        [self.txtPwd becomeFirstResponder];
        return;
    }
    if(self.txtPwd.text.length<6)
    {
        [SVProgressHUD showErrorWithStatus:@"密码长度不能小于6"];
        [self.txtPwd becomeFirstResponder];
        return;
    }
    NSLog(@"密码修改");
    [self setPwd];
    
}


/**
 *  获取验证码
 */
- (void) getCodeFromNetwork
{
    [SVProgressHUD showWithStatus:k_Status_GetVerifyCode];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,k_url_get_code];
    
    NSDictionary *paramDict = @{
                                @"mobile":ApplicationDelegate.userInfo.Mobile,
                                @"codeType":@"0"
                                };
    
    [ApplicationDelegate.httpManager POST:urlStr parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //http请求状态
        if (task.state == NSURLSessionTaskStateCompleted) {
            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
            NSLog(@"%@",jsonDic);
            NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
            if ([status isEqualToString:@"0"]) {
                //成功返回
                code =nil;//清空验证码
                [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
                
            } else if([status isEqualToString:@"1"]) {
                code =jsonDic[@"Message"];
                //[SVProgressHUD showErrorWithStatus:jsonDic[@"Message"]];
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
 *  设置手机号
 */
- (void) setPwd
{
    [SVProgressHUD showWithStatus:k_Status_GetVerifyCode];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,k_url_auth_NewPwd];
    
    NSDictionary *paramDict = @{
                                @"mobile":ApplicationDelegate.userInfo.Mobile,
                                @"newPwd":self.txtPwd.text,
                                @"code":self.txtInPutCode.text ,
                                @"usrType":@"0"
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
                code =nil;//清空验证码
                [SVProgressHUD showSuccessWithStatus:jsonDic[@"密码修改成功"]];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
