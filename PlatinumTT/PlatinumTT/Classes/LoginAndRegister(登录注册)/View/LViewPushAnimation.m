//
//  LViewPushAnimation.m
//  SPOffices
//
//  Created by 罗惠 on 16/7/7.
//  Copyright © 2016年 罗惠. All rights reserved.
//

#import "LViewPushAnimation.h"

@implementation LViewPushAnimation
+ (void)viewCtlPushAndPopWithAnimationCtl:(UIViewController *)ctl andSubtypes:(NSString *)ad
{
    CATransition * animation = [CATransition animation];
    animation.duration = 0.15;    //  时间
    
    /**  type：动画类型
     *  pageCurl       向上翻一页
     *  pageUnCurl     向下翻一页
     *  rippleEffect   水滴
     *  suckEffect     收缩
     *  cube           方块
     *  oglFlip        上下翻转
     */
    animation.type = @"rippleEffect";
    
    /**  type：页面转换类型
     *  kCATransitionFade       淡出
     *  kCATransitionMoveIn     覆盖
     *  kCATransitionReveal     底部显示
     *  kCATransitionPush       推出
     */
    animation.type = kCATransitionPush;
    
    /**  subtype：出现的方向
     *  kCATransitionFromRight       右
     *  kCATransitionFromLeft        左
     *  kCATransitionFromTop         上
     *  kCATransitionFromBottom      下
     */
   // animation.subtype = kCATransitionFromRight;
    animation.subtype = ad;
    [ctl.view.window.layer addAnimation:animation forKey:nil];

}
+ (UIView *)returnLHomeHeadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 160, XPScreenWidth - 10, 30)];
    view.backgroundColor = [UIColor yellowColor];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, view.frame.size.width - 145, 25)];
    lbl.backgroundColor = [UIColor greenColor];
    [view addSubview:lbl];
    
    UIPageControl *pageCtl = [[UIPageControl alloc] initWithFrame:CGRectMake(view.frame.size.width - 120 , 5,110, 20)];
    pageCtl.backgroundColor = [UIColor purpleColor];
    
    
    [view addSubview:pageCtl];
    
    return view;
}

@end
