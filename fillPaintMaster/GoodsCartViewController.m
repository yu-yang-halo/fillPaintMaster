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
#import "ElApiService.h"
#import "OrderSuccessViewController.h"
static const NSString *KEY_NAME=@"key_name";
static const NSString *KEY_PHONE=@"key_phone";
static const NSString *KEY_ADDRESS=@"key_address";

@interface GoodsCartViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSArray *mycartClassList;
    UITextField *firstResponderTF;
    
    
    float totalPrice;
    CGFloat kbHeight;
    double  duration;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UIButton *checkAllButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitOrderBtn;

@end

@implementation GoodsCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"我的购物车";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    

    
    self.tableView.rowHeight=128;
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    mycartClassList=[[CartManager defaultManager] myCartClassList];
    [_checkAllButton addTarget:self action:@selector(selectedAllGoods:) forControlEvents:UIControlEventTouchUpInside];
    [self updateViewShow];
    
    
    self.nameTF.delegate=self;
    self.phoneTF.delegate=self;
    self.addressTF.delegate=self;
    
    NSString *name=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_NAME];
    NSString *phone=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_PHONE];
    NSString *address=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADDRESS];
    
    self.nameTF.text=(name==nil?@"":name);
    self.phoneTF.text=(phone==nil?@"":phone);
    self.addressTF.text=(address==nil?@"":address);
    
    
    self.commitOrderBtn.layer.cornerRadius=4;
    [self.commitOrderBtn addTarget:self action:@selector(beginCommitOrder:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)beginCommitOrder:(id)sender
{
    
    NSString *name=_nameTF.text;
    NSString *phone=_phoneTF.text;
    NSString *address=_addressTF.text;
    
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
                for(CommitDataBean *bean in commitDatas)
                {
                    successYN=[[ElApiService shareElApiService] createGoodsOrder:bean.data shopId:bean.shopId price:bean.totalPrice address:address name:name phone:phone];
                    if(!successYN){
                        continue;
                    }
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(successYN){
                        NSLog(@"success");
                    }else{
                        NSLog(@"fail");
                    }
                    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                    OrderSuccessViewController *orderSucVC=[storyBoard instantiateViewControllerWithIdentifier:@"orderSucVC"];
                    [orderSucVC setCarBeautyType:CarBeautyType_none];
                    [orderSucVC setResultOK:successYN];
                    
                    
                    [self.navigationController pushViewController:orderSucVC animated:YES];
                });
                
                
            });
        }
        
        
        
    }
    
}


-(NSArray<CommitDataBean *> *)getCommitDatas{
    CommitDataBean *bean0=[[CommitDataBean alloc] init];
    CommitDataBean *bean1=[[CommitDataBean alloc] init];
    NSMutableString *data0=[NSMutableString new];
    NSMutableString *data1=[NSMutableString new];
    float totalPrice0=0.0;
    float totalPrice1=0.0;
    for (MyCartClass *mycartClass in mycartClassList) {
        if(mycartClass.checkYN){
            if(mycartClass.goodInfo.shopId==-1){
                [data0 appendString:[NSString stringWithFormat:@"%d+%d,",mycartClass.goodsId,mycartClass.count]];
                bean0.shopId=-1;
                totalPrice0+=mycartClass.count*mycartClass.goodInfo.price;
                
            }else{
                [data1 appendString:[NSString stringWithFormat:@"%d+%d,",mycartClass.goodsId,mycartClass.count]];
                bean1.shopId=mycartClass.goodInfo.shopId;
                totalPrice1+=mycartClass.count*mycartClass.goodInfo.price;
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
    // Dispose of any resources that can be recreated.
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
    cell.goodImageView.image=mycartClass.image;
    cell.nameLabel.text=mycartClass.goodInfo.name;
    cell.descLabel.text=mycartClass.goodInfo.desc;
    cell.countLabel.text=[NSString stringWithFormat:@"x%d",mycartClass.count];
    cell.priceLabel.text=[NSString stringWithFormat:@"%.1f元",mycartClass.goodInfo.price];
    
    cell.checkBtn.tag=indexPath.row;
    
    [cell.checkBtn setSelected:mycartClass.checkYN];
    [cell setSelectedBackgroundView:[[UIView alloc] initWithFrame:CGRectZero]];
    [cell.checkBtn addTarget:self action:@selector(checkOne:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
-(void)checkOne:(UIButton *)sender{
   [sender setSelected:!sender.selected];
    
   [[mycartClassList objectAtIndex:sender.tag] setCheckYN:sender.selected];
   [self updateViewShow];
}

-(void)updateViewShow{
    totalPrice=0.0;
    for (MyCartClass * cartClass in mycartClassList) {
        if(cartClass.checkYN){
            totalPrice+=(cartClass.count*cartClass.goodInfo.price);
        }
    }
    self.priceLabel.text=[NSString stringWithFormat:@"%.1f元",totalPrice];
}

#pragma mark UITextField delegate
-(void)autoLayoutSelfView{
    if(kbHeight<=0||firstResponderTF==nil){
        return;
    }
    CGFloat offset=0;
    offset=kbHeight-(self.view.frame.size.height-firstResponderTF.frame.origin.y-firstResponderTF.frame.size.height);
   
    
    
    
    offset=offset>0?offset+70:kbHeight-60;
    
    
    [UIView animateWithDuration:duration animations:^{
        CGRect frame=self.view.frame;
        frame.origin.y=-offset;
        
        self.view.frame=frame;
    }];
}

-(void)keyBoardWillShow:(NSNotification *)notification{
    kbHeight=[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    duration=[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self autoLayoutSelfView];
}

-(void)keyBoardWillHide:(NSNotification *)notification{
    
    double duration2=[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration2 animations:^{
        CGRect frame=self.view.frame;
        frame.origin.y=0;
        self.view.frame=frame;
    }];
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    firstResponderTF=textField;
    [self autoLayoutSelfView];
    return YES;
}


@end

@implementation CommitDataBean


@end