//
//  XPHotelDetailTableViewController.m
//  PlatinumTT
//
//  Created by 罗惠 on 16/7/12.
//  Copyright © 2016年 win. All rights reserved.
//

#import "XPHotelDetailTableViewController.h"
#import "XPShareViewController.h"


@interface XPHotelDetailTableViewController ()

//头视图
@property (nonatomic, strong) UIView *tableHeadView;
@end

@implementation XPHotelDetailTableViewController

- (UIView *)tableHeadView{
    if (_tableHeadView == nil) {
        _tableHeadView = [[[NSBundle mainBundle] loadNibNamed:@"XPHotelTableHeadView" owner:self options:nil]lastObject];
        _tableHeadView.frame = CGRectMake(0, 0, XPScreenWidth, 60);
    }
    return _tableHeadView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"酒店详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(onRightBtn)];
    self.tableView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    //头视图初始化
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XPScreenWidth, 60)];
    [self.tableView.tableHeaderView addSubview:self.tableHeadView];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.textLabel.text = @"12";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 120;
    } else {
        return 80;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - navigationBar的点击按钮


- (void)onRightBtn{
    
    XPShareViewController *shareCtl = [XPShareViewController new];
    shareCtl.view.frame = CGRectMake(0, 0, XPScreenWidth, XPScreenHeight);
    [self.parentViewController addChildViewController:shareCtl];
    [[UIApplication sharedApplication].keyWindow addSubview:shareCtl.view];
  
}

@end
