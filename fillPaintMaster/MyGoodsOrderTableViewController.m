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
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "DecimalCaculateUtils.h"
#import "AlibabaPay.h"
#import "Constants.h"
#import <UIView+Toast.h>
@interface MyGoodsOrderTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *goodsOrderList;
    MJRefreshNormalHeader *refreshHeader;
    NSArray *goodsList;
    int filterType;
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *titles;
@property(nonatomic,strong)  NSArray *list;
@property(nonatomic,strong) HMSegmentedControl *segmentedControl;
@end

@implementation MyGoodsOrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=@"我的商品订单";
    CGRect screen=[UIScreen mainScreen].bounds;
    refreshHeader=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self netDataGet];
    }];
    [refreshHeader.lastUpdatedTimeLabel setHidden:YES];
    
    /** state::0  1  2  3  **/
    self.titles=@[@"未发货",@"已发货",@"未支付"];
    
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
    
    
    self.tableView.mj_header=refreshHeader;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    
    //self.tableView.contentInset=UIEdgeInsetsMake(0, 0,-20,0);
    
    
    // 马上进入刷新状态
    [refreshHeader beginRefreshing];
    
    filterType=0;
    __weak MyGoodsOrderTableViewController *weakSelf=self;
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        NSLog(@" index %d ",index);
        filterType=index;
        [weakSelf refreshData];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:) name:notification_alipay_refresh object:nil];

    
}
-(void)refreshData{
     [self filterGoodOrder];
     [self.tableView reloadData];
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        TDOrderSearch *search=[[TDOrderSearch alloc] init];
        
        [search setSearchType:SEARCH_TYPE_USERID];
        [search setStartTime:@"1999-09-01+00+00+00"];
        
         self.list=[[ElApiService shareElApiService] getGoodsOrderList:search];
         goodsList=[[ElApiService shareElApiService] getGoodsList:-2];
       
        
        
         dispatch_async(dispatch_get_main_queue(), ^{
            
             [self refreshData];
             [refreshHeader endRefreshing];
         });
        
        
    });
}


-(void)filterGoodOrder{
    NSArray *allDatas=[_list copy];
    
    NSMutableArray *temp=[NSMutableArray new];
    for(TDGoodsOrderListType *goodOrder in allDatas){
        if(goodOrder.state==filterType){
            [temp addObject:goodOrder];
        }
    }
    
    NSMutableDictionary *cacheMap=[NSMutableDictionary new];
    
    for(TDGoodsOrderListType *goods in temp) {
        if(goods.tradeNo==nil||[goods.tradeNo isEqualToString:@""]){
            continue;
        }
        TDGoodsOrderListType *existObj=[cacheMap objectForKey:goods.tradeNo];
        
        if(existObj==nil){
            [cacheMap setObject:goods forKey:goods.tradeNo];
        }else{
            /**
             **  组合数据
             **/
            
            
            
            [existObj setGoodsInfo:[NSString stringWithFormat:@"%@,%@",existObj.goodsInfo,goods.goodsInfo]];
            NSString *totalPrice=[DecimalCaculateUtils addWithA:[NSString stringWithFormat:@"%@",existObj.price] andB:[NSString stringWithFormat:@"%@",goods.price]];
            
            [existObj setPrice:totalPrice];
            [cacheMap setObject:existObj forKey:existObj.tradeNo];
        }
        
        
    }
    
    
    goodsOrderList=cacheMap.allValues;

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification_alipay_refresh object:nil];

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
    
    [cell.priceLabel setText:[DecimalCaculateUtils showDecimalFloat:goodsInfo.price]];

    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerBgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    
    [footerBgView setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:0.7]];
    
    UIButton *cancelBtn=[[UIButton alloc] initWithFrame:CGRectMake(20, (50-30)/2, 100, 30)];
    
    [cancelBtn.layer setBorderColor:[[UIColor redColor] CGColor]];
    [cancelBtn.layer setBorderWidth:1];
    [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.5] forState:UIControlStateHighlighted];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    UIButton *payBtn=[[UIButton alloc] initWithFrame:CGRectMake(footerBgView.frame.size.width-20-100, (50-30)/2, 100, 30)];
    
    [payBtn.layer setBorderColor:[[UIColor redColor] CGColor]];
    [payBtn.layer setBorderWidth:1];
    [payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.5] forState:UIControlStateHighlighted];
    [payBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    [footerBgView addSubview:cancelBtn];
    [footerBgView addSubview:payBtn];
    
    TDGoodsOrderListType *orderObj=[goodsOrderList objectAtIndex:section];
    
    if(orderObj.state==GOOD_STATE_ORDER_NO_PAY){
        [payBtn setHidden:NO];
    }else{
        [payBtn setHidden:YES];
    }
    
    [payBtn setTag:section];
    [cancelBtn setTag:section];
    
    [payBtn addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return footerBgView;
}
-(void)cancelClick:(UIButton *)sender{
    TDGoodsOrderListType *orderObj=[goodsOrderList objectAtIndex:sender.tag];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        [[ElApiService shareElApiService] updGoodsOrder:orderObj.goodsOrderId state:GOOD_STATE_ORDER_CANCEL];
        dispatch_async(dispatch_get_main_queue(), ^{
              [self netDataGet];
        });
        
    });
    
}
-(void)payClick:(UIButton *)sender{
     TDGoodsOrderListType *orderObj=[goodsOrderList objectAtIndex:sender.tag];
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
         AlipayInfoType *alipayInfoType=[[ElApiService shareElApiService] getAlipayByShopId:-1];
         Product *product=[[Product alloc] init];
         
         [product setSubject:@"客乐养车坊"];
         [product setBody:@"商品订单"];
         [product setPrice:orderObj.price.floatValue];
         [product setOrderId:orderObj.tradeNo];
         
         AlibabaPay *alibabaPay=[[AlibabaPay alloc] initPartner:alipayInfoType.aliPid seller:alipayInfoType.sellerEmail];
         NSString *content=[alibabaPay getTradInfo:product];
         
         
         NSString *sign=[[ElApiService shareElApiService] signContent:-1 content:content];
         [product setSign:sign];
         
         
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerBgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    
    [headerBgView setBackgroundColor:[UIColor colorWithWhite:0.98 alpha:0.98]];
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, (50-30)/2, 80, 30)];
    [titleLabel setText:@"订单总金额:"];
    [titleLabel setFont:[UIFont systemFontOfSize:12]];
    [titleLabel setTextColor:[UIColor colorWithWhite:0.6 alpha:0.9]];
    
    UILabel *totalPriceLabel=[[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width+2, (50-30)/2, 160, 30)];
    [totalPriceLabel setFont:[UIFont systemFontOfSize:12]];
    [totalPriceLabel setTextColor:[UIColor redColor]];
    
    [headerBgView addSubview:titleLabel];
    [headerBgView addSubview:totalPriceLabel];
    
    TDGoodsOrderListType *orderObj=[goodsOrderList objectAtIndex:section];

    
    [totalPriceLabel setText:[DecimalCaculateUtils showDecimalString:orderObj.price]];
    
    
    return headerBgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
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



@end
