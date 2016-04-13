//
//  MyCouponTableViewController.m
//  fillPaintMaster
//
//  Created by admin on 16/4/13.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "MyCouponTableViewController.h"
#import "MyCouponTableViewCell.h"
#import "ElApiService.h"
#import "TimeUtils.h"
#import <MJRefresh/MJRefresh.h>
static const int COUPON_TYPE_DISCOUNT=0;
static const int COUPON_TYPE_PRICE=1;
@interface MyCouponTableViewController ()
{
     NSArray *couponInfoList;
     MJRefreshNormalHeader *refreshHeader;
    
}
@end

@implementation MyCouponTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      self.title=@"我的优惠券";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
     [self.tableView setRowHeight:138];
    
    
    refreshHeader=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self netDataGet];
    }];
    [refreshHeader.lastUpdatedTimeLabel setHidden:YES];
    self.tableView.mj_header=refreshHeader;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    // 马上进入刷新状态
    [refreshHeader beginRefreshing];
    
}

-(void)netDataGet{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        couponInfoList=[[ElApiService shareElApiService] getCouponList:-1];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            
            [refreshHeader endRefreshing];

            
        });
        
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(couponInfoList!=nil){
        return [couponInfoList count];
    }
    return 0;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCouponTableViewCell"];
    if(cell==nil){
        cell= [[[NSBundle mainBundle] loadNibNamed:@"MyCouponTableViewCell" owner:self options:nil] lastObject];
    }
    TDCouponInfo *coupon=[couponInfoList objectAtIndex:indexPath.row];
    
    
    NSString *usingTimeStr=[NSString stringWithFormat:@"有效期至%@",[TimeUtils normalShowTime:coupon.endTime format:@"yyyy-MM-dd"]];
    
    [cell.usingTimeLabel setText:usingTimeStr];
    
    [cell.nameLabel setText:coupon.name];
    [cell.descLabel setText:coupon.desc];
    if([TimeUtils isOverTime:coupon.endTime]){
        [cell.invaildImageView setHidden:NO];
    }else{
        [cell.invaildImageView setHidden:YES];
    }
    
    if(coupon.type==COUPON_TYPE_DISCOUNT){
        [cell.backgroundImageView setImage:[UIImage imageNamed:@"coupon_bg0"]];
        [cell.couponContentLabel setText:[NSString stringWithFormat:@"%.f折",coupon.discount]];
        
        [cell.nameLabel setTextColor:[UIColor blackColor]];
        [cell.couponContentLabel setTextColor:[UIColor blackColor]];
        
        
        [cell.descLabel setTextColor:[UIColor colorWithWhite:0 alpha:0.5]];
        [cell.usingTimeLabel setTextColor:[UIColor colorWithWhite:0 alpha:0.5]];
        
        
    }else{
        [cell.backgroundImageView setImage:[UIImage imageNamed:@"coupon_bg1"]];
        [cell.couponContentLabel setText:[NSString stringWithFormat:@"￥%.1f",coupon.price]];
        
        [cell.nameLabel setTextColor:[UIColor orangeColor]];
        [cell.couponContentLabel setTextColor:[UIColor orangeColor]];
        
        UIColor *orange2=[UIColor colorWithRed:251/255.0 green:170/255.0 blue:88/255.0 alpha:0.9];
        
        [cell.descLabel setTextColor:orange2];
        [cell.usingTimeLabel setTextColor:orange2];
        
        
    }
    
    
    return cell;
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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

@end
