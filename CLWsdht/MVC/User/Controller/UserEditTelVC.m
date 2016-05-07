//
//  UserEditTelVC.m
//  CLWsdht
//
//  Created by clish on 16/4/18.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "UserEditTelVC.h"
#import "UserInfo.h"

@interface UserEditTelVC ()
{
    NSTimer *_timer;//定时器
    NSInteger seconds;//时间
    NSInteger i_times;//验证码按钮点击次数
    NSString * code;//验证码
}
@end

@implementation UserEditTelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"修改绑定手机号";
    
    // Dispose of any resources that can be recreated.
    UILabel * lbltitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    lbltitle.text = @"请输入您的新手机号";
    lbltitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lbltitle];
    
    //上面线
    UIView *Line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 0.5)];
    Line1.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [self.view addSubview:Line1];
    
    //+86
    UILabel * lbl86 = [[UILabel alloc]initWithFrame:CGRectMake(10, 55, 30, 20)];
    lbl86.text = @"+86";
    lbl86.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:lbl86];
    
    //+86 与手机号间线
    UIView *Line2 = [[UIView alloc]initWithFrame:CGRectMake(40, 50, 0.5, 30)];
    Line2.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [self.view addSubview:Line2];
    
    //手机号输入
    self.txtTel = [[UITextField alloc]initWithFrame:CGRectMake(43, 51, self.view.frame.size.width-43, 30)];
    self.txtTel.placeholder = @"请输入手机号";
    [self.view addSubview:self.txtTel];
    
    //手机号面下线
    UIView *Line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 0.5)];
    Line3.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [self.view addSubview:Line3];
    
    //验证码输入框
    self.txtCode = [[UITextField alloc]initWithFrame:CGRectMake(13, 81, self.view.frame.size.width-150, 30)];
    self.txtCode.placeholder = @"验证码";
    [self.view addSubview:self.txtCode];
    
    //获取验证码按钮
    self.getPassWord = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-135, 81, 130, 30)];
    [self.getPassWord setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.getPassWord addTarget:self action:@selector(getVerificationCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    self.getPassWord.backgroundColor = [UIColor grayColor];
    self.getPassWord.layer.cornerRadius = 2.0;
    [self.view addSubview:self.getPassWord];
    
    //验证码下面的线
    UIView *Line4 = [[UIView alloc]initWithFrame:CGRectMake(0, 113, self.view.frame.size.width, 0.5)];
    Line4.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [self.view addSubview:Line4];
    
    //更新手机号按钮
    UIButton * btnNewTel= [[UIButton alloc]initWithFrame:CGRectMake(13, 120, self.view.frame.size.width - 26, 30)];
    [btnNewTel setTitle:@"提交" forState:UIControlStateNormal];
    [btnNewTel addTarget:self action:@selector(setNewTel:) forControlEvents:UIControlEventTouchUpInside];
    btnNewTel.backgroundColor = [UIColor grayColor];
    btnNewTel.layer.cornerRadius = 5.0;
    [self.view addSubview:btnNewTel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark *** 计时器的响应事件 ***
- (void)changeTheTime:(NSTimer *)timer {
    if (seconds > 1) {
        --seconds; //每次进入减一秒
        [self.getPassWord setTitle:[NSString stringWithFormat:@"发送验证码(%ld)", (long)seconds] forState:UIControlStateNormal];
        //设置button是否可以点击，默认是yes
        [self.getPassWord setEnabled:NO];
    } else {
        [self.getPassWord setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        //设置button是否可以点击
        [self.getPassWord setEnabled:YES];
        //关闭并删除计时器
        [_timer invalidate];
        seconds = 60;
    }
}

#pragma mark *** 获取验证码按钮 ***
-(void)getVerificationCodeAction:(id)sender
{
    if (![MJYUtils mjy_checkTel:self.txtTel.text]) {
        [SVProgressHUD showErrorWithStatus:@"手机号格式有误"];
    } else {
        [self getCodeFromNetwork];
    seconds = 60;
    [self.getPassWord setTitle:@"发送验证码(60)" forState:UIControlStateNormal];
    //设置计时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTheTime:) userInfo:nil repeats:YES];
    }
    
    NSLog(@"电话号%@",self.txtTel.text);
}
#pragma mark *** 更新手机号 ***
-(void)setNewTel:(id)sender
{
    if(!code)//没有返回验证码
    {
        [SVProgressHUD showSuccessWithStatus:@"请先获取验证码"];
        return ;
    }
    if(![code isEqualToString:self.txtCode.text])
    {
        [SVProgressHUD showSuccessWithStatus:@"验证码输入错误"];
        return ;
    }
    if (![MJYUtils mjy_checkTel:self.txtTel.text]) {
        [SVProgressHUD showErrorWithStatus:@"手机号格式有误"];
        return;
    }
    [self setTel];
    
}


/**
 *  获取验证码
 */
- (void) getCodeFromNetwork
{
    [SVProgressHUD showWithStatus:k_Status_GetVerifyCode];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,k_url_get_code];
    
    NSDictionary *paramDict = @{
                                @"mobile":self.txtTel.text,
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
- (void) setTel
{
    [SVProgressHUD showWithStatus:k_Status_GetVerifyCode];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,k_url_auth_NewMobile];
    
    NSDictionary *paramDict = @{
                                @"code":self.txtCode.text,
                                @"mobile":ApplicationDelegate.userInfo.Mobile,
                                @"newMobile":self.txtTel.text,
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
                [SVProgressHUD showSuccessWithStatus:jsonDic[@"Message"]];
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
