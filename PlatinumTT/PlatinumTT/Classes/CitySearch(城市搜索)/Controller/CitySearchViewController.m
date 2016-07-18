//
//  CitySearchViewController.m
//  PlatinumTT
//
//  Created by tarena on 16/7/12.
//  Copyright © 2016年 win. All rights reserved.
//

#import "CitySearchViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Masonry.h"
#import "DataManager.h"
#import "CityGroupModel.h"

@interface CitySearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) NSArray *allCitiesArray;
@property (strong, nonatomic) CLGeocoder *geocoder;
//主界面
@property (nonatomic, strong) UITableView *tableView;
//搜索框
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) UISearchDisplayController *searchController;
@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) UINavigationBar *customNavigationBar;

@end

@implementation CitySearchViewController

-(NSArray *)allCitiesArray{
    if (!_allCitiesArray) {
        _allCitiesArray = [DataManager getCityGroups];
    }
    return _allCitiesArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //画面显示
    self.modalTransitionStyle =  UIModalTransitionStyleCrossDissolve;
    
    self.navigationItem.title = @"选择城市";
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.geocoder = [[CLGeocoder alloc]init];
    
    self.searchResults = [[NSMutableArray alloc]initWithCapacity:5];
    
    self.customNavigationBar =[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, XPScreenWidth, 84)];
    [self.customNavigationBar setBarTintColor:[UIColor colorWithRed:255/255.0 green:113/255.0 blue:1/255.0 alpha:1]];
    [self.customNavigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [self.view addSubview:self.customNavigationBar];
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
    //    self.tableView.sectionIndexColor = [UIColor whiteColor];
    //    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight/7*2)];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets inset = UIEdgeInsetsMake(84, 0, 0, 0);
        make.edges.equalTo(self.view).insets(inset);
    }];
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 20, XPScreenWidth, 44)];
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.placeholder = @"首字母/拼音/汉字";
    self.searchBar.delegate = self;
    
    self.searchController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
    self.searchController.delegate = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.searchResultsDataSource = self;
    //    self.searchController.displaysSearchBarInNavigationBar = YES;
    //    self.searchController.navigationItem.rightBarButtonItems = @[self.doneButton];
    //    self.navigationBar.items = @[self.searchController.navigationItem];
    //    self.doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed)];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.searchController setActive:YES animated:NO];
    [self.searchController.searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchController setActive:NO animated:NO];
    [self.searchController.searchBar resignFirstResponder];
}

#pragma mark - 按钮触发方法
- (void)doneButtonPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self.geocoder geocodeAddressString:searchString completionHandler: ^ (NSArray *placemarks, NSError *error) {
        self.searchResults = [[NSMutableArray alloc]initWithCapacity:1];
        for(CLPlacemark *placemark in placemarks) {
            if(placemark.locality) {
                [self.searchResults addObject:placemark];
            }
        }
        [controller.searchResultsTableView reloadData];
    }];
    return NO;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{
    [tableView setFrame:CGRectMake(0, CGRectGetHeight(self.customNavigationBar.bounds), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.customNavigationBar.bounds))];
    //    tableView.backgroundColor = [UIColor colorWithRed:55/255.0 green:69/255.0 blue:95/255.0 alpha:1.0];
    //    tableView.separatorColor = [UIColor colorWithRed:66/255.0 green:80/255.0 blue:106/255.0 alpha:1.0];
    [self.tableView bringSubviewToFront:self.customNavigationBar];
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == self.searchController.searchResultsTableView){
        return 1;
    }
    else{
        return self.allCitiesArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.searchController.searchResultsTableView){
        return [self.searchResults count];
    }
    else{
        CityGroupModel *cityGroup = self.allCitiesArray[section];
        return cityGroup.cities.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.searchController.searchResultsTableView) {
        static NSString *cellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        
        //        cell.separatorInset = UIEdgeInsetsZero;
        //        cell.layoutMargins = UIEdgeInsetsZero;
        //        cell.preservesSuperviewLayoutMargins = NO;
        
        CLPlacemark *placemark = [self.searchResults objectAtIndex:indexPath.row];
        NSString *city = placemark.locality;
        NSString *country = placemark.country;
        NSString *cellText = [NSString stringWithFormat:@"%@, %@", city, country];
        cell.textLabel.text = cellText;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        return cell;
    }else{
        static NSString *identity = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
        }
        cell.textLabel.text = ((CityGroupModel*)self.allCitiesArray[indexPath.section]).cities[indexPath.row];
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.searchController.searchResultsTableView) {
        [tableView cellForRowAtIndexPath:indexPath].selected = NO;
        CLPlacemark *placemark = [self.searchResults objectAtIndex:indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeCity" object:self userInfo:@{@"CityName":placemark.addressDictionary[@"City"]}];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeCity" object:self userInfo:@{@"CityName":((CityGroupModel*)self.allCitiesArray[indexPath.section]).cities[indexPath.row]}];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(tableView != self.searchController.searchResultsTableView) {
        CityGroupModel *cityGroup = self.allCitiesArray[section];
        return cityGroup.title;
    }else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor whiteColor];
    //    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    //    [header.textLabel setTextColor:[UIColor colorWithRed:153/255.0 green:167/255.0 blue:183/255.0 alpha:1.0]];
}

//索引
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    //方式一：为NSArray[]对应找到分区头的索引
    //    NSMutableArray *titles = [@[]mutableCopy];
    //    for (CityGroup *cityGroup in self.allCitiesArray) {
    //        [titles addObject:cityGroup.title];
    //    }
    //    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    //    return  titles;
    //方式二
    if(tableView != self.searchController.searchResultsTableView) {
        tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        return [self.allCitiesArray valueForKeyPath:@"title"];
    }
    else{
        return nil;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.customNavigationBar.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y,CGRectGetWidth(self.customNavigationBar.frame),CGRectGetHeight(self.customNavigationBar.frame));
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
