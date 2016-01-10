//
//  TDTabViewController.m
//  fillPaintMaster
//
//  Created by apple on 15/9/28.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import "TDTabViewController.h"
#import "TDLocationViewController.h"
#import "TDCarInfoViewController.h"
@interface TDTabViewController ()

@end

@implementation TDTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initTDTabBar];
    
    [self initCustomView:0];
    
}
-(void)initTDTabBar{
    UIView *barView=[[UIView alloc] initWithFrame:self.tabBar.frame];
    float width=self.tabBar.frame.size.width;
    float height=self.tabBar.frame.size.height;
    float BUTTON_W=60;
    float BUTTON_H=46;
    
    [barView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *homeBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, (height-BUTTON_H)/2, BUTTON_W,BUTTON_H)];
    [homeBtn setTag:0];
    [homeBtn setBackgroundImage:[UIImage imageNamed:@"home"] forState:UIControlStateNormal];
    UIButton *addBtn=[[UIButton alloc] initWithFrame:CGRectMake(((width-BUTTON_W)/2), (height-BUTTON_H)/2, BUTTON_W, BUTTON_H)];
    [addBtn setTag:1];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    
    UIButton *individualBtn=[[UIButton alloc] initWithFrame:CGRectMake(width-BUTTON_W, (height-BUTTON_H)/2, BUTTON_W, BUTTON_H)];
    [individualBtn setTag:2];
    [individualBtn setBackgroundImage:[UIImage imageNamed:@"individual"] forState:UIControlStateNormal];
    
    
    [barView addSubview:homeBtn];
    [barView addSubview:addBtn];
    [barView addSubview:individualBtn];
    
    [homeBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    [addBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    [individualBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:barView];
    [self.tabBar setHidden:YES];
}
-(void)click:(UIButton *)sender{
    long tag=sender.tag;
    NSLog(@"tag %ld",tag);
    if(tag==1){
        TDCarInfoViewController *tdCarInfo=[[TDCarInfoViewController alloc] init];
        [self presentViewController:tdCarInfo animated:YES completion:^{
            
        }];
        return;
    }
    [self setSelectedIndex:tag];
    [self initCustomView:tag];
}

-(void)initCustomView:(NSUInteger)tagId{
    if(tagId==0||tagId==1){
        [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
        UIButton *locBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,(44-40)/2, 60, 40)];
        [locBtn setImage:[UIImage imageNamed:@"loc"] forState:UIControlStateNormal];
        [locBtn addTarget:self action:@selector(location:) forControlEvents:UIControlEventTouchUpInside];
        [locBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:locBtn];
        
        UIButton *portraitBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,0, 60, 44)];
        [portraitBtn setEnabled:NO];
        [portraitBtn setImage:[UIImage imageNamed:@"portrait"] forState:UIControlStateNormal];
        [portraitBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -30)];
        
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:portraitBtn];
        
        self.navigationItem.titleView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    }else{
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:20]];
        [titleLabel setText:@"个人中心"];
        self.navigationItem.titleView=titleLabel;
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectZero]];
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectZero]];
        
    }
   
    
}
-(void)location:(UIButton *)sender{
    NSLog(@"location...");
    
    TDLocationViewController *locationVC=[[TDLocationViewController alloc] init];
    [self presentViewController:locationVC animated:YES completion:^{
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
