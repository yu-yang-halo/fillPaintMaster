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
const float ROW_HEIGHT=50;
const float ROW_HEIGHT_SECTION10=100;
const float ROW_HEIGHT_SECTION11=60;
@interface OrderReViewController (){
    NSArray *test;
    NSString *titleName;
    float totalPrice;
}
@property (weak, nonatomic) IBOutlet UITableView *beautyItemTableView;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *favourableLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitOrderBtn;

@end

@implementation OrderReViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(_carBeautyType==CarBeautyType_beauty){
        titleName=@"洗车美容";
    }else if(_carBeautyType==CarBeautyType_oil){
        titleName=@"换油保养";
    }else{
        titleName=@"钣金喷漆";
    }
    self.title=titleName;
    
    
    [self initBeautyItemTableView];
    [self initButton];
    [self updateLabelView];
    
}
-(void)initButton{
    [self.commitOrderBtn.layer setCornerRadius:4];
    [self.commitOrderBtn setBackgroundColor:BTN_BG_COLOR];
    
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
        
    }else{
        for (TDBaseItem *baseItem in _items) {
            totalPrice+=baseItem.price;
        }
    }
    
    [self.totalLabel setText:[NSString stringWithFormat:@"%.f元",totalPrice]];
    if(totalPrice<=0){
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
        [self commitMyOrder];
    }
    
}
-(void)commitMyOrder{
    
    int carId=[[[NSUserDefaults standardUserDefaults] objectForKey:KEY_CAR_ID] intValue];
    int shopId=[[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SHOP_ID] intValue];
    int incre=[[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SELECT_INCRE] intValue];
    NSString *hhmm=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SELECT_TIME];
    
    NSLog(@"incre %d; hhmm %@ ; %@",incre,hhmm,[TimeUtils createTimeHHMM:hhmm incre:incre]);
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL todoSuccess=NO;
        if(_carBeautyType==CarBeautyType_beauty){
            TDDecoOrder *decoOrder=[[TDDecoOrder alloc] init];
            [decoOrder setType:TYPE_PAY_TOSHOP];
            [decoOrder setState:STATE_ORDER_UNFINISHED];
      
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
        }
      
        
        dispatch_async(dispatch_get_main_queue(), ^{
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
        return 2;
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
        
        
       
        
        [tableCell.itemLabel setText:[NSString stringWithFormat:@"%@   %.f元",baseItem.name,baseItem.price]];
        
        
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
            [tableCell.offerTypeLabel setText:@"到店支付"];
        }else{
            [tableCell.contentLabel setText:@"使用i码"];
            [tableCell.offerTypeLabel setText:@""];
        }
       
        
        return tableCell;
    }
    return nil;
}
-(void)switchView:(UISwitch *)sender{
    
}
-(void)delItem:(UIButton *)sender{
    [_items removeObjectAtIndex:sender.tag];
     [self updateLabelView];
    [_beautyItemTableView reloadData];
}
@end
