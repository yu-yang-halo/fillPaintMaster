//
//  TDShopViewController.m
//  fillPaintMaster
//
//  Created by apple on 16/1/1.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "TDShopViewController.h"
#import "ShopView0Controller.h"
#import "ShopView1Controller.h"

@interface TDShopViewController (){
    ShopView0Controller *s0;
    
    ShopView1Controller *s1;
    
}

@property (weak, nonatomic) IBOutlet UIButton *btn0;
@property (weak, nonatomic) IBOutlet UIButton *btn1;


@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation TDShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTitleView];
    [self initButton];
    
    s0=[[ShopView0Controller alloc] init];
    [s0 setTdShopVCDelegate:self];
    s0.view.frame=self.containerView.bounds;
    
    
    s1=[[ShopView1Controller alloc] init];
    [s1 setTdShopVCDelegate:self];
    s1.view.frame=self.containerView.bounds;
    [s0.view setBackgroundColor:[UIColor purpleColor]];
    
    
    [self.containerView addSubview:s0.view];
    [self.containerView addSubview:s1.view];
    [self.containerView bringSubviewToFront:s0.view];
}


-(void)initButton{
    [self.btn0 setSelected:YES];
    [self.btn0 setTag:0];
    [self.btn0 addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btn1 setSelected:NO];
    [self.btn1 setTag:1];
    [self.btn1 addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)switchView:(UIButton *)sender{
    if(sender.tag==0){
        if(sender.selected){
            [sender setSelected:NO];
            [self.btn1 setSelected:YES];
            [self.containerView bringSubviewToFront:s1.view];
        }else{
            [sender setSelected:YES];
            [self.btn1 setSelected:NO];
            [self.containerView bringSubviewToFront:s0.view];
        }
    }else{
        if(sender.selected){
            [sender setSelected:NO];
            [self.btn0 setSelected:YES];
            [self.containerView bringSubviewToFront:s0.view];
        }else{
            [sender setSelected:YES];
            [self.btn0 setSelected:NO];
            [self.containerView bringSubviewToFront:s1.view];
        }
    }
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
    [titleLabel setText:@"门店"];
    
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


@end
