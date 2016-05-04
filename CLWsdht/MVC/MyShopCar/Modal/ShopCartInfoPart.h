//
//  ShopCartInfoPart.h
//  CLWsdht
//
//  Created by OYJ on 16/4/11.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCartInfoPart : NSObject
@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *UsrId;
@property (strong, nonatomic) NSString *PartsId;
@property (strong, nonatomic) NSString *AddDate;
@property (assign, nonatomic) BOOL DelFlg;
@property (strong, nonatomic) NSString *UsrStoreId;
@property (strong, nonatomic) NSString *PartsUseForId;
@property (strong, nonatomic) NSString *PartsTypeId;
@property (strong, nonatomic) NSString *Name;
@property (assign, nonatomic) float Price;
@property (strong, nonatomic) NSString *ColourId;
@property (strong, nonatomic) NSString *Description;
@property (strong, nonatomic) NSString *Spec;
@property (strong, nonatomic) NSString *StoreName;
@property (strong, nonatomic) NSString *UseForName;
@property (strong, nonatomic) NSString *TypeName;
@property (strong, nonatomic) NSString *Img;
@property (strong, nonatomic) NSString *Url;
@property (strong, nonatomic) NSString *ColourName;
@property (strong, nonatomic) NSString *PurityName;
@property (strong, nonatomic) NSString *PartsSrcName;
@property (strong, nonatomic) NSString *PartsSrcId;
@property (strong, nonatomic) NSString *PurityId;
@property (assign, nonatomic) int Views;
@property (assign, nonatomic) int Cnt;

@end
