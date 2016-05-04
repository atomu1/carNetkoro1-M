//
//  SelectButton.h
//  CLWsdht
//
//  Created by OYJ on 16/4/11.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectButton : UIButton
@property(assign,nonatomic)NSInteger section;
@property(assign,nonatomic)NSInteger row;
@property(assign,nonatomic)BOOL selectState;
@property(strong,nonatomic) UITextField *countTextField;

@end
