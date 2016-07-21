//
//  GoodsCartViewController.m
//  fillPaintMaster
//
//  Created by admin on 16/4/27.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "GoodsCartViewController.h"
#import "CartManager.h"
#import "GoodsTableCell.h"
#import <UIView+Toast.h>
#import <UIImageView+AFNetworking.h>
#import "ElApiService.h"
#import "OrderSuccessViewController.h"
#import "UserAddressManager.h"
#import "MyAddressViewController.h"
#import "Constants.h"
#import "AlibabaPay.h"
#import "DecimalCaculateUtils.h"
@interface GoodsCartViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *mycartClassList;
       
    NSString *totalPrice;
   
    int shopId;
    
    NSString *name;
    NSString *phone;
    NSString *address;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *checkAllButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitOrderBtn;
@property (weak, nonatomic) IBOutlet UILabel *receivingInfoLabel;

@end

@implementation GoodsCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"我的购物车";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"我的地址" style:UIBarButtonItemStylePlain target:self action:@selector(toAddress:)];
    
    
    shopId=[[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SHOP_ID] intValue];

    
    self.tableView.rowHeight=128;
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    mycartClassList=[[[CartManager defaultManager] getMyCartClassList] mutableCopy];
    [_checkAllButton addTarget:self action:@selector(selectedAllGoods:) forControlEvents:UIControlEventTouchUpInside];
    [self updateViewShow];
    
    
    
    self.commitOrderBtn.layer.cornerRadius=4;
    [self.commitOrderBtn addTarget:self action:@selector(beginCommitOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toAddress2:)];
   
    
    [_receivingInfoLabel addGestureRecognizer:tapGR];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResultCallback) name:notification_alipay_refresh object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated{
    name=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_NAME];
    phone=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_PHONE];
    address=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADDRESS];
    
    if(name!=nil&&phone!=nil&&address!=nil){
        _receivingInfoLabel.text=[NSString stringWithFormat:@"地址:%@\n收货人姓名:%@ 联系电话:%@",address,name,phone];
    }
    
}

-(void)toAddress:(id)sender{
    MyAddressViewController *myAddressVC=[[MyAddressViewController alloc] init];
    [self.navigationController pushViewController:myAddressVC animated:YES];
    
}
-(void)toAddress2:(UIGestureRecognizer *)gr{
    MyAddressViewController *myAddressVC=[[MyAddressViewController alloc] init];
    [self.navigationController pushViewController:myAddressVC animated:YES];
    
}

-(void)beginCommitOrder:(id)sender
{
    
    if([name isEqualToString:@""]){
        [self.view makeToast:@"收货人姓名不能为空"];
    }else if([phone isEqualToString:@""]){
         [self.view makeToast:@"手机号码不能为空"];
    }else if([address isEqualToString:@""]){
        [self.view makeToast:@"地址不能为空"];
    }else{
        
        [[NSUserDefaults standardUserDefaults] setObject:name forKey:KEY_NAME];
        [[NSUserDefaults standardUserDefaults] setObject:phone forKey:KEY_PHONE];
        [[NSUserDefaults standardUserDefaults] setObject:address forKey:KEY_ADDRESS];
        
        
        NSArray *commitDatas=[self getCommitDatas];
        
        if([commitDatas count]<=0||commitDatas==nil){
            [self.view makeToast:@"请选择您的商品"];
        }else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                BOOL successYN=NO;
                int size=[commitDatas count];
                NSString *out_trade_no=@"";
                NSMutableString *descontent=[NSMutableString new];
                int index=0;
                for(CommitDataBean *bean in commitDatas)
                {
                    if(size==1){
                        NSArray *retObj=[[ElApiService shareElApiService] createGoodsOrder:bean.data shopId:bean.shopId price:bean.totalPrice.floatValue address:address name:name phone:phone desContent:@"0" realShopId:shopId];
                        
                        if(retObj!=nil&&[retObj count]==2){
                            out_trade_no=retObj[1];
                        }
                    }else{
                        if(index<size-1){
                            NSArray *retObj=[[ElApiService shareElApiService] createGoodsOrder:bean.data shopId:bean.shopId price:bean.totalPrice.floatValue address:address name:name phone:phone desContent:@"" realShopId:shopId];
                            if(retObj!=nil&&[retObj count]==2){
                                if(index==size-2){
                                    [descontent appendString:retObj[0]];
                                }else{
                                    [descontent appendFormat:@"%@,",retObj[0]];
                                }
                            }

                         }else{
                              NSArray *retObj=[[ElApiService shareElApiService] createGoodsOrder:bean.data shopId:bean.shopId price:bean.totalPrice.floatValue address:address name:name phone:phone desContent:descontent realShopId:shopId];
                              if(retObj!=nil&&[retObj count]==2){
                                 out_trade_no=retObj[1];
                               }
                         }
                    }
                    index++;
                }
                
                Product *product=[[Product alloc] init];
                product.subject=@"客乐养车坊";
                product.body=@"商品订单";
                product.price=totalPrice.floatValue;
                product.orderId=out_trade_no;
                
                
                AlipayInfoType *alipayInfo=[[ElApiService shareElApiService] getAlipayByShopId:-1];
               
                AlibabaPay *alibabPay=[[AlibabaPay alloc] initPartner:alipayInfo.aliPid seller:alipayInfo.sellerEmail];
                
                NSString *content=[alibabPay getTradInfo:product];
                
                NSString *sign=[[ElApiService shareElApiService] signContent:-1 content:content];
                product.sign=sign;
               
                [alibabPay aliPay:product callback:^(NSDictionary *resultDic) {
                   
                    NSLog(@"resultDic %@",resultDic);
                    id  resultStatus=[resultDic objectForKey:@"resultStatus"];
                    if([resultStatus intValue]==9000){
                        [self.view.window makeToast:@"支付成功"];
                        
                    }else{
                        [self.view.window makeToast:@"支付失败"];
                        
                    }
                    [self payResultCallback];
                    
                }];
                
                
                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if(successYN){
//                        NSLog(@"success");
//                        [self clearCartData];
//                    }else{
//                        NSLog(@"fail");
//                    }
//                    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//                    OrderSuccessViewController *orderSucVC=[storyBoard instantiateViewControllerWithIdentifier:@"orderSucVC"];
//                    [orderSucVC setCarBeautyType:CarBeautyType_none];
//                    [orderSucVC setResultOK:successYN];
//                    
//                    
//                    [self.navigationController pushViewController:orderSucVC animated:YES];
//                });
                
                
            });
        }
        
        
        
    }
    
}
-(void)payResultCallback{
    [self clearCartData];
    /** 支付成功逻辑处理 **/
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(NSArray<CommitDataBean *> *)getCommitDatas{
    CommitDataBean *bean0=[[CommitDataBean alloc] init];
    CommitDataBean *bean1=[[CommitDataBean alloc] init];
    NSMutableString *data0=[NSMutableString new];
    NSMutableString *data1=[NSMutableString new];
    NSString *totalPrice0=@"0.0";
    NSString *totalPrice1=@"0.0";
    for (MyCartClass *mycartClass in mycartClassList) {
        if(mycartClass.checkYN){
            if(mycartClass.goodInfo.shopId==-1){
                [data0 appendString:[NSString stringWithFormat:@"%d+%d,",mycartClass.goodsId,mycartClass.count]];
                bean0.shopId=-1;
                
                NSString *temp=[DecimalCaculateUtils mutiplyWithA:[NSString stringWithFormat:@"%d",mycartClass.count] andB:[NSString stringWithFormat:@"%f",mycartClass.goodInfo.price]];
                
                totalPrice0=[DecimalCaculateUtils addWithA:totalPrice0 andB:temp];
                
                NSLog(@"totalPrice0 %@ temp %@",totalPrice0,temp);
                
                
            }else{
                [data1 appendString:[NSString stringWithFormat:@"%d+%d,",mycartClass.goodsId,mycartClass.count]];
                bean1.shopId=mycartClass.goodInfo.shopId;
                
                NSString *temp=[DecimalCaculateUtils mutiplyWithA:[NSString stringWithFormat:@"%d",mycartClass.count] andB:[NSString stringWithFormat:@"%f",mycartClass.goodInfo.price]];
                
                totalPrice1=[DecimalCaculateUtils addWithA:totalPrice1 andB:temp];
                
                NSLog(@"totalPrice1 %@ temp %@",totalPrice0,temp);

                
            }
        
        }
    }
    
    if(![data0 isEqualToString:@""]){
       data0=[data0 substringWithRange:NSMakeRange(0, data0.length-1)];
    }
    if(![data1 isEqualToString:@""]){
       data1=[data1 substringWithRange:NSMakeRange(0, data1.length-1)];
    }
    
    NSMutableArray *commitArrs=[NSMutableArray new];
    
    if(totalPrice0>0){
        [bean0 setTotalPrice:totalPrice0];
        [bean0 setData:data0];
        [commitArrs addObject:bean0];
    }
    
    if(totalPrice1>0){
        [bean1 setTotalPrice:totalPrice1];
        [bean1 setData:data1];
        [commitArrs addObject:bean1];
    }
    
    return commitArrs;
}


-(void)selectedAllGoods:(UIButton *)sender{
    [sender setSelected:!sender.selected];
    
    for (MyCartClass *cartClass in mycartClassList) {
        [cartClass setCheckYN:sender.selected];
    }
    
    [self.tableView reloadData];
    [self updateViewShow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification_alipay_refresh object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(mycartClassList!=nil){
        return [mycartClassList count];
    }
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodsTableCell *cell=[tableView dequeueReusableCellWithIdentifier:@"GoodsTableCell"];
    if(cell==nil){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"GoodsTableCell" owner:self options:nil] lastObject];
    }
    MyCartClass *mycartClass=[mycartClassList objectAtIndex:indexPath.row];
    [cell.goodImageView setImageWithURL:[NSURL URLWithString:mycartClass.imageUrl]];
    cell.nameLabel.text=mycartClass.goodInfo.name;
    cell.descLabel.text=mycartClass.goodInfo.desc;
    cell.countLabel.text=[NSString stringWithFormat:@"x%d",mycartClass.count];
    
    cell.priceLabel.text=[DecimalCaculateUtils showDecimalFloat:mycartClass.goodInfo.price];
    
    cell.checkBtn.tag=indexPath.row;
    
    [cell.checkBtn setSelected:mycartClass.checkYN];
    [cell setSelectedBackgroundView:[[UIView alloc] initWithFrame:CGRectZero]];
    [cell.checkBtn addTarget:self action:@selector(checkOne:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"commitEditingStyle....");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [mycartClassList removeObjectAtIndex:indexPath.row];
        
        [[CartManager defaultManager] saveMyCartClassToDisk:mycartClassList];
        
         [self updateViewShow];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

-(void)clearCartData{
   
    for(int i=0;i<[mycartClassList count];i++){
        if([mycartClassList[i] checkYN]){
            [mycartClassList removeObjectAtIndex:i];
            i--;
        }
     }
    NSLog(@"leave now list data:::%@",mycartClassList);
    
    [[CartManager defaultManager] saveMyCartClassToDisk:mycartClassList];
    

}




-(void)checkOne:(UIButton *)sender{
   [sender setSelected:!sender.selected];
    
   [[mycartClassList objectAtIndex:sender.tag] setCheckYN:sender.selected];
   [self updateViewShow];
}

-(void)updateViewShow{
    totalPrice=@"0.0";
    for (MyCartClass * cartClass in mycartClassList) {
        if(cartClass.checkYN){
            NSString *temp=[DecimalCaculateUtils mutiplyWithA:[NSString stringWithFormat:@"%d",cartClass.count] andB:[NSString stringWithFormat:@"%f",cartClass.goodInfo.price]];
            
            totalPrice=[DecimalCaculateUtils addWithA:totalPrice andB:temp];
        }
    }
    self.priceLabel.text=[DecimalCaculateUtils showDecimalString:totalPrice];
}


@end

@implementation CommitDataBean


@end