//
//  XPMyMessageViewController.m
//  PlatinumTT
//
//  Created by dragon on 16/7/13.
//  Copyright © 2016年 win. All rights reserved.
//

#import "XPMyMessageViewController.h"

@interface XPMyMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation XPMyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [self tableHeaderView];
}

- (UIView *)tableHeaderView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(XPScreenWidth, 250, 0, 0)];
    headView.backgroundColor = [UIColor colorWithRed:251/255.0 green:75/255.0 blue:18/255.0 alpha:1];
    return headView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else
    {
        return 3;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

@end
