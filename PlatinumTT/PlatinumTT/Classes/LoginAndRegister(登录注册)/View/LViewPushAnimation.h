//
//  LViewPushAnimation.h
//  SPOffices
//
//  Created by 罗惠 on 16/7/7.
//  Copyright © 2016年 罗惠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LViewPushAnimation : NSObject

/** 视图控制器跳转动画*/
+ (void)viewCtlPushAndPopWithAnimationCtl:(UIViewController *)ctl andSubtypes:(NSString *) ad;

/** 首页视图头部的显示工具*/
+ (UIView *)returnLHomeHeadView;

@end
