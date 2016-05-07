//
//  NameCollectionViewCell.m
//  CLWsdht
//
//  Created by 关宇琼 on 16/4/27.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "NameCollectionViewCell.h"
#import "PartsClassModel.h"
#import "BaseHeader.h"
#import "CarClassModel.h"

@interface NameCollectionViewCell ()
@property (strong, nonatomic)  UILabel *title;


@end

@implementation NameCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = [[UILabel alloc] init];
        
        
        [self.contentView addSubview:_title];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    _title.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:107 / 255.0 blue:25 / 255.0 alpha:1.0];
    _title.textAlignment = 1;
    _title.font = [UIFont systemFontOfSize:15.0];
    [_title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo (self.contentView);
    }];
}

- (void)setCarModel:(CarClassModel *)carModel {
    if (_carModel != carModel) {
        _carModel = carModel;
    }
    
    _title.text = carModel.BrandName;
  
}
- (void)setPartModel:(PartsClassModel *)partModel {
    if (_partModel != partModel) {
        _partModel = partModel;
    }
    _title.text = partModel.PartsUsrForName;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
