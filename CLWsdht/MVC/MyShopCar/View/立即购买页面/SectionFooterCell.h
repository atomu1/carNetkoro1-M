//
//  SectionFooterCell.h
//  CLWsdht
//
//  Created by OYJ on 16/4/14.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionFooterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *adviceTextField;

@property (weak, nonatomic) IBOutlet UILabel *totalCount;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;

@end
