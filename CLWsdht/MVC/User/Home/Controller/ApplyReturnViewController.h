//
//  ApplyReturnViewController.h
//  CLWsdht
//
//  Created by tom on 16/4/28.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface ApplyReturnViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UITextField *reasonTextField;
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;

@property (nonatomic, strong) OrderModel *returnNumber;
@end
