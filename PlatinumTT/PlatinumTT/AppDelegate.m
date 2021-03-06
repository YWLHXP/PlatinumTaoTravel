//
//  AppDelegate.m
//  PlatinumTT
//
//  Created by dragon on 16/7/11.
//  Copyright © 2016年 win. All rights reserved.
//

#import "AppDelegate.h"
#import "XPWelcomeViewController.h"

//测试
#import "XPHomeViewController.h"
#import "XPNavigationController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //短信
    [SMSSDK registerApp:MOBAPPKEY_SMS withSecret:MOBAPPSECRECT_SMS];
    
    
    //初始化SDK并且初始化第三方平台
    [self initializePlat];
    
    //初始化Bmob
    [Bmob registerWithAppKey:BMOBAPPKEY];
    
    //创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 显示窗口
    [self.window makeKeyAndVisible];
    
    XPNavigationController *xpNav = [[XPNavigationController alloc] initWithRootViewController:[XPHomeViewController new]];
    
    //判断是否登录
    if ([BmobUser getCurrentUser]) {
        //登录过显示主页
        self.window.rootViewController = xpNav;
    }else{
        self.window.rootViewController = [[XPWelcomeViewController alloc] init];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults boolForKey:@"first"]) {
        // 设置窗口的根控制器
        self.window.rootViewController = [[XPWelcomeViewController alloc] init];
        self.isFirst = YES;
        [defaults setBool:self.isFirst forKey:@"first"];
        //同步 可以使内存中数据改变完之后 立即保存到文件中   不加也能保存 但是有可能不够及时
        [defaults synchronize];
    }else{
        // 设置窗口的根控制器
        self.window.rootViewController = xpNav;
    }
    return YES;
}


- (void)initializePlat{
    [ShareSDK registerApp:MOBAPPKEY_3Login
     
          activePlatforms:@[@(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:MOBAPPKEY_WeiXin appSecret:MOBAPPSECRECT_WeiXin];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:MOBAPPKEY_QQ appKey:MOBAPPSECRECT_QQ authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
