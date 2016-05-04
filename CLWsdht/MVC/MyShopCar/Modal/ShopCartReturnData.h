//
//  ShopCartReturnData.h
//  CLWsdht
//
//  Created by OYJ on 16/4/11.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopCartData.h"

@interface ShopCartReturnData : NSObject
@property (assign, nonatomic) BOOL Success;
@property (strong, nonatomic) NSString *Message;
@property (strong, nonatomic) ShopCartData *Data;
@end
