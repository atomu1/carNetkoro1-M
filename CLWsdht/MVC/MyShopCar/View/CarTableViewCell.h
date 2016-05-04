//
//  CarTableViewCell.h
//  CLWsdht
//
//  Created by OYJ on 16/4/11.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectButton.h"

@interface CarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet SelectButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet SelectButton *addButton;
@property (weak, nonatomic) IBOutlet SelectButton *reduceButton;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;

@end
