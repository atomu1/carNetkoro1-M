//
//  DemandDetailsCollectionCell.m
//  CLWsdht
//
//  Created by 关宇琼 on 16/4/27.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "DemandDetailsCollectionCell.h"
#import "BaseHeader.h"
#import "PartsClassModel.h"
#import "DemandDetailsModel.h"
#import "StoreBtCell.h"
#import "CarClassModel.h"


@interface DemandDetailsCollectionCell () <UITableViewDelegate, UITableViewDataSource>  {
    NSInteger first;
    NSInteger second;
}
@property (strong, nonatomic) UILabel *lineLb;

@property (strong, nonatomic) IBOutlet UIButton *bt1;

@property (strong, nonatomic) IBOutlet UIButton *bt2;
@property (strong, nonatomic) IBOutlet UIView *titleBv;


@property (strong, nonatomic) IBOutlet UITableView *repairTableView;
@property (nonatomic, strong) NSMutableArray *carBrandArr;
@property (nonatomic, strong) NSMutableArray *partsUseForArr;
@property (nonatomic, strong) DemandDetailsModel *detailsModel;

@end

@implementation DemandDetailsCollectionCell

- (void)dealloc {
    _repairTableView.delegate = nil;
    _repairTableView.dataSource = nil;
}

- (void)setModel:(BaseModel *)model {
    _detailsModel = (DemandDetailsModel *)model;
    for (NSDictionary *dic in _detailsModel.ServiceCarBrand) {
        CarClassModel *car = [CarClassModel modelWithDictionary:dic];
        [_carBrandArr addObject:car];
    }
    if (_carBrandArr.count / 3 >= 1) {
        switch (_carBrandArr.count %3) {
            case 0:
                first  = _carBrandArr.count / 3;
                break;
                
            default:
                first  = _carBrandArr.count / 3 + 1;
                break;
        }
    } else {
        first = 1;
    }
    
    for (NSDictionary *dic in _detailsModel.ServicePartsUseFor) {
        PartsClassModel *parts = [PartsClassModel modelWithDictionary:dic];
        [_partsUseForArr addObject:parts];
    }
    if (_carBrandArr.count / 3 >= 1) {
        switch (_partsUseForArr.count %3) {
            case 0:
                second  = _partsUseForArr.count / 3;
                break;
                
            default:
                second  = _partsUseForArr.count / 3 + 1;
                break;
        }
    } else {
        second = 1;
    }
    [_repairTableView reloadData];
}

- (IBAction)select:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        [_lineLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 2));
            make.centerX.equalTo(sender);
            make.top.equalTo(_titleBv.mas_bottom);
        }];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initData];
    [self initUI];
    // Initialization code
}
- (void)initData {
    _partsUseForArr = [NSMutableArray arrayWithCapacity:0];
    _carBrandArr = [NSMutableArray arrayWithCapacity:0];
}

- (void)initUI {
    [self setLineLb];
    _repairTableView.dataSource = self;
    _repairTableView.delegate = self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"StoreBtCell";
    StoreBtCell *cell = [[[NSBundle mainBundle] loadNibNamed:cellName owner:nil options:nil] firstObject];
   
    if (indexPath.section == 0) {
        cell.carBrandArr = _carBrandArr;
        cell.key = @"carBrandArr";
    } else {
        cell.partsUseForArr = _partsUseForArr;
        cell.key = @"partsUseForArr";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            
            return first * 40 + (first +1) * 5;
            
            break;
            
        default:
            return second * 40 + (second +1) * 5;
            
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UILabel *)setLineLb {
    if (!_lineLb) {
        _lineLb = [[UILabel alloc] init];
        _lineLb.backgroundColor  = [UIColor redColor];
        [self.contentView addSubview:_lineLb];
        [_lineLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 2));
            make.centerX.equalTo(_bt1);
            make.top.equalTo(_titleBv.mas_bottom);
        }];
    }
    return _lineLb;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *vi = nil;
    vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 40)];
    UILabel *lb = [[UILabel alloc] init];
    [vi addSubview:lb];
    [lb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vi).offset(20);
        make.bottom.top.right.equalTo(vi);
    }];
    lb.textAlignment = 0;
    lb.textColor = [UIColor colorWithRed:160 /255.0 green:160/ 255.0 blue:160 /255.0 alpha:1.0];
    switch (section) {
        case 0:
            lb.text = @"维 修 能 力";
            break;
            
        default:
            lb.text = @"店 铺 展 示";
            break;
    }
    return vi;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
