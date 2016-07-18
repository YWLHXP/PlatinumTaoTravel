//
//  XPShareViewController.m
//  PlatinumTT
//
//  Created by 罗惠 on 16/7/14.
//  Copyright © 2016年 win. All rights reserved.
//

#import "XPShareViewController.h"
#import "XPHotelDetailTableViewController.h"
@interface XPShareViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *darkImageView;


@end

@implementation XPShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.darkImageView.userInteractionEnabled = YES;
}

//微信按钮点击事件
- (IBAction)weixinBtnclick:(id)sender {
    NSLog(@"1");

}

//朋友圈按钮点击事件
- (IBAction)friendBtnClick:(id)sender {
    NSLog(@"2");

}

//QQ按钮点击事件
- (IBAction)qqBtnClick:(id)sender {
    NSLog(@"3");
}

//灰色空白处点击跳转
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.darkImageView.frame, p)) {
        [self.view removeFromSuperview];
    }
}


@end
