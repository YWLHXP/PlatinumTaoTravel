//
//  XPAddInformationViewController.m
//  PlatinumTT
//
//  Created by dragon on 16/7/13.
//  Copyright © 2016年 win. All rights reserved.
//

#import "XPAddInformationViewController.h"
#import "XPMyMessageViewController.h"

@interface XPAddInformationViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *IDField;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;

@end

@implementation XPAddInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"完善信息";
    self.view.backgroundColor = self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1];
    self.nameField.delegate = self;
    //修改文本框光标显示位置
    [self moveTheCursorPosition];

    [self configNavigation];
}

- (void)configNavigation
{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:self action:@selector(jumpAction)];
}

- (void)jumpAction
{
    [self.navigationController pushViewController:[XPMyMessageViewController new] animated:YES];
}

#pragma mark -UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.nameField.text.length > 2 ) {
        self.updateButton.enabled = YES;
        [self.updateButton setBackgroundImage:[UIImage imageNamed:@"bgBtnDis"] forState:UIControlStateNormal];
    }else
    {
        self.updateButton.enabled = NO;
    }
    return YES;
}

#pragma mark -修改文本框光标显示位置
- (void)moveTheCursorPosition
{
    UIImageView  *leftPhone = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weizhi"]];
    leftPhone.frame = CGRectMake(0, 0, 20, 20);
    leftPhone.contentMode = UIViewContentModeCenter;
    self.nameField.leftViewMode = UITextFieldViewModeAlways;
    self.nameField.leftView = leftPhone;
    
    UIImageView  *IDImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weizhi"]];
    IDImageView.frame = CGRectMake(0, 0, 20, 20);
    IDImageView.contentMode = UIViewContentModeCenter;
    self.IDField.leftViewMode = UITextFieldViewModeAlways;
    self.IDField.leftView = IDImageView;
}

- (IBAction)updateButtonClick:(id)sender {
     [self.navigationController pushViewController:[XPMyMessageViewController new] animated:YES];
}
@end
