//
//  CarBeautyViewController.m
//  fillPaintMaster
//
//  Created by apple on 15/9/29.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import "CarBeautyViewController.h"
#import "TimeUtils.h"
#import "TDBeautyTableViewCell.h"
#import "OrderReViewController.h"
#import "TDHttpDataService.h"
#import "TDBaseItem.h"
#import "TDBaseTime.h"
#import "YYButtonUtils.h"
#import "TDLocationViewController.h"
@interface CarBeautyViewController (){
    NSUInteger totalMoney;
    NSUInteger totalCount;
    
    NSString *titleName;
    
    TDHttpDataService *httpServer;
}
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UITableView *beautyItemTableView;

@property(retain,nonatomic) NSArray *items;
@property (weak, nonatomic) IBOutlet UIButton *cartBtn;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;

@end

@implementation CarBeautyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    httpServer=[[TDHttpDataService alloc] init];
    if(_carBeautyType==CarBeautyType_beauty){
        titleName=@"洗车美容";
        
        self.items=[httpServer fetchAllBeautyItems];
    }else{
        titleName=@"换油保养";
        
        self.items=[httpServer fetchAllOilMaintainItems];
    }
    
    [self initTitleView];
   
    [self initBeautyItemTableView];
    
    [self initOrderBtn];
}

-(void)viewDidAppear:(BOOL)animated{
     [self initTimeView];
}
-(void)viewWillAppear:(BOOL)animated{
    
}
-(void)initOrderBtn{
    [self.orderBtn setEnabled:NO];
    [self.orderBtn setBackgroundColor:[UIColor grayColor]];
    [self.orderBtn.layer setCornerRadius:5.0];
    
    [self.orderBtn addTarget:self action:@selector(orderDetail:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)orderDetail:(id)sender{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    OrderReViewController *orderVC=[storyBoard instantiateViewControllerWithIdentifier:@"orderVC"];
    [orderVC setCarBeautyType:_carBeautyType];
    [orderVC setItems:[self selectedItems]];
    
    [self.navigationController pushViewController:orderVC animated:YES];
    
}
-(NSMutableArray *)selectedItems{
    NSMutableArray *selectedArrs=[[NSMutableArray alloc] init];
    
    for (TDBaseItem *item in _items) {
        if(item.isAddYN){
           [selectedArrs addObject:item];
        }
    }
    return selectedArrs;
}

-(void)initBeautyItemTableView{
   
    
    
    [self.beautyItemTableView setRowHeight:50];
    [self.beautyItemTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.beautyItemTableView.delegate=self;
    self.beautyItemTableView.dataSource=self;
}

-(void)initTimeView{
    /*
         4行 6列
     
     */
    NSArray *orderTimes=[httpServer fetchAllOrderTimes];
    
    float totalH=self.timeView.frame.size.height;
    float totalW=self.timeView.frame.size.width;
    float top=5;
    float left=20;
    
    float BTN_WIDTH=45;
    float BTN_HEIGHT=28;
   
    float hspace=(totalW-left-6*BTN_WIDTH)/6;
    float vspace=(totalH-4*BTN_HEIGHT-top*2)/3;
    
    
    for(int j=0;j<24;j++){
        int row=j/6;
        int col=j%6;
        TDBaseTime *baseTime=[orderTimes objectAtIndex:j];
        
        UIButton *timeBtn=[[UIButton alloc] initWithFrame:CGRectMake(left+col*(BTN_WIDTH+hspace),top+row*(BTN_HEIGHT+vspace),BTN_WIDTH, BTN_HEIGHT)];
        [timeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [timeBtn.layer setBorderWidth:1];
        [timeBtn.layer setBorderColor:[[UIColor colorWithWhite:0.8 alpha:1] CGColor]];
        
        
        [timeBtn setBackgroundImage:[UIImage imageNamed:@"yes"] forState:UIControlStateSelected];
        
        [timeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [timeBtn setTag:j];
        [timeBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
        [timeBtn setTitle:baseTime.timeValue forState:UIControlStateNormal];
        if(!baseTime.enableYN){
            [timeBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        }else{
            [timeBtn setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
        }
        [timeBtn setEnabled:baseTime.enableYN];
        
        [self.timeView addSubview:timeBtn];
        
    }
    
}
-(void)selectTime:(UIButton *)sender{
    NSLog(@"tag %d",sender.tag);
    if(sender.selected){
        [sender setSelected:NO];
        //[sender setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
        

    }else{
        [sender setSelected:YES];
        //[sender setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
      
    }
}

-(void)initTitleView{

    UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,0, 70, 44)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 0)];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *changeBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,0, 70, 44)];
     [changeBtn setTitle:@"合肥" forState:UIControlStateNormal];
    [changeBtn setImage:[UIImage imageNamed:@"city_icon_location"] forState:UIControlStateNormal];
   
    [changeBtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    
    [YYButtonUtils RimageLeftTextRight:changeBtn];
    
    UIView  *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 24)];
    UILabel *cphLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 24, 150, 20)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:20]];
    
    [titleLabel setText:titleName];
    
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
    TDLocationViewController *locationVC=[[TDLocationViewController alloc] init];
    [self presentViewController:locationVC animated:YES completion:^{
        
    }];
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"beautyCell";
    TDBeautyTableViewCell *tableCell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(tableCell==nil){
       tableCell= [[[NSBundle mainBundle] loadNibNamed:@"TDBeautyTableViewCell" owner:self options:nil] lastObject];
       
        NSLog(@"new ....");
    }else{
        NSLog(@"exists...");
    }
    
    TDBaseItem *item=[_items objectAtIndex:indexPath.row];
    
    [tableCell.contentLabel setText:[NSString stringWithFormat:@"%@   %.f元",item.itemName,item.itemPrice] ];
    [tableCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [tableCell.addOrRemoveBtn setSelected:item.isAddYN];
    [tableCell.addOrRemoveBtn setTag:indexPath.row];
    [tableCell.addOrRemoveBtn addTarget:self action:@selector(addOrRemoveCart:) forControlEvents:UIControlEventTouchUpInside];
    return tableCell;
}
-(void)addOrRemoveCart:(UIButton *)sender{
    TDBaseItem *item=[_items objectAtIndex:sender.tag];
    if(item.isAddYN){
        [item setIsAddYN:NO];
    }else{
        [item setIsAddYN:YES];
    }
    [sender setSelected:item.isAddYN];
    
    int val=item.itemPrice;
    
    if(sender.selected){
       
        totalMoney+=val;
        totalCount++;
        
    }else{
        totalMoney-=val;
        totalCount--;
    }

    if(totalMoney>0){
        [self.orderBtn setEnabled:YES];
        [self.orderBtn setBackgroundColor:[UIColor blueColor]];
        [self.moneyLabel setTextColor:[UIColor blueColor]];
        [self.moneyLabel setText:[NSString stringWithFormat:@"¥ %d元",totalMoney]];
        [self.cartBtn setBackgroundImage:[UIImage imageNamed:@"cartcircle"] forState:UIControlStateNormal];
        [self.cartBtn setTitle:[NSString stringWithFormat:@"%d",totalCount] forState:UIControlStateNormal];
    }else{
        [self.orderBtn setEnabled:NO];
         [self.orderBtn setBackgroundColor:[UIColor grayColor]];
        [self.moneyLabel setTextColor:[UIColor grayColor]];
        [self.moneyLabel setText:@"0元"];
        [self.cartBtn setBackgroundImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
        [self.cartBtn setTitle:@"" forState:UIControlStateNormal];
        
    }
   
    
    NSLog(@"addOrRemoveCart index %d",sender.tag);
    
}

@end
