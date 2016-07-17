//
//  UITextField+TextField.h
//  text
//
//  Created by dragon on 16/7/16.
//  Copyright © 2016年 win. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (TextField)

//限定字数
- (void)textLength:(int)length;

//判断是否是手机号
+ (BOOL)isNumberPhone:(NSString *)mobile;
@end
