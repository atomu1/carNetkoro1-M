//
//  BuyNowController.m
//  CLWsdht
//
//  Created by OYJ on 16/4/21.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "BuyNowController.h"
#import "ImgModal.h"
#import "GoodInfoReturn.h"
#import "MJExtension.h"
#import "UserInfo.h"//用户模型信息

@interface BuyNowController ()
//地址信息
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *Mobile;

//商品信息
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UIImageView *goodImage;
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *goodPrice;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel2;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;


@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;


//卖家留言
@property (weak, nonatomic) IBOutlet UITextField *leaveWordsTextField;
//合计
@property (weak, nonatomic) IBOutlet UILabel *goodsTotalCount;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;

@end

@implementation BuyNowController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
}
#pragma mark - UI&Data
-(void)updateUI
{
    NSLog(@"%@",self.storeName);
//商品信息
    //店铺名字
    self.storeName.text=self.goodInfo.StoreName;
    //商品图片
    ImgModal *modal=[self.goodInfo.Imgs objectAtIndex:0];
    [self.goodImage sd_setImageWithURL:[NSURL URLWithString:[modal valueForKey:@"Url"]] placeholderImage:[UIImage imageNamed:@"rc_ic_picture"]];
    //商品名字
    self.goodName.text=self.goodInfo.Name;
    //商品数量
    self.countLabel.text=@"×1";
    //商品新旧
    self.styleLabel1.text=self.goodInfo.PurityName;
    //商品性质
    self.styleLabel2.text=self.goodInfo.PartsSrcName;
    //商品价格
    self.goodPrice.text=[NSString stringWithFormat:@"￥%.2f",self.goodInfo.Price];
 //合计
    self.totalPrice.text=[NSString stringWithFormat:@"￥%.2f",self.goodInfo.Price];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Networking
/**
 *  @author oyj, 16-04-21
 *
 *  立即购买
 */
-(void)buyNowToNetwork
{
    [SVProgressHUD showWithStatus:k_Status_Load];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"Usr.asmx/AddOrders"];
    
    NSString *Id=[MJYUtils mjy_uuid];
    NSString *OrdersId=[MJYUtils mjy_uuid];
    NSDictionary *garageOrdersJson =@{};
    NSDictionary *partsOrdersJson =@{
                                     @"Addr":@"1",
                                     @"CityId":ApplicationDelegate.userInfo.CityId,
                                     @"Consignee":ApplicationDelegate.userInfo.Name,
                                     @"GarageOrdersId":@"",
                                     @"Id":OrdersId,
                                     @"Mobile":ApplicationDelegate.userInfo.Mobile,
                                     @"Msg":self.leaveWordsTextField.text,
                                     @"Price":[NSString stringWithFormat:@"%.2f",[self.countTextField.text intValue]*self.goodInfo.Price],
                                     @"StoreId":self.goodInfo.UsrStoreId,
                                     @"UsrId":ApplicationDelegate.userInfo.user_Id,
                                     @"UsrType":@"1"
                                     };
    NSArray *partsOrdersJsonArray=@[partsOrdersJson];

    NSDictionary *partsLstJson =@{
                                  @"Cnt":self.countTextField.text,
                                  @"Id":Id,
                                  @"OrdersId":OrdersId,
                                  @"PartsId":self.goodInfo.Id,
                                  @"Price":[NSString stringWithFormat:@"%.2f",[self.countTextField.text intValue]*self.goodInfo.Price]
                                  };

    NSArray *partsLstJsonArray=@[partsLstJson];
    NSDictionary *paramDict = @{
                                @"garageOrdersJson":[JYJSON JSONStringWithDictionaryOrArray:garageOrdersJson],
                                @"partsOrdersJson":[JYJSON JSONStringWithDictionaryOrArray:partsOrdersJsonArray],
                                @"partsLstJson":[JYJSON JSONStringWithDictionaryOrArray:partsLstJsonArray],
                                };
    [ApplicationDelegate.httpManager POST:urlStr
                               parameters:paramDict
                                 progress:^(NSProgress * _Nonnull uploadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      //http请求状态
                                      if (task.state == NSURLSessionTaskStateCompleted) {
                                                      NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
                                          if (jsonDic[@"Success"]) {
                                                [self dismissViewControllerAnimated:YES completion:^{
                                                  [SVProgressHUD showSuccessWithStatus:@"订单提交成功！"];
                                              }];
                                              
                                          } else {
                                              //失败
                                              [SVProgressHUD showErrorWithStatus:@"订单提交失败！"];

                                          }
                                          
                                      } else {
                                          [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                      }
                                      
                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      //请求异常
                                      [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                  }];
}



#pragma mark - Action
-(IBAction)buyNowAction:(id)sender
{
    [self buyNowToNetwork];
}

- (IBAction)addressButton:(id)sender {
}

- (IBAction)addButtonAction:(id)sender {
    //更改数量
    int number=[self.countTextField.text intValue]+1;
    self.countLabel.text=[NSString stringWithFormat:@"×%d",number];
    self.countTextField.text=[NSString stringWithFormat:@"%d",number];
    //更改件数
    self.goodsTotalCount.text=[NSString stringWithFormat:@"共计%d件商品",number];
    //更改合计价格
    self.totalPrice.text=[NSString stringWithFormat:@"￥%.2f",number*self.goodInfo.Price];

}
- (IBAction)reduceButtonAction:(id)sender {
    //更改数量
    
    int number=[self.countTextField.text intValue]-1;
    if (number==0) {
        [SVProgressHUD showInfoWithStatus:@"购买数量不能低于1件"];
        return;
    }
    self.countLabel.text=[NSString stringWithFormat:@"×%d",number];
    self.countTextField.text=[NSString stringWithFormat:@"%d",number];
    //更改件数
    self.goodsTotalCount.text=[NSString stringWithFormat:@"共计%d件商品",number];
    //更改合计价格
    self.totalPrice.text=[NSString stringWithFormat:@"￥%.2f",number*self.goodInfo.Price];
    
}





@end
