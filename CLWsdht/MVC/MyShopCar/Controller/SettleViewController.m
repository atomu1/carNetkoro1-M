//
//  SettleViewController.m
//  CLWsdht
//
//  Created by OYJ on 16/4/14.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "SettleViewController.h"
#import "ShopCartDetailData.h"
#import "ShopCartInfoPart.h"
#import "ShopCartDetailData.h"
#import "ShopCartInfoPart.h"
#import "SectionFooterCell.h"
#import "SectionRowCell.h"
#import "SectionTitleCell.h"
#import "ShopCartReturnData.h"
#import "MJExtension.h"
#import "AddressTableViewCell.h"

@interface SettleViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *settleTableView;
@property (strong,nonatomic) NSMutableArray *leaveWordsArray;//记录留言数组
@property (strong,nonatomic) NSMutableArray *sectionTotalPriceArray;//记录店铺合计总额数组

@end

@implementation SettleViewController
-(NSMutableArray *)leaveWordsArray
{
    if (!_leaveWordsArray) {
        self.leaveWordsArray=[NSMutableArray array];
        for (int i=0; i<self.settleArray.count;i++) {
            [self.leaveWordsArray addObject:@""];
        }
    }
    return _leaveWordsArray;
}
-(NSMutableArray *)sectionTotalPriceArray
{
    if (!_sectionTotalPriceArray) {
        self.sectionTotalPriceArray=[NSMutableArray array];
        for (int i=0; i<self.settleArray.count;i++) {
            [self.sectionTotalPriceArray addObject:@""];
        }
    }
    return _sectionTotalPriceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.settleArray);
    static NSString *cellID = @"AddressTableViewCell";
    AddressTableViewCell *cell = [self.settleTableView dequeueReusableCellWithIdentifier:cellID];
    self.settleTableView.tableHeaderView=cell;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buyNowAction:(id)sender {
    [self AddOrderByNetwork];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.settleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ShopCartDetailData *part=[self.settleArray objectAtIndex:section];
    return part.Parts.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 93;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"SectionRowCell";
    
    ShopCartDetailData *part=[self.settleArray objectAtIndex:indexPath.section];
    ShopCartInfoPart *infoPart=[part.Parts objectAtIndex:indexPath.row];
    SectionRowCell *cell = [self.settleTableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell)
    {
        cell = [[SectionRowCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.titleLabel.text=infoPart.Name;
    cell.priceLabel.text=[NSString stringWithFormat:@"￥%.2f",infoPart.Price];
    cell.count.text=[NSString stringWithFormat:@"×%d",infoPart.Cnt];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:infoPart.Url]placeholderImage:[UIImage imageNamed:@"rc_ic_picture"]];
    cell.PurityName.text=infoPart.PurityName;
    cell.PartsSrcName.text=infoPart.PartsSrcName;

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 33;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *cellID = @"SectionTitleCell";
    SectionTitleCell *cell = [self.settleTableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell)
    {
        cell = [[SectionTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    ShopCartDetailData *part=[self.settleArray objectAtIndex:section];
    cell.titleLabel.text=part.StoreName;
        return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 81;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    static NSString *cellID = @"SectionFooterCell";
    SectionFooterCell *cell = [self.settleTableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell)
    {
        cell = [[SectionFooterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.adviceTextField.tag=section;
    cell.adviceTextField.delegate=self;
    cell.adviceTextField.text=[self.leaveWordsArray objectAtIndex:section];
    int count=0;
    float totalPrice=0;
    ShopCartDetailData *part=[self.settleArray objectAtIndex:section];
    for (ShopCartInfoPart *infoPart in part.Parts) {
        count++;
        totalPrice=totalPrice+infoPart.Price*infoPart.Cnt;
    }
    cell.totalCount.text=[NSString stringWithFormat:@"共计%d件商品",count];
    cell.totalPrice.text=[NSString stringWithFormat:@"%.2f",totalPrice];
    [self.sectionTotalPriceArray replaceObjectAtIndex:section withObject:cell.totalPrice.text];
    return cell;
}

#pragma mark - Networking

/**
 *  @author oyj, 16-04-18
 *  返回数据
 *  添加订单
 */
-(void)AddOrderByNetwork
{
    NSLog(@"%@",self.settleArray);
    [SVProgressHUD showWithStatus:k_Status_Load];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"Usr.asmx/AddOrders"];
    NSMutableArray *partsOrdersJsonArray=[NSMutableArray array];
    NSMutableArray *partsLstJsonArray=[NSMutableArray array];
 
    NSDictionary *garageOrdersJson =@{};
    
    for (ShopCartDetailData *storeData in self.settleArray) {
        int i=0;//用户获取第几个店铺的卖家留言
        NSString *OrdersId=[MJYUtils mjy_uuid];
        for (ShopCartInfoPart *part in storeData.Parts) {
            NSDictionary *partsLstJson =@{
                                          @"Cnt":[NSString stringWithFormat:@"%d",part.Cnt],
                                          @"Id":[MJYUtils mjy_uuid],
                                          @"OrdersId":OrdersId,
                                          @"PartsId":part.PartsId,
                                          @"Price":[NSString stringWithFormat:@"%.2f",part.Price]
                                          };
            [partsLstJsonArray  addObject:partsLstJson];
        }
        NSDictionary *partsOrdersJson =@{
                                         @"Addr":ApplicationDelegate.userInfo.Address,
                                         @"CityId":ApplicationDelegate.userInfo.CityId,
                                         @"Consignee":ApplicationDelegate.userInfo.Name,
                                         @"GarageOrdersId":@"",
                                         @"Id":OrdersId,
                                         @"Mobile":ApplicationDelegate.userInfo.Mobile,
                                         @"Msg":[self.leaveWordsArray objectAtIndex:i],
                                         @"Price":[self.sectionTotalPriceArray objectAtIndex:i],
                                         @"StoreId":storeData.UsrStoreId,
                                         @"UsrId":ApplicationDelegate.userInfo.user_Id,
                                         @"UsrType":@"1"
                                         };
        [partsOrdersJsonArray addObject:partsOrdersJson];
    }
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




#pragma mark - textFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.leaveWordsArray replaceObjectAtIndex:textField.tag withObject:textField.text];
}
@end
