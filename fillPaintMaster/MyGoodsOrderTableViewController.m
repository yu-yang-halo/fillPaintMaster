//
//  MyGoodsOrderTableViewController.m
//  fillPaintMaster
//
//  Created by admin on 16/4/13.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "MyGoodsOrderTableViewController.h"
#import "MyGoodsOrderTableViewCell.h"
#import "ElApiService.h"
#import "TimeUtils.h"
#import <MJRefresh/MJRefresh.h>

@interface MyGoodsOrderTableViewController ()
{
    NSArray *goodsOrderList;
    MJRefreshNormalHeader *refreshHeader;
    NSArray *goodsList;
}
@end

@implementation MyGoodsOrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      self.title=@"我的商品订单";
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
       
        TDOrderSearch *search=[[TDOrderSearch alloc] init];
        
        [search setSearchType:SEARCH_TYPE_USERID];
        [search setStartTime:@"1999-09-01+00+00+00"];
        
         goodsOrderList=[[ElApiService shareElApiService] getGoodsOrderList:search];
         goodsList=[[ElApiService shareElApiService] getGoodsList:-2];
        
        
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

    if(goodsOrderList!=nil){
        return [goodsOrderList count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyGoodsOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyGoodsOrderTableViewCell"];
    if(cell==nil){
        cell= [[[NSBundle mainBundle] loadNibNamed:@"MyGoodsOrderTableViewCell" owner:self options:nil] lastObject];
    }
    
    TDGoodsOrderListType *goodsOrder=[goodsOrderList objectAtIndex:indexPath.row];
    
    
    [cell.createTimeLabel setText:[NSString stringWithFormat:@"创建时间:%@",[TimeUtils normalShowTime:goodsOrder.createTime]]];
    
    [cell.totalPriceLabel setText:[NSString stringWithFormat:@"总价:￥%.1f",goodsOrder.price]];
    
    [cell.detailLabel setText:[self detailContent:goodsOrder.goodsInfo]];
    
    [cell.detailLabel setNumberOfLines:4];

    
    return cell;
}

-(NSString *)detailContent:(NSString *)goodsInfo{
    
    NSArray* groupItems=[goodsInfo componentsSeparatedByString:@","];
    
    
    NSMutableString *detailContentStr=[[NSMutableString alloc] init];
    
    for (NSString *childItem in  groupItems) {
        NSArray *idWithNums=[childItem componentsSeparatedByString:@"+"];
        
        if([idWithNums count]==2){
            int goodId=[[idWithNums objectAtIndex:0] intValue];
            
            
            [detailContentStr appendFormat:[NSString stringWithFormat:@"%@ x%@\n",[self findGoodNameById:goodId],[idWithNums objectAtIndex:1]]];
            
            
        }
        
        
    }
    
    return detailContentStr;
    
    
}

-(NSString *)findGoodNameById:(int)goodsId{
    NSString *goodName=@"";
    for (TDGoodInfo *goodInfo in goodsList) {
        if(goodInfo.goodId==goodsId){
            goodName=goodInfo.name;
            break;
        }
        
    }
    return goodName;
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
