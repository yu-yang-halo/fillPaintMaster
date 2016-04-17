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
#import "YYButtonUtils.h"
#import "TDLocationViewController.h"


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
  
    self.title=@"手机探店";
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    
    [self initButton];
    
    s0=[[ShopView0Controller alloc] init];
    [s0 setTdShopVCDelegate:self];
    s0.view.frame=self.containerView.bounds;
    
    
    s1=[[ShopView1Controller alloc] init];
    [s1 setTdShopVCDelegate:self];
    s1.view.frame=self.containerView.bounds;
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [s0 viewWillAppear:animated];
    [s1 viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [s0 viewWillDisappear:animated];
    [s1 viewWillDisappear:animated];
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
