//
//  TardeCancelOrderViewController.m
//  CLWsdht
//
//  Created by koroysta1 on 16/4/18.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "TardeCancelOrderViewController.h"
#import "AFNetworking.h"//主要用于网络请求方法
#import "UIKit+AFNetworking.h"//里面有异步加载图片的方法
#import "MJExtension.h"
#import "OrderTableViewCell.h"
#import "BaseHeader.h"
#import "OrderModel.h"
#import "MyOrderViewController.h"
#import "SingleCase.h"

@interface TardeCancelOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *orderTableView;
@property (nonatomic, strong) NSMutableArray *partlistArr;
@property (nonatomic, copy) NSString *userId;

@end

@implementation TardeCancelOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的配件订单"];
    _partlistArr = [[NSMutableArray alloc] initWithCapacity:0];
    SingleCase *singleCase = [SingleCase sharedSingleCase];
    _userId = singleCase.str;
    [self GetOrderListByNetwork];
    [self setUpView];
}

//UI界面
-(void)setUpView{
    _orderTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:UITableViewStyleGrouped];
    _orderTableView.delegate=self;
    _orderTableView.dataSource=self;
    [_orderTableView registerNib:[UINib nibWithNibName:@"OrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderCellIdentifer"];
    [self.view addSubview:_orderTableView];
}


//已交易按钮
- (IBAction)tardeBtn:(UIButton *)sender {
    _orderState = @"100";
    [self GetOrderListByNetwork];
}
//已取消按钮
- (IBAction)cancelBtn:(UIButton *)sender {
    _orderState = @"-1";
    [self GetOrderListByNetwork];
}

//获取我的订单
- (void)GetOrderListByNetwork{
    [SVProgressHUD showWithStatus:k_Status_Load];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"Usr.asmx/GetOrdersList"];
    NSDictionary *paramDict = @{
                                @"state":_orderState,
                                @"usrId":_userId,
                                @"garageId":@"",
                                @"storeId":@"",
                                @"start":[NSString stringWithFormat:@"%d",0],
                                @"limit":[NSString stringWithFormat:@"%d",10]
                                };
    
    
    [ApplicationDelegate.httpManager POST:urlStr
                               parameters:paramDict
                                 progress:^(NSProgress * _Nonnull uploadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      //http请求状态
                                      if (task.state == NSURLSessionTaskStateCompleted) {
                                          //            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
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
                                              NSLog(@"zzzzzzzzzzz%@",_partlistArr);
                                              [_orderTableView reloadData];
                                              if (_partlistArr.count == 0) {
                                                  [SVProgressHUD showErrorWithStatus:@"你还没有订单"];
                                              }else{
                                                  [SVProgressHUD showSuccessWithStatus:  k_Success_Load];
                                              }
                                              
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
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    //[button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    //支付按钮
    UIButton *payButton = [[UIButton alloc] initWithFrame:CGRectMake(cancelButton.frame.origin.x-70, cancelButton.frame.origin.y, 65, 30)];
    [payButton setBackgroundColor:[UIColor redColor]];
    [payButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [payButton setTitle:@"支付" forState:UIControlStateNormal];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    //[button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    //根据返回的state调整UI
    NSString *state = [NSString stringWithFormat:@"%@",OM.State];
    if ([state isEqualToString:@"0"]) {
        [footerView addSubview:cancelButton];
    }
    else if ([state isEqualToString:@"1"]){
        [footerView addSubview:cancelButton];
        [footerView addSubview:payButton];
    }
    else if ([state isEqualToString:@"2"]){
    }
    else if ([state isEqualToString:@"3"]){
    }
    else if ([state isEqualToString:@"4"]){
    }
    //等待商家确认状态
    UILabel *storeOK = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 90, 15)];
    [storeOK setBackgroundColor:[UIColor clearColor]];
    [storeOK setText:@"等待商家确认"];
    [storeOK setTextColor:[UIColor redColor]];
    [storeOK setFont:[UIFont systemFontOfSize:12]];
    [footerView addSubview:storeOK];
    //等待修理厂确认状态
    UILabel *garageOK = [[UILabel alloc] initWithFrame:CGRectMake(storeOK.frame.origin.x
                                                                  , storeOK.frame.size.height+storeOK.frame.origin.y+1, 90, 15)];
    [garageOK setBackgroundColor:[UIColor clearColor]];
    [garageOK setText:@"等待修理厂确认"];
    [garageOK setTextColor:[UIColor redColor]];
    [garageOK setFont:[UIFont systemFontOfSize:12]];
    [footerView addSubview:garageOK];
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
    NSLog(@"zzzzzz%lu",(unsigned long)_partlistArr.count);
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
