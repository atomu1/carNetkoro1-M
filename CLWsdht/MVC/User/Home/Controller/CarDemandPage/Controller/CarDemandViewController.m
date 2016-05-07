//
//  CarDemandViewController.m
//  CLWsdht
//
//  Created by 关宇琼 on 16/4/26.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "CarDemandViewController.h"
#import "BackBtView.h"
#import "BaseHeader.h"
#import "UserInfo.h"
#import "DemandGModel.h"
#import "CarDemandDetailsViewController.h"
#import "ReleaseRequireModel.h"

#define rowNum (NSInteger)((kScreen_Height - 50) / 96 + 1)


@interface CarDemandViewController () <BackBtViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSInteger totalNum;
    id __block chooseAddress;
    id __block chooseSortStyle;
}


@property (strong, nonatomic) IBOutlet UILabel *addressLb;

@property (strong, nonatomic) IBOutlet UILabel *sortLb;

@property (nonatomic, strong) BackBtView *btView;

@property (strong, nonatomic) IBOutlet UITableView *demandListTableview;

@property (nonatomic, strong) NSMutableArray *modelArr;



@property (nonatomic, assign) NSInteger times;

@end

@implementation CarDemandViewController

- (void)dealloc {
    _btView.delegate = nil;
    _demandListTableview.dataSource = nil;
    _demandListTableview.delegate = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"修配厂检索";
        self.automaticallyAdjustsScrollViewInsets = NO;
        _modelArr = [NSMutableArray arrayWithCapacity:0];
    
        [self setBack];
    }
    return self;
}

- (void)setBack  {
    UIButton *back = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [back setFrame:CGRectMake(0, 0, 20, 20)];
    [back setTintColor:[UIColor orangeColor]];
    [back setImage:[UIImage imageNamed:@"fanhuiy"] forState:(UIControlStateNormal)];
    [back addTarget:self action:@selector(back:) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *item  = [[UIBarButtonItem  alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = item;
}
- (void)back:(UIButton *)back {
    [self backAction];
}

- (void)viewWillAppear:(BOOL)animated {
    if (!self.tabBarController.tabBar.hidden) {
        self.tabBarController.tabBar.hidden = YES;
    }
    [self addNoti];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self removeNoti];
}

- (void)removeNoti {
    [kNotiCenter removeObserver:chooseAddress];
    [kNotiCenter removeObserver:chooseSortStyle];
}


- (void)addNoti {
    chooseAddress = [kNotiCenter addObserverForName:@"chooseAddress" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        ReleaseRequireModel *proModel = note.userInfo[@"proModel"];
        ReleaseRequireModel *cityModel = note.userInfo[@"cityModel"];
        _addressLb.text = [NSString stringWithFormat:@"%@ %@",proModel.Name, cityModel.Name];
    }];
    chooseSortStyle = [kNotiCenter addObserverForName:@"chooseSortStyle" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        _sortLb.text = note.userInfo[@"style"];
    }];
}

- (BackBtView *)btViewWithBtViewStyle:(BtViewStyle)style {
    if (!_btView) {
        _btView = [[BackBtView alloc] initWithBtViewStyle:style];
        _btView.delegate = self;
        [ApplicationDelegate.window addSubview:_btView];
        [ApplicationDelegate.window bringSubviewToFront:_btView];
        [_btView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.bottom.equalTo(ApplicationDelegate.window);
        }];
    }
    return _btView;
}

- (void)pass {
    _btView = nil;
}

#pragma mark buttonClick
- (IBAction)opreation:(UIButton *)sender {
    switch (sender.tag) {
        case 111:
            [self btViewWithBtViewStyle:Double];
            break;
        case 112:
            [self btViewWithBtViewStyle:Single];
            break;
    }
}


#pragma mark - 上拉刷新
- (void)setHeaderRefresh {
    
    _demandListTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _modelArr = [NSMutableArray arrayWithCapacity:0];
        [self dataHandle];
        
        [_demandListTableview.mj_header beginRefreshing];
        [_demandListTableview reloadData];
    }];
}


#pragma mark - 下拉加载
- (void)setFooterRefresh {
    _demandListTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _times++;
        NSLog(@"%ld", _times);
        [_demandListTableview.mj_footer endRefreshing];
        [_demandListTableview reloadData];
    }];
}



#pragma mark  dataHandle 
- (void)dataHandle {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"UsrGarage.asmx/GetGarageList"];
    NSDictionary *paramDic = @{
                               @"brandSIG":@"",
                               
                               @"sortJson":@"",
                               
                               @"useForSIG":@"",
                               
                               @"garageJson":@"",
                               
                               @"start":@"0",
                               
                               @"limit":@"10"
                               };
    
    [ApplicationDelegate.httpManager POST:urlStr parameters:paramDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //http请求状态
        if (task.state == NSURLSessionTaskStateCompleted) {
            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
            
            NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
            if ([status isEqualToString:@"1"]) {
                //成功返回
                [self datprocessingWith:jsonDic];
                totalNum = [[jsonDic objectForKey:@"Total"] integerValue];
                [SVProgressHUD dismiss];
            } else {
                [SVProgressHUD showErrorWithStatus:jsonDic[@"Message"]];
            }
            [_demandListTableview.mj_header endRefreshing];
            
        } else {
            [SVProgressHUD showErrorWithStatus:k_Error_Network];
            [_demandListTableview.mj_header endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        //请求异常
        [_demandListTableview.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:k_Error_Network];
    }];

}


- (void)datprocessingWith:(NSDictionary *)jsonDic {
    NSDictionary *dicFirst = jsonDic[@"Data"];
    NSArray *dataArr = dicFirst[@"Data"];
    NSLog(@"%@",jsonDic);
    for (NSDictionary *dic in dataArr) {
        DemandGModel *model = [DemandGModel modelWithDictionary:dic];
        [_modelArr addObject:model];
    }
    [_demandListTableview reloadData];
}


- (void)initUI {
    _demandListTableview.delegate = self;
    _demandListTableview.dataSource = self;
    
    _demandListTableview.tableFooterView = [[UIView alloc] init];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (_modelArr.count) {
        case 0:
            return 1;
            break;
            
        default:
            return _modelArr.count;
            break;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BaseTableViewCell *cell = nil;
    BaseModel *model = nil;
    switch (_modelArr.count) {
        case 0: {
            static NSString *cellName = @"SoyTableViewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell = [CellFactory creatCellWithClassName:cellName cellModel:model indexPath:indexPath];
            }
        }
            break;
            
        default: {
            model = _modelArr[indexPath.row];
            static NSString *cellName = @"DemandCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell = [CellFactory creatCellWithClassName:cellName cellModel:model indexPath:indexPath];
            }
        }
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (_modelArr.count) {
        case 0:
            [SVProgressHUD showErrorWithStatus:@"暂无匹配的修理厂"];
            break;
            
        default: {
            CarDemandDetailsViewController *details = [[CarDemandDetailsViewController alloc] init];
            
          
            details.demandModel = _modelArr[indexPath.row];
            [self.navigationController pushViewController:details animated:YES];
        }
            break;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataHandle];
    [self initUI];
    [self setHeaderRefresh];
    [self setFooterRefresh];
    // Do any additional setup after loading the view from its nib.
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
