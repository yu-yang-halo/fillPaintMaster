//
//  TDUserCenterViewController.m
//  fillPaintMaster
//
//  Created by admin on 16/1/5.
//  Copyright (c) 2016年 LZTech. All rights reserved.
//

#import "TDUserCenterViewController.h"
#import "ElApiService.h"
#import <MJRefresh/MJRefresh.h>
#import "MyOrderTableViewController.h"
#import "MyGoodsOrderTableViewController.h"
#import "MyCouponTableViewController.h"
#import "MyCarTableViewController.h"
static const float ROW_HEIGHT=60;
static CGFloat const kWindowHeight = 160.0f;
@interface TDUserCenterViewController (){
    NSArray *items;
    NSArray *itemsIcons;
    MJRefreshNormalHeader *refreshHeader;
}
@property (retain, nonatomic)  UITableView *tableView;

@end

@implementation TDUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    items=@[@[@"",@""],@"我的订单",@"我的商品订单",@"我的预约",@"优惠券"];
  itemsIcons=@[@"home_btn_my_sel",@"my_icon_input",@"my_icon_set",@"my_icon_zixun",@"my_icon_message"];
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-49)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setRowHeight:ROW_HEIGHT];
   
    
    [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    
    refreshHeader=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self netDataGet];
    }];
    [refreshHeader.lastUpdatedTimeLabel setHidden:YES];
    self.tableView.mj_header=refreshHeader;
    
   
    
    
    
    
    [self.view addSubview:_tableView];
  
    
}
-(void)viewWillAppear:(BOOL)animated{
    // 马上进入刷新状态
    [refreshHeader beginRefreshing];

}

-(void)netDataGet{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        TDUser *user=[[ElApiService shareElApiService] getUserInfo];
        NSArray *carInfos=[[ElApiService shareElApiService] getCarByCurrentUser];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSArray *datas=nil;
            if(carInfos!=nil&&[carInfos count]>0){
               
                if ([carInfos count]>=2) {
                    datas=@[user.loginName,[NSString stringWithFormat:@"%@ 更多...",[(TDCarInfo *)carInfos[0] number]]];
                }else{
                    datas=@[user.loginName,[(TDCarInfo *)carInfos[0] number]];
                }
                
                
            }else{
                datas=@[user.loginName,@"您还没有车牌，请添加"];
            }
            
            items=@[datas,@"我的订单",@"我的商品订单",@"我的预约",@"优惠券"];
            [_tableView reloadData];
            
            [refreshHeader endRefreshing];
            
        });
        
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        return 80;
    }
    return ROW_HEIGHT;
}

#pragma mark DataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"mTableCell";
    UITableViewCell *tableCell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(tableCell==nil){
        tableCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    if(indexPath.row==0){
        [tableCell.textLabel setText:[items objectAtIndex:indexPath.row][0]];

        
        [tableCell.detailTextLabel setText:[items objectAtIndex:indexPath.row][1]];
        [tableCell.detailTextLabel setFont:[UIFont systemFontOfSize:16]];
        [tableCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }else{
        [tableCell.textLabel setText:[items objectAtIndex:indexPath.row]];
    }
    
    [tableCell.imageView setImage:[UIImage imageNamed:[itemsIcons objectAtIndex:indexPath.row]]];
  
    return tableCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.row==1){
        MyOrderTableViewController *myOrderTableVC=[[MyOrderTableViewController alloc] init];
        [myOrderTableVC setType:0];
        [self.navigationItem.backBarButtonItem setTitle:@"返回"];
        
        [self.tabBarController.navigationController pushViewController:myOrderTableVC animated:YES];
    }else if(indexPath.row==3){
        MyOrderTableViewController *myOrderTableVC=[[MyOrderTableViewController alloc] init];
        [myOrderTableVC setType:1];
        [self.navigationItem.backBarButtonItem setTitle:@"返回"];
        [self.tabBarController.navigationController pushViewController:myOrderTableVC animated:YES];
    }else if(indexPath.row==2){
        MyGoodsOrderTableViewController *goodsOrderTableVC=[[MyGoodsOrderTableViewController alloc] init];
        [self.navigationItem.backBarButtonItem setTitle:@"返回"];
        [self.tabBarController.navigationController pushViewController:goodsOrderTableVC animated:YES];
    }else if(indexPath.row==4){
        
        MyCouponTableViewController *couponTableVC=[[MyCouponTableViewController alloc] init];
        [self.navigationItem.backBarButtonItem setTitle:@"返回"];
        [self.tabBarController.navigationController pushViewController:couponTableVC animated:YES];
    }else if(indexPath.row==0){
        MyCarTableViewController *carTableVC=[[MyCarTableViewController alloc] init];
        [self.navigationItem.backBarButtonItem setTitle:@"返回"];
        [self.tabBarController.navigationController pushViewController:carTableVC animated:YES];
    }
}


@end
