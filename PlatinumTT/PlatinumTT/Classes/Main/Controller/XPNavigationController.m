//
//  XPNavigationController.m
//  PlatinumTT
//
//  Created by dragon on 16/7/12.
//  Copyright © 2016年 win. All rights reserved.
//

#import "XPNavigationController.h"

@interface XPNavigationController ()

@end

@implementation XPNavigationController

// 当前类或者他的子类第一次使用的时候才会调用
+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = [UIColor colorWithRed:230/255.0 green:95/255.0 blue:40/255.0 alpha:1];
    
    // 设置导航条标题颜色及字体
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    titleAttr[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    [bar setTitleTextAttributes:titleAttr];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
@end
