//
//  StoreBtCell.m
//  CLWsdht
//
//  Created by 关宇琼 on 16/4/27.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "StoreBtCell.h"
#import "BaseHeader.h"
#import "NameCollectionViewCell.h"


@interface StoreBtCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *showListCollectionView;

@property (nonatomic, strong) NSArray *tempArr;

@end

@implementation StoreBtCell

- (UICollectionView *)showListCollectionView {
    if (!_showListCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.itemSize = CGSizeMake((kScreen_Width - 20) / 3 , 40);
        flow.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        flow.minimumLineSpacing = 5;
        flow.minimumInteritemSpacing = 5;
        _showListCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _showListCollectionView.scrollEnabled = NO;
        
        _showListCollectionView.delegate = self;
        _showListCollectionView.dataSource = self;
        [self.contentView addSubview:_showListCollectionView];
        _showListCollectionView.backgroundColor = [UIColor whiteColor];
       
        [_showListCollectionView registerClass:[NameCollectionViewCell class] forCellWithReuseIdentifier:@"NameCollectionViewCell"];
        [_showListCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.left.equalTo(self.contentView);
        }];
    }
    return _showListCollectionView;
}


- (void)setCarBrandArr:(NSArray *)carBrandArr {
    if (_carBrandArr != carBrandArr) {
        _carBrandArr = carBrandArr;
    }
   
    [_showListCollectionView reloadData];
}
- (void)setPartsUseForArr:(NSArray *)partsUseForArr {
    if (_partsUseForArr != partsUseForArr) {
        _partsUseForArr = partsUseForArr;
    }
    [_showListCollectionView reloadData];
}


- (void)initUI {
    [self showListCollectionView];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([_key isEqualToString:@"carBrandArr"]) {
        return _carBrandArr.count;
    } else {
        return _partsUseForArr.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NameCollectionViewCell" forIndexPath:indexPath];
    if ([_key isEqualToString:@"carBrandArr"]) {
        cell.carModel = _carBrandArr[indexPath.item];
    } else {
        cell.partModel = _partsUseForArr[indexPath.item];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initUI];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
