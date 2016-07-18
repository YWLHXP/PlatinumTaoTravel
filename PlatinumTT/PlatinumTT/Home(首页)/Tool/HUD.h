//
//  HUD.h
//  MBLoadingHUD
//
//  Created by develop on 15/9/21.
//  Copyright (c) 2015年 songhailiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface HUD : NSObject

/**
 *  隐藏hud
 */
+ (void)hideHUD;

/**
 *  显示hud（只有图片）
 */
+ (void)showLoadingHUD;

/**
 *  显示hud（图片+文字）
 *
 *  @param text 文字内容
 */
+ (void)showLoadingHUDWithText:(NSString *)text;

/**
 *  显示hud（图片+文字）
 *
 *  @param text          文字内容
 *  @param containerView 容器View
 */
+ (void)showLoadingHUDWithText:(NSString *)text inView:(UIView *)containerView;

@end
