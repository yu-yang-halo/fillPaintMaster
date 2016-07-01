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
#import "YYButtonUtils.h"
#import "TDLocationViewController.h"
#import "ElApiService.h"
#import "Constants.h"
#import "MyCollectionViewCell.h"
#import <UIView+Toast.h>
#import "WashOilDetailViewController.h"
@interface CarBeautyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    NSUInteger totalMoney;
    NSUInteger totalCount;
    
    NSString *titleName;
    int shopId;
    
    NSArray *dayOrderStates;
    NSArray *carItems;
    int incre;
}
@property (weak, nonatomic) IBOutlet UICollectionView *timeCollectionView;

@property (weak, nonatomic) IBOutlet UITableView *beautyItemTableView;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIButton *cartBtn;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;

- (IBAction)timeChange:(id)sender;




@end

@implementation CarBeautyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    
    shopId=[[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SHOP_ID] intValue];
   
    if(_carBeautyType==CarBeautyType_beauty){
        titleName=@"洗车美容";
    }else{
        titleName=@"换油保养";
    }
    self.title=titleName;
    [self resetNSUserDefaults];
    
    incre=-1;
    self.timeCollectionView.delegate=self;
    self.timeCollectionView.dataSource=self;
    
    
    [self.timeCollectionView registerNib:[UINib nibWithNibName:@"MyCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyCollectionViewCell"];
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小为100*100
    layout.itemSize = CGSizeMake(50, 30);
    layout.minimumInteritemSpacing=5;
    layout.minimumLineSpacing=5;
    [self.timeCollectionView setCollectionViewLayout:layout];
   
    [self.beautyItemTableView setRowHeight:50];
    [self.beautyItemTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.beautyItemTableView.delegate=self;
    self.beautyItemTableView.dataSource=self;
    
    [self initOrderBtn];
    
    [self netDataGet];
}
-(void)resetNSUserDefaults{
    [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:KEY_SELECT_INCRE];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KEY_SELECT_TIME];
}


-(void)netDataGet{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        if(incre<0){
            dayOrderStates=[[ElApiService shareElApiService] getDayOrderStateList:shopId searchType:_carBeautyType incre:0];
            if(_carBeautyType==CarBeautyType_beauty){
                carItems=[[ElApiService shareElApiService] getDecorationList:shopId];
            }else if (_carBeautyType==CarBeautyType_oil){
                carItems=[[ElApiService shareElApiService] getOilListByshopId:shopId];
            }

            
        }else{
            dayOrderStates=[[ElApiService shareElApiService] getDayOrderStateList:shopId searchType:_carBeautyType incre:incre];
        }
        
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.timeCollectionView reloadData];
            [self.beautyItemTableView reloadData];
            int row=[dayOrderStates count]%6==0?[dayOrderStates count]/6:([dayOrderStates count]/6+1);
            
            [self.topView addConstraint:[NSLayoutConstraint
                                  constraintWithItem:_topView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1
                                  constant:row*30+34]];
            
            
        });
    });
}

-(void)initOrderBtn{
    
    [self.cartBtn.layer setBorderColor:[BTN_BG_COLOR CGColor]];
    [self.cartBtn.layer setBorderWidth:1];
    [self.cartBtn.layer setCornerRadius:_cartBtn.frame.size.width/2];
    [self.cartBtn setBackgroundColor:[UIColor clearColor]];
    [self.cartBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cartBtn setTitle:@"0" forState:UIControlStateNormal];
    
    
    [self.orderBtn setEnabled:NO];
    [self.orderBtn setBackgroundColor:[UIColor grayColor]];
    [self.orderBtn.layer setCornerRadius:4.0];
    
    
    [self.orderBtn addTarget:self action:@selector(orderDetail:) forControlEvents:UIControlEventTouchUpInside];
    
     [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KEY_SELECT_TIME];
}

-(void)orderDetail:(id)sender{
    
    NSString *selectTime=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SELECT_TIME];
    if(selectTime==nil||[selectTime isEqualToString:@""]){
        [self.view makeToast:@"请选择预约时间"];
        return;
    }
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    OrderReViewController *orderVC=[storyBoard instantiateViewControllerWithIdentifier:@"orderVC"];
    [orderVC setCarBeautyType:_carBeautyType];
    [orderVC setItems:[self selectBaseItems]];
    [orderVC setCarInfos:self.carInfos];
    
    [self.navigationController pushViewController:orderVC animated:YES];
    

}

-(void)selectTime:(UIButton *)sender{
    NSLog(@"tag %d  %@",sender.tag, sender.titleLabel.text);
    
    [[NSUserDefaults standardUserDefaults] setObject:sender.titleLabel.text forKey:KEY_SELECT_TIME];
    
     [self.timeCollectionView reloadData];
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
    if(carItems!=nil){
      return [carItems count];
    }
    return 0;
}

-(NSMutableArray *)selectBaseItems{
    NSMutableArray *selectItems=[[NSMutableArray alloc] init];
    for (TDBaseItem *baseItem in carItems) {
        if(baseItem.isAddYN){
            [selectItems addObject:baseItem];
        }
    }
    return selectItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"beautyCell";
    TDBeautyTableViewCell *tableCell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(tableCell==nil){
       tableCell= [[[NSBundle mainBundle] loadNibNamed:@"TDBeautyTableViewCell" owner:self options:nil] lastObject];
    }
    
    TDBaseItem *item=[carItems objectAtIndex:indexPath.row];
    
    [tableCell.contentLabel setText:[NSString stringWithFormat:@"%@",item.name] ];
    [tableCell.priceLabel setText:[NSString stringWithFormat:@"%.f元",item.price]];
    [tableCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [tableCell.addOrRemoveBtn setSelected:item.isAddYN];
    [tableCell.addOrRemoveBtn setTag:indexPath.row];
    [tableCell.addOrRemoveBtn addTarget:self action:@selector(addOrRemoveCart:) forControlEvents:UIControlEventTouchUpInside];
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TDBaseItem *item=[carItems objectAtIndex:indexPath.row];
    
    NSArray *images=[item.src componentsSeparatedByString:@","];
    
    if(images==nil||[images count]<=0){
        [self.view makeToast:@"暂无详情数据"];
        return;
    }
    
    WashOilDetailViewController *washOilDetailVC=[[WashOilDetailViewController alloc] init];
    washOilDetailVC.desc=item.desc;
    washOilDetailVC.type=_carBeautyType;
    
    if (_carBeautyType==CarBeautyType_beauty) {
        washOilDetailVC.itemId=item.decorationId;
    }else if (_carBeautyType==CarBeautyType_oil){
        washOilDetailVC.itemId=item.oilId;
    }
    washOilDetailVC.src=item.src;
    washOilDetailVC.title=item.name;
    washOilDetailVC.pos=indexPath.row;
    washOilDetailVC.vcDelegate=self;
    
    [self.navigationController pushViewController:washOilDetailVC animated:YES];
    
}

-(void)reDrawItemView:(int)index onlyAdd:(BOOL)onlyAdd{
    TDBaseItem *item=[carItems objectAtIndex:index];
    if(onlyAdd){
        [item setIsAddYN:YES];
    }else{
        if(item.isAddYN){
            [item setIsAddYN:NO];
        }else{
            [item setIsAddYN:YES];
        }
    }
    int val=item.price;
    
    if(item.isAddYN){
        
        totalMoney+=val;
        totalCount++;
        
    }else{
        totalMoney-=val;
        totalCount--;
    }
    
    if(totalMoney>0){
        [self.orderBtn setEnabled:YES];
        [self.orderBtn setBackgroundColor:BTN_BG_COLOR];
        [self.moneyLabel setTextColor:[UIColor blackColor]];
        [self.moneyLabel setText:[NSString stringWithFormat:@"¥ %d元",totalMoney]];
        
        [self.cartBtn setTitle:[NSString stringWithFormat:@"%d",totalCount] forState:UIControlStateNormal];
    }else{
        [self.orderBtn setEnabled:NO];
        [self.orderBtn setBackgroundColor:[UIColor grayColor]];
        [self.moneyLabel setTextColor:[UIColor grayColor]];
        [self.moneyLabel setText:@"0元"];
        
        [self.cartBtn setTitle:@"0" forState:UIControlStateNormal];
        
    }
    
    [_beautyItemTableView reloadData];
}

-(void)addOrRemoveCart:(UIButton *)sender{
    [self reDrawItemView:sender.tag onlyAdd:NO];
    NSLog(@"addOrRemoveCart index %d",sender.tag);
    
}
#pragma mark Collections Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(dayOrderStates!=nil){
         return [dayOrderStates count];
    }
    return 0;
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
 
    MyCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionViewCell" forIndexPath:indexPath];
   
    NSString *selectTime= [[NSUserDefaults standardUserDefaults] objectForKey:KEY_SELECT_TIME];
    
    
    
    TDOrderStateType *orderStateType=[dayOrderStates objectAtIndex:indexPath.row];
    [cell.timeButton setTitle:orderStateType.orderTime forState:UIControlStateNormal];
    
    if (orderStateType.isFull||orderStateType.isInvaild) {
        [cell.timeButton setUserInteractionEnabled:NO];
        [cell.timeButton setBackgroundColor:[UIColor colorWithWhite:0.7 alpha:0.3]];
        
        [cell.timeButton setTitleColor:[UIColor colorWithWhite:0.5 alpha:0.7] forState:UIControlStateNormal];
        [cell.timeButton setSelected:NO];
    }else{
        
        [cell.timeButton setUserInteractionEnabled:YES];
         [cell.timeButton setTitleColor:[UIColor colorWithWhite:0.1 alpha:1] forState:UIControlStateNormal];
        if([orderStateType.orderTime isEqualToString:selectTime]){
            [cell.timeButton setSelected:YES];
        }else{
            [cell.timeButton setSelected:NO];
        }
        if(cell.timeButton.selected){
            [cell.timeButton setBackgroundColor:BTN_TIME_SELECTED_COLOR];
        }else{
            [cell.timeButton setBackgroundColor:[UIColor clearColor]];
        }
        
        [cell.timeButton addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];

        
    }
    

    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(48, 24);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
     return UIEdgeInsetsMake(5, 3, 0,3);
}

- (IBAction)timeChange:(UISegmentedControl *)sender {
    NSLog(@"sender index : %d",sender.selectedSegmentIndex);
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KEY_SELECT_TIME];
    incre=sender.selectedSegmentIndex;
    
    [[NSUserDefaults standardUserDefaults] setObject:@(incre) forKey:KEY_SELECT_INCRE];
    
    [self netDataGet];
    
}
@end
