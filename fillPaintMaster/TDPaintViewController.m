//
//  TDPaintViewController.m
//  fillPaintMaster
//
//  Created by apple on 15/10/5.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import "TDPaintViewController.h"
#import "PaintView0Controller.h"
#import "PaintView1Controller.h"
@interface TDPaintViewController (){
    PaintView0Controller *p0;
    PaintView1Controller *p1;
    

}
@property (weak, nonatomic) IBOutlet UIButton *btn0;
@property (weak, nonatomic) IBOutlet UIButton *btn1;


@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation TDPaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTitleView];
    [self initButton];
    
    p0=[[PaintView0Controller alloc] init];
    [p0 setTdPaintVCDelegate:self];
    p0.view.frame=self.containerView.bounds;
    
    p1=[[PaintView1Controller alloc] init];
    [p1 setTdPaintVCDelegate:self];
    p1.view.frame=self.containerView.bounds;
    
    [self.containerView addSubview:p0.view];
    [self.containerView addSubview:p1.view];
    [self.containerView bringSubviewToFront:p0.view];
}


-(void)viewDidAppear:(BOOL)animated{
  
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
            [self.containerView bringSubviewToFront:p1.view];
        }else{
            [sender setSelected:YES];
            [self.btn1 setSelected:NO];
            [self.containerView bringSubviewToFront:p0.view];
        }
    }else{
        if(sender.selected){
            [sender setSelected:NO];
            [self.btn0 setSelected:YES];
            [self.containerView bringSubviewToFront:p0.view];
        }else{
            [sender setSelected:YES];
            [self.btn0 setSelected:NO];
            [self.containerView bringSubviewToFront:p1.view];
        }
    }
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
    [titleLabel setText:@"钣金喷漆"];
    
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
