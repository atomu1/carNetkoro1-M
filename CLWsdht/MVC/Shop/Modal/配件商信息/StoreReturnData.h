//
//  StoreReturnData.h
//  CLWsdht
//
//  Created by OYJ on 16/4/9.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreData.h"

@interface StoreReturnData : NSObject
@property (copy, nonatomic) NSString *Success;
@property (copy, nonatomic) NSString *Message;
@property (assign, nonatomic) StoreData *Data;
@end
