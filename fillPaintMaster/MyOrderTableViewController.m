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
#import <UIView+Toast.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "DecimalCaculateUtils.h"
#import "AlibabaPay.h"
#import "AppDelegate.h"
@interface MyOrderTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *orderClassArr;
    
    MJRefreshNormalHeader *refreshHeader;
    MBProgressHUD *hud;
    int filterType;
    int shopId;
}
@property(nonatomic,strong) NSArray *titles;
@property(nonatomic,strong) HMSegmentedControl *segmentedControl;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray  *global_orderClassArr;

@end
@implementation MyOrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=@"我的订单";
    CGRect screen=[UIScreen mainScreen].bounds;
    shopId=[[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SHOP_ID] intValue];

    
    /*
     * 初始化HMSegmentedControl视图
     */
    self.titles=@[@"待支付",@"已付款",@"待确认",@"已完成",@"已退款"];
    
    self.segmentedControl=[[HMSegmentedControl alloc] initWithFrame:CGRectMake(0,64,self.view.bounds.size.width,50)];
    [_segmentedControl setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    [_segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleFullWidthStripe];
    [_segmentedControl setSelectionIndicatorLocation:(HMSegmentedControlSelectionIndicatorLocationDown)];
    [_segmentedControl setSelectionIndicatorColor:[UIColor whiteColor]];
    [_segmentedControl setSelectionIndicatorHeight:2];
    
    [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [_segmentedControl setSectionTitles:_titles];
    
    [self.view addSubview:_segmentedControl];
     self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,50+64,self.view.bounds.size.width, screen.size.height-50-64)];
   
    [self.view addSubview:_tableView];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    
    
    
    filterType=0;
    __weak MyOrderTableViewController *weakSelf=self;
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        NSLog(@" index %d ",index);
        filterType=index;
        [weakSelf filterData];
        [weakSelf.tableView reloadData];
    }];

    refreshHeader=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self netDataGet];
    }];
    [refreshHeader.lastUpdatedTimeLabel setHidden:YES];
    self.tableView.mj_header=refreshHeader;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    // 马上进入刷新状态
    [refreshHeader beginRefreshing];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:) name:notification_alipay_refresh object:nil];
    
}

-(void)refreshView:(NSNotification *)notification{
     NSNumber *result=notification.object;
     if([result boolValue]){
        [refreshHeader beginRefreshing];
         NSLog(@"支付成功》》》》");
     }else{
         NSLog(@"支付失败》》》》");
     }
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
            self.global_orderClassArr=[[NSMutableArray alloc] init];
            if(decoOrderList!=nil){
                for (TDDecoOrder *decoOrder in decoOrderList) {
                    
                    if(decoOrder.price<0){
                        continue;
                    }
                    
                    OrderInterface *orderInterface=[[OrderInterface alloc] init];
                    [orderInterface setOrderId:decoOrder.decoOrderId];
                    [orderInterface setOrderType:AC_TYPE_WASH];
                    [orderInterface setStatus:decoOrder.state];
                     [orderInterface setPayStatus:decoOrder.payState];
                    [orderInterface setCreateTimeLabel:decoOrder.createTime];
                    [orderInterface setShopId:decoOrder.shopId];
                    [orderInterface setNumlabel:[NSString stringWithFormat:@"数量:%d",[decoOrder.decoOrderNumber count]]];
                    
                    [orderInterface setPriceLabel:[NSString stringWithFormat:@"总价:%@",[DecimalCaculateUtils decimalFloat:decoOrder.price]]];
                    [orderInterface setPayPrice:decoOrder.price];
                    [orderInterface setTrade_no:decoOrder.tradeNo];
                    
                    [_global_orderClassArr addObject:orderInterface];
                    
                }

            }
            if(oilOrderList!=nil){
                for (TDOilOrder *oilOrder in oilOrderList) {
                    if(oilOrder.price<=0){
                        continue;
                    }
                    OrderInterface *orderInterface=[[OrderInterface alloc] init];
                    [orderInterface setOrderId:oilOrder.oilOrderId];
                    [orderInterface setOrderType:AC_TYPE_OIL];
                    [orderInterface setStatus:oilOrder.state];
                     [orderInterface setPayStatus:oilOrder.payState];
                    [orderInterface setCreateTimeLabel:oilOrder.createTime];
                       [orderInterface setShopId:oilOrder.shopId];
                    [orderInterface setNumlabel:[NSString stringWithFormat:@"数量:%d",[oilOrder.oilOrderNumber count]]];
                    [orderInterface setPriceLabel:[NSString stringWithFormat:@"总价:%@",[DecimalCaculateUtils decimalFloat:oilOrder.price]]];
                    [orderInterface setPayPrice:oilOrder.price];
                    [orderInterface setTrade_no:oilOrder.tradeNo];
                    [_global_orderClassArr addObject:orderInterface];
                    
                }
                
            }
            
            if(metaOrderList!=nil){
                for (TDMetaOrder *metaOrder in metaOrderList) {
                  
                    if(metaOrder.state==STATE_ORDER_CANCEL){
                        continue;
                    }
                
                    OrderInterface *orderInterface=[[OrderInterface alloc] init];
                    [orderInterface setOrderId:metaOrder.metaOrderId];
                    [orderInterface setOrderType:AC_TYPE_META];
                    [orderInterface setStatus:metaOrder.state];
                    [orderInterface setPayStatus:metaOrder.payState];
                    [orderInterface setCreateTimeLabel:metaOrder.createTime];
                     [orderInterface setShopId:metaOrder.shopId];
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
                   
                    [_global_orderClassArr addObject:orderInterface];
                    
                }
                
            }
            
            [self filterData];

            [self.tableView reloadData];
            
            [refreshHeader endRefreshing];
            
            if(hud!=nil){
                [hud hide:YES];
                 hud=nil;
            }
            
        });
    });
}

-(void)filterData{
    orderClassArr=[[NSMutableArray alloc] init];
    if(filterType==0){
        for (OrderInterface *bean in _global_orderClassArr) {
            if(bean.status==STATE_ORDER_CANCEL){
                continue;
            }
            if(bean.payStatus==PAY_STATE_UNFINISHED&&bean.orderType!=AC_TYPE_META){
                [orderClassArr addObject:bean];
            }
        }
    }else  if(filterType==1){
        for (OrderInterface *bean in _global_orderClassArr) {
            if(bean.status==STATE_ORDER_CANCEL){
                continue;
            }
            if(bean.payStatus==PAY_STATE_FINISHED&&bean.status!=STATE_ORDER_FINISHED){
                [orderClassArr addObject:bean];
            }
        }
    }else  if(filterType==2){
        for (OrderInterface *bean in _global_orderClassArr) {
            if(bean.status==STATE_ORDER_CANCEL){
                continue;
            }
            if(bean.orderType==AC_TYPE_META){
                [orderClassArr addObject:bean];
            }
        }
    }else  if(filterType==3){
        for (OrderInterface *bean in _global_orderClassArr) {
            if(bean.status==STATE_ORDER_CANCEL){
                continue;
            }
            if(bean.payStatus==PAY_STATE_FINISHED&&bean.status==STATE_ORDER_FINISHED){
                [orderClassArr addObject:bean];
            }
        }
    }else  if(filterType==4){
        for (OrderInterface *bean in _global_orderClassArr) {
          
            if(bean.payStatus==PAY_STATE_FINISHED&&bean.status==STATE_ORDER_CANCEL){
                [orderClassArr addObject:bean];
            }
        }
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification_alipay_refresh object:nil];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"h::%f",cell.frame.size.height);
    return cell.frame.size.height;
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
    
    [cell.createTimeLabel setText:[NSString stringWithFormat:@"预约时间:%@",[TimeUtils normalShowTime:ori.createTimeLabel]]];
    [cell.totalPriceLabel setText:ori.priceLabel];
    
    [cell.statusLabel setText:_titles[filterType]];
    
    
    AppDelegate *delegate=[UIApplication sharedApplication].delegate;
    TDShopInfo *shopInfo=[delegate findShopInfo:ori.shopId];
    
    
    if(shopInfo!=nil&&shopInfo.shopId!=-1){
        [cell.shopNameLabel setText:[NSString stringWithFormat:@"服务店铺:%@",shopInfo.name]];
    }else{
        [cell.shopNameLabel setText:@""];

    }
    

    
    
    BOOL isOverTime=[TimeUtils isOverTime:ori.createTimeLabel];
    
    if(filterType==0){
        if(isOverTime){
            [cell.statusLabel setText:@"已过期"];
            [cell.cancelButton setHidden:YES];
            [cell.payButton setHidden:YES];
        }else{
            [cell.cancelButton setHidden:NO];
            [cell.payButton setHidden:NO];
        }
        
    }else if(filterType==1){
         [cell.payButton setHidden:YES];
        if(isOverTime){
        
            [cell.cancelButton setHidden:YES];
           
        }else{
            [cell.cancelButton setHidden:NO];
        }
        
    }else if(filterType==2){
        [cell.payButton setHidden:YES];
        if(isOverTime){
            [cell.statusLabel setText:@"已过期"];
            [cell.cancelButton setHidden:YES];
            
        }else{
            [cell.cancelButton setHidden:NO];
        }
        
    }else if(filterType==3||filterType==4){
        [cell.payButton setHidden:YES];
        [cell.cancelButton setHidden:YES];
    }
    

    [cell.cancelButton setTag:indexPath.row];
    [cell.cancelButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.payButton setTag:indexPath.row];
    [cell.payButton addTarget:self action:@selector(payOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}
-(void)payOrder:(UIButton *)sender{
    int pos=sender.tag;
    OrderInterface *ori=[orderClassArr objectAtIndex:pos];
    NSString *title=@"";
    NSString *desc=ori.numlabel;
    if(ori.orderType==AC_TYPE_OIL){
        title=@"换油保养";
    }else if(ori.orderType==AC_TYPE_WASH){
        title=@"汽车美容";
    }else if(ori.orderType==AC_TYPE_META){
       title=@"钣金喷漆";
    }
    Product *product=[[Product alloc] init];
    product.subject=title;
    product.body=desc;
    product.price=ori.payPrice;
    product.orderId=ori.trade_no;
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        AlipayInfoType *alipayInfoType=[[ElApiService shareElApiService] getAlipayByShopId:ori.shopId];
        AlibabaPay *alibabaPay=[[AlibabaPay alloc] initPartner:alipayInfoType.aliPid seller:alipayInfoType.sellerEmail];
        
        NSString *content=[alibabaPay getTradInfo:product];
        
        NSString *sign=[[ElApiService shareElApiService] signContent:ori.shopId content:content];
        
        product.sign=sign;
        
        [alibabaPay aliPay:product callback:^(NSDictionary *resultDic) {
            
            NSLog(@"resultDic %@",resultDic);
            id  resultStatus=[resultDic objectForKey:@"resultStatus"];
            if([resultStatus intValue]==9000){
                [self.view.window makeToast:@"支付成功"];
                 [refreshHeader beginRefreshing];
            }else{
                [self.view.window makeToast:@"支付失败"];
            }
            
        }];
        
        
        
    });

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
