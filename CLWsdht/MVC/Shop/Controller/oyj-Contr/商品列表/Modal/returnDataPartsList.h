//
//  returnDataPartsList.h
//  CLWsdht
//
//  Created by OYJ on 16/4/21.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "returnDataInfoPartsList.h"

@interface returnDataPartsList : NSObject
@property (assign, nonatomic) BOOL Success;
@property (copy, nonatomic) NSString *Message;
@property (strong, nonatomic) returnDataInfoPartsList *Data;
@end
