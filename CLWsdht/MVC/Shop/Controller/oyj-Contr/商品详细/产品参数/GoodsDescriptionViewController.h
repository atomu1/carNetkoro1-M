//
//  GoodsDescriptionViewController.h
//  CLWsdht
//
//  Created by OYJ on 16/4/9.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "BaseViewController.h"

@interface GoodsDescriptionViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *style;
@property (weak, nonatomic) IBOutlet UILabel *kind;
@property (weak, nonatomic) IBOutlet UILabel *color;
@property (weak, nonatomic) IBOutlet UILabel *origin;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
