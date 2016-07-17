//
//  XPAccountAndLoginViewController.m
//  PlatinumTT
//
//  Created by dragon on 16/7/12.
//  Copyright © 2016年 win. All rights reserved.
//

#import "XPAccountAndLoginViewController.h"
#import "XPNavigationController.h"
#import "UIView+frame.h"
#import "XPForgetPwdViewController.h"
#import "LViewPushAnimation.h"
#import "UITextField+TextField.h"
#import <MBProgressHUD.h>

@interface XPAccountAndLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation XPAccountAndLoginViewController

//忘记密码
- (IBAction)forgetPwd:(id)sender {
    XPNavigationController *nav = [[XPNavigationController alloc] initWithRootViewController:[XPForgetPwdViewController new]];
    [LViewPushAnimation viewCtlPushAndPopWithAnimationCtl:self andSubtypes:kCATransitionFromRight];
       [self presentViewController:nav animated:NO completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1];
    //设置bgView为圆角
    self.bgView.layer.cornerRadius = 5;
    
    //监听键盘弹出
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self configNavigation];
    
    self.phoneTextField.delegate = self;
    [self.phoneTextField textLength:11];

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
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)keyboardFrameChange:(NSNotification*)noti{
    
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        if (keyboardF.origin.y == XPScreenHeight) {//收键盘
            self.view.transform = CGAffineTransformIdentity;
            
        }else{
            self.view.transform = CGAffineTransformMakeTranslation(0, -100);
        }
    }];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    [self.view endEditing:YES];
}

#pragma mark -UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    if(textField == self.phoneTextField)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            if (string.length <= 11) {
                [self showTooltip:@"亲，请正确的输入11位手机号"];
                return NO;
            }
        }
    }
    
    //判断手机号是否为11位
    if (self.phoneTextField.text.length == 10 ) {
        self.loginButton.enabled = YES;
    }else
    {
        self.loginButton.enabled = NO;
    }
    return YES;
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
