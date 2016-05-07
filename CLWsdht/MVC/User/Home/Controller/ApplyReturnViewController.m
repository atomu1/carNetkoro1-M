//
//  ApplyReturnViewController.m
//  CLWsdht
//
//  Created by tom on 16/4/28.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "ApplyReturnViewController.h"
#import "AFNetworking.h"//主要用于网络请求方法
#import "UIKit+AFNetworking.h"//里面有异步加载图片的方法
#import "MJExtension.h"
#import "BaseHeader.h"
#import "ReturnGoodsViewController.h"


@interface ApplyReturnViewController ()

@end

@implementation ApplyReturnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"退货申请"];
    //退货按钮设置圆角
    [_returnBtn.layer setMasksToBounds:YES];
    [_returnBtn.layer setCornerRadius:8];
}

//申请退货按钮
- (IBAction)returnBtnClicked:(UIButton *)sender {
    [self refund];
}

#pragma mark -- 退货申请接口
- (void)refund{
    [SVProgressHUD showWithStatus:k_Status_Load];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"Usr.asmx/Refund"];
    
    NSDictionary *returnJson = @{
                                   @"Id":_returnNumber.Id,
                                   @"RefundPrice":_moneyTextField.text,
                                   @"RefundReason":_reasonTextField.text
                                   };
    NSError *error;
    
    NSArray *returnArrJson = @[
                               returnJson
                               ];
    NSData *returnArrJsonData = [NSJSONSerialization dataWithJSONObject:returnArrJson options:NSJSONWritingPrettyPrinted error:&error];
    NSString *returnArrJsonDataJsonString = [[NSString alloc] initWithData:returnArrJsonData encoding:NSUTF8StringEncoding];
    NSLog(@"str = %@", returnArrJsonDataJsonString);

    
    NSDictionary *paramDict = @{
                                   @"ordersPartsJson":returnArrJsonDataJsonString
                                   };
    NSLog(@"parmDic = %@", paramDict);
    
    
    [ApplicationDelegate.httpManager POST:urlStr
                               parameters:paramDict
                                 progress:^(NSProgress * _Nonnull uploadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      //http请求状态
                                      if (task.state == NSURLSessionTaskStateCompleted) {
                                          NSError* error;
                                          NSDictionary* jsonDic = [NSJSONSerialization
                                                                   JSONObjectWithData:responseObject
                                                                   options:kNilOptions
                                                                   error:&error];
                                          NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
                                          if ([status isEqualToString:@"1"]) {
                                              //成功
                                              [SVProgressHUD showSuccessWithStatus:  k_Success_Load];
                                              ReturnGoodsViewController *returnGVC = [[ReturnGoodsViewController alloc] init];
                                              [self.navigationController pushViewController:returnGVC animated:YES];
                                              
                                          } else {
                                              //失败
                                              [SVProgressHUD showErrorWithStatus:@"退款金额不能大于商品金额"];
                                              
                                          }
                                          
                                      } else {
                                          [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                      }
                                      
                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      //请求异常
                                      [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                  }];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
