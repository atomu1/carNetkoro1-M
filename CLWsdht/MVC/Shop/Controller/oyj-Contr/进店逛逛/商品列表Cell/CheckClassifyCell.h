//
//  CheckClassifyCell.h
//  CLWsdht
//
//  Created by OYJ on 16/4/19.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellRowButton.h"

@interface CheckClassifyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet CellRowButton *imageButton1;
@property (weak, nonatomic) IBOutlet UILabel *nameTitle1;
@property (weak, nonatomic) IBOutlet UILabel *priceTitle1;
@property (weak, nonatomic) IBOutlet CellRowButton *imageButton2;
@property (weak, nonatomic) IBOutlet UILabel *nameTitle2;
@property (weak, nonatomic) IBOutlet UILabel *priceTitle2;
@property (weak, nonatomic) IBOutlet UIView *view2;

@end
