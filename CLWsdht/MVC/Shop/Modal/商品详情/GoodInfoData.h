//
//  GoodInfoData.h
//  CLWsdht
//
//  Created by OYJ on 16/4/8.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodInfoData : NSObject
@property (copy, nonatomic) NSString *Id;
@property (copy, nonatomic) NSString *UsrStoreId;
@property (copy, nonatomic) NSString *StoreName;
@property (copy, nonatomic) NSString *StoreMobile;
@property (copy, nonatomic) NSString *Name;
@property (copy, nonatomic) NSString *PartsTypeId;
@property (copy, nonatomic) NSString *TypeName;
@property (copy, nonatomic) NSString *PartsUseForId;
@property (copy, nonatomic) NSString *UseForName;
@property (assign, nonatomic) float Price;
@property (copy, nonatomic) NSString *Spec;
@property (copy, nonatomic) NSString *ColourId;
@property (copy, nonatomic) NSString *ColourName;
@property (copy, nonatomic) NSString *Description;
@property (copy, nonatomic) NSString *PurityName;
@property (copy, nonatomic) NSString *PartsSrcName;
@property (strong, nonatomic) NSMutableArray *Imgs;
@property (strong, nonatomic) NSMutableArray *CarModels;
@property (copy, nonatomic) NSString *AddDate;


@end
