//
//  GoodInfoReturn.h
//  CLWsdht
//
//  Created by OYJ on 16/4/8.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodInfoData.h"

@interface GoodInfoReturn : NSObject
@property (copy, nonatomic) NSString *Success;
@property (copy, nonatomic) NSString *Message;
@property (assign, nonatomic) GoodInfoData *Data;

@end
