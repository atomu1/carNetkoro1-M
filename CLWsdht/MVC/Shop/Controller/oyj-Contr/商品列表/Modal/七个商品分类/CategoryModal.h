//
//  CategoryModal.h
//  CLWsdht
//
//  Created by OYJ on 16/4/27.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModal : NSObject
@property (assign, nonatomic) BOOL Success;
@property (copy, nonatomic) NSString *Message;
@property (strong, nonatomic) NSString *Data;
@end
