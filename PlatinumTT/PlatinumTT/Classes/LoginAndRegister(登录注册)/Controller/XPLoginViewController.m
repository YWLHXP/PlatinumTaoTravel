//
//  XPLoginViewController.m
//  PlatinumTT
//
//  Created by dragon on 16/7/12.
//  Copyright © 2016年 win. All rights reserved.
//

#import "XPLoginViewController.h"
#import "UIView+frame.h"
#import "XPAccountAndLoginViewController.h"
#import <MBProgressHUD.h>
#import "XPSetPwdViewController.h"
#import "XPNavigationController.h"
#import "LViewPushAnimation.h"
#import <ShareSDK/ShareSDK.h>
#import "XPBindPhoneViewController.h"
#import "LViewPushAnimation.h"

@interface XPLoginViewController ()<UITextFieldDelegate>
{
    NSInteger _count;
    NSInteger _number;
}
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
//获取验证码
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;

/** timer */
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation XPLoginViewController

- (IBAction)loginButtonClick:(id)sender {
    
      [SMSSDK commitVerificationCode:self.verificationCodeTextField.text phoneNumber:self.phoneTextField.text zone:@"86" result:^(NSError *error) {
        
        if (!error) {
            
            [self showTooltip:@"验证码已发送到你的手机，请注意查收哦"];
            
        }
        else
        {
            NSLog(@"错误信息：%@",error);
            
        }
    }];
    
    XPNavigationController *nav = [[XPNavigationController alloc] initWithRootViewController:[XPSetPwdViewController new]];
    [LViewPushAnimation viewCtlPushAndPopWithAnimationCtl:self andSubtypes:kCATransitionFromRight];
    [self presentViewController:nav animated:NO completion:nil];
    
}

//账号密码登录
- (IBAction)accountAndPwdLogin:(id)sender {
    [self.navigationController pushViewController:[XPAccountAndLoginViewController new] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1];
    //设置bgView为圆角
    self.bgView.layer.cornerRadius = 5;
    
    //监听键盘弹出
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self configNavigation];
    
    self.navigationController.navigationBar.translucent = YES;
    
    self.phoneTextField.delegate = self;
}

- (void)configNavigation
{
//    //去掉前面的图片  设置背景图片 为 一个没有内容 image 对象
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    //去掉背景下的阴影
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
   // self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
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


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //去掉前面的图片  设置背景图片 为 一个没有内容 image 对象
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //去掉背景下的阴影
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
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
    //判断手机号是否为11位
    if (self.phoneTextField.text.length == 10 ) {
        [self.getCodeButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        self.loginButton.enabled = YES;
    }else
    {
        [self.getCodeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.loginButton.enabled = NO;
    }
    
//    NSString * phoneString = [self.phoneTextField.text stringByReplacingCharactersInRange:range withString:string];
//    if (phoneString.length > 11 && range.length!=1){
//        self.phoneTextField.text = [phoneString substringToIndex:11];
//        return NO;
//    }

    return YES;
}

- (IBAction)getCodeButtonClick:(id)sender {
    
    //倒计时
    [self theCountdown];
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                            phoneNumber:self.phoneTextField.text
                                   zone:@"86" customIdentifier:nil result:^(NSError *error) {
                                       if (error) {
                                           NSLog(@"error %@",error);
                                       }else{
                                         [self showTooltip:@"验证码已发送到你的手机，请注意查收哦"];
                                        [self.timer invalidate];
                                        [self.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];

                                       }
                                   }];
    
}

- (void)theCountdown
{
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
    [self.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
}

- (IBAction)qqLogin:(id)sender {
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
           //  [self showTooltip:@"QQ登录成功"];
             XPNavigationController *nav = [[XPNavigationController alloc] initWithRootViewController:[XPBindPhoneViewController new]];
             [LViewPushAnimation viewCtlPushAndPopWithAnimationCtl:self andSubtypes:kCATransitionFromRight];
             [self presentViewController:nav animated:NO completion:nil];

         }
         
         else
         {
             NSLog(@"%@",error);
             NSLog(@"请确认安装了QQ");
         }
         
     }];

}
- (IBAction)weiXinLogin:(id)sender {
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
          //   [self showTooltip:@"微信登录成功"];
             XPNavigationController *nav = [[XPNavigationController alloc] initWithRootViewController:[XPBindPhoneViewController new]];
             [LViewPushAnimation viewCtlPushAndPopWithAnimationCtl:self andSubtypes:kCATransitionFromRight];
             [self presentViewController:nav animated:NO completion:nil];

         }
         
         else
         {
             NSLog(@"%@",error);
             NSLog(@"请确认安装了微信");
         }
         
     }];

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