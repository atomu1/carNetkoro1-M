//
//  returnDataInfoPartsList.h
//  CLWsdht
//
//  Created by OYJ on 16/4/21.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "returnDataDetailPartsList.h"

@interface returnDataInfoPartsList : NSObject
@property (assign, nonatomic) int Total;
@property (strong, nonatomic) NSMutableArray *Data;
@end
