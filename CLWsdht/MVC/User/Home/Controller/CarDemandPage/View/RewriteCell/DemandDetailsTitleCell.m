//
//  DemandDetailsTitleCell.m
//  CLWsdht
//
//  Created by 关宇琼 on 16/4/27.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "DemandDetailsTitleCell.h"
#import "DemandGModel.h"
#import "StartView.h"
#import "BaseHeader.h"

@interface DemandDetailsTitleCell ()

@property (strong, nonatomic) IBOutlet UILabel *ratingBv;

@property (strong, nonatomic) IBOutlet UIImageView *storeImage;
@property (strong, nonatomic) IBOutlet UILabel *sentimentLb;

@property (strong, nonatomic) IBOutlet UILabel *titleName;
@property (strong, nonatomic) IBOutlet UILabel *storeAddress;

@property (nonatomic, strong) DemandGModel *demandModel;

@property (nonatomic, strong) StartView *ratingView;

@end

@implementation DemandDetailsTitleCell


- (void)setModel:(BaseModel*)model {
    _demandModel = (DemandGModel *)model;
    [_storeImage sd_setImageWithURL:[NSURL URLWithString:_demandModel.Url]];
    _titleName.text = _demandModel.Name;
    _storeAddress.text = [NSString stringWithFormat:@"%@  %@", _demandModel.ProvincialName, _demandModel.CityName];
    [_ratingView setRating:[_demandModel.Rating integerValue]];
}

- (IBAction)call:(id)sender {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self ratingView];
    // Initialization code
}
- (StartView *)ratingView {
    if (!_ratingView) {
        _ratingView = [[StartView alloc] init];
        [self.contentView addSubview:_ratingView];
        [_ratingView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.ratingBv.mas_right).offset(5);
            make.centerY.equalTo(self.ratingBv);
            make.height.equalTo(@20);
        }];
    }
    return _ratingView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
