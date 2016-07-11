//
//  XPWelcomeViewController.m
//  PlatinumTaoTravel
//
//  Created by dragon on 16/7/11.
//  Copyright © 2016年 win. All rights reserved.
//

#import "XPWelcomeViewController.h"

@interface XPWelcomeViewController ()<UIScrollViewDelegate>
/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation XPWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configScrollView];
    self.scrollView.delegate = self;
}

- (void)configScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.contentSize = CGSizeMake(4 * XPScreenWidth, self.view.bounds.size.height);
    
    for (int i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * XPScreenWidth, 0, XPScreenWidth, self.view.bounds.size.height)];
        NSString *str = [NSString stringWithFormat:@"lead%d",i + 1];
        imageView.image = [UIImage imageNamed:str];
        if (i == 3) {
            imageView.userInteractionEnabled = YES;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = CGRectMake(XPScreenWidth/2 - 130, XPScreenHeight * 0.83, 260, 70);
            [btn addTarget:self action:@selector(enter:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:btn];
        }
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    //关闭弹性
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
}

-(void)enter:(UIButton *)sender
{
    [UIApplication sharedApplication].keyWindow.rootViewController = nil;
}

@end
