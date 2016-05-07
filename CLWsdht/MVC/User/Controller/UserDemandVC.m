//
//  UserDemandVC.m
//  CLWsdht
//
//  Created by clish on 16/4/14.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "UserDemandVC.h"
#import "UserInfo.h"
#import "DemandModel.h"
#import "UserDemandInfoVC.h"

@interface UserDemandVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * thisData ;
    UITableView *thisTV;
}
@end

@implementation UserDemandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initData];
    
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent=NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

-(void) initData
{
    thisData = [[NSMutableArray alloc]init];
    [self getMyShopListInfoFromNetwork];
}
-(void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"我的需求";
    UIBarButtonItem * btnBarItem = [[UIBarButtonItem alloc]init];
    [btnBarItem setTitle:@""];
    [self.navigationController.navigationBar.backItem setBackBarButtonItem:btnBarItem];
    
    //设置弹出页返回按钮文字
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]init];
    [cancelButton setTitle:@""];
    self.navigationItem.backBarButtonItem = cancelButton;
    //表格
    thisTV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    thisTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    thisTV.dataSource = self;
    thisTV.delegate = self;
    [self.view addSubview:thisTV];

}
#pragma mark - 表格数据处理

/*
 1.多少分区
 2.每个分区名称是什么
 3.每个分区下有多少行
 4.每一行的高度
 5.每一行的样式
 */

/**
 *  指定有多少个分区(Section)，默认为1
 *
 *  @param tableView 页面显示
 *
 *  @return 几个分组
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//返回标题数组中元素的个数来确定分区的个数
    
}

//指定每个分区中有多少行，默认为1
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return thisData.count;
    
}
//设置rowHeight
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIFont * BlackFont = [[UIFont alloc]init];
       //设置标识符
    UITableViewCell * cell = [thisTV dequeueReusableCellWithIdentifier:@"mycell"];
    if(cell ==nil)
    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"mycell"];
    }
    DemandModel *dMod = [thisData objectAtIndex:indexPath.item];
    UILabel * lbltitle = [[UILabel alloc]initWithFrame:CGRectMake(3, 3, self.view.frame.size.width-125, 20)];
    lbltitle.font =[UIFont systemFontOfSize:12];
    
    UILabel * lblCarName = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-120, 3, 75, 20)];
    lblCarName.textAlignment = NSTextAlignmentRight;
    lblCarName.font =[UIFont systemFontOfSize:10];
    lblCarName.textColor = [UIColor darkGrayColor];
    
    UILabel * lblState = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-40, 3, 37, 20)];
    lblState.font =[UIFont systemFontOfSize:10];
    lblState.textColor = [UIColor darkGrayColor];
    
    UILabel * lblCarNameType = [[UILabel alloc]initWithFrame:CGRectMake(3, 23, self.view.frame.size.width, 20)];
    lblCarNameType.font =[UIFont systemFontOfSize:10];

    UIView * Dot = [[UIView alloc]initWithFrame:CGRectMake(3, 47, 6, 6)];
    Dot.backgroundColor =[UIColor magentaColor];
    Dot.layer.cornerRadius = 3;
    
    
    UILabel * lblPro = [[UILabel alloc]initWithFrame:CGRectMake(10, 43, (self.view.frame.size.width/10.0)*6.0, 15)];
    lblPro.font =[UIFont systemFontOfSize:9];
    lblPro.textColor = [UIColor darkGrayColor];
    
    UILabel * lblCount = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width/10.0)*5, 43, 50, 15)];
    lblCount.font =[UIFont systemFontOfSize:9];
    lblCount.textColor = [UIColor darkGrayColor];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 61, self.view.frame.size.width, 3)];
    line.backgroundColor =[UIColor grayColor];
    
//
    lbltitle.text =dMod.Title;//[NSString stringWithFormat:@"求购%@的%@",dMod.CarBrandName,];
    lblCarName.text = dMod.CarBrandName;
    
    lblState.text =@"待选标";//***************************************************需修改
    lblCarNameType.text = dMod.CarModelName;
    lblPro.text = dMod.ProvincialName;
    lblCount.text =[NSString stringWithFormat:@"数量 %@",dMod.Cnt];
   
    [cell addSubview:lbltitle];
    [cell addSubview:lblCarName];
    [cell addSubview:lblState];
    [cell addSubview:lblCarNameType];
    [cell addSubview:lblPro];
    [cell addSubview:lblCount];
    [cell addSubview:Dot];
    [cell addSubview:line];

    return cell;
}
//当一行被选中进执行此事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserDemandInfoVC *DemandInfoVC = [[UserDemandInfoVC alloc]init];
     DemandModel *dMod = [thisData objectAtIndex:indexPath.item];
    DemandInfoVC.Id = dMod.Id;

//    由navigationController推向我们要推向的view
    [self.navigationController pushViewController:DemandInfoVC animated:YES];
}

#pragma mark - Networking

/**
 *  获取我的店铺列表信息接口数据
 */
- (void)getMyShopListInfoFromNetwork
{
    [SVProgressHUD showWithStatus:k_Status_Load];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,k_url_GetDemandList];
    
    NSDictionary *paramDict = @{
                                @"demandJson": [NSString stringWithFormat:@"{\"UsrId\":\"%@\"}",ApplicationDelegate.userInfo.user_Id],
                                @"limit":@"10",
                                @"sortJson":@"",
                                @"start":@"0"
                                };
    
    [ApplicationDelegate.httpManager POST:urlStr parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //http请求状态
        if (task.state == NSURLSessionTaskStateCompleted) {
            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
            NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
            if ([status isEqualToString:@"1"]) {
                //成功返回
                NSDictionary *jsonDic2 = [jsonDic objectForKey:@"Data"];
                NSMutableArray *mar = jsonDic2[@"Data"];
                //NSLog(@"%@",jsonDic);
                for (NSDictionary * dDic in mar) {
                    DemandModel *dMod = [[DemandModel alloc] initWithNSDictionary:dDic];
                    [thisData addObject: dMod];
                }
                [thisTV reloadData];
            [SVProgressHUD dismiss];
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
@end
