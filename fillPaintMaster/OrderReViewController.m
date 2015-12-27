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
const float ROW_HEIGHT=50;
const float ROW_HEIGHT_SECTION10=100;
const float ROW_HEIGHT_SECTION11=60;
@interface OrderReViewController (){
    NSArray *test;
}
@property (weak, nonatomic) IBOutlet UITableView *beautyItemTableView;
@property(retain,nonatomic) NSArray *items;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *favourableLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitOrderBtn;

@end

@implementation OrderReViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTitleView];
    [self initBeautyItemTableView];
    [self initButton];
    
}
-(void)initButton{
    [self.commitOrderBtn.layer setCornerRadius:5];
    [self.commitOrderBtn setBackgroundColor:[UIColor orangeColor]];
    
}
-(void)initBeautyItemTableView{
    self.items=@[@">离子覆膜精细洗车         ¥40元",
                 @">漆面深度清洁打蜡         ¥198元",
                 @">内室普通清洗消毒         ¥380元",
                 @">内室环保清洗护理         ¥598元"];
    
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 25)];
    [label setText:@"汽车美容"];
    [label setFont:[UIFont systemFontOfSize:20]];
    
    [self.beautyItemTableView setTableHeaderView:label];
    [self.beautyItemTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.beautyItemTableView.delegate=self;
    self.beautyItemTableView.dataSource=self;
    
    
    
}

-(void)initTitleView{
    
    UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,0, 70, 44)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 0)];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *changeBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,0, 70, 44)];
    [changeBtn setImage:[UIImage imageNamed:@"change"] forState:UIControlStateNormal];
    [changeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -40)];
    [changeBtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView  *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 24)];
    UILabel *cphLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 24, 150, 20)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:20]];
    [titleLabel setText:@"洗车美容"];
    
    [cphLabel setTextAlignment:NSTextAlignmentCenter];
    [cphLabel setFont:[UIFont systemFontOfSize:10]];
    [cphLabel setText:@"皖A PS826"];
    
    [titleView addSubview:titleLabel];
    [titleView addSubview:cphLabel];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.titleView=titleView;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:changeBtn];
}
-(void)change:(id)sender{
    
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)oneKeyOrder:(id)sender {
    //立即下单
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *orderSucVC=[storyBoard instantiateViewControllerWithIdentifier:@"orderSucVC"];
    [self.navigationController pushViewController:orderSucVC animated:YES];
    
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
        
        [tableCell.itemLabel setText:[_items objectAtIndex:indexPath.row]];
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
    
}
@end
