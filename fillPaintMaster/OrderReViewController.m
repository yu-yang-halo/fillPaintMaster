//
//  OrderReViewController.m
//  fillPaintMaster
//
//  Created by apple on 15/10/2.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import "OrderReViewController.h"
#import "TDBeautyTableViewCell2.h"
#import "TDTableViewCell0.h"
#import "TDTableViewCell1.h"
#import "OrderSuccessViewController.h"
#import "TDConstants.h"
#import "YYButtonUtils.h"
#import "TDLocationViewController.h"
#import "ElApiService.h"
#import "Constants.h"
#import "TimeUtils.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <UIView+Toast.h>
#import "TimeUtils.h"
const float ROW_HEIGHT=50;
const float ROW_HEIGHT_SECTION10=100;
const float ROW_HEIGHT_SECTION11=60;
@interface OrderReViewController (){
    NSArray *test;
    NSString *titleName;
    float totalPrice;
    MBProgressHUD *hud;
    int payIndex;
    int couponIndex;
    int shopId;
    int orderType;
}
@property (weak, nonatomic) IBOutlet UITableView *beautyItemTableView;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *favourableLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitOrderBtn;
@property(nonatomic,strong) NSArray *payTypes;
@property(nonatomic,strong) NSMutableArray *couponInfos;
@end

@implementation OrderReViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    orderType=-2;
    if(_carBeautyType==CarBeautyType_beauty){
        titleName=@"洗车美容";
        orderType=ORDER_TYPE_DECO;
    }else if(_carBeautyType==CarBeautyType_oil){
        titleName=@"换油保养";
         orderType=ORDER_TYPE_OIL;
    }else{
        titleName=@"钣金喷漆";
        orderType=ORDER_TYPE_METE;
    }
    shopId=[[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SHOP_ID] intValue];
    self.payTypes=@[@"在线支付",@"到店支付"];
    couponIndex=-1;
    payIndex=0;
    
    self.title=titleName;
    
    
    [self initBeautyItemTableView];
    [self initButton];
    [self updateLabelView];
    
    
    [self dataRequestTask];
}
-(void)initButton{
    [self.commitOrderBtn.layer setCornerRadius:4];
    [self.commitOrderBtn setBackgroundColor:BTN_BG_COLOR];
    
}

-(void)dataRequestTask{
    self.couponInfos=[NSMutableArray new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
       NSArray *allCoupons=[[ElApiService shareElApiService] getCouponList:shopId];
       
        
        for (TDCouponInfo *info in allCoupons) {
            if(![TimeUtils isOverTime:info.endTime]&&!info.isUsed){
                if(info.orderType==ORDER_TYPE_ALL||info.orderType==orderType){
                    [_couponInfos addObject:info];
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    });
}

-(void)initBeautyItemTableView{
    
    
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    [label setText:titleName];
    [label setFont:[UIFont systemFontOfSize:18]];
    
    [self.beautyItemTableView setTableHeaderView:label];
    [self.beautyItemTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.beautyItemTableView.delegate=self;
    self.beautyItemTableView.dataSource=self;
}
-(void)updateLabelView{
    totalPrice=0.0;
    if(_carBeautyType==CarBeautyType_paint){
        for (TDBaseItem *baseItem in _items) {
            totalPrice+=baseItem.price*baseItem.count;
        }
    }else{
        for (TDBaseItem *baseItem in _items) {
            totalPrice+=baseItem.price;
        }
    }
    float couponPrice=0;
    
    if(couponIndex>=0){
        TDCouponInfo *couponInfo=[_couponInfos objectAtIndex:couponIndex];
        if(couponInfo.type==COUPON_TYPE_DISCOUNT){
            totalPrice=totalPrice*couponInfo.discount/10.0;
            couponPrice=totalPrice*(1-couponInfo.discount/10.0);
            
        }else{
            totalPrice=totalPrice-couponInfo.price;
            couponPrice=couponInfo.price;
            if(totalPrice<0){
                totalPrice=0;
            }
        }
    }
    
    
    [self.totalLabel setText:[NSString stringWithFormat:@"%.f元",totalPrice]];
    
    [self.favourableLabel setText:[NSString stringWithFormat:@"已优惠%.f元",couponPrice]];
    
    if([_items count]<=0){
        [self.commitOrderBtn setBackgroundColor:[UIColor grayColor]];
        [self.commitOrderBtn setEnabled:NO];
        
    }else{
        [self.commitOrderBtn setBackgroundColor:BTN_BG_COLOR];
        [self.commitOrderBtn setEnabled:YES];
    }
    
    
    
}


- (IBAction)oneKeyOrder:(id)sender {
    //立即下单
    
    
    if([_items count]>0){
        if([self.carInfos count]<=0){
            [self.view makeToast:@"您还没有车牌号，请到设置中添加车牌号"];
        }else{
             [self commitMyOrder];
        }
       
    }
    
}
-(void)commitMyOrder{
    int couponId=0;
    if(couponIndex>=0){
        TDCouponInfo *couponInfo=[_couponInfos objectAtIndex:couponIndex];
        couponId=couponInfo.couponId;
    }
    
    int carId=[[[NSUserDefaults standardUserDefaults] objectForKey:KEY_CAR_ID] intValue];
//    int shopId=[[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SHOP_ID] intValue];
    int incre=[[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SELECT_INCRE] intValue];
    NSString *hhmm=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SELECT_TIME];
    
    NSLog(@"incre %d; hhmm %@ ; %@",incre,hhmm,[TimeUtils createTimeHHMM:hhmm incre:incre]);
    
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"订单处理中";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL todoSuccess=NO;
        if(_carBeautyType==CarBeautyType_beauty){
            TDDecoOrder *decoOrder=[[TDDecoOrder alloc] init];
            [decoOrder setType:TYPE_PAY_TOSHOP];
            [decoOrder setState:STATE_ORDER_UNFINISHED];
      
            [decoOrder setCouponId:couponId];
            [decoOrder setCarId:carId];
            [decoOrder setShopId:shopId];
            [decoOrder setPrice:totalPrice];
            [decoOrder setOrderTime:[TimeUtils createTimeHHMM:hhmm incre:incre]];
            int decoOrderId=[[ElApiService shareElApiService] createDecoOrder:decoOrder];
            
            if(decoOrderId>0){
                
                for (TDBaseItem *item in _items) {
                    todoSuccess=[[ElApiService shareElApiService] createDecoOrderNumber:decoOrderId decoId:item.decorationId];
                    if(todoSuccess){
                        break;
                    }
                }
            }
            
        }else if (_carBeautyType==CarBeautyType_oil){
            TDOilOrder *oilOrder=[[TDOilOrder alloc] init];
            [oilOrder setType:TYPE_PAY_TOSHOP];
            [oilOrder setState:STATE_ORDER_UNFINISHED];
            [oilOrder setCouponId:couponId];
            [oilOrder setCarId:carId];
            [oilOrder setShopId:shopId];
            [oilOrder setPrice:totalPrice];
            [oilOrder setOrderTime:[TimeUtils createTimeHHMM:hhmm incre:incre]];
            int oilOrderId=[[ElApiService shareElApiService] createOilOrder:oilOrder];
            
            if(oilOrderId>0){
                for (TDBaseItem *item in _items) {
                    todoSuccess=[[ElApiService shareElApiService] createOilOrderNumber:oilOrderId oilId:item.oilId];
                    if(!todoSuccess){
                        break;
                    }
                }
            }
        }else if(_carBeautyType==CarBeautyType_paint){
            
            TDMetaOrder *metaOrder=[[TDMetaOrder alloc] init];
            [metaOrder setType:TYPE_PAY_TOSHOP];
            [metaOrder setState:STATE_ORDER_UNFINISHED];
            [metaOrder setCouponId:couponId];
            [metaOrder setCarId:carId];
            [metaOrder setShopId:shopId];
            [metaOrder setPrice:totalPrice];
            [metaOrder setOrderTime:[TimeUtils createTimeHHMM:hhmm incre:incre]];
            int metaOrderId=[[ElApiService shareElApiService] createMetaOrder:metaOrder];
            
            if(metaOrderId>0){
                for (TDBaseItem *item in _items) {
                    todoSuccess=[[ElApiService shareElApiService] createMetaOrderNumber:metaOrderId metaId:item.metalplateId ordernum:item.count];
                    if(!todoSuccess){
                        break;
                    }
                }
            }
        }
      
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(hud!=nil){
                [hud hide:YES];
            }
            if(todoSuccess){
                NSLog(@"success");
            }else{
                  NSLog(@"fail");
            }
            UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            OrderSuccessViewController *orderSucVC=[storyBoard instantiateViewControllerWithIdentifier:@"orderSucVC"];
            [orderSucVC setCarBeautyType:_carBeautyType];
            [orderSucVC setResultOK:todoSuccess];
            [orderSucVC setItems:_items];
            
            
            [self.navigationController pushViewController:orderSucVC animated:YES];

        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return [self.items count];
    }else if(section==1){
        return 1;
    }else{
        return 2;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    // Default is 1 if not implemented
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   if(indexPath.section==1){
        if(indexPath.row==0){
            return ROW_HEIGHT_SECTION10;
        }else{
            return ROW_HEIGHT_SECTION11;
        }
   }else{
       return ROW_HEIGHT;
   }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0){
        TDBeautyTableViewCell2 *tableCell=[tableView dequeueReusableCellWithIdentifier:@"beautyCell2"];
        if(tableCell==nil){
            tableCell= [[[NSBundle mainBundle] loadNibNamed:@"TDBeautyTableViewCell2" owner:self options:nil] lastObject];
            
            NSLog(@"new ....");
        }else{
            NSLog(@"exists...");
        }
        TDBaseItem *baseItem=[_items objectAtIndex:indexPath.row];
        
        if(_carBeautyType==CarBeautyType_paint){
            [tableCell.itemLabel setText:[NSString stringWithFormat:@"%@   %.f元",baseItem.name,baseItem.price]];
            
        }else{
            [tableCell.itemLabel setText:[NSString stringWithFormat:@"%@   %.f元",baseItem.name,baseItem.price]];
        }
        
        
       
        
        
        [tableCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [tableCell.delBtn setTag:indexPath.row];
        [tableCell.delBtn addTarget:self action:@selector(delItem:) forControlEvents:UIControlEventTouchUpInside];
        return tableCell;
    }
    
    if(indexPath.section==1){
        if(indexPath.row==0){
            TDTableViewCell0 *tableCell=[tableView dequeueReusableCellWithIdentifier:@"tdcell0"];
            if(tableCell==nil){
                tableCell= [[[NSBundle mainBundle] loadNibNamed:@"TDTableViewCell0" owner:self options:nil] lastObject];
                
                NSLog(@"new ....");
            }else{
                NSLog(@"exists...");
            }
            
            [tableCell.label0 setText:@"上门取送"];
            [tableCell.label1 setText:@"工作日5-7时、20-24时免费上门去送费，取车到送车期间出现的一切事故、违章等权益风险由本店和保险公司负责　"];
            [tableCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [tableCell.swView setTag:indexPath.row];
            [tableCell.swView addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventTouchUpInside];
            
            return tableCell;
        }else{
            TDTableViewCell1 *tableCell=[tableView dequeueReusableCellWithIdentifier:@"tdcell1"];
            if(tableCell==nil){
                tableCell= [[[NSBundle mainBundle] loadNibNamed:@"TDTableViewCell1" owner:self options:nil] lastObject];
            }
            
            
           
            [tableCell.contentLabel setText:@"请选择门店"];
            [tableCell.offerTypeLabel setText:@""];
            return tableCell;
        }
       
        
    }
    if(indexPath.section==2){
        TDTableViewCell1 *tableCell=[tableView dequeueReusableCellWithIdentifier:@"tdcell1"];
        if(tableCell==nil){
            tableCell= [[[NSBundle mainBundle] loadNibNamed:@"TDTableViewCell1" owner:self options:nil] lastObject];
        }
        
        if(indexPath.row==0){
            [tableCell.contentLabel setText:@"支付方式"];
            [tableCell.offerTypeLabel setText:_payTypes[payIndex]];
        }else{
            [tableCell.contentLabel setText:@"使用优惠券"];
            NSString *str;
            if(couponIndex<0){
                str=@"";
            }else{
                TDCouponInfo *couponInfo=[_couponInfos objectAtIndex:couponIndex];
                if(couponInfo.type==COUPON_TYPE_DISCOUNT){
                    str=[NSString stringWithFormat:@"%.1f折优惠",couponInfo.discount];
                }else{
                    str=[NSString stringWithFormat:@"抵扣%.1f",couponInfo.price];
                }
                
            }
            
            [self updateLabelView];
            
            [tableCell.offerTypeLabel setText:str];
        }
       
        
        return tableCell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==2){
        if(indexPath.row==0){
            [self selectPayForType];
        }else{
            [self selectCouponItem];
        }
    }
}
-(void)switchView:(UISwitch *)sender{
    
}
-(void)delItem:(UIButton *)sender{
    [_items removeObjectAtIndex:sender.tag];
     [self updateLabelView];
    [_beautyItemTableView reloadData];
}
-(void)selectCouponItem{
    
    if(_couponInfos==nil||[_couponInfos count]<=0){
        [self.view makeToast:@"没有可用的优惠券"];
        return;
    }
    
    MMPopupCompletionBlock completeBlock=^(MMPopupView *view, BOOL complete) {
        NSLog(@"view %@,complete %d",view,complete);
    };
    MMPopupItemHandler block=^(NSInteger index) {
        couponIndex=index;
        [_beautyItemTableView reloadData];
    };
    NSMutableArray *items=[NSMutableArray new];
    for (int i=0;i<[_couponInfos count];i++) {
        TDCouponInfo *info=_couponInfos[i];
        NSString *desc=@"";
        if(info.type==COUPON_TYPE_DISCOUNT){
            desc=[NSString stringWithFormat:@"%.1f折优惠",info.discount];
        }else{
            desc=[NSString stringWithFormat:@"抵扣%.1f",info.price];
        }
        if(i==couponIndex){
            [items addObject:MMItemMake(desc, MMItemTypeHighlight,block)];
        }else{
            [items addObject:MMItemMake(desc, MMItemTypeNormal,block)];
        }
        
    }
    MMSheetView *sheetView=[[MMSheetView alloc] initWithTitle:@"选择优惠券" items:items];
    [sheetView showWithBlock:completeBlock];
}


-(void)selectPayForType{
    
    MMPopupCompletionBlock completeBlock=^(MMPopupView *view, BOOL complete) {
        NSLog(@"view %@,complete %d",view,complete);
    };
    MMPopupItemHandler block=^(NSInteger index) {
        payIndex=index;
        [_beautyItemTableView reloadData];
    };
    NSMutableArray *items=[NSMutableArray new];
    for (int i=0;i<[_payTypes count];i++) {
        if(i==payIndex){
            [items addObject:MMItemMake(_payTypes[i], MMItemTypeHighlight,block)];
        }else{
            [items addObject:MMItemMake(_payTypes[i], MMItemTypeNormal,block)];
        }
        
    }
    MMSheetView *sheetView=[[MMSheetView alloc] initWithTitle:@"支付类型" items:items];
    [sheetView showWithBlock:completeBlock];
}

@end
