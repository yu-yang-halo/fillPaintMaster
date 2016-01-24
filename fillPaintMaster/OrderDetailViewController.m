//
//  OrderDetailViewController.m
//  fillPaintMaster
//
//  Created by apple on 16/1/1.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "OrderDetailViewController.h"

@interface OrderDetailViewController (){
    NSString *titleName;
}
@property (weak, nonatomic) IBOutlet UILabel *txtLabel;
@property (weak, nonatomic) IBOutlet UIView *itemsView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *itemNumsLabel;
- (IBAction)cancelOrder:(id)sender;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_carBeautyType==CarBeautyType_beauty){
        titleName=@"洗车美容";
    }else if(_carBeautyType==CarBeautyType_oil){
        titleName=@"换油保养";
    }else{
        titleName=@"钣金喷漆";
    }
    [self initTitleView];
    [self initContentView];
    
}
-(void)initContentView{
    [self.txtLabel setText:@"您的订单正在等待客服确认"];
    
    [self.cancelBtn.layer setCornerRadius:5];
    [self.cancelBtn.layer setBorderWidth:1];
    [self.cancelBtn.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [self.cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    
    
}
-(void)change:(id)sender{
    
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initTitleView{
    
    UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,0, 70, 44)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 0)];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *changeBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,0, 70, 44)];
    [changeBtn setImage:[UIImage imageNamed:@"city_icon_location"] forState:UIControlStateNormal];
    [changeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -40)];
    [changeBtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelOrder:(id)sender {
    
}
@end
