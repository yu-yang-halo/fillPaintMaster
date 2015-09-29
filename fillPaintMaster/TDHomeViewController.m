//
//  ViewController.m
//  fillPaintMaster
//
//  Created by apple on 15/9/14.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import "TDHomeViewController.h"
#import "TDAdView.h"
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
    switch (sender.tag) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
            
    }
}
-(void)viewDidLayoutSubviews{
   self.tdScrollView.contentSize=CGSizeMake(self.view.frame.size.width,400);
}

-(CGRect)createCGRect:(int)row col:(int)col{
    float hspace=10;
    float vspace=20;
    int ALL_COLUMN=2;
    float width=self.view.frame.size.width;
    if(col==ALL_COLUMN-1){
        return CGRectMake(width-vspace-130,row*90+hspace*(row+1), 130, 90);
    }else{
        return CGRectMake(vspace,row*90+hspace*(row+1), 130, 90);
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
