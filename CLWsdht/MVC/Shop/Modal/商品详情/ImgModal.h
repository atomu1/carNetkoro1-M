//
//  ImgModal.h
//  CLWsdht
//
//  Created by OYJ on 16/4/8.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImgModal : NSObject
@property (copy, nonatomic) NSString *Id;
@property (copy, nonatomic) NSString *DataId;
@property (copy, nonatomic) NSString *Url;
@property (copy, nonatomic) NSString *IsFirst;
@property (copy, nonatomic) NSString *AddDate;
@property (assign, nonatomic) BOOL IsSingle;


@end
