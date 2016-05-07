//
//  ReleaseModel.h
//  CLWsdht
//
//  Created by tom on 16/4/27.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReleaseModel : NSObject

@property (nonatomic, copy) NSString *Id;//
@property (nonatomic, copy) NSString *UsrGarageName;//修理厂名字
@property (nonatomic, copy) NSString *PartsUseFor;//修理能力
@property (nonatomic, copy) NSString *Url;//图片
@property (nonatomic, copy) NSString *Province;//省
@property (nonatomic, copy) NSString *CityName;//市
@property (nonatomic, copy) NSString *FuturePrice;//报价
@property (nonatomic, copy) NSString *Mobile;//电话
@property (nonatomic, copy) NSString *Address;//地址
@property (nonatomic, copy) NSString *CityId;//城市ID

- (NSMutableArray *)releaseModelWithDict: (NSDictionary *) dataDict;

@end
