//
//  DemandDetailsModel.h
//  CLWsdht
//
//  Created by 关宇琼 on 16/4/27.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "BaseModel.h"

@interface DemandDetailsModel : BaseModel


@property (nonatomic, copy) NSString *Address;
@property (nonatomic, copy) NSString *DistrictId;
@property (nonatomic ,copy) NSString *IdNumber;
@property (nonatomic ,copy) NSString *EvalTimes;
@property (nonatomic ,copy) NSString *Lat;
@property (nonatomic ,copy) NSString *Lng;
@property (nonatomic ,strong) NSArray *ServiceCarBrand;
@property (nonatomic ,strong) NSArray *ServicePartsUseFor;
@property (nonatomic, copy) NSString *Id;



@end
