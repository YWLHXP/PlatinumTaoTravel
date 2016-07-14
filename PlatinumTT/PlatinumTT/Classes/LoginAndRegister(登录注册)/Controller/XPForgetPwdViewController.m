//
//  XPForgetPwdViewController.m
//  PlatinumTT
//
//  Created by dragon on 16/7/12.
//  Copyright © 2016年 win. All rights reserved.
//

#import "XPForgetPwdViewController.h"
#import "UIView+frame.h"
#import "LViewPushAnimation.h"
#import "XPNewPwdViewController.h"

@interface XPForgetPwdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation XPForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1]; 
    self.navigationItem.title = @"找回密码";
    
    [self configNavigation];
    
    //修改文本框光标显示位置
    [self moveTheCursorPosition];
    
    self.phoneTextField.delegate = self;
}

#pragma mark -修改文本框光标显示位置
- (void)moveTheCursorPosition
{
    UIImageView  *leftPhone = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weizhi"]];
    leftPhone.frame = CGRectMake(0, 0, 10, 20);
    leftPhone.contentMode = UIViewContentModeCenter;
    self.phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    self.phoneTextField.leftView = leftPhone;
}

- (void)configNavigation
{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.size = CGSizeMake(30, 30);
    [button setImage:[UIImage imageNamed:@"backbutton"] forState:UIControlStateNormal];
    // 让按钮的内容往左边偏移10
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)leftBtnClick
{
    [LViewPushAnimation viewCtlPushAndPopWithAnimationCtl:self andSubtypes:kCATransitionFromLeft];
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = YES;
}

#pragma mark - 下一步
- (IBAction)nextButtonClick:(id)sender {
    [self.navigationController pushViewController:[XPNewPwdViewController new] animated:YES];
}

#pragma mark -UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //判断手机号是否为11位
    if (self.phoneTextField.text.length == 11 ) {
        self.nextButton.enabled = YES;
        [self.nextButton setBackgroundImage:[UIImage imageNamed:@"bgBtnDis"] forState:UIControlStateNormal];
        return NO;
    }else
    {
        self.nextButton.enabled = NO;
    }
    return YES;
}
@end
