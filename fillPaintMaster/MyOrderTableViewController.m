//
//  MyOrderTableViewController.m
//  fillPaintMaster
//
//  Created by apple on 16/4/10.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "MyOrderTableViewController.h"
#import "MyOrderTableViewCell.h"
#import "ElApiService.h"
#import "Constants.h"
#import <MJRefresh/MJRefresh.h>
#import "TimeUtils.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface MyOrderTableViewController ()
{
    NSMutableArray *orderClassArr;
    MJRefreshNormalHeader *refreshHeader;
    MBProgressHUD *hud ;
}
@end

@implementation MyOrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.type==0){
        self.title=@"我的订单";
    }else{
        self.title=@"我的预约";
    }
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
    id shopId=[[NSUserDefaults standardUserDefaults] objectForKey:@"shopId"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        TDOrderSearch *search=[[TDOrderSearch alloc] init];
        
        [search setSearchType:SEARCH_TYPE_USERID];
        [search setStartTime:@"1999-09-01+00+00+00"];
        
        NSArray *decoOrderList=[[ElApiService shareElApiService] getDecoOrderList:search];
        
        NSArray *metaOrderList=[[ElApiService shareElApiService] getMetaOrderList:search];
        
        NSArray *oilOrderList=[[ElApiService shareElApiService] getOilOrderList:search];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            orderClassArr=[[NSMutableArray alloc] init];
            if(decoOrderList!=nil){
                for (TDDecoOrder *decoOrder in decoOrderList) {
                    
                    if(decoOrder.price<=0){
                        continue;
                    }
                    if(decoOrder.state==STATE_ORDER_CANCEL){
                        continue;
                    }
                    if(_type==0&&decoOrder.state!=STATE_ORDER_FINISHED){
                        continue;
                    }
                    
                    if(_type==1&&decoOrder.state==STATE_ORDER_FINISHED){
                        continue;
                    }
                    
                    
                    OrderInterface *orderInterface=[[OrderInterface alloc] init];
                    [orderInterface setOrderId:decoOrder.decoOrderId];
                    [orderInterface setOrderType:AC_TYPE_WASH];
                    [orderInterface setStatus:decoOrder.state];
                    [orderInterface setCreateTimeLabel:decoOrder.createTime];
                    [orderInterface setNumlabel:[NSString stringWithFormat:@"数量:%d",[decoOrder.decoOrderNumber count]]];
                    [orderInterface setPriceLabel:[NSString stringWithFormat:@"总价:%.2f",decoOrder.price]];
                    [orderClassArr addObject:orderInterface];
                    
                }

            }
            if(oilOrderList!=nil){
                for (TDOilOrder *oilOrder in oilOrderList) {
                    if(oilOrder.price<=0){
                        continue;
                    }
                    if(oilOrder.state==STATE_ORDER_CANCEL){
                        continue;
                    }
                    if(_type==0&&oilOrder.state!=STATE_ORDER_FINISHED){
                        continue;
                    }
                    
                    if(_type==1&&oilOrder.state==STATE_ORDER_FINISHED){
                        continue;
                    }

                    
                    OrderInterface *orderInterface=[[OrderInterface alloc] init];
                    [orderInterface setOrderId:oilOrder.oilOrderId];
                    [orderInterface setOrderType:AC_TYPE_OIL];
                    [orderInterface setStatus:oilOrder.state];
                    [orderInterface setCreateTimeLabel:oilOrder.createTime];
                    [orderInterface setNumlabel:[NSString stringWithFormat:@"数量:%d",[oilOrder.oilOrderNumber count]]];
                    [orderInterface setPriceLabel:[NSString stringWithFormat:@"总价:%.2f",oilOrder.price]];
                    [orderClassArr addObject:orderInterface];
                    
                }
                
            }
            
            if(metaOrderList!=nil){
                for (TDMetaOrder *metaOrder in metaOrderList) {
                  
                    if(metaOrder.state==STATE_ORDER_CANCEL){
                        continue;
                    }
                    if(_type==0&&metaOrder.state!=STATE_ORDER_FINISHED){
                        continue;
                    }
                    
                    if(_type==1&&metaOrder.state==STATE_ORDER_FINISHED){
                        continue;
                    }

                    OrderInterface *orderInterface=[[OrderInterface alloc] init];
                    [orderInterface setOrderId:metaOrder.metaOrderId];
                    [orderInterface setOrderType:AC_TYPE_META];
                    [orderInterface setStatus:metaOrder.state];
                    [orderInterface setCreateTimeLabel:metaOrder.createTime];
                    if(metaOrder.metaOrderImg!=nil&& [metaOrder.metaOrderImg count]>0){
                        [orderInterface setNumlabel:[NSString stringWithFormat:@"上传照片数:%d",[metaOrder.metaOrderImg count]]];
                    }
                    
                    if(metaOrder.metaOrderNumber!=nil&& [metaOrder.metaOrderNumber count]>0){
                        [orderInterface setNumlabel:[NSString stringWithFormat:@"数量:%d",[metaOrder.metaOrderNumber count]]];
                    }
                   
                    if(metaOrder.price<=0){
                        [orderInterface setPriceLabel:@""];
                    }else{
                        [orderInterface setPriceLabel:[NSString stringWithFormat:@"总价:%.2f",metaOrder.price]];
                    }
                   
                    [orderClassArr addObject:orderInterface];
                    
                }
                
            }
            
            [self.tableView reloadData];
            
            [refreshHeader endRefreshing];
            
            if(hud!=nil){
                [hud hide:YES];
                 hud=nil;
            }
            
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

    if(orderClassArr!=nil){
        return [orderClassArr count];
    }
    
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderTableViewCell"];
    if(cell==nil){
        cell= [[[NSBundle mainBundle] loadNibNamed:@"MyOrderTableViewCell" owner:self options:nil] lastObject];
    }
    
    OrderInterface *ori=[orderClassArr objectAtIndex:indexPath.row];
    
    if(ori.orderType==AC_TYPE_OIL){
        [cell.iconImageView setImage:[UIImage imageNamed:@"homepage_gridview_6"]];
        [cell.nameLabel setText:@"换油保养"];
    }else if(ori.orderType==AC_TYPE_WASH){
        [cell.iconImageView setImage:[UIImage imageNamed:@"homepage_gridview_8"]];
        [cell.nameLabel setText:@"汽车美容"];
    }else if(ori.orderType==AC_TYPE_META){
        [cell.iconImageView setImage:[UIImage imageNamed:@"homepage_gridview_7"]];
        [cell.nameLabel setText:@"钣金喷漆"];
    }
    
    [cell.numLabel setText:ori.numlabel];
    
    [cell.createTimeLabel setText:[NSString stringWithFormat:@"订单时间:%@",[TimeUtils normalShowTime:ori.createTimeLabel]]];
    [cell.totalPriceLabel setText:ori.priceLabel];
    
    if(ori.status==STATE_ORDER_FINISHED){
        [cell.statusLabel setText:@"已完成"];
        
    }else if(ori.status==STATE_ORDER_UNFINISHED){
        [cell.statusLabel setText:@"正在处理"];
    }else if(ori.status==STATE_ORDER_WAIT){
        [cell.statusLabel setText:@"请等待客服确认"];
    }
    
    if(_type==0){
        [cell.cancelButton setHidden:YES];
    }else{
        [cell.cancelButton setTag:indexPath.row];
        
        [cell.cancelButton setHidden:NO];
        [cell.cancelButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    return cell;
}
-(void)cancelOrder:(UIButton *)sender{
    
    int pos=sender.tag;
    OrderInterface *ori=[orderClassArr objectAtIndex:pos];
    hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    
    hud.labelText = @"取消中...";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        if(ori.orderType==AC_TYPE_WASH){
            TDDecoOrder *tdDecoOrder=[[TDDecoOrder alloc] init];
            [tdDecoOrder setState:STATE_ORDER_CANCEL];
            [tdDecoOrder setDecoOrderId:ori.orderId];
            [[ElApiService shareElApiService] updDecoOrder:tdDecoOrder];
            
        }else if(ori.orderType==AC_TYPE_OIL){
            TDOilOrder *tdOilOrder=[[TDOilOrder alloc] init];
            [tdOilOrder setState:STATE_ORDER_CANCEL];
            [tdOilOrder setOilOrderId:ori.orderId];
            [[ElApiService shareElApiService] updOilOrder:tdOilOrder];
            
        }else if(ori.orderType==AC_TYPE_META){
            TDMetaOrder *tdMetaOrder=[[TDMetaOrder alloc] init];
            [tdMetaOrder setState:STATE_ORDER_CANCEL];
            [tdMetaOrder setMetaOrderId:ori.orderId];
            [[ElApiService shareElApiService] updMetaOrder:tdMetaOrder];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 马上进入刷新状态
            [self netDataGet];
        });
        
        
        
    });
    
}



@end

@implementation OrderInterface


@end
