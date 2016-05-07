//
//  ChooseCarViewController.m
//  CLWsdht
//
//  Created by 关宇琼 on 16/4/28.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "ChooseCarViewController.h"
#import "ReleaseRequireModel.h"
#import "TableViewSectionIndexTitlesView.h"
#import "BaseHeader.h"

@interface ChooseCarViewController () <UITableViewDelegate, UITableViewDataSource, TableViewSectionIndexTitlesViewDelegate>
#pragma tbvList;
@property (strong, nonatomic) IBOutlet UITableView *carTypeListTableView;
@property (strong, nonatomic) IBOutlet UITableView *detailsCarListTableView;


@property (nonatomic, strong) UILabel *titleIndex;


#pragma mark  sectionTitlesList
@property (nonatomic, strong) TableViewSectionIndexTitlesView *sectionIndexView;

#pragma mark date
@property (nonatomic, strong) NSDictionary *allCarDataDic;
@property (nonatomic, strong) NSMutableArray *allKeys;
@property (nonatomic, strong) NSMutableDictionary *modelDic;


@property (nonatomic, strong) NSMutableArray *detailsModelArr;


@property (nonatomic, strong) ReleaseRequireModel *carModel;
@end

@implementation ChooseCarViewController

- (void)dealloc {
    _carTypeListTableView.dataSource = nil;
    _carTypeListTableView.delegate = nil;
    _detailsCarListTableView.dataSource = nil;
    _detailsCarListTableView.delegate = nil;
    _sectionIndexView.delegate = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"车辆选择";
        self.automaticallyAdjustsScrollViewInsets = NO;
       
        
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
- (void)addNoti {
}
- (void)viewWillDisappear:(BOOL)animated {
    [self removeNoti];
}
- (void)removeNoti {
}

#pragma mark data
- (void)carDataHandle {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CarType" ofType:@"plist"];
    
    self.allCarDataDic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    self.allKeys = [NSMutableArray arrayWithCapacity:0];
    
    [self.allKeys addObjectsFromArray:[[_allCarDataDic allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    self.modelDic = [NSMutableDictionary dictionaryWithCapacity:0];
    for (NSString *key in _allKeys) {
        NSArray *arr = _allCarDataDic[key];
        NSMutableArray *modelArr = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dic in arr) {
            ReleaseRequireModel *model = [ReleaseRequireModel modelWithDictionary:dic];
            [modelArr addObject:model];
        }
        [_modelDic setObject:modelArr forKey:key];
    }
    
}


#pragma mark sectionIndex
- (void)creatTitleIndexList {
    if (!_sectionIndexView) {
        _sectionIndexView = [[TableViewSectionIndexTitlesView alloc] init];
        [self.view addSubview:_sectionIndexView];
        _sectionIndexView.backgroundColor = [UIColor clearColor];
        _sectionIndexView.delegate = self;
        [_sectionIndexView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(3);
            make.height.equalTo([NSNumber numberWithFloat:kScreen_Height * 0.6]);
            make.width.equalTo(@20);
            make.centerY.equalTo(self.carTypeListTableView);
        }];
        _sectionIndexView.titles = _allKeys;
    }
}
#pragma mark 代理方法
- (void)scrollerToSection:(NSInteger)section withIndex:(NSString *)index{
    [_carTypeListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    [self addSignWith:index];
}
- (void)addSignWith:(NSString *)index {
    if (!_titleIndex) {
        _titleIndex = [[UILabel alloc] init];
        [self.view addSubview:_titleIndex];
        _titleIndex.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _titleIndex.layer.cornerRadius = kScreen_Width / 16;
        _titleIndex.layer.masksToBounds = YES;
        _titleIndex.text = index;
        _titleIndex.font = [UIFont systemFontOfSize:kScreen_Width / 8];
        _titleIndex.textAlignment = 1;
        _titleIndex.textColor = [UIColor whiteColor];
        [_titleIndex mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kScreen_Width / 4, kScreen_Width / 4));
            make.center.equalTo(self.view);
        }];
        [self delayOperation];
    }
}

#pragma mark  GCD 延时操作
- (void)delayOperation {
    double delayInSeconds = 1.0;
    WS(weakSelf);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf delayMethod]; });
}

- (void)delayMethod {
    [_titleIndex  removeFromSuperview];
    _titleIndex = nil;
}
- (void)setTableView {
    _carTypeListTableView.delegate = self;
    _carTypeListTableView.dataSource = self;
    _detailsCarListTableView.delegate = self;
    _detailsCarListTableView.dataSource = self;
    _detailsCarListTableView.tableFooterView = [[UIView alloc] init];
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    [_carTypeListTableView addGestureRecognizer:swipeGR];
}
- (void)swipeAction:(UISwipeGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (_detailsCarListTableView.hidden == NO) {
            _detailsCarListTableView.hidden = YES;
            _sectionIndexView.hidden = NO;
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([tableView isEqual:_carTypeListTableView]) {
        return self.allKeys.count;
    } else {
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_carTypeListTableView]) {
        NSString *key = _allKeys[section];
        NSArray *typeSection = _allCarDataDic[key];
        return [typeSection count];
    } else {
        
        return _detailsModelArr.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([tableView isEqual:_carTypeListTableView]) {
        static NSString *cellIdentifier = @"carTypeCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellIdentifier];
        }
        ReleaseRequireModel *model = _modelDic[_allKeys[indexPath.section]][indexPath.row];
        cell.textLabel.text = model.Name;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    } else {
        static NSString *cellIdentifier = @"carDetailsCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellIdentifier];
        }
        ReleaseRequireModel *model = _detailsModelArr[indexPath.row];
        cell.textLabel.text = model.Name;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ([tableView isEqual:_carTypeListTableView]) {
        return 25;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *bgView = nil;
    if ([tableView isEqual:_carTypeListTableView]) {
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kScreen_Width,30)];
        bgView.backgroundColor = [UIColor lightGrayColor];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [bgView addSubview:titleLabel];
        [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(bgView);
            make.left.equalTo(@20);
        }];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor colorWithRed:60 /255.0 green:60 / 255.0 blue:60 / 255.0 alpha:1.0];
        titleLabel.font = [UIFont systemFontOfSize:14];
        NSString *key = _allKeys[section];
        titleLabel.text = key;
        
    }
    return bgView;
}


#pragma mark cellClick
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([tableView isEqual:_carTypeListTableView]) {
        _sectionIndexView.hidden = YES;
        _detailsModelArr = [NSMutableArray arrayWithCapacity:0];
        ReleaseRequireModel *model = _modelDic[_allKeys[indexPath.section]][indexPath.row];
        self.carModel = model;
        for (NSDictionary *dic in model.T_DicCarModel) {
            ReleaseRequireModel *detailModel = [ReleaseRequireModel modelWithDictionary:dic];
            [_detailsModelArr addObject:detailModel];
        }
        if (_detailsCarListTableView.hidden) {
            _detailsCarListTableView.hidden = NO;
        }
        [_detailsCarListTableView reloadData];
        
    } else {
        [kNotiCenter postNotificationName:@"addCarTypeandName" object:nil userInfo:@{@"carModel":self.carModel,@"detailsModel":_detailsModelArr[indexPath.row]}];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self carDataHandle];
    [self setTableView];
    [self creatTitleIndexList];
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
