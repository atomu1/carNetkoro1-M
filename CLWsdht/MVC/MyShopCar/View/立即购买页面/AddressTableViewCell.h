//
//  AddressTableViewCell.h
//  CLWsdht
//
//  Created by OYJ on 16/4/22.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *telphoneLabel;

@end
