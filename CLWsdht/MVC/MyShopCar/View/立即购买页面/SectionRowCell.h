//
//  SectionRowCell.h
//  CLWsdht
//
//  Created by OYJ on 16/4/14.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionRowCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *PurityName;
@property (weak, nonatomic) IBOutlet UILabel *PartsSrcName;

@end
