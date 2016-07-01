//
//  MyGoodsOrderTableViewController.m
//  fillPaintMaster
//
//  Created by admin on 16/4/13.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "MyGoodsOrderTableViewController.h"
#import "ElApiService.h"
#import "TimeUtils.h"
#import <MJRefresh/MJRefresh.h>
#import "MyGoodsOrderItemCell.h"
#import <UIImageView+WebCache.h>
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
    refreshHeader=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self netDataGet];
    }];
    [refreshHeader.lastUpdatedTimeLabel setHidden:YES];
    self.tableView.mj_header=refreshHeader;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    self.tableView.contentInset=UIEdgeInsetsMake(0, 0,-20,0);
    
    
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
    if(goodsOrderList!=nil){
        return [goodsOrderList count];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(goodsOrderList!=nil){
        TDGoodsOrderListType *item=[goodsOrderList objectAtIndex:section];
        NSArray *infos=[self detailContent:item.goodsInfo];
        
        return [infos count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TDGoodsOrderListType *item=[goodsOrderList objectAtIndex:indexPath.section];
    NSArray *infos=[self detailContent:item.goodsInfo];
    
    
    MyGoodsOrderItemCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MyGoodsOrderItem"];
    if(cell==nil){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"MyGoodsOrderItemCell" owner:nil options:nil] lastObject];
        
    }
    TDGoodInfo *goodsInfo=[infos objectAtIndex:indexPath.row];
    
    NSArray * imageNames=[goodsInfo.src componentsSeparatedByString:@","];
    NSString *imageName=nil;
    if([imageNames count]>0){
        imageName=[imageNames objectAtIndex:0];
    }
    
    NSString *imageURL=[[ElApiService shareElApiService] getGoodsURL:imageName shopId:goodsInfo.shopId];
    
    [cell.itemImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]
                          placeholderImage:[UIImage imageNamed:@"icon_default"]];
    
    [cell.descLabel setText:goodsInfo.desc];
    [cell.priceLabel setText:[NSString stringWithFormat:@"￥%.1f",goodsInfo.price]];

    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    
    [bgView setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:0.7]];
    
    return bgView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return  cell.frame.size.height;
}

-(NSArray *)detailContent:(NSString *)goodsInfoStr{
    
    NSArray* groupItems=[goodsInfoStr componentsSeparatedByString:@","];
    
    
    NSMutableArray *detailGoodinfos=[[NSMutableArray alloc] init];
    
    for (NSString *childItem in  groupItems) {
        NSArray *idWithNums=[childItem componentsSeparatedByString:@"+"];
        
        if([idWithNums count]==2){
            int goodId=[[idWithNums objectAtIndex:0] intValue];
            TDGoodInfo *goodInfo=[self findGoodInfoById:goodId];
            
            [goodInfo setPayNumber:[[idWithNums objectAtIndex:1] intValue]];
            [detailGoodinfos addObject:goodInfo];
        }
        
        
    }
    
    return detailGoodinfos;
}

-(TDGoodInfo *)findGoodInfoById:(int)goodsId{
    TDGoodInfo *mgoodInfo=nil;
    for (TDGoodInfo *goodInfo in goodsList) {
        if(goodInfo.goodId==goodsId){
            mgoodInfo=goodInfo;
            break;
        }
        
    }
    return mgoodInfo;
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
