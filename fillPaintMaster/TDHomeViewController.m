//
//  ViewController.m
//  fillPaintMaster
//
//  Created by apple on 15/9/14.
//  Copyright © 2015年 LZTech. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TDHomeViewController.h"
#import "TDAdView.h"
#import "TDLoginViewController.h"
#import "CarBeautyViewController.h"
const float ICON_WIDTH=130;
const float ICON_HEIGHT=90;
@interface TDHomeViewController ()
@property (retain, nonatomic)  UIScrollView *tdScrollView;

@property (retain, nonatomic)  TDAdView *adView;

@end

@implementation TDHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.adView=[[TDAdView alloc] initADViewWithFrame:CGRectMake(0,64, self.view.frame.size.width, 150) adImageNames:@[@"ad",@"ad",@"ad"]];
    
    
    self.tdScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 150+64, self.view.frame.size.width, self.view.frame.size.height-(150+64))];
    [self.view addSubview:_adView];
    [self.view addSubview:_tdScrollView];
    
    [self initHomeView];

}
-(void)initHomeView{
    /*
     三行
     两列
     0 1
     2 3
     4 5
     */
    for (int i=0; i<6; i++) {
        
        int col=i%2;
        int row=i/2;
        
        UIButton *button=[[UIButton alloc] initWithFrame:[self createCGRect:row col:col]];
        [button setTag:i];
        [button setImage:[UIImage imageNamed:[self imageName:i]] forState:UIControlStateNormal];
        
        
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.tdScrollView addSubview:button];
    }
    
}
-(void)click:(UIButton *)sender{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    switch (sender.tag) {
        case 0:{
            /*
             汽车美容
             */
            CarBeautyViewController *vc=[storyBoard instantiateViewControllerWithIdentifier:@"beautyVC"];
            [vc setCarBeautyType:CarBeautyType_beauty];
            [self.tabBarController.navigationController pushViewController:vc animated:YES];
            
               }
            break;
        case 1:
        {
            /*
             换油保养
             */
            CarBeautyViewController *vc=[storyBoard instantiateViewControllerWithIdentifier:@"beautyVC"];
            [vc setCarBeautyType:CarBeautyType_oil];
            [self.tabBarController.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 2:{
            /*
             钣金喷漆
             */
            UIViewController *vc=[storyBoard instantiateViewControllerWithIdentifier:@"tdPaintVC"];
            [self.tabBarController.navigationController pushViewController:vc animated:YES];
            
        }
            
            break;
        case 3:{
            /*
             手机探店
             */
            UIViewController *vc=[storyBoard instantiateViewControllerWithIdentifier:@"tdShopVC"];
            [self.tabBarController.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 4:
            /*
             车险直销
             */
            
            break;
        case 5:
            /*
             产品超市
             */
        {
            TDLoginViewController *tdLoginVC=[[TDLoginViewController alloc] init];
            [self presentViewController:tdLoginVC animated:YES completion:^{
                
            }];
        }
            break;
            
    }
}
-(void)viewDidLayoutSubviews{
   self.tdScrollView.contentSize=CGSizeMake(self.view.frame.size.width,400);
}

-(CGRect)createCGRect:(int)row col:(int)col{
    
    
    
    
    float hspace=15;
    float vspace=(self.view.frame.size.width-ICON_WIDTH*2-20)/2;
    int ALL_COLUMN=2;
    float width=self.view.frame.size.width;
    if(col==ALL_COLUMN-1){
        return CGRectMake(width-vspace-ICON_WIDTH,row*ICON_HEIGHT+hspace*(row+1), ICON_WIDTH, ICON_HEIGHT);
    }else{
        return CGRectMake(vspace,row*90+hspace*(row+1), ICON_WIDTH, ICON_HEIGHT);
    }
    
}

-(NSString *)imageName:(int)tag{
    NSString *imageName=@"xcmr";
    switch (tag) {
        case 0:
            imageName=@"xcmr";
            break;
        case 1:
            imageName=@"hyby";
            break;
        case 2:
            imageName=@"bjpq";
            break;
        case 3:
            imageName=@"sjtd";
            break;
        case 4:
            imageName=@"cxzx";
            break;
        case 5:
            imageName=@"cpcs";
            break;
    }
    return imageName;
    
}

-(void)viewWillAppear:(BOOL)animated{
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
