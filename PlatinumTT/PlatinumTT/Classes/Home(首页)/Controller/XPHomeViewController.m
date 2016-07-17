//
//  XPHomeViewController.m
//  PlatinumTT
//
//  Created by dragon on 16/7/12.
//  Copyright © 2016年 win. All rights reserved.
//

#import "XPHomeViewController.h"
#import "DataManager.h"
#import "NetworkManager.h"
#import "UIImageView+WebCache.h"
#import "XPNavigationController.h"

#import "CitySearchViewController.h"
#import "XPLoginViewController.h"

#import "ThreeInOneTableViewCell.h"
#import "BrandTableViewCell.h"

#define Space 20
#define NaviHeight 44
#define StatusHeight 20
#define LineSpace 10
#define ViewWidth self.view.bounds.size.width
#define ViewHeight self.view.bounds.size.height

@interface XPHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *homeTableView;
@property (nonatomic, strong) NSArray *adArray;
@property (nonatomic, strong) NSArray *threeInOneArray;
@property (nonatomic, strong) NSArray *brandArray;

@end

@implementation XPHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeStatusBarWithApplication:[UIApplication sharedApplication]];
    [self setNavigationBarItem];
    [self configHomeTableView];
    self.navigationItem.title = @"铂涛旅行";
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - TV界面
-(void)configHomeTableView{
    self.homeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, XPScreenWidth, XPScreenHeight) style:UITableViewStyleGrouped];
    self.homeTableView.dataSource = self;
    self.homeTableView.delegate = self;
    
    //测试
    self.homeTableView.rowHeight = 100;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XPScreenWidth, 200)];
    view.backgroundColor = [UIColor blueColor];
    
    self.homeTableView.tableHeaderView = view;
    [self.view addSubview:self.homeTableView];
}

#pragma mark - TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text=@"内容";
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return LineSpace;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark - 导航栏
- (void)setNavigationBarItem{
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, NaviHeight)];
    [leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"ic_xiala"] forState:UIControlStateNormal];
    leftButton.adjustsImageWhenHighlighted = NO;
    [leftButton setTitle:@"深圳" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0 , -leftButton.imageView.frame.size.width*2, 0, Space)];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -leftButton.titleLabel.bounds.size.width*2+5)];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"user"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}
#pragma mark - 导航栏按钮事件
-(void)leftButtonAction{
    CitySearchViewController *citySearchVC = [[CitySearchViewController alloc]init];
    [self.navigationController pushViewController:citySearchVC animated:YES];
}
-(void)rightBarButtonAction{
    XPLoginViewController *LoginVC = [[XPLoginViewController alloc]init];
    XPNavigationController *nav = [[XPNavigationController alloc] initWithRootViewController:LoginVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:251/255.0 green:75/255.0 blue:18/255.0 alpha:1];
}

#pragma mark - 状态栏
- (void)initializeStatusBarWithApplication:(UIApplication *)application{
    application.statusBarStyle = UIStatusBarStyleLightContent;
    application.statusBarHidden = NO;
}

@end
