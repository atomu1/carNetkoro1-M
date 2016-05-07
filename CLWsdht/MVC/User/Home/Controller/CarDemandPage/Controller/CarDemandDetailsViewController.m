//
//  CarDemandDetailsViewController.m
//  CLWsdht
//
//  Created by 关宇琼 on 16/4/27.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "CarDemandDetailsViewController.h"
#import "DemandDetailsModel.h"
#import "DemandGModel.h"
#import "BaseHeader.h"
#import "AddRepairViewController.h"

@interface CarDemandDetailsViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSInteger totalNum;
    NSInteger first;
    NSInteger second;
}

@property (strong, nonatomic) IBOutlet UITableView *detailsInfoTableView;

@property (nonatomic, strong) NSMutableArray *modelArr;

@property (nonatomic, strong) DemandDetailsModel *tempModel;

@end

@implementation CarDemandDetailsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"修配厂详情";
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
}


- (void)addNoti {
}


- (void)setDemandModel:(DemandGModel *)demandModel {
    if (_demandModel != demandModel) {
        _demandModel = demandModel;
    }
    
}
- (void)dataHandle {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"auth.asmx/GarageByMobile"];
    NSDictionary *paramDic = @{
                               @"mobile":[NSString stringWithFormat:@"%ld", _demandModel.Mobile],
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
            [_detailsInfoTableView.mj_header endRefreshing];
            
        } else {
            [SVProgressHUD showErrorWithStatus:k_Error_Network];
            [_detailsInfoTableView.mj_header endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        //请求异常
        [_detailsInfoTableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:k_Error_Network];
    }];
}
- (void)datprocessingWith:(NSDictionary *)jsonDic {
    NSDictionary *dicFirst = jsonDic[@"Data"];
    
    NSLog(@"%@",jsonDic);
    
    _tempModel = [DemandDetailsModel modelWithDictionary:dicFirst];
    if (_tempModel.ServiceCarBrand.count / 3 >= 1) {
        switch (_tempModel.ServiceCarBrand.count %3) {
            case 0:
                first  = _tempModel.ServiceCarBrand.count / 3;
                break;
                
            default:
                first  = _tempModel.ServiceCarBrand.count / 3 + 1;
                break;
        }
    } else {
        first = 1;
    }
    if (_tempModel.ServicePartsUseFor.count / 3 >= 1) {
        switch (_tempModel.ServicePartsUseFor.count %3) {
            case 0:
                second  = _tempModel.ServicePartsUseFor.count / 3;
                break;
                
            default:
                second  = _tempModel.ServicePartsUseFor.count / 3 + 1;
                break;
        }
    } else {
        second = 1;
    }

    [_modelArr addObject:_tempModel];

    [_detailsInfoTableView reloadData];
}

- (void)initUI {
    _detailsInfoTableView.delegate = self;
    _detailsInfoTableView.dataSource = self;
    _detailsInfoTableView.tableFooterView = [[UIView alloc] init];
    _detailsInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + _modelArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = nil;
    BaseModel *model = nil;
    switch (indexPath.row) {
        case 0: {
            model = _demandModel;
            static NSString *cellName = @"DemandDetailsTitleCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell = [CellFactory creatCellWithClassName:cellName cellModel:model indexPath:indexPath];
            }
        }
            break;
            
        default: {
            model = _modelArr[0];
            static NSString *cellName = @"DemandDetailsCollectionCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell = [CellFactory creatCellWithClassName:cellName cellModel:model indexPath:indexPath];
            }
        }
            break;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return 182;
            break;
        default: {
            
            return 130 + (first + second) * 40 + (first + second +2) * 5;
            
        }
            break;
    }
    
}


- (IBAction)sureJump:(id)sender {
    AddRepairViewController *addRepair = [[AddRepairViewController alloc] init];
    addRepair.detailsModel = _tempModel;
    [self.navigationController pushViewController:addRepair animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataHandle];
    [self initUI];
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
