//
//  OrderSuccessViewController.m
//  fillPaintMaster
//
//  Created by apple on 15/10/5.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import "OrderSuccessViewController.h"
#import "YYButtonUtils.h"
#import "TDLocationViewController.h"
#import "ElApiService.h"
#import "TDTabViewController.h"
#import "DescriptionTableViewCell.h"
#import "DecimalCaculateUtils.h"
@interface OrderSuccessViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSString *titleName;
}
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIImageView *okImageView;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (weak, nonatomic) IBOutlet UIButton *backHomeButton;

@end

@implementation OrderSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_carBeautyType==CarBeautyType_beauty){
        titleName=@"洗车美容";
    }else if(_carBeautyType==CarBeautyType_oil){
        titleName=@"换油保养";
    }else if(_carBeautyType==CarBeautyType_paint){
        titleName=@"钣金喷漆";
    }else{
        titleName=@"商品订单";
    }
    self.title=titleName;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    if (_carBeautyType==-1) {
        if(_resultOK){
            [self.resultLabel setText:@"订单生成成功"];
            [self.okImageView setHidden:NO];
        }else{
            [self.resultLabel setText:@"订单生成失败"];
            [self.okImageView setHidden:YES];
            [self.headerView setBackgroundColor:[UIColor redColor]];
        }

    }else{
        if(_resultOK){
            [self.resultLabel setText:@"预约成功\n请等待客服确认"];
            [self.okImageView setHidden:NO];
        }else{
            [self.resultLabel setText:@"对不起，预约失败"];
            [self.okImageView setHidden:YES];
            [self.headerView setBackgroundColor:[UIColor redColor]];
        }

    }
    
    
    [self.backHomeButton.layer setCornerRadius:4];
    self.detailTableView.delegate=self;
    self.detailTableView.dataSource=self;
    [self.detailTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.detailTableView setRowHeight:60];
    
    
    [self.backHomeButton addTarget:self action:@selector(backHome:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)backHome:(id)sender{
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    TDTabViewController *tabVC=[storyBoard instantiateViewControllerWithIdentifier:@"tabVC"];
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DescriptionTableViewCell"];
    if(cell==nil){
        cell= [[[NSBundle mainBundle] loadNibNamed:@"DescriptionTableViewCell" owner:self options:nil] lastObject];
    }
    TDBaseItem *baseItem=[_items objectAtIndex:indexPath.row];
    
    [cell.nameLabel setText:baseItem.name];
    [cell.priceLabel setText:[NSString stringWithFormat:@"%@元",[DecimalCaculateUtils decimalFloat:baseItem.price]]];
    
    
    return cell;
}


@end
