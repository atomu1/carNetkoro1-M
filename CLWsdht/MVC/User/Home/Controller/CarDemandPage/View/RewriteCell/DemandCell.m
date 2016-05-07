//
//  DemandCell.m
//  CLWsdht
//
//  Created by 关宇琼 on 16/4/26.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "DemandCell.h"
#import "BaseHeader.h"
#import "DemandGModel.h"
#import "StartView.h"

@interface DemandCell ()

@property (strong, nonatomic) IBOutlet UIImageView *storeImage;
@property (strong, nonatomic) IBOutlet UILabel *titleName;

@property (strong, nonatomic) IBOutlet UILabel *partsClass;
@property (strong, nonatomic) IBOutlet UILabel *storeAddress;
@property (strong, nonatomic) IBOutlet UIImageView *signImage;
@property (strong, nonatomic) IBOutlet UILabel *soyLb;

@property (nonatomic, strong) DemandGModel *demondModel;
@property (nonatomic, strong) StartView *ratingView;


@end


@implementation DemandCell

- (void)setModel:(BaseModel *)model {
    _demondModel  = (DemandGModel *)model;
    [_storeImage sd_setImageWithURL:[NSURL URLWithString:_demondModel.Url]];
    _soyLb.text = @"已认证";
    [_signImage setImage:[UIImage imageNamed:@"shang"]];
    _titleName.text = _demondModel.Name;
    _storeAddress.text = [NSString stringWithFormat:@"%@  %@", _demondModel.ProvincialName, _demondModel.CityName];
    [_ratingView setRating:[_demondModel.Rating integerValue]];
}

- (void)awakeFromNib {
    [self ratingView];
}
- (StartView *)ratingView {
    if (!_ratingView) {
        _ratingView = [[StartView alloc] init];
        [self.contentView addSubview:_ratingView];
        [_ratingView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.storeImage.mas_right).offset(14);
            make.top.equalTo(self.partsClass.mas_bottom).offset(8);
            make.bottom.equalTo(self.storeAddress.mas_top).offset(-8);
        }];
    }
    return _ratingView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
