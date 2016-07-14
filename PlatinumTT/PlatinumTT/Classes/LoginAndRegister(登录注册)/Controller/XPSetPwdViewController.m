//
//  XPSetPwdViewController.m
//  PlatinumTT
//
//  Created by dragon on 16/7/13.
//  Copyright © 2016年 win. All rights reserved.
//

#import "XPSetPwdViewController.h"
#import "UIView+frame.h"
#import "LViewPushAnimation.h"
#import "XPAddInformationViewController.h"

@interface XPSetPwdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation XPSetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1];

    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationItem.title = @"设置密码";
    self.pwdField.delegate = self;
    //修改文本框光标显示位置
    [self moveTheCursorPosition];
    
    [self configNavigation];
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

//-(void)viewWillAppear:(BOOL)animated
//{
//    self.navigationController.navigationBar.translucent = YES;
//}

- (void)leftBtnClick
{
    [LViewPushAnimation viewCtlPushAndPopWithAnimationCtl:self andSubtypes:kCATransitionFromLeft];
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark -修改文本框光标显示位置
- (void)moveTheCursorPosition
{
    UIImageView  *leftPhone = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weizhi"]];
    leftPhone.frame = CGRectMake(0, 0, 20, 20);
    leftPhone.contentMode = UIViewContentModeCenter;
    self.pwdField.leftViewMode = UITextFieldViewModeAlways;
    self.pwdField.leftView = leftPhone;
}

#pragma mark -UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.pwdField.text.length >= 6 ) {
        self.sureButton.enabled = YES;
        [self.sureButton setBackgroundImage:[UIImage imageNamed:@"bgBtnDis"] forState:UIControlStateNormal];
    }else
    {
        self.sureButton.enabled = NO;
    }
    return YES;
}

- (IBAction)sureButtonClick:(id)sender {
    [self.navigationController pushViewController:[XPAddInformationViewController new] animated:YES];
}
@end
