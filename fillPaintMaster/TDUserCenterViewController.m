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
#import "TDLoginViewController.h"
#import "UserAddressManager.h"
static const float ROW_HEIGHT=60;
static CGFloat const kWindowHeight = 160.0f;
@interface TDUserCenterViewController (){
    NSArray *items;
    NSArray *itemsIcons;
    MJRefreshNormalHeader *refreshHeader;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UIView *carView;
@property (weak, nonatomic) IBOutlet UILabel *carnumberLabel;

@end

@implementation TDUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    items=@[@"我的订单",@"我的商品订单",@"我的预约"];
   itemsIcons=@[@"my_icon_input",@"my_icon_set",@"my_icon_zixun"];

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
    
    [self.exitButton addTarget:self action:@selector(exitApp:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toCoupon:)];
    [tapGR setNumberOfTapsRequired:1];
    
    [self.couponView addGestureRecognizer:tapGR];
    UITapGestureRecognizer *tapGR2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toCar:)];
    [tapGR2 setNumberOfTapsRequired:1];
    
    [self.carView addGestureRecognizer:tapGR2];

    
}
-(void)toCoupon:(UIGestureRecognizer *)gr{
    MyCouponTableViewController *couponTableVC=[[MyCouponTableViewController alloc] init];
    [self.navigationItem.backBarButtonItem setTitle:@"返回"];
    [self.tabBarController.navigationController pushViewController:couponTableVC animated:YES];
}
-(void)toCar:(UIGestureRecognizer *)gr{
    MyCarTableViewController *carTableVC=[[MyCarTableViewController alloc] init];
    [self.navigationItem.backBarButtonItem setTitle:@"返回"];
    [self.tabBarController.navigationController pushViewController:carTableVC animated:YES];
}

-(void)exitApp:(id)sender{
    TDLoginViewController *loginVC=[[TDLoginViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:^{
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
    // 马上进入刷新状态
    [refreshHeader beginRefreshing];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:NO];
}

-(void)netDataGet{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        TDUser *user=[[ElApiService shareElApiService] getUserInfo];
        NSArray *carInfos=[[ElApiService shareElApiService] getCarByCurrentUser];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *datas=@"";
            if(carInfos!=nil&&[carInfos count]>0){
               
                if ([carInfos count]>=2) {
                    datas=[NSString stringWithFormat:@"%@..",[(TDCarInfo *)carInfos[0] number]];
                }else{
                    datas=[NSString stringWithFormat:@"%@",[(TDCarInfo *)carInfos[0] number]];
                }
            }else{
                datas=@"您还没有车牌，请添加";
            }
            _carnumberLabel.text=datas;
            
            _usernameLabel.text=user.loginName;
            [UserAddressManager cacheUserInfoToLocal:user];
            
            
    
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
    
    [tableCell.textLabel setText:[items objectAtIndex:indexPath.row]];
    [tableCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    [tableCell.imageView setImage:[UIImage imageNamed:[itemsIcons objectAtIndex:indexPath.row]]];
  
    return tableCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if(indexPath.row==0){
        MyOrderTableViewController *myOrderTableVC=[[MyOrderTableViewController alloc] init];
        [myOrderTableVC setType:0];
        [self.navigationItem.backBarButtonItem setTitle:@"返回"];
        
        [self.tabBarController.navigationController pushViewController:myOrderTableVC animated:YES];
    }else if(indexPath.row==2){
        MyOrderTableViewController *myOrderTableVC=[[MyOrderTableViewController alloc] init];
        [myOrderTableVC setType:1];
        [self.navigationItem.backBarButtonItem setTitle:@"返回"];
        [self.tabBarController.navigationController pushViewController:myOrderTableVC animated:YES];
    }else if(indexPath.row==1){
        MyGoodsOrderTableViewController *goodsOrderTableVC=[[MyGoodsOrderTableViewController alloc] init];
        [self.navigationItem.backBarButtonItem setTitle:@"返回"];
        [self.tabBarController.navigationController pushViewController:goodsOrderTableVC animated:YES];
    }else if(indexPath.row==3){
        
       
    }else if(indexPath.row==-1){
       
    }
}


@end
