//
//  ProductInfoViewController.h
//  PagingDemo
//
//  Created by Liu jinyong on 15/8/6.
//  Copyright (c) 2015年 Baidu 91. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SDCycleScrollView.h"
#import "UserInfo.h"

@interface ProductInfoViewController : BaseViewController<SDCycleScrollViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) NSString *goodID;
@property (nonatomic,strong) NSString *storeMobile;


@end
