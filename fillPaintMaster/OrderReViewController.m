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
#import "DecimalCaculateUtils.h"

#import "AlibabaPay.h"

const float ROW_HEIGHT=50;
const float ROW_HEIGHT_SECTION10=0;
const float ROW_HEIGHT_SECTION11=0;
@interface OrderReViewController (){
    NSArray *test;
    NSString *titleName;
    NSString *totalPrice;
    MBProgressHUD *hud;
    int payIndex;
    int couponIndex;
    int shopId;
    int orderType;
    AlipayInfoType *alipayInfoType;
    AlibabaPay     *alibabaPay;
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
    NSString *typeVal=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_TYPE];
    
   
    if([typeVal intValue]==5){
        self.payTypes=@[@"在线支付",@"到店支付"];
        payIndex=1;
    }else{
        self.payTypes=@[@"在线支付"];
        payIndex=0;
    }
    if(_carBeautyType==CarBeautyType_beauty){
        titleName=@"洗车美容";
        orderType=ORDER_TYPE_DECO;
    
    }else if(_carBeautyType==CarBeautyType_oil){
        titleName=@"换油保养";
        orderType=ORDER_TYPE_OIL;
    
    }else{
        titleName=@"钣金喷漆";
        orderType=ORDER_TYPE_METE;
        payIndex=1;
    }
    
    
   
   
    
    
    
    
    
    shopId=[[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SHOP_ID] intValue];
    
    couponIndex=-1;
    
    
    self.title=titleName;
    
    
    [self initBeautyItemTableView];
    [self initButton];
    [self updateLabelView];
    
    
    [self dataRequestTask];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResultCallback) name:notification_alipay_refresh object:nil];
    

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
        
        alipayInfoType=[[ElApiService shareElApiService] getAlipayByShopId:shopId];
        
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            alibabaPay=[[AlibabaPay alloc] initPartner:alipayInfoType.aliPid seller:alipayInfoType.sellerEmail];
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
    totalPrice=@"0.0";
    if(_carBeautyType==CarBeautyType_paint){
        for (TDBaseItem *baseItem in _items) {
            
            NSString *temp=[DecimalCaculateUtils mutiplyWithA:[NSString stringWithFormat:@"%f",baseItem.price] andB:[NSString stringWithFormat:@"%d",baseItem.count]];
            
            totalPrice=[DecimalCaculateUtils addWithA:totalPrice andB:temp];
            
            
        }
    }else{
        for (TDBaseItem *baseItem in _items) {
            totalPrice=[DecimalCaculateUtils addWithA:totalPrice andB:[NSString stringWithFormat:@"%f",baseItem.price]];
        }
    }
    NSString *couponPrice=@"0.0";
    
    if(couponIndex>=0){
        TDCouponInfo *couponInfo=[_couponInfos objectAtIndex:couponIndex];
        if(couponInfo.type==COUPON_TYPE_DISCOUNT){
            NSString *t1=[DecimalCaculateUtils divideWithA:[NSString stringWithFormat:@"%f",couponInfo.discount] andB:[NSString stringWithFormat:@"%f",10.0]];
            NSString *realTotalPrice=[DecimalCaculateUtils mutiplyWithA:totalPrice andB:t1];
            couponPrice=[DecimalCaculateUtils divideWithA:totalPrice andB:realTotalPrice];
            totalPrice=realTotalPrice;
            
        }else{
            totalPrice=[DecimalCaculateUtils divideWithA:totalPrice andB:[NSString stringWithFormat:@"%f",couponInfo.price]];
            
            couponPrice=[DecimalCaculateUtils decimalFloat:couponInfo.price];
            if([totalPrice floatValue]<0){
                totalPrice=@"0";
            }
        }
    }
    
    
    [self.totalLabel setText:[DecimalCaculateUtils showDecimalString:totalPrice]];
    
    [self.favourableLabel setText:[NSString stringWithFormat:@"已优惠%@元",couponPrice]];
    
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
        
        Product *product=[[Product alloc] init];
        BOOL successYN=NO;
        
        if(_carBeautyType==CarBeautyType_beauty){
            TDDecoOrder *decoOrder=[[TDDecoOrder alloc] init];
            [decoOrder setType:payIndex];
            [decoOrder setState:STATE_ORDER_UNFINISHED];
      
            [decoOrder setCouponId:couponId];
            [decoOrder setCarId:carId];
            [decoOrder setShopId:shopId];
            [decoOrder setPrice:[totalPrice floatValue]];
            [decoOrder setOrderTime:[TimeUtils createTimeHHMM:hhmm incre:incre]];
            NSArray *retObjArr=[[ElApiService shareElApiService] createDecoOrder:decoOrder];
            
            if(retObjArr!=nil&&[retObjArr count]==2){
                int decoOrderId=[retObjArr[0] intValue];
                NSMutableString *desc=[NSMutableString new];
                for (TDBaseItem *item in _items) {
                    [[ElApiService shareElApiService] createDecoOrderNumber:decoOrderId decoId:item.decorationId];
                    [desc appendFormat:@"%@\n",item.name];
                }
                product.subject=@"汽车美容";
                product.body=desc;
                product.orderId=retObjArr[1];
                product.price=totalPrice.floatValue;
                
                NSString *content=[alibabaPay getTradInfo:product];
                
                NSString *sign=[[ElApiService shareElApiService] signContent:shopId content:content];
                
                product.sign=sign;
                successYN=YES;
                
            }
            
        }else if (_carBeautyType==CarBeautyType_oil){
            TDOilOrder *oilOrder=[[TDOilOrder alloc] init];
            [oilOrder setType:payIndex];
            [oilOrder setState:STATE_ORDER_UNFINISHED];
            [oilOrder setCouponId:couponId];
            [oilOrder setCarId:carId];
            [oilOrder setShopId:shopId];
            [oilOrder setPrice:[totalPrice floatValue]];
            [oilOrder setOrderTime:[TimeUtils createTimeHHMM:hhmm incre:incre]];
             NSArray *retObjArr=[[ElApiService shareElApiService] createOilOrder:oilOrder];
            
            if(retObjArr!=nil&&[retObjArr count]==2){
                int oilOrderId=[retObjArr[0] intValue];
                NSMutableString *desc=[NSMutableString new];
                for (TDBaseItem *item in _items) {
                    [desc appendFormat:@"%@\n",item.name];
                    
                    [[ElApiService shareElApiService] createOilOrderNumber:oilOrderId oilId:item.oilId];
                }
                
                product.subject=@"换油保养";
                product.body=desc;
                product.orderId=retObjArr[1];
                product.price=totalPrice.floatValue;
                
                NSString *content=[alibabaPay getTradInfo:product];
                
                NSString *sign=[[ElApiService shareElApiService] signContent:shopId content:content];
                
                product.sign=sign;
                successYN=YES;
            }
        }else if(_carBeautyType==CarBeautyType_paint){
            
            TDMetaOrder *metaOrder=[[TDMetaOrder alloc] init];
            [metaOrder setType:payIndex];
            [metaOrder setState:STATE_ORDER_UNFINISHED];
            [metaOrder setCouponId:couponId];
            [metaOrder setCarId:carId];
            [metaOrder setShopId:shopId];
            [metaOrder setPrice:[totalPrice floatValue]];
            [metaOrder setOrderTime:[TimeUtils createTimeHHMM:hhmm incre:incre]];
             NSArray *retObjArr=[[ElApiService shareElApiService] createMetaOrder:metaOrder];
            
            if(retObjArr!=nil&&[retObjArr count]==2){
                int metaOrderId=[retObjArr[0] intValue];
                for (TDBaseItem *item in _items) {
                   successYN=[[ElApiService shareElApiService] createMetaOrderNumber:metaOrderId metaId:item.metalplateId ordernum:item.count];
                   if(!successYN){
                       break;
                   }
                    
                }
            }
        }
        
        
        
        
      
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(hud!=nil){
                [hud hide:YES];
            }
            
            if(successYN){
                
                if(payIndex==0){
                    [alibabaPay aliPay:product callback:^(NSDictionary *resultDic) {
                        NSLog(@"resultDic %@",resultDic);
                        id  resultStatus=[resultDic objectForKey:@"resultStatus"];
                        if([resultStatus intValue]==9000){
                            [self.view.window makeToast:@"支付成功"];
                            
                        }else{
                            [self.view.window makeToast:@"支付失败"];
                            
                        }
                        [self payResultCallback];
                        
                    }];
                }else{
                    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                    OrderSuccessViewController *orderSucVC=[storyBoard instantiateViewControllerWithIdentifier:@"orderSucVC"];
                    [orderSucVC setCarBeautyType:_carBeautyType];
                    [orderSucVC setResultOK:successYN];
                    [orderSucVC setItems:_items];
                    
                    
                    [self.navigationController pushViewController:orderSucVC animated:YES];
                }
                
            }else{
                [self.view.window makeToast:@"创建订单失败，请重试"];
            }
        });
    });
}
-(void)payResultCallback{
    /** 支付成功逻辑处理 **/
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification_alipay_refresh object:nil];
}

#pragma mark delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return [self.items count];
    }else if(section==1){
        return 0;
    }else{
        return 2;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    // Default is 1 if not implemented
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
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
            [tableCell.itemLabel setText:[NSString stringWithFormat:@"%@   %@元",baseItem.name,[DecimalCaculateUtils decimalFloat:baseItem.price]]];
            
        }else{
            [tableCell.itemLabel setText:[NSString stringWithFormat:@"%@   %@元",baseItem.name,[DecimalCaculateUtils decimalFloat:baseItem.price]]];
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
                    str=[NSString stringWithFormat:@"%@折优惠",[DecimalCaculateUtils decimalFloat:couponInfo.discount]];
                }else{
                    str=[NSString stringWithFormat:@"抵扣%@",[DecimalCaculateUtils decimalFloat:couponInfo.price]];
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
    if(_carBeautyType!=CarBeautyType_paint){
        if(indexPath.section==2){
            if(indexPath.row==0){
                [self selectPayForType];
            }else{
                [self selectCouponItem];
            }
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
            desc=[NSString stringWithFormat:@"%@折优惠",[DecimalCaculateUtils decimalFloat:info.discount]];
        }else{
            desc=[NSString stringWithFormat:@"抵扣%@",[DecimalCaculateUtils decimalFloat:info.price]];
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
