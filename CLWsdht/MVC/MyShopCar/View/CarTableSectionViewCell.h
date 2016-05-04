//
//  CarTableSectionViewCell.h
//  CLWsdht
//
//  Created by OYJ on 16/4/11.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectButton.h"

@interface CarTableSectionViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet SelectButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
