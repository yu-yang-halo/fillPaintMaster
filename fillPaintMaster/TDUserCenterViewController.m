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
#import "MyAddressViewController.h"
#import <UIColor+uiGradients.h>
#import <UIView+Toast.h>
#import "GoodsCartViewController.h"
#import "CartManager.h"
#import "MessageManager.h"
#import "MessageViewController.h"
#import "AppDelegate.h"
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
    items=@[@"我的订单",@"我的商品订单",@"收货地址",@"我的购物车",@"消息"];
   itemsIcons=@[@"my_icon_input",@"my_icon_set",@"my_icon_address",@"icon_cart_item",@"my_icon_message"];

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
    
    [_exitButton.layer setCornerRadius:3];
    [_exitButton.layer setBorderWidth:1];
    [_exitButton.layer setBorderColor:[[UIColor colorWithWhite:0.9 alpha:1] CGColor]];
    
    [self.exitButton addTarget:self action:@selector(exitApp:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toCoupon:)];
    [tapGR setNumberOfTapsRequired:1];
    
    [self.couponView addGestureRecognizer:tapGR];
    UITapGestureRecognizer *tapGR2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toCar:)];
    [tapGR2 setNumberOfTapsRequired:1];
    
    [self.carView addGestureRecognizer:tapGR2];
    

    UIColor *startColor=[UIColor yellowColor];
    UIColor *endColor=[UIColor redColor];
    CAGradientLayer *gradient=[CAGradientLayer layer];
    gradient.frame=_backgroundView.bounds;
    gradient.startPoint=CGPointMake(0,0);
    gradient.endPoint=CGPointMake(1,1);
    gradient.colors=@[(id)[startColor CGColor],(id)[endColor CGColor]];

    [_backgroundView.layer insertSublayer:gradient atIndex:0];
    
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
   [self.navigationController setNavigationBarHidden:YES];
    // 马上进入刷新状态
    [refreshHeader beginRefreshing];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)netDataGet{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        TDUser *user=[[ElApiService shareElApiService] getUserInfo];
        NSArray *carInfos=[[ElApiService shareElApiService] getCarByCurrentUser];
        NSArray *shopInfos=[[ElApiService shareElApiService] getShopList];
        

    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            AppDelegate *delegate=[UIApplication sharedApplication].delegate;
            
            delegate.shoplist=shopInfos;
            
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
        [self.navigationItem.backBarButtonItem setTitle:@"返回"];
        
        [self.tabBarController.navigationController pushViewController:myOrderTableVC animated:YES];
    }else if(indexPath.row==1){
        MyGoodsOrderTableViewController *goodsOrderTableVC=[[MyGoodsOrderTableViewController alloc] init];
        [self.navigationItem.backBarButtonItem setTitle:@"返回"];
        [self.tabBarController.navigationController pushViewController:goodsOrderTableVC animated:YES];
    }else if(indexPath.row==2){
        MyAddressViewController *addressVC=[[MyAddressViewController alloc] init];
        [self.navigationItem.backBarButtonItem setTitle:@"返回"];
        [self.tabBarController.navigationController pushViewController:addressVC animated:YES];
       
    }else if(indexPath.row==3){
        NSArray *mycartClassList=[[CartManager defaultManager] getMyCartClassList];
        if([mycartClassList count]<=0){
            [self.view.window makeToast:@"您的购物车还没有任何的商品~"];
        }else{
            
            GoodsCartViewController *goodsCartVC=[[GoodsCartViewController alloc] init];
            [self.navigationItem.backBarButtonItem setTitle:@"返回"];
            [self.tabBarController.navigationController pushViewController:goodsCartVC animated:YES];
        }
     

    }else if(indexPath.row==4){
        NSArray *msgList=[MessageManager getJPMessageArray];
        if(msgList==nil||[msgList count]<=0){
            [self.view.window makeToast:@"暂时还没有最新消息"];
        }else{
            MessageViewController *messageVC=[[MessageViewController alloc] init];
            [self.navigationItem.backBarButtonItem setTitle:@"返回"];
            [self.tabBarController.navigationController pushViewController:messageVC animated:YES];
        }
    }
}


@end
