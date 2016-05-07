//
//  AddRepairViewController.m
//  CLWsdht
//
//  Created by 关宇琼 on 16/4/28.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "AddRepairViewController.h"
#import "PlaceHolderTextView.h"
#import "ChooseCarViewController.h"
#import "ReleaseRequireModel.h"
#import "BaseHeader.h"
#import "UserInfo.h"
#import "DemandDetailsModel.h"

@interface AddRepairViewController () {
    id __block carName;
}

@property (strong, nonatomic) IBOutlet UIView *chooseCarBv;

@property (strong, nonatomic) IBOutlet UIView *descripBv;

@property (strong, nonatomic) IBOutlet UILabel *desTitle;

@property (strong, nonatomic) IBOutlet UILabel *carType;

@property (nonatomic, strong) NSMutableArray *modelArr;

@property (nonatomic, strong) PlaceHolderTextView *placeHTV;

@property (nonatomic, strong) ReleaseRequireModel *carTypeModel;
@property (nonatomic, strong) ReleaseRequireModel *carDetailsModel;

@property (nonatomic, assign) BOOL isChoose;

@end

@implementation AddRepairViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
       
        self.title = @"车辆问题说明";
        self.automaticallyAdjustsScrollViewInsets = NO;
        _modelArr = [NSMutableArray arrayWithCapacity:0];
        [self addNoti];
        [self setBack];
        self.isChoose = NO;
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
    
}
- (void)addNoti {
   carName =  [kNotiCenter addObserverForName:@"addCarTypeandName" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
       _carTypeModel = note.userInfo[@"carModel"];
       _carDetailsModel = note.userInfo[@"detailsModel"];
       
       _carType.text = _carDetailsModel.Name;
       _isChoose = YES;
       [self removeNoti];
    }];
}

- (void)removeNoti {
    [kNotiCenter removeObserver:carName];
}


- (PlaceHolderTextView *)placeHTV {
    if (!_placeHTV) {
        _placeHTV = [[PlaceHolderTextView alloc] init];
        _placeHTV.backgroundColor = [UIColor colorWithRed: 240 / 255.0  green:240 / 255.0 blue:240 /255.0 alpha:1.0f];
        _placeHTV.tag = 571;
        _placeHTV.layer.cornerRadius = 20;
        _placeHTV.layer.masksToBounds = YES;
        
        _placeHTV.font = [UIFont systemFontOfSize:13];
        _placeHTV.layer.cornerRadius = 15;
        _placeHTV.layer.masksToBounds = YES;
        [self.descripBv addSubview:_placeHTV];
        _placeHTV.placeholder = @"车主请描述下您的车辆问题, 让维修厂更了解您的车辆状况";
        [_placeHTV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.desTitle.mas_bottom).offset(8);
            make.left.equalTo(self.descripBv).offset(10);
            make.right.equalTo(self.descripBv).offset(-10);
            make.bottom.equalTo(self.descripBv).offset(-8);
        }];
    }
    return _placeHTV;
}

- (void)initUI {
    [self placeHTV];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    _chooseCarBv.userInteractionEnabled = YES;
    [_chooseCarBv addGestureRecognizer:tap];
}

- (void)tap:(UITapGestureRecognizer *)tap {
    ChooseCarViewController *choo = [[ChooseCarViewController alloc] init];
    [self.navigationController pushViewController:choo animated:YES];
}

- (void)setDetailsModel:(DemandDetailsModel *)detailsModel {
    if (_detailsModel != detailsModel) {
        _detailsModel = detailsModel;
    }
    
}


- (IBAction)sur:(id)sender {
    if (!_isChoose) {
        [SVProgressHUD showInfoWithStatus:@"请选择车型"];
        return;
    }
    if (_placeHTV.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请您简要叙述问题方便修配厂了解"];
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"Usr.asmx/AddOrders"];
    NSDictionary *param = @{
                            @"CarBrandId":_carTypeModel.Id,
                            @"CarModelId":_carDetailsModel.Id,
                            @"Evaluate":@"",
                            @"Id":[MJYUtils mjy_uuid],
                            @"Message":_placeHTV.text,
                            @"Mobile":ApplicationDelegate.userInfo.Mobile,
                            @"Price":@"0",
                            @"Reason":@"",
                            @"Serial":@"",
                            @"UsrGarageId":_detailsModel.Id,
                            @"UsrId":ApplicationDelegate.userInfo.user_Id
                            };
    NSDictionary *paramDic = @{
                               @"garageOrdersJson": [JYJSON JSONStringWithDictionaryOrArray:param],
                               
                               @"partsOrdersJson":@"[]",
                               
                               @"partsLstJson":@"[]"
                               };
    [ApplicationDelegate.httpManager POST:urlStr parameters:paramDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //http请求状态
        if (task.state == NSURLSessionTaskStateCompleted) {
            
            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
            NSLog(@"%@", jsonDic);
            NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
            if ([status isEqualToString:@"1"]) {
                //成功返回
                [SVProgressHUD showSuccessWithStatus:@"发布成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:jsonDic[@"Message"]];
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:k_Error_Network];

        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
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
