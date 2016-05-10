//
//  TheOrderViewController.m
//  CLWsdht
//
//  Created by koroysta1 on 16/4/8.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "TheOrderViewController.h"
#import "AFNetworking.h"//主要用于网络请求方法
#import "UIKit+AFNetworking.h"//里面有异步加载图片的方法
#import "MJExtension.h"
#import "BaseHeader.h"
#import "OrderTableViewCell.h"
#import "OrderModel.h"
#import "MyOrderViewController.h"
#import "SingleCase.h"
#import "ApplyReturnViewController.h"

#define rowNum (NSInteger)((kScreen_Height - 100) / 96 + 1)

@interface TheOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *orderTableView;
@property (nonatomic, strong) NSMutableArray *partlistArr;
@property (nonatomic, copy) NSString *userId;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;

/**
 *  刷新
 */
@property (nonatomic, strong) NSMutableArray *modelArr;
@property (nonatomic, strong) NSMutableArray *showModel;
@property (nonatomic, assign) NSInteger times;
@property (nonatomic, assign) NSInteger totalNum;

@end

@implementation TheOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setTitle:@"我的配件订单"];
    _partlistArr = [[NSMutableArray alloc] initWithCapacity:0];
    SingleCase *singleCase = [SingleCase sharedSingleCase];
    _userId = singleCase.str;

    _times  = 0;
    self.showModel = [NSMutableArray arrayWithCapacity:0];
    
    [self GetOrderListByNetwork];
    [self setUpView];
    [self changLabel];
    [self setHeaderRefresh];
    [self setFooterRefresh];

}

//UI界面
-(void)setUpView{
    _orderTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:UITableViewStyleGrouped];
    _orderTableView.delegate=self;
    _orderTableView.dataSource=self;
    [_orderTableView registerNib:[UINib nibWithNibName:@"OrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderCellIdentifer"];
    [self.view addSubview:_orderTableView];
}

- (void)changLabel{
    if ([_orderState  isEqual: @"0"]) {
        [_label1 setBackgroundColor:[UIColor redColor]];
        [_label2 setBackgroundColor:[UIColor whiteColor]];
        [_label3 setBackgroundColor:[UIColor whiteColor]];
        [_label4 setBackgroundColor:[UIColor whiteColor]];
        [_label5 setBackgroundColor:[UIColor whiteColor]];
    }else if ([_orderState  isEqual: @"1"]){
        [_label1 setBackgroundColor:[UIColor whiteColor]];
        [_label2 setBackgroundColor:[UIColor redColor]];
        [_label3 setBackgroundColor:[UIColor whiteColor]];
        [_label4 setBackgroundColor:[UIColor whiteColor]];
        [_label5 setBackgroundColor:[UIColor whiteColor]];
    }else if ([_orderState  isEqual: @"2"]){
        [_label1 setBackgroundColor:[UIColor whiteColor]];
        [_label2 setBackgroundColor:[UIColor whiteColor]];
        [_label3 setBackgroundColor:[UIColor redColor]];
        [_label4 setBackgroundColor:[UIColor whiteColor]];
        [_label5 setBackgroundColor:[UIColor whiteColor]];
    }else if ([_orderState  isEqual: @"3"]){
        [_label1 setBackgroundColor:[UIColor whiteColor]];
        [_label2 setBackgroundColor:[UIColor whiteColor]];
        [_label3 setBackgroundColor:[UIColor whiteColor]];
        [_label4 setBackgroundColor:[UIColor redColor]];
        [_label5 setBackgroundColor:[UIColor whiteColor]];
    }else if ([_orderState  isEqual: @"4"]){
        [_label1 setBackgroundColor:[UIColor whiteColor]];
        [_label2 setBackgroundColor:[UIColor whiteColor]];
        [_label3 setBackgroundColor:[UIColor whiteColor]];
        [_label4 setBackgroundColor:[UIColor whiteColor]];
        [_label5 setBackgroundColor:[UIColor redColor]];
    }
}

//待确认
- (IBAction)confirmBtn:(UIButton *)sender {
    _orderState = @"0";
    [self changLabel];
    [self GetOrderListByNetwork];
}
//待付款
- (IBAction)payBtn:(UIButton *)sender {
    _orderState = @"1";
    [self changLabel];
    [self GetOrderListByNetwork];
}
//待发货
- (IBAction)dispatchBtn:(UIButton *)sender {
    _orderState = @"2";
    [self changLabel];
    [self GetOrderListByNetwork];
}
//待收货
- (IBAction)receiveBtn:(UIButton *)sender {
    _orderState = @"3";
    [self changLabel];
    [self GetOrderListByNetwork];
}
//待评价
- (IBAction)judgeBtn:(UIButton *)sender {
    _orderState = @"4";
    [self changLabel];
    [self GetOrderListByNetwork];
}

/**
 *  上下拉刷新
 */
#pragma mark - 上拉刷新
- (void)setHeaderRefresh {
    
    _orderTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _modelArr = [NSMutableArray arrayWithCapacity:0];
        _showModel = [NSMutableArray arrayWithCapacity:0];
        _totalNum = 0;
        _times = 0;
        [self GetOrderListByNetwork];
        
        [_orderTableView.mj_header beginRefreshing];
        [_orderTableView reloadData];
    }];
}



#pragma mark - 下拉加载
- (void)setFooterRefresh {
    _orderTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (_totalNum >= 10&&_times == 1) {
            [self GetOrderListByNetwork];
        } else {
            for (NSInteger i = _times * rowNum; i < _modelArr.count; i++) {
                [_showModel addObject:_modelArr[i]];
                if (i ==( (1 + _times) * rowNum) - 1) {
                    break;
                }
            }
            _times++;
        }
        if (_showModel.count == _modelArr.count) {
            [SVProgressHUD showInfoWithStatus:@"没有更多可以加载了"];
        }
        [_orderTableView.mj_footer endRefreshing];
        [_orderTableView reloadData];
    }];
}
/**
 *  刷新
 */
- (void)datprocessingWith:(NSMutableArray *)jsonArr {
    for (NSInteger i = _times*rowNum; i < jsonArr.count; i ++) {
        [_showModel addObject:jsonArr[i]];
        if (i == ((1 + _times) * rowNum)-1) {
            break;
        }
    }
    _times ++;
    
    [_orderTableView reloadData];
}


//获取我的订单
- (void)GetOrderListByNetwork{
    [SVProgressHUD showWithStatus:k_Status_Load];
    if (_totalNum == 0) {
        _totalNum = 10;
    }

    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"Usr.asmx/GetOrdersList"];
    NSDictionary *paramDict = @{
                                   @"state":_orderState,
                                   @"usrId":_userId,
                                @"garageId":@"",
                                 @"storeId":@"",
                                   @"start":[NSString stringWithFormat:@"%d",0],
                                   @"limit":[NSString stringWithFormat:@"%ld", _totalNum]
                                };

    
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
                                              NSLog(@"------------------%@", jsonDic);
                                              OrderModel *orderModel = [[OrderModel alloc] init];
                                              _partlistArr = [orderModel assignModelWithDict:jsonDic];
                                              [self datprocessingWith:_partlistArr];
                                              if (_partlistArr.count == 0) {
                                                  [SVProgressHUD showErrorWithStatus:@"你还没有订单"];
                                              }else{
                                                  [SVProgressHUD showSuccessWithStatus:  k_Success_Load];
                                              }
                                              
                                          } else {
                                              //失败
                                              [SVProgressHUD showErrorWithStatus:k_Error_WebViewError];
                                              
                                          }
                                          [_orderTableView.mj_header endRefreshing];
                                      } else {
                                          [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                      }
                                      [_orderTableView.mj_header endRefreshing];
                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      //请求异常
                                      [_orderTableView.mj_header endRefreshing];
                                      [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                  }];

}


#pragma mark -- UITableViewDataSource

/*设置标题头的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
/*设置标题尾的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80;
}
//设置cell头的UI
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    OrderModel *OM = [[OrderModel alloc] init];
    OM = _partlistArr[section];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    //店铺图标
    UIImageView *storeImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    [storeImg setImage:[UIImage imageNamed:@"NotificationBackgroundError.png"]];
    [headerView addSubview:storeImg];
    //店铺名字
    UILabel *storeName = [[UILabel alloc] initWithFrame:CGRectMake(storeImg.frame.origin.x+storeImg.frame.size.width+5, storeImg.frame.origin.y, 100, 20)];
    [storeName setBackgroundColor:[UIColor clearColor]];
    [storeName setText:OM.StoreName];
    [storeName setTextColor:[UIColor blackColor]];
    [storeName setFont:[UIFont systemFontOfSize:14]];
    [headerView addSubview:storeName];
    //图标
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35, storeImg.frame.origin.y, 20, 20)];
    [img setImage:[UIImage imageNamed:@"等级砖石"]];
    [headerView addSubview:img];
    return headerView;

}
//设置cell尾的UI
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [footerView setBackgroundColor:[UIColor whiteColor]];
    
    OrderModel *OM = [[OrderModel alloc] init];
    OM = _partlistArr[section];
    
    //取消按钮
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(footerView.frame.size.width-80, footerView.frame.size.height-35, 65, 30)];
    [cancelButton setBackgroundColor:[UIColor redColor]];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTag:section];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchUpInside];
    //确认收货按钮
    UIButton *crnfirmButton = [[UIButton alloc] initWithFrame:CGRectMake(footerView.frame.size.width-95, footerView.frame.size.height-35, 80, 30)];
    [crnfirmButton setBackgroundColor:[UIColor redColor]];
    [crnfirmButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [crnfirmButton setTitle:@"确认收货" forState:UIControlStateNormal];
    [crnfirmButton setTag:section];
    [crnfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [crnfirmButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [crnfirmButton addTarget:self action:@selector(crnfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    //评价按钮
    UIButton *judgeButton = [[UIButton alloc] initWithFrame:CGRectMake(footerView.frame.size.width-80, footerView.frame.size.height-35, 65, 30)];
    [judgeButton setBackgroundColor:[UIColor redColor]];
    [judgeButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [judgeButton setTitle:@"评价" forState:UIControlStateNormal];
    [judgeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [judgeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    //[button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    //支付按钮
    UIButton *payButton = [[UIButton alloc] initWithFrame:CGRectMake(cancelButton.frame.origin.x-70, cancelButton.frame.origin.y, 65, 30)];
    [payButton setBackgroundColor:[UIColor redColor]];
    [payButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [payButton setTitle:@"支付" forState:UIControlStateNormal];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    payButton.tag=section;
    [payButton addTarget:self action:@selector(payButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //退货按钮
    UIButton *returnButton = [[UIButton alloc] initWithFrame:CGRectMake(cancelButton.frame.origin.x-70, cancelButton.frame.origin.y, 65, 30)];
    [returnButton setBackgroundColor:[UIColor redColor]];
    [returnButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [returnButton setTitle:@"退货" forState:UIControlStateNormal];
    [returnButton setTag:section];
    [returnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [returnButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [returnButton addTarget:self action:@selector(returnButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //等待商家确认状态
    UILabel *storeOK = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 90, 15)];
    [storeOK setBackgroundColor:[UIColor clearColor]];
    [storeOK setText:@"等待商家确认"];
    [storeOK setTextColor:[UIColor redColor]];
    [storeOK setFont:[UIFont systemFontOfSize:12]];
    
    //等待修理厂确认状态
    UILabel *garageOK = [[UILabel alloc] initWithFrame:CGRectMake(storeOK.frame.origin.x
                                                                  , storeOK.frame.size.height+storeOK.frame.origin.y+1, 90, 15)];
    [garageOK setBackgroundColor:[UIColor clearColor]];
    [garageOK setText:@"等待修理厂确认"];
    [garageOK setTextColor:[UIColor redColor]];
    [garageOK setFont:[UIFont systemFontOfSize:12]];
    
    //根据返回的state调整UI
    NSString *state = [NSString stringWithFormat:@"%@",OM.State];
    NSString *garageState = [NSString stringWithFormat:@"%@",OM.GarageState];
    if ([state isEqualToString:@"0"]) {
        [footerView addSubview:cancelButton];
        [footerView addSubview:storeOK];
    }
    //根据当前状态显示订单按钮
    if ([_orderState isEqualToString:@"0"]) {
        [footerView addSubview:cancelButton];
    }
    else if ([_orderState isEqualToString:@"1"]){
        [footerView addSubview:cancelButton];
        [footerView addSubview:payButton];
    }
    else if ([_orderState isEqualToString:@"2"]){
    }
    else if ([_orderState isEqualToString:@"3"]){
        [footerView addSubview:crnfirmButton];
    }
    else if ([_orderState isEqualToString:@"4"]){
        [footerView addSubview:judgeButton];
        [footerView addSubview:returnButton];
    }
    //根据修理厂的状态调整UI
    if ([garageState isEqualToString:@"0"]) {
        [footerView addSubview:garageOK];
    }

    
    //价格Label
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-65, cancelButton.frame.origin.y-25, 50, 15)];
    [price setBackgroundColor:[UIColor clearColor]];
    //[price setText:OM.Price];
    [price setText:[NSString stringWithFormat:@"￥%@",OM.Price]];
    [price setTextAlignment:NSTextAlignmentCenter];
    [price setTextColor:[UIColor redColor]];
    [price setFont:[UIFont systemFontOfSize:13]];
    [footerView addSubview:price];
    //合计
    UILabel *add = [[UILabel alloc] initWithFrame:CGRectMake(price.frame.origin.x-40, price.frame.origin.y, 35, 15)];
    [add setBackgroundColor:[UIColor clearColor]];
    [add setText:@"合计"];
    [add setTextAlignment:NSTextAlignmentRight];
    [add setTextColor:[UIColor lightGrayColor]];
    [add setFont:[UIFont systemFontOfSize:13]];
    [footerView addSubview:add];
    //共计几件商品
    UILabel *manyGood = [[UILabel alloc] initWithFrame:CGRectMake(add.frame.origin.x-95, add.frame.origin.y, 90, 15)];
    [manyGood setBackgroundColor:[UIColor clearColor]];
    NSArray *many = OM.PartsList;
    [manyGood setText:[NSString stringWithFormat:@"共计%lu件商品",(unsigned long)many.count]];
    [manyGood setTextAlignment:NSTextAlignmentCenter];
    [manyGood setTextColor:[UIColor lightGrayColor]];
    [manyGood setFont:[UIFont systemFontOfSize:13]];
    [footerView addSubview:manyGood];
    //分割线
//    UILabel *carveF = [[UILabel alloc] initWithFrame:CGRectMake(0, garageOK.frame.origin.y+garageOK.frame.size.height+2, SCREEN_WIDTH, 0.5)];
//    [carveF setBackgroundColor:[UIColor lightGrayColor]];
//    [footerView addSubview:carveF];
    UILabel *carveS = [[UILabel alloc] initWithFrame:CGRectMake(0, cancelButton.frame.origin.y+cancelButton.frame.size.height+2, SCREEN_WIDTH, 0.5)];
    [carveS setBackgroundColor:[UIColor lightGrayColor]];
    [footerView addSubview:carveS];
    return footerView;
}

#pragma mark -- 取消订单按钮
/**
 *  取消
 */
- (void)cancelButton:(UIButton *)btn{
    [SVProgressHUD showWithStatus:k_Status_Load];
    OrderModel *OM = [[OrderModel alloc] init];
    OM = _partlistArr[btn.tag];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"Usr.asmx/CancelPartsOrders"];
    NSDictionary *paramDict = @{
                                @"ordersId":OM.Id,
                                };
    
    
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
                                              NSLog(@"------------------%@", jsonDic);
                                              [self GetOrderListByNetwork];
                                              [SVProgressHUD showSuccessWithStatus:@"取消成功"];
                                              
                                          } else {
                                              //失败
                                              [SVProgressHUD showErrorWithStatus:k_Error_WebViewError];
                                              
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
 *  确认收货
 */
- (void)crnfirmButton:(UIButton *)btn{
    [SVProgressHUD showWithStatus:k_Status_Load];
    OrderModel *OM = [[OrderModel alloc] init];
    OM = _partlistArr[btn.tag];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"Usr.asmx/Receipt"];
    NSDictionary *paramDict = @{
                                @"ordersId":OM.Id,
                                };
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
                                              NSLog(@"------------------%@", jsonDic);
                                              [self GetOrderListByNetwork];
                                              [SVProgressHUD showSuccessWithStatus:@"确认成功"];
                                              
                                          } else {
                                              //失败
                                              [SVProgressHUD showErrorWithStatus:k_Error_WebViewError];
                                              
                                          }
                                      } else {
                                          [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                      }
                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      //请求异常
                                      [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                  }];
}

//返回某个section中rows的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    OrderModel *OM = [[OrderModel alloc] init];
    OM = _partlistArr[section];
    return OM.PartsList.count;
}


//这个方法是用来创建cell对象，并且给cell设置相关属性的
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置标识符
    static NSString *userStoreCellIdentifer = @"orderCellIdentifer";
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCellIdentifer"];
    if (cell == nil) {
        cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userStoreCellIdentifer];
    }
    OrderModel *OM=_partlistArr[indexPath.section];
    GoodModel *GM=OM.PartsList[indexPath.row];
    [cell setOrderWithModel:GM];
    
    return cell;
}

//返回section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _partlistArr.count;
}

#pragma mark -- UITableViewDelegate
//返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}
//选中cell时调起的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //选中cell要做的操作
    
}


#pragma mark -- 退货按钮响应事件
- (void)returnButton:(UIButton *)btn{
    ApplyReturnViewController *applyVC = [[ApplyReturnViewController alloc] init];
    applyVC.returnNumber = _partlistArr[btn.tag];
    [self.navigationController pushViewController:applyVC animated:YES];
}
- (void)zhangmengBtn:(OrderModel *)model{
    NSLog(@"model = %@", model);
}

#pragma mark -- Action

-(IBAction)payButtonAction:(UIButton*)sender
{
    PayOrderController *contr=[[PayOrderController alloc]init];
    OrderModel *OM = [[OrderModel alloc] init];
    OM = _partlistArr[sender.tag];
    contr.orderModal=OM;
    [self.navigationController pushViewController:contr animated:YES];
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
