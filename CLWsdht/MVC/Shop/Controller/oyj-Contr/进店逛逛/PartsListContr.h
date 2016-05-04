//
//  PartsListContr.h
//  CLWsdht
//
//  Created by OYJ on 16/4/16.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "BaseViewController.h"

@interface PartsListContr : BaseViewController
@property(nonatomic,strong)NSString *PartsTypeId;//子类
@property(nonatomic,strong)NSString *UsrStoreId;//店铺id
@property(nonatomic,strong)NSString *PartsUseForId;//大类

@property(nonatomic,assign)int state;//0全部商品 1大类别商品 2小类别商品
@end
