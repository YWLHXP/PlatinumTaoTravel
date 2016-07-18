//
//  HomeWebViewController.m
//  PlatinumTT
//
//  Created by tarena on 16/7/15.
//  Copyright © 2016年 win. All rights reserved.
//

#import "HomeWebViewController.h"
#import "Masonry.h"
#import "HUD.h"

@interface HomeWebViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (nonatomic, copy) NSString *contentUrl;
@property (nonatomic, strong) NSString *navigationBarTitle;
//等待框
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation HomeWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentUrl = self.transUrl;
    self.navigationBarTitle = self.transTitle;
    NSLog(@"url：%@，title：%@",self.contentUrl,self.transTitle);
    self.navigationItem.title = self.navigationBarTitle;
    self.webView = [[UIWebView alloc]init];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    self.webView.scalesPageToFit=YES;
    //self.webView.exclusiveTouch = YES;
    self.webView.dataDetectorTypes=UIDataDetectorTypeAll;
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.contentUrl]]];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [HUD showLoadingHUD];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //考虑需不需要模拟等待动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD hideHUD];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
