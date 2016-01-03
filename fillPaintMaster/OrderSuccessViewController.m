//
//  OrderSuccessViewController.m
//  fillPaintMaster
//
//  Created by apple on 15/10/5.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import "OrderSuccessViewController.h"
#import "OrderDetailViewController.h"
@interface OrderSuccessViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contactsLabel;
@property (weak, nonatomic) IBOutlet UILabel *carInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIButton *bookingDetailButon;
@property (weak, nonatomic) IBOutlet UIButton *backHomeButton;
- (IBAction)bookDetailAction:(id)sender;

- (IBAction)backHomeAction:(id)sender;

@end

@implementation OrderSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTitleView];
    [self initButton];
}
-(void)initButton{
    [self.bookingDetailButon.layer setCornerRadius:5];
    [self.bookingDetailButon.layer setBorderWidth:1];
    [self.bookingDetailButon setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self.bookingDetailButon.layer setBorderColor:[[UIColor grayColor] CGColor]];
    
    [self.backHomeButton.layer setCornerRadius:5];
    [self.backHomeButton.layer setBorderWidth:1];
    [self.backHomeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.backHomeButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (IBAction)bookDetailAction:(id)sender {
   
    OrderDetailViewController *orderDetail=[[OrderDetailViewController alloc] init];
    [self.navigationController pushViewController:orderDetail animated:YES];
    
}

- (IBAction)backHomeAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
