//
//  HomeWebViewController.m
//  PlatinumTT
//
//  Created by tarena on 16/7/15.
//  Copyright © 2016年 win. All rights reserved.
//

#import "HomeWebViewController.h"
#import "XPHotelDetailTableViewController.h"
#import "XPNavigationController.h"
#import "XPLoginViewController.h"
#import "Masonry.h"
#import "HUD.h"

@interface HomeWebViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (nonatomic, copy) NSString *contentUrl;
@property (nonatomic, strong) NSString *navigationBarTitle;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation HomeWebViewController
/**  此处开始就是LHui宝宝的了*/
- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentUrl = self.transUrl;
    self.navigationBarTitle = self.transTitle;
    self.navigationItem.title = self.navigationBarTitle;
    self.webView = [[UIWebView alloc]init];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    self.webView.dataDetectorTypes=UIDataDetectorTypeAll;
    self.webView.delegate = self;
    self.webView.userInteractionEnabled = YES;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    //进制webView拖拽的反弹效果
    [(UIScrollView *)[[self.webView subviews] objectAtIndex:0] setBounces:NO];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.contentUrl]]];
}

#pragma mark -UIWebViewDelegate代理方法的实现

//开始加载时，显示动画
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [HUD showLoadingHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD hideHUD];
    });
}

//和后台约定一下定义一个标示，在用webView的- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;去获取URL，检测URL中含有标识，就执行oc的跳转代码。
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //获取返回的url
    NSString *currentUrl =[[[request URL] absoluteString]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"currentUrl -- %@",currentUrl);
    NSArray *components = [currentUrl componentsSeparatedByString:@"|"];
    NSArray *array = [[components firstObject] componentsSeparatedByString:@"/"];
    NSString *method = array[array.count - 1];
    NSLog(@"当前按钮的标记method：%@",method);
    if ([method hasPrefix:@"hotelDetail?"]){
        NSLog(@"立即预定1");
        //[self presentViewController:[[XPNavigationController alloc ] initWithRootViewController:[XPHotelDetailTableViewController new] ]animated:YES completion:nil];
        [self.navigationController pushViewController:[XPHotelDetailTableViewController new] animated:YES];
        return NO;
    }
    else if([method hasPrefix:@"login"]){
        [self.navigationController pushViewController:[XPLoginViewController new] animated:YES];
        NSLog(@"优惠券");
        return YES;
    }else if([method hasPrefix:@"hotelList?"]){
        //当前按钮的标记method：hotelList?cityStr=[{"cityCode":"AR00252","cityName":"广州","pinyin":"guangzhou"}]&brandStr=98
        
        NSLog(@"我的目的地");
        return  NO;
    }else if([method hasPrefix:@"tel"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:method]];
        NSLog(@"电话真机中响应，此方法在执行后会自动返回当前页面");
        return NO;
    }else{
        return YES;
    }
    
    
}

@end
