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
#import "LocationManager.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

#import "XPNavigationController.h"

#import "CitySearchViewController.h"
#import "XPLoginViewController.h"
#import "HomeWebViewController.h"

#import "ADModel.h"
#import "AdCollectionViewCell.h"

#import "ThreeInOneModel.h"
#import "ThreeInOneCollectionViewCell.h"

#import "BrandModel.h"
#import "BrandCollectionViewCell.h"

#define Space 20
#define NaviHeight 44
#define StatusHeight 20
#define LineSpace 10
#define CellHeight200 200
#define CellHeight150 150
#define CellHeight100 100
#define CellHeight50 50
#define CellLineHeight 0.5
#define CellLineWidth 0.5
#define ViewWidth self.view.bounds.size.width
#define ViewHeight self.view.bounds.size.height
#define ADCollectionWidth self.adCollectionView.bounds.size.width
#define ADCollectionHeight self.adCollectionView.bounds.size.height

@interface XPHomeViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
//主页
@property (nonatomic, strong) UITableView *homeTableView;
@property (nonatomic, strong) UIButton *leftButton;
//用户位置
@property (nonatomic, strong) CLLocation *userLocation;
//地理编码
@property (nonatomic, strong) CLGeocoder *geocoder;
//存储城市
@property (nonatomic, copy) NSString *cityString;
//广告相关
@property (nonatomic, strong) NSMutableArray *adArray;
@property (nonatomic, strong) UICollectionView *adCollectionView;
@property (nonatomic, strong) UIPageControl *adPageControl;
//三合
@property (nonatomic, strong) UICollectionView *threeInOneCollectionView;
@property (nonatomic, strong) NSArray *threeInOneArray;
//品牌
@property (nonatomic, strong) NSArray *brandArray;
@property (nonatomic, strong) UICollectionView *brandCollectionView;

@end

@implementation XPHomeViewController
- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationItem.title = @"铂涛旅行";
    //状态栏
    [self initializeStatusBarWithApplication:[UIApplication sharedApplication]];
    //导航栏
    [self setNavigationBarItem];
    //监听通知
    [self listenNotification];
    
    [self configHomeTableView];
    
    [self configADCollectionView];
    
    [self configThreeInOneCollectionView];
    
    [self configBrandCollectionView];
    
    //下拉控件
    [self createRefreshControl];
    
    //获取用户的位置并发送请求
    [self getLocationAndSendRequest];
    
}

#pragma mark - 通知监听
- (void)listenNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenChangeCity:) name:@"ChangeCity" object:nil];
}
- (void)listenChangeCity:(NSNotification *)notification {
    NSString *cityName = notification.userInfo[@"CityName"];
    NSLog(@"城市名字:%@",cityName);
    
    [self.geocoder geocodeAddressString:cityName completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks lastObject];
        self.userLocation = placemark.location;
        self.cityString = [placemark.addressDictionary[@"City"] stringByReplacingOccurrencesOfString:@"市" withString:@""];
        [self.leftButton setTitle:self.cityString forState:UIControlStateNormal];
        NSLog(@"城市拼音:%@;000--%f", self.cityString, self.userLocation.coordinate.latitude);
        [self.homeTableView reloadData];
    }];
    //发送请求
    [self sendADRequestToServer];
}

#pragma mark - TV界面
-(void)configHomeTableView{
    self.homeTableView = [[UITableView alloc]init];
    self.homeTableView.dataSource = self;
    self.homeTableView.delegate = self;
    [self.homeTableView setSeparatorColor:[UIColor lightGrayColor]];
    self.homeTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight/7*2)];
    [self.view addSubview:self.homeTableView];
    [self.homeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
}

#pragma mark - TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    if (section == 2 || section == 3) {
        return 2;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fourthCell"];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fourthCell"];
        }
        if (indexPath.row == 0) {
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
                make.edges.equalTo(cell.contentView).insets(inset);
            }];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic-huangguan"]];
            imageView.contentMode = UIViewContentModeCenter;
            UILabel *leftLabel = [UILabel new];
            leftLabel.text = @"品牌直销";
            leftLabel.font = [UIFont systemFontOfSize:16];
            //加线
            UIView *horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XPScreenWidth, CellLineHeight)];
            horizontalLine.backgroundColor = [UIColor lightGrayColor];
            [view addSubview:horizontalLine];
            [view addSubview:imageView];
            [view addSubview:leftLabel];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view).offset(15);
                make.size.mas_equalTo(CGSizeMake(20, 20));
                make.right.mas_equalTo(leftLabel.mas_left).with.offset(-5);
                make.centerY.equalTo(view);
            }];
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(70, 20));
                make.centerY.mas_equalTo(imageView);
            }];
        }
        if (indexPath.row == 1) {
            //加线
            UIView *horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(0, CellHeight200/3-CellLineHeight, XPScreenWidth, CellLineHeight)];
            horizontalLine.backgroundColor = [UIColor lightGrayColor];
            UIView *horizontalLine1 = [[UIView alloc]initWithFrame:CGRectMake(0, CellHeight200/3*2-CellLineHeight, XPScreenWidth, CellLineHeight)];
            horizontalLine1.backgroundColor = [UIColor lightGrayColor];
            UIView *horizontalLine2 = [[UIView alloc]initWithFrame:CGRectMake(0, CellHeight200-CellLineHeight, XPScreenWidth/5*3, CellLineHeight)];
            horizontalLine2.backgroundColor = [UIColor lightGrayColor];
            
            UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake(XPScreenWidth/5-CellLineWidth, 0, CellLineWidth, CellHeight200)];
            verticalLine.backgroundColor = [UIColor lightGrayColor];
            UIView *verticalLine1 = [[UIView alloc]initWithFrame:CGRectMake(XPScreenWidth/5*2-CellLineWidth, 0, CellLineWidth, CellHeight200)];
            verticalLine1.backgroundColor = [UIColor lightGrayColor];
            UIView *verticalLine2 = [[UIView alloc]initWithFrame:CGRectMake(XPScreenWidth/5*3-CellLineWidth, 0, CellLineWidth, CellHeight200)];
            verticalLine2.backgroundColor = [UIColor lightGrayColor];
            UIView *verticalLine3 = [[UIView alloc]initWithFrame:CGRectMake(XPScreenWidth/5*4-CellLineWidth, 0, CellLineWidth, CellHeight200/3*2)];
            verticalLine3.backgroundColor = [UIColor lightGrayColor];
            [self.brandCollectionView addSubview:horizontalLine];
            [self.brandCollectionView addSubview:horizontalLine1];
            [self.brandCollectionView addSubview:horizontalLine2];
            [self.brandCollectionView addSubview:verticalLine];
            [self.brandCollectionView addSubview:verticalLine1];
            [self.brandCollectionView addSubview:verticalLine2];
            [self.brandCollectionView addSubview:verticalLine3];
            [cell.contentView addSubview:self.brandCollectionView];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"thirdCell"];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"thirdCell"];
        }
        if (indexPath.row == 0) {
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
                make.edges.equalTo(cell.contentView).insets(inset);
            }];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic-_scdh"]];
            imageView.contentMode = UIViewContentModeCenter;
            UILabel *leftLabel = [UILabel new];
            leftLabel.text = @"积分商城";
            leftLabel.font = [UIFont systemFontOfSize:16];
            UILabel *rightLabel = [UILabel new];
            rightLabel.text = @"更多兑换 >";
            rightLabel.font = [UIFont systemFontOfSize:15];
            rightLabel.textColor = [UIColor grayColor];
            //加线
            UIView *horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XPScreenWidth, CellLineHeight)];
            horizontalLine.backgroundColor = [UIColor lightGrayColor];
            [view addSubview:horizontalLine];
            [view addSubview:imageView];
            [view addSubview:leftLabel];
            [view addSubview:rightLabel];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view).offset(15);
                make.size.mas_equalTo(CGSizeMake(20, 20));
                make.right.mas_equalTo(leftLabel.mas_left).with.offset(-5);
                make.centerY.equalTo(view);
            }];
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(70, 20));
                make.centerY.mas_equalTo(imageView);
            }];
            [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(80, 20));
                make.right.equalTo(view).with.offset(0);
                make.centerY.mas_equalTo(leftLabel);
            }];
        }
        if (indexPath.row == 1) {
            /**
             *  未实现
             */
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor whiteColor];
            
            [cell.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
                make.edges.equalTo(cell.contentView).insets(inset);
            }];
            //加线
            UIView *horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(0, CellHeight150-CellLineHeight, XPScreenWidth, CellLineHeight)];
            horizontalLine.backgroundColor = [UIColor lightGrayColor];
            [view addSubview:horizontalLine];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstCell"];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"firstCell"];
        }
        if (indexPath.row == 0) {
            /**
             *  未实现
             */
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor whiteColor];
            
            [cell.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
                make.edges.equalTo(cell.contentView).insets(inset);
            }];
            //加线
            UIView *horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XPScreenWidth, CellLineHeight)];
            horizontalLine.backgroundColor = [UIColor lightGrayColor];
            [view addSubview:horizontalLine];
            cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        }
        if (indexPath.row == 1) {
            [cell.imageView setImage:[UIImage imageNamed:@"location"]];
            cell.imageView.contentMode = UIViewContentModeCenter;
            if (self.cityString) {
                cell.textLabel.text = self.cityString;
            }else{
                cell.textLabel.text = @"城市";
            }
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        }
        if (indexPath.row == 2) {
            [cell.imageView setImage:[UIImage imageNamed:@"search"]];
            cell.imageView.contentMode = UIViewContentModeCenter;
            cell.textLabel.text = @"输入关键字查找";
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        }
        if (indexPath.row == 3) {
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
                make.edges.equalTo(cell.contentView).insets(inset);
            }];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bgBtnDis"]];
            cell.imageView.contentMode = UIViewContentModeCenter;
            UILabel *centerLabel = [UILabel new];
            centerLabel.text = @"订酒店";
            centerLabel.font = [UIFont systemFontOfSize:18];
            [centerLabel setTextAlignment:NSTextAlignmentCenter];
            centerLabel.textColor = [UIColor whiteColor];
            //加线
            UIView *horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(0, CellHeight100-CellLineHeight, XPScreenWidth, CellLineHeight)];
            horizontalLine.backgroundColor = [UIColor lightGrayColor];
            [view addSubview:horizontalLine];
            [view addSubview:imageView];
            [view addSubview:centerLabel];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(340, 60));
                make.center.equalTo(view);
            }];
            [centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(55, 25));
                make.center.equalTo(view);
            }];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"otherCell"];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"otherCell"];
        }
        //加线
        UIView *horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XPScreenWidth, CellLineHeight)];
        horizontalLine.backgroundColor = [UIColor lightGrayColor];
        UIView *horizontalLine1 = [[UIView alloc]initWithFrame:CGRectMake(0, CellHeight150-CellLineHeight, XPScreenWidth, CellLineHeight)];
        horizontalLine1.backgroundColor = [UIColor lightGrayColor];
        UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake(XPScreenWidth/3-CellLineWidth, 0, CellLineWidth, CellHeight150)];
        verticalLine.backgroundColor = [UIColor lightGrayColor];
        UIView *verticalLine1 = [[UIView alloc]initWithFrame:CGRectMake(XPScreenWidth/3*2-CellLineWidth, 0, CellLineWidth, CellHeight150)];
        verticalLine1.backgroundColor = [UIColor lightGrayColor];
        [self.threeInOneCollectionView addSubview:horizontalLine];
        [self.threeInOneCollectionView addSubview:horizontalLine1];
        [self.threeInOneCollectionView addSubview:verticalLine];
        [self.threeInOneCollectionView addSubview:verticalLine1];
        [cell.contentView addSubview:self.threeInOneCollectionView];
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            CitySearchViewController *citySearchVC = [[CitySearchViewController alloc]init];
            [self.navigationController pushViewController:citySearchVC animated:YES];
        }
    }
    NSLog(@"第%ld区，第%ld行",indexPath.section,indexPath.row);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return LineSpace;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            return CellHeight50;
        }
        if (indexPath.row == 1) {
            return CellHeight200;
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return CellHeight50;
        }
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0 || indexPath.row == 3) {
            return CellHeight100;
        }
        if (indexPath.row == 1 || indexPath.row == 2) {
            return CellHeight50;
        }
    }
    return CellHeight150;
}

#pragma mark - TableView 分割线设置
-(void)viewDidLayoutSubviews{
    if ([self.homeTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.homeTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.homeTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.homeTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3 || indexPath.section == 2) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

#pragma mark - 广告CV界面
-(void)configADCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(ViewWidth, ViewHeight/7*2);
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    self.adCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight/7*2) collectionViewLayout:flowLayout];
    self.adCollectionView.backgroundColor = [UIColor whiteColor];
    self.adCollectionView.showsHorizontalScrollIndicator = NO;
    self.adCollectionView.dataSource = self;
    self.adCollectionView.delegate = self;
    self.adCollectionView.pagingEnabled = YES;
    [self.homeTableView.tableHeaderView addSubview:self.adCollectionView];
    self.adPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.homeTableView.tableHeaderView.frame.size.width/2-90, self.homeTableView.tableHeaderView.frame.size.height-20, 180, 20)];
    self.adPageControl.userInteractionEnabled = NO;
    [self.homeTableView.tableHeaderView addSubview:self.adPageControl];
    //轮播计时器
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [self.adCollectionView registerClass:[AdCollectionViewCell class] forCellWithReuseIdentifier:@"ADC"];
}
#pragma mark - 三合CV界面
-(void)configThreeInOneCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(ViewWidth/3, CellHeight150);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    self.threeInOneCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, CellHeight150) collectionViewLayout:flowLayout];
    self.threeInOneCollectionView.backgroundColor = [UIColor whiteColor];
    self.threeInOneCollectionView.showsVerticalScrollIndicator = NO;
    self.threeInOneCollectionView.dataSource = self;
    self.threeInOneCollectionView.delegate = self;
    [self.threeInOneCollectionView registerClass:[ThreeInOneCollectionViewCell class] forCellWithReuseIdentifier:@"TIOC"];
}
#pragma mark - 品牌CV界面
-(void)configBrandCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(ViewWidth/5, CellHeight200/3);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    self.brandCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, CellHeight200) collectionViewLayout:flowLayout];
    self.brandCollectionView.backgroundColor = [UIColor whiteColor];
    self.brandCollectionView.showsVerticalScrollIndicator = NO;
    self.brandCollectionView.dataSource = self;
    self.brandCollectionView.delegate = self;
    [self.brandCollectionView registerClass:[BrandCollectionViewCell class] forCellWithReuseIdentifier:@"BC"];
}

#pragma mark - 刷新控件
- (void)createRefreshControl {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(sendADRequestToServer)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    [header beginRefreshing];
    self.homeTableView.mj_header = header;
}

#pragma mark - 请求相关方法
- (void)getLocationAndSendRequest {
    [LocationManager getUserLocation:^(double lat, double lon) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        self.userLocation = location;
        [self sendADRequestToServer];
    }];
}
//广告
-(void)sendADRequestToServer{
    [NetworkManager sendRequestWithUrl:@"http://trip.plateno.com/advertisement/homePage" parameters:nil success:^(id responseObject) {
        //更新城市
        [self updateCity];
        self.adArray = [NSMutableArray arrayWithArray:[DataManager getADData:responseObject]];
        [self handleImages];
        self.adCollectionView.contentOffset = CGPointMake(ADCollectionWidth, 0);
        self.adPageControl.numberOfPages = self.adArray.count-2;
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5;
        animation.subtype = kCATransitionFade;
        [self.adCollectionView.layer addAnimation:animation forKey:nil];
        [self.adCollectionView reloadData];
        [self sendThreeInOneRequestToServer];
    } failure:^(NSError *error) {
        NSLog(@"AD服务器请求失败:%@", error.userInfo);
    }];
}
//三合
-(void)sendThreeInOneRequestToServer{
    [NetworkManager sendRequestWithUrl:@"http://trip.plateno.com/index/v2/logoList" parameters:nil success:^(id responseObject) {
        self.threeInOneArray = [DataManager getThreeInOneData:responseObject];
        [self.threeInOneCollectionView reloadData];
        [self sendBrandRequestToServer];
    } failure:^(NSError *error) {
        NSLog(@"ThreeInOne服务器请求失败:%@", error.userInfo);
    }];
}
//品牌
-(void)sendBrandRequestToServer{
    [NetworkManager sendRequestWithUrl:@"http://trip.plateno.com/basic/ota/hotBrand" parameters:nil success:^(id responseObject) {
        self.brandArray = [DataManager getBrandData:responseObject];
        [self.brandCollectionView reloadData];
        [self.homeTableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"Brand服务器请求失败:%@", error.userInfo);
        [self.homeTableView.mj_header endRefreshing];
    }];
}
- (void)updateCity{
    if (self.userLocation) {
        [self.geocoder reverseGeocodeLocation:self.userLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if (!error) {
                //反地理编码成功
                CLPlacemark *placemark = [placemarks firstObject];
                //城市名称
                [self.leftButton setTitle:[placemark.addressDictionary[@"City"] stringByReplacingOccurrencesOfString:@"市" withString:@""] forState:UIControlStateNormal];
                self.cityString = [placemark.addressDictionary[@"City"] stringByReplacingOccurrencesOfString:@"市" withString:@""];
                NSLog(@"%@",placemark.addressDictionary[@"City"]);
                [self.homeTableView reloadData];
            }
        }];
    }
}

#pragma mark - 其他处理
-(void)timerAction:(NSTimer *)timer{
    [self.adCollectionView setContentOffset:CGPointMake(ADCollectionWidth*(self.adPageControl.currentPage+2), 0) animated:YES];
}
-(void)handleImages{
    ADModel *ADModelFirst = [self.adArray firstObject];
    ADModel *ADModelLast = [self.adArray lastObject];
    [self.adArray insertObject:ADModelLast atIndex:0];
    [self.adArray addObject:ADModelFirst];
}

#pragma mark - CollectionView DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.adCollectionView) {
        return self.adArray.count;
    }
    if (collectionView == self.threeInOneCollectionView) {
        return self.threeInOneArray.count;
    }
    return self.brandArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.adCollectionView) {
        AdCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ADC" forIndexPath:indexPath];
        ADModel *AD = [self.adArray objectAtIndex:indexPath.item];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:AD.bannerImage] placeholderImage:[UIImage imageNamed:@"bigpic-default"]];
        return cell;
    }
    if (collectionView == self.threeInOneCollectionView) {
        ThreeInOneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TIOC" forIndexPath:indexPath];
        ThreeInOneModel *threeInOne = [self.threeInOneArray objectAtIndex:indexPath.item];
        cell.tLabel.text = threeInOne.title;
        cell.dLabel.text = threeInOne.desc;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:threeInOne.twoX] placeholderImage:[UIImage imageNamed:@"loadingImage-tmp"]];
        return cell;
    }
    BrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BC" forIndexPath:indexPath];
    BrandModel *brand = [self.brandArray objectAtIndex:indexPath.item];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:brand.logo] placeholderImage:[UIImage imageNamed:@"loadingImage-tmp"]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.adCollectionView) {
        ADModel *AD = [self.adArray objectAtIndex:indexPath.item];
        if ([AD.wapURL isEqualToString:@""]) {
        }else{
            HomeWebViewController *webVC = [[HomeWebViewController alloc]init];
            webVC.transUrl = AD.wapURL;
            webVC.transTitle = AD.name;
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
    if (collectionView == self.threeInOneCollectionView) {
        ThreeInOneModel *threeInOne = [self.threeInOneArray objectAtIndex:indexPath.item];
        if ([threeInOne.url isEqualToString:@""]) {
        }else{
            HomeWebViewController *webVC = [[HomeWebViewController alloc]init];
            webVC.transTitle = threeInOne.title;
            webVC.transUrl = threeInOne.url;
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
    if (collectionView == self.brandCollectionView) {
        /** LHui在此处更改了网络请求的路径，使用了brandCode变量*/
        BrandModel *brand = [self.brandArray objectAtIndex:indexPath.item];
        if (brand.h5Url) {
            HomeWebViewController *webVC = [[HomeWebViewController alloc]init];
            webVC.transTitle = brand.brandName;
            if ([brand.brandName isEqualToString:@"安铂酒店"]) {
                brand.brandName = @"安珀酒店";
                webVC.transUrl = brand.h5Url;
                [self.navigationController pushViewController:webVC animated:YES];
            }else{
                webVC.transUrl = [NSString stringWithFormat:@"http://m.7daysinn.cn/maserati/static/brands/brands.html?actId=1300&TOKEN=&brandId=%@&cityCode=&appVersion=1.4.3&os=ios&versionCode=13", brand.brandCode];
                [self.navigationController pushViewController:webVC animated:YES];
            }
        }else{
            NSLog(@"还未销售的页面");
        }
    }
    NSLog(@"CV第%ld区，第%ld个",indexPath.section,indexPath.row);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int halfX = self.adCollectionView.frame.size.width/2;
    self.adPageControl.currentPage = (self.adCollectionView.contentOffset.x-ADCollectionWidth-halfX)/(ADCollectionWidth)+1;
    if (self.adCollectionView.contentOffset.x >=ADCollectionWidth*(self.adArray.count-1)) {
        self.adCollectionView.contentOffset = CGPointMake(ADCollectionWidth, 0);
    }
    if (self.adCollectionView.contentOffset.x <= 0) {
        self.adCollectionView.contentOffset = CGPointMake(ADCollectionWidth*(self.adArray.count-2),0);
    }
}

#pragma mark - 导航栏
- (void)setNavigationBarItem{
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, NaviHeight)];
    [self.leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton setImage:[UIImage imageNamed:@"ic_xiala"] forState:UIControlStateNormal];
    self.leftButton.adjustsImageWhenHighlighted = NO;
    [self.leftButton setTitle:@"城市" forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0 , -self.leftButton.imageView.frame.size.width*2, 0, Space)];
    [self.leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -self.leftButton.titleLabel.bounds.size.width*2+5)];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
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
    [self.navigationController presentViewController:[[XPNavigationController alloc]initWithRootViewController:LoginVC] animated:YES completion:nil];
//    [self.navigationController pushViewController:LoginVC animated:YES];
}

#pragma mark - 状态栏
- (void)initializeStatusBarWithApplication:(UIApplication *)application{
    application.statusBarStyle = UIStatusBarStyleLightContent;
    application.statusBarHidden = NO;
}

@end
