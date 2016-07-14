//
//  XPBindPhoneViewController.m
//  PlatinumTT
//
//  Created by dragon on 16/7/14.
//  Copyright © 2016年 win. All rights reserved.
//

#import "XPBindPhoneViewController.h"
#import "XPHomeViewController.h"
#import <MBProgressHUD.h>

@interface XPBindPhoneViewController ()<UITextFieldDelegate>
{
    NSInteger _count;
    NSInteger _number;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
/** timer */
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation XPBindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"绑定手机";
    self.view.backgroundColor = self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:2];
    self.navigationController.navigationBar.translucent = YES;
    self.phoneTextField.delegate = self;
    [self configNavigation];
}

- (void)configNavigation
{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:self action:@selector(jumpAction)];
}

- (void)jumpAction
{
    [self.navigationController pushViewController:[XPHomeViewController new] animated:YES];
}

#pragma mark -UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //判断手机号是否为11位
    if (self.phoneTextField.text.length == 11 ) {
        self.updateButton.enabled = YES;
        [self.updateButton setBackgroundImage:[UIImage imageNamed:@"bgBtnDis"] forState:UIControlStateNormal];
       // self.getCodeButton.enabled = YES;
        [self.getCodeButton setHighlighted:YES];
        return NO;
    }else
    {
        self.updateButton.enabled = NO;
    }
    return YES;
}

- (IBAction)getCodeButtonClick:(id)sender {
    self.getCodeButton.enabled = NO;
    _count = 60;
    _number = 0;
    [self.getCodeButton setTitle:@"60秒" forState:UIControlStateDisabled];
    [self.getCodeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)timerFired:(NSTimer *)_timer
{
    if (_count !=0 && _number ==0) {
        _count -=1;
        NSString *str = [NSString stringWithFormat:@"%ld秒", (long)_count];
        [self.getCodeButton setTitle:str forState:UIControlStateDisabled];
        [self.getCodeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    }else{
        [self.timer invalidate];
        self.getCodeButton.enabled = YES;
        [self.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self showTooltip:@"请求超时，请重新获取"];
    }


}

-(void)dealloc
{
    [self.timer invalidate];
}

- (IBAction)updateButtonClick:(id)sender {
    [self.navigationController pushViewController:[XPHomeViewController new] animated:YES];
}

- (void)showTooltip:(NSString *)tip
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = NSLocalizedString(tip, @"HUD message title");
    hud.labelFont = [UIFont systemFontOfSize:13];
    [hud hide:YES afterDelay:2];
}
@end
