//
//  returnData.h
//  CLWsdht
//
//  Created by OYJ on 16/4/15.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface returnData : NSObject
@property (assign, nonatomic) BOOL Success;
@property (strong, nonatomic) NSString *Message;
@property (strong, nonatomic) NSMutableArray *Data;

@end
