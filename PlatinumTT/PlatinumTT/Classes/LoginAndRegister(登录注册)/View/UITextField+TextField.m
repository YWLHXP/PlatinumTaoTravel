//
//  UITextField+TextField.m
//  text
//
//  Created by dragon on 16/7/16.
//  Copyright © 2016年 win. All rights reserved.
//

#import "UITextField+TextField.h"
#import <objc/objc.h>
#import <objc/objc-runtime.h>

@implementation UITextField (TextField)

static NSString *kLimitTextLengthKey = @"kLimitTextLengthKey";

-(void)textLength:(int)length
{
   //让一个对象可以保持对另一个对象的引用，并获取那个对象
    //objc_setAssociatedObject需要四个参数：源对象，关键字，关联的对象和一个关联策略。
    objc_setAssociatedObject(self, (__bridge const void *)(kLimitTextLengthKey), [NSNumber numberWithInt:length], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addTarget:self action:@selector(textFieldTextLengthLimit:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldTextLengthLimit:(id)sender
{
    NSNumber *lengthNumber = objc_getAssociatedObject(self, (__bridge const void *)(kLimitTextLengthKey));
    int length = [lengthNumber intValue];
    if(self.text.length > length){
        self.text = [self.text substringToIndex:length];
    }
}

//判断是否是手机号
+ (BOOL)isNumberPhone:(NSString *)mobile
{
    //手机号以13，15，18开头，八个 \d 数字字符
    NSString *phone = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0|8|7]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phone];
    return [phoneTest evaluateWithObject:mobile];
}
@end
