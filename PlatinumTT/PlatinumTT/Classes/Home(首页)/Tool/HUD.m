//
//  HUD.m
//  MBLoadingHUD
//
//  Created by develop on 15/9/21.
//  Copyright (c) 2015年 songhailiang. All rights reserved.
//

#import "HUD.h"
#import <UIKit/UIKit.h>

@implementation HUD

+(MBProgressHUD *)sharedHUD{
    static MBProgressHUD* hud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hud = [[MBProgressHUD alloc] initWithWindow:[[UIApplication sharedApplication].delegate window]];
        hud.removeFromSuperViewOnHide = YES;
    });
    return hud;
}

/**
 *  隐藏hud
 */
+ (void)hideHUD
{
    if([self sharedHUD].superview){
        [[self sharedHUD] hide:YES];
    }
}

/**
 *  显示hud（只有图片）
 */
+ (void)showLoadingHUD {
    [self showLoadingHUDWithText:nil];
}

/**
 *  显示hud（图片+文字）
 *
 *  @param text 文字内容
 */
+ (void)showLoadingHUDWithText:(NSString *)text {
    
    [self showLoadingHUDWithText:text inView:nil];
}

+ (void)showLoadingHUDWithText:(NSString *)text inView:(UIView *)containerView {
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"network_loadingLogo"]];
    //    imgView.layer.cornerRadius = imgView.frame.size.width / 2;
    //    imgView.layer.masksToBounds = YES;
    
    UIView *customerView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, imgView.frame.size.width*2, imgView.frame.size.width*2)];
    [customerView addSubview:imgView];
    imgView.center = customerView.center;
    
    //外围背景Layer
    CAShapeLayer *borderLayer = [CAShapeLayer new];
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor clearColor].CGColor;
    borderLayer.lineWidth = 3.0f;
    borderLayer.bounds = customerView.bounds;
    borderLayer.position = CGPointMake(CGRectGetMidX(customerView.bounds), CGRectGetMidY(customerView.bounds));
    borderLayer.path = [UIBezierPath bezierPathWithArcCenter:borderLayer.position radius:(borderLayer.bounds.size.width - 2)/2 startAngle:0 endAngle:M_PI * 2 clockwise:YES].CGPath;
    
    [customerView.layer addSublayer:borderLayer];
    
    //滚动中得Layer
    CAShapeLayer *animationLayer = [CAShapeLayer new];
    animationLayer.strokeColor = [UIColor whiteColor].CGColor;
    animationLayer.lineWidth = borderLayer.lineWidth - 1;
    animationLayer.fillColor = [UIColor clearColor].CGColor;
    animationLayer.bounds = borderLayer.bounds;
    animationLayer.position = borderLayer.position;
    animationLayer.path = [UIBezierPath bezierPathWithArcCenter:borderLayer.position radius:(borderLayer.bounds.size.width)/2 startAngle:0 endAngle:M_PI_2*1 clockwise:YES].CGPath;
    
    //渐变色Layer
    CAGradientLayer *gradienLayer = [CAGradientLayer new];
    gradienLayer.bounds = borderLayer.bounds;
    gradienLayer.position = borderLayer.position;
    gradienLayer.colors = [self gradientColorArrayWithColor:[UIColor whiteColor]];
    gradienLayer.startPoint = CGPointMake(1, 1);
    gradienLayer.endPoint = CGPointMake(0, 0);
    [gradienLayer setMask:animationLayer];
    
    [customerView.layer addSublayer:gradienLayer];
    
    //动画
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform";
    NSValue *val1 = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0 * M_PI, 0, 0, 1)];
    NSValue *val2 = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.5 * M_PI, 0, 0, 1)];
    NSValue *val3 = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(1.0 * M_PI, 0, 0, 1)];
    NSValue *val4 = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(1.5 * M_PI, 0, 0, 1)];
    NSValue *val5 = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(2.0 * M_PI, 0, 0, 1)];
    anim.values = @[val1, val2, val3, val4, val5];
    anim.duration = 1.0;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.repeatCount = MAXFLOAT;
    anim.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [animationLayer addAnimation:anim forKey:@"ringLayerAnimation"];
    
    MBProgressHUD *hud = [self sharedHUD];
    [self appendToView:containerView];
    hud.customView = customerView;
    hud.opacity = 0.5;
    hud.mode = MBProgressHUDModeCustomView;
    hud.margin = 15.0f; //设置HUD和customerView的边距（默认是20）
    hud.yOffset = -20.0f; //设置HUD距离中心位置的y偏移（同理也可以设置xOffset）
    //    hud.userInteractionEnabled = NO; //userInteractionEnabled=NO时，不会遮挡containerView，view可以正常响应
    if (text.length > 0) {
        hud.labelText = text;
    }
    [hud show:YES];
}

#pragma mark - private method

+ (void)appendToView:(UIView *)containerView
{
    if (containerView) {
        [containerView addSubview:[self sharedHUD]];
    }
    else {
        [[[UIApplication sharedApplication].delegate window] addSubview:[self sharedHUD]];
    }
}

+ (NSArray *)gradientColorArrayWithColor: (UIColor *)color{
    if (!color) {
        return nil;
    }
    return @[(id)[color colorWithAlphaComponent:0.0].CGColor, (id)[color colorWithAlphaComponent:0.1].CGColor, (id)[color colorWithAlphaComponent:0.2].CGColor, (id)[color colorWithAlphaComponent:0.3].CGColor, (id)[color colorWithAlphaComponent:0.6].CGColor, (id)[color colorWithAlphaComponent:0.8].CGColor, (id)[color colorWithAlphaComponent:1.0].CGColor, (id)[color colorWithAlphaComponent:1.0].CGColor, (id)[color colorWithAlphaComponent:1.0].CGColor];
}

@end
