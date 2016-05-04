//
//  ChoseSparePartsViewController.h
//  CLWsdht
//
//  Created by tom on 16/1/21.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ChoseSparePartsViewController : BaseViewController
@property(nonatomic,copy)NSString *categoryID;

@property (weak, nonatomic) IBOutlet UIButton *districtButton;
@property (weak, nonatomic) IBOutlet UIButton *sortButton;
@property (weak, nonatomic) IBOutlet UIButton *careTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *repairBagButton;


@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
