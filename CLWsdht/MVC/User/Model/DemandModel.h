//
//  DemandModel.h
//  CLWsdht
//
//  Created by clish on 16/4/14.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemandModel : NSObject


@property (nonatomic ,copy) NSString *Id;
@property (nonatomic ,copy) NSString *UsrId;
@property (nonatomic ,copy) NSString *CarModelId;
@property (nonatomic ,copy) NSString *PartsTypeId;
@property (nonatomic ,copy) NSString *Cnt;
@property (nonatomic ,copy) NSString *Year;
@property (nonatomic ,copy) NSString *EndDate;
@property (nonatomic ,copy) NSString *State;
@property (nonatomic ,copy) NSString *AddDate;
@property (nonatomic ,copy) NSString *Description;
@property (nonatomic ,copy) NSString *Views;
@property (nonatomic ,copy) NSString *CarBrandId;
@property (nonatomic ,copy) NSString *PartsUseForId;
@property (nonatomic ,copy) NSString *UsrName;
@property (nonatomic ,copy) NSString *CarBrandName;
@property (nonatomic ,copy) NSString *CarModelName;
@property (nonatomic ,copy) NSString *PartsUseForName;
@property (nonatomic ,copy) NSString *PartsTypeName;
@property (nonatomic ,copy) NSString *Img;
@property (nonatomic ,copy) NSString *ProvincialName;
@property (nonatomic ,copy) NSString *CityName;
@property (nonatomic ,copy) NSString *Title;
@property (nonatomic ,copy) NSString *Displacement;
@property (nonatomic ,copy) NSString *ProvincialId;
@property (nonatomic ,copy) NSString *CityId;
@property (nonatomic ,copy) NSString *Mobile;
@property (nonatomic ,copy) NSString *Enable;
@property (nonatomic ,copy) NSString *RespondId;
@property (nonatomic ,copy) NSString *Reason;
-(DemandModel *) initWithNSDictionary: (NSDictionary *) dic;

@end
