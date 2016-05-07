//
//  UserAddressEditVC.h
//  CLWsdht
//
//  Created by clish on 16/4/18.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "BaseViewController.h"

@interface UserAddressEditVC : BaseViewController
@property (nonatomic ,copy) NSString *Id;
@property (nonatomic ,copy) NSString *ProvincialName;
@property (nonatomic ,copy) NSString *CityName;
@property (nonatomic ,copy) NSString *DistrictName;
@property (nonatomic ,copy) NSString *DetailAddress;
@property (nonatomic ,copy) NSString *ZipCode;
@property (nonatomic ,copy) NSString *Name;
@property (nonatomic ,copy) NSString *Telephone;
@property (nonatomic ,copy) NSString *IsDefault;
@property   UIPickerView *pickerView;

@end
