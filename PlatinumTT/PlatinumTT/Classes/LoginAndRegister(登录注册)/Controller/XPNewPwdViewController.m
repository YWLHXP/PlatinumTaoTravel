//
//  XPNewPwdViewController.m
//  PlatinumTT
//
//  Created by dragon on 16/7/13.
//  Copyright © 2016年 win. All rights reserved.
//

#import "XPNewPwdViewController.h"
#import <MBProgressHUD.h>

@interface XPNewPwdViewController ()<UITextFieldDelegate>
{
    NSInteger _count;
    NSInteger _number;
}

@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation XPNewPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:2];
    self.navigationItem.title = @"新密码";
    self.codeField.delegate = self;
    [self sendAction];
    
}

- (void)sendAction
{
    self.getCodeBtn.enabled = NO;
    _count = 60;
    _number = 0;
    [self.getCodeBtn setTitle:@"60秒" forState:UIControlStateDisabled];
    [self.getCodeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}


- (void)timerFired:(NSTimer *)_timer
{
    if (_count !=0 && _number ==0) {
        _count -=1;
        NSString *str = [NSString stringWithFormat:@"%ld秒", (long)_count];
        [self.getCodeBtn setTitle:str forState:UIControlStateDisabled];
        [self.getCodeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    }else{
        [_timer invalidate];
        self.getCodeBtn.enabled = YES;
        [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

- (void)showTooltip:(NSString *)tip
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = NSLocalizedString(tip, @"HUD message title");
    hud.labelFont = [UIFont systemFontOfSize:13];
    [hud hide:YES afterDelay:2];
}

#pragma mark -UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //判断手机号是否为11位
    if (self.codeField.text.length == 4 ) {
        self.sureButton.enabled = YES;
        [self.sureButton setBackgroundImage:[UIImage imageNamed:@"bgBtnDis"] forState:UIControlStateNormal];
        return NO;
    }else
    {
        self.sureButton.enabled = NO;
    }
    return YES;
}



#pragma mark - 确定按钮
- (IBAction)sureButtonClicl:(id)sender {
    
    
}
@end
