//
//  UserDemandInfoVC.m
//  CLWsdht
//
//  Created by clish on 16/4/15.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "UserDemandInfoVC.h"
#import "DemandModel.h"
#import "UserRespondDemandModel.h"

@interface UserDemandInfoVC ()<UITableViewDataSource,UITableViewDelegate>
{
    DemandModel * demandMod ;

    UIScrollView * scroView ;//基本滚动视图
    UIView * viwTop;//头部
    UIView * viwControl;//切换显示按制
    UIView * viwResDemand;//供应商内容
    UIView * viwDemand; //需求详细
    UITableView * TVResp; //供应商列表
    NSMutableArray * thisData;//代应商表数据
    UILabel * lblResDemand;//供应商信息说明
    NSString *ResDemandStr ;//供应商信息说明文字
    BOOL isHiddenRes; //是否显示切换按钮与供应量
    
    
}
@end

@implementation UserDemandInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"需求详细";

    [self initData];
    //[self initUI];

    NSLog(@"%@",self.Id);
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initData
{
    thisData = [[NSMutableArray alloc]init];
    [self getData];
}
-(void)initUI
{
    //基本可以滚动的视图
    scroView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scroView.contentSize = CGSizeMake(self.view.frame.size.width, 500);//滚动条视图内容范围的大小
    scroView.showsHorizontalScrollIndicator = FALSE;//水平滚动条是否显示
    scroView.showsVerticalScrollIndicator = FALSE;//垂直滚动条是否显示
    [self.view addSubview:scroView];
    
    viwTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 45)];//上面基本信息
    viwControl = [[UIView alloc] initWithFrame:CGRectMake(0, 45,self.view.frame.size.width, 31)];//供应商与需求切换
    viwResDemand = [[UIView alloc] initWithFrame:CGRectMake(0, viwTop.frame.size.height+viwControl.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-viwTop.frame.size.height-viwControl.frame.size.height)];//供应商
    viwDemand = [[UIView alloc]init];//需求
    
    //基本信息显示
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.view.frame.size.width, 33)];
    lblTitle.text = demandMod.Title;
    lblTitle.font = [UIFont systemFontOfSize:15];
    [viwTop addSubview:lblTitle];
    
    UILabel *lblPro =[[UILabel alloc]initWithFrame:CGRectMake(5,33, 100, 12)];
    lblPro.text = demandMod.ProvincialName;
    lblPro.font = [UIFont systemFontOfSize:12];
    lblPro.textAlignment = NSTextAlignmentCenter;
    lblPro.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.3];
    [viwTop addSubview:lblPro];
    
    UILabel *lblCarName =[[UILabel alloc]initWithFrame:CGRectMake(110,33, 50, 12)];
    lblCarName.text = demandMod.CarBrandName;
    lblCarName.font = [UIFont systemFontOfSize:12];
    lblCarName.textColor = [UIColor redColor];
    lblCarName.textAlignment = NSTextAlignmentCenter;
    lblCarName.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.3];
    [viwTop addSubview:lblCarName];
    
    [scroView addSubview:viwTop];
    
    //供应商与需求切换
    
    NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"报价详情",@"详细信息",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedData];
    segmentedControl.frame = CGRectMake(5, 3,self.view.frame.size.width-10, 25);
    /*
     这个是设置按下按钮时的颜色
     */
    segmentedControl.tintColor = [UIColor colorWithRed:49.0 / 256.0 green:148.0 / 256.0 blue:208.0 / 256.0 alpha:1];
    segmentedControl.selectedSegmentIndex = 0;//默认选中的按钮索引
    
    
    /*
     下面的代码实同正常状态和按下状态的属性控制,比如字体的大小和颜色等
     */
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,[UIColor redColor], NSForegroundColorAttributeName, nil ,nil];
    
    
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
    
    [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    //设置分段控件点击相应事件
    [segmentedControl addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
    
    [viwControl addSubview:segmentedControl];
    
    
    //供应商列表
    TVResp = [[UITableView alloc]initWithFrame:CGRectMake(0, 24, self.view.frame.size.width, viwResDemand.frame.size.height-24)];
    TVResp.dataSource = self;
    TVResp.delegate = self;
    
    lblResDemand = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, viwResDemand.frame.size.width, 20)];
    lblResDemand.text = ResDemandStr;
    lblResDemand.textColor = [UIColor grayColor];
    lblResDemand.font = [UIFont systemFontOfSize:12];
    lblResDemand.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.3];
    [viwResDemand addSubview:lblResDemand];
    [viwResDemand addSubview:TVResp];

    
    //需求信息
    UIView *Line0 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
    Line0.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [viwDemand addSubview:Line0];
    
    UILabel *lblYear =              [[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.view.frame.size.width -210, 25)];//车辆出厂年份
    [viwDemand addSubview:lblYear];
    UILabel *lblYearValue =         [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-205, 0, 200, 25)];//车辆出厂年份
    lblYearValue.textAlignment = NSTextAlignmentRight;
    [viwDemand addSubview:lblYearValue];
    
    UIView *Line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 25, self.view.frame.size.width, 0.5)];
    Line1.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [viwDemand addSubview:Line1];
    
    UILabel * lblPaiLiang =         [[UILabel alloc]initWithFrame:CGRectMake(5, 25, self.view.frame.size.width -210, 25)];//排量
    [viwDemand addSubview:lblPaiLiang];
    UILabel * lblPaiLiangValue=     [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-205, 25, 200, 25)];//排量
     lblPaiLiangValue.textAlignment = NSTextAlignmentRight;
    [viwDemand addSubview:lblPaiLiangValue];
    
    UIView *Line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 0.5)];
    Line2.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [viwDemand addSubview:Line2];
    
    
    UILabel * lblLaiyuan =          [[UILabel alloc]initWithFrame:CGRectMake(5, 50, self.view.frame.size.width -210, 25)];//配件来源
    [viwDemand addSubview:lblLaiyuan];
    UILabel * lblLaiyuanValue =     [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-205, 50, 200, 25)];//配件来源
     lblLaiyuanValue.textAlignment = NSTextAlignmentRight;
    [viwDemand addSubview:lblLaiyuanValue];
    
    UIView *Line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 75, self.view.frame.size.width, 0.5)];
    Line3.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [viwDemand addSubview:Line3];
    
    
    UILabel * lblPeiJianName  =     [[UILabel alloc]initWithFrame:CGRectMake(5, 75, self.view.frame.size.width -210, 25)];//配件名称
    [viwDemand addSubview:lblPeiJianName];
    UILabel * lblPeiJianNameValue=  [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-205, 75, 200, 25)];//配件名称
     lblPeiJianNameValue.textAlignment = NSTextAlignmentRight;
    [viwDemand addSubview:lblPeiJianNameValue];
    
    UIView *Line4 = [[UIView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 0.5)];
    Line4.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [viwDemand addSubview:Line4];
    
    
    UILabel * lblPeijianCount =     [[UILabel alloc]initWithFrame:CGRectMake(5, 100, self.view.frame.size.width -210, 25)];//配件数量
    [viwDemand addSubview:lblPeijianCount];
    UILabel * lblPeijianCountValue= [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-205, 100, 200, 25)];//配件数量
     lblPeijianCountValue.textAlignment = NSTextAlignmentRight;
    [viwDemand addSubview:lblPeijianCountValue];
    
    UIView *Line5 = [[UIView alloc]initWithFrame:CGRectMake(0, 125, self.view.frame.size.width, 0.5)];
    Line5.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [viwDemand addSubview:Line5];
    
    
    UILabel * lblPaiJianDate    =   [[UILabel alloc]initWithFrame:CGRectMake(5, 125, self.view.frame.size.width -210, 25)];//截止日期
    [viwDemand addSubview:lblPaiJianDate];
    UILabel * lblPaiJianDateValue  =[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-205, 125, 200, 25)];//截止日期
     lblPaiJianDateValue.textAlignment = NSTextAlignmentRight;
    [viwDemand addSubview:lblPaiJianDateValue];
    
    UIView *Line6 = [[UIView alloc]initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 0.5)];
    Line6.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [viwDemand addSubview:Line6];
    
    
    UILabel * lblPeiJianPlace   =   [[UILabel alloc]initWithFrame:CGRectMake(5, 150, self.view.frame.size.width -210, 25)];//所在地
    [viwDemand addSubview:lblPeiJianPlace];
    UILabel * lblPeiJianPlaceValue= [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-205, 150, 200, 25)];//所在地
     lblPeiJianPlaceValue.textAlignment = NSTextAlignmentRight;
    [viwDemand addSubview:lblPeiJianPlaceValue];
    
    UIView *Line7 = [[UIView alloc]initWithFrame:CGRectMake(0, 175, self.view.frame.size.width, 0.5)];
    Line7.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [viwDemand addSubview:Line7];
    
    
    UILabel * lblPeiJianTel =       [[UILabel alloc]initWithFrame:CGRectMake(5, 175, self.view.frame.size.width -210, 25)];//手机号
    [viwDemand addSubview:lblPeiJianTel];
    UILabel * lblPeiJianTelValue =  [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-205, 175, 200, 25)];//手机号
     lblPeiJianTelValue.textAlignment = NSTextAlignmentRight;
    [viwDemand addSubview:lblPeiJianTelValue];
    
    UIView *Line8 = [[UIView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 0.5)];
    Line8.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [viwDemand addSubview:Line8];
    
    
    UILabel * lblPeiJianReq =       [[UILabel alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 25)];//县体要求
    lblPeiJianReq.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [viwDemand addSubview:lblPeiJianReq];
    UILabel * lblPeiJianReqValue =  [[UILabel alloc]initWithFrame:CGRectMake(5, 225, self.view.frame.size.width, 50)];//县体要求
//    lblPeiJianReqValue.textAlignment = nstex
    lblPeiJianReqValue.numberOfLines = 0;
    [viwDemand addSubview:lblPeiJianReqValue];
    lblYear.text = @"车辆出厂年份";
    lblYearValue.text = [NSString stringWithFormat:@"%@",demandMod.Year]; 
    lblPaiLiang.text = @"排量";
    lblPaiLiangValue.text = [NSString stringWithFormat:@"%@",demandMod.Displacement];
    lblLaiyuan.text = @"配件来源";
    lblLaiyuanValue.text = @""; //配件来源*********************
    lblPeiJianName.text = @"配件名称";
    lblPeiJianNameValue.text = [NSString stringWithFormat:@"%@",demandMod.PartsTypeName];
    lblPeijianCount.text = @"配件数量";
    lblPeijianCountValue.text = [NSString stringWithFormat:@"%@",demandMod.Cnt];
    lblPaiJianDate.text = @"截止日期";
    lblPaiJianDateValue.text = [NSString stringWithFormat:@"%@",demandMod.EndDate];
    lblPeiJianPlace.text =@"所在地";
    lblPeiJianPlaceValue.text = [demandMod.ProvincialName stringByAppendingString:demandMod.CityName];
    lblPeiJianTel.text = @"手机号";
    lblPeiJianTelValue.text = [NSString stringWithFormat:@"%@",demandMod.Mobile];
    lblPeiJianReq.text = @" 具体要求";
    lblPeiJianReqValue.text = [NSString stringWithFormat:@"%@",demandMod.Description];
    
    
    if(isHiddenRes)
    {
        viwDemand.frame = CGRectMake(0, viwTop.frame.size.height, self.view.frame.size.width, 250);
        [scroView addSubview:viwDemand];
    }
    else
    {
        [scroView addSubview:viwControl];
        [scroView addSubview:viwResDemand];
        viwDemand.frame = CGRectMake(0, viwTop.frame.size.height+viwControl.frame.size.height, self.view.frame.size.width, 250);
        [scroView addSubview:viwDemand];
        viwDemand.hidden = YES;
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 报价与需求切换
/**
 *  切换
 *
 *  @param sender <#sender description#>
 */
-(void) doSomethingInSegment:(UISegmentedControl *)sender
{
    //NSLog(@"切换事件");
    NSInteger Index = sender.selectedSegmentIndex;
    
    switch (Index)
    {
        case 0:
            viwDemand.hidden = YES;
            viwResDemand.hidden = NO;
            
            break;
        case 1:
            viwDemand.hidden = NO;
            viwResDemand.hidden = YES;
                       break;
        default:
            break;
    }
}
#pragma mark - 供商表格实现

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
    return 51;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UIFont * BlackFont = [[UIFont alloc]init];
    //设置标识符
    UITableViewCell * cell = [TVResp dequeueReusableCellWithIdentifier:@"mycell"];
    if(cell ==nil)
    {
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"mycell"];
    }
    UserRespondDemandModel *dMod = [thisData objectAtIndex:indexPath.item];
    UILabel *lblCellTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 100, 16)];
    lblCellTitle.text = dMod.StoreName;
    lblCellTitle.font = [UIFont systemFontOfSize:12];
    [cell addSubview:lblCellTitle];
    
    UILabel *lblCellPriceTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 16, 27, 11)];
    lblCellPriceTitle.text = @"总价：";
    lblCellPriceTitle.textColor = [UIColor grayColor];
    lblCellPriceTitle.font = [UIFont systemFontOfSize:9];
    [cell addSubview:lblCellPriceTitle];
    
    UILabel *lblCellPriceValue = [[UILabel alloc]initWithFrame:CGRectMake(30, 16, 100, 11)];
    lblCellPriceValue.text = [NSString stringWithFormat:@"￥%@", dMod.PartsPrice];
    lblCellPriceValue.textColor = [UIColor redColor];
    lblCellPriceValue.font = [UIFont systemFontOfSize:9];
    [cell addSubview:lblCellPriceValue];
    
    UIView *Line = [[UIView alloc]initWithFrame:CGRectMake(0, 27, self.view.frame.size.width, 0.5)];
    Line.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [cell addSubview:Line];
    
    UILabel *lblCellGoto = [[UILabel alloc]initWithFrame:CGRectMake(0, 27, self.view.frame.size.width, 24)];
    lblCellGoto.text = @"进店看一看";
    lblCellGoto.textAlignment = NSTextAlignmentCenter;
    lblCellGoto.font = [UIFont systemFontOfSize:15];
    [cell addSubview:lblCellGoto];
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
- (void)getData
{
    [SVProgressHUD showWithStatus:k_Status_Load];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,k_url_GetDemandDetail];
    
    NSDictionary *paramDict = @{
                                @"id":self.Id
                                };
    NSLog(@"请求地址%@请求内容%@",urlStr,paramDict);
    [ApplicationDelegate.httpManager POST:urlStr parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //http请求状态
        if (task.state == NSURLSessionTaskStateCompleted) {
            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
            //NSLog(@"%@",jsonDic);
            NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
            if ([status isEqualToString:@"1"]) {
                //成功返回
                demandMod =[[DemandModel alloc]initWithNSDictionary:[[jsonDic objectForKey:@"Data"] objectForKey:@"Demand"] ];
                
                NSMutableArray *mar = [[jsonDic objectForKey:@"Data"] objectForKey:@"Respond"] ;
                //NSLog(@"%@",jsonDic);
                for (NSDictionary * dDic in mar) {
                    UserRespondDemandModel *dMod = [[UserRespondDemandModel alloc] initWithNSDictionary:dDic];
                    [thisData addObject: dMod];
                    //NSLog(@"供应商数据%@",thisData);
                }
                if(mar.count>0)
                {
                    ResDemandStr = [NSString stringWithFormat:@"   已有%d人报价",mar.count];
                    isHiddenRes = NO;
                }else
                {
                    isHiddenRes = YES;
                }
                
                [self initUI];
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
