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
static const float ICON_WIDTH=70;
static const float ICON_HEIGHT=80;
static const float AD_HEIGHT=120;
static const float TOP_SPACE=5;
static const float LEFT_SPACE=15;
static const float ROW_HEIGHT=40;
@interface TDHomeViewController (){
    NSArray *imgItms;
    NSArray *contentItms;
}
@property(retain, nonatomic)  UIScrollView *tdScrollView;
@property(retain, nonatomic)  UIView *containerView;
@property(retain, nonatomic)  UITableView *tableView;

@property (retain, nonatomic)  TDAdView *adView;
@property(retain,nonatomic) NSArray *serviceItems;

@end

@implementation TDHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.adView=[[TDAdView alloc] initADViewWithFrame:CGRectMake(0,64, self.view.frame.size.width, AD_HEIGHT) adImageNames:@[@"ad",@"ad",@"ad"]];
    self.serviceItems=@[@"洗车美容",@"换油保养",@"钣金喷漆",@"手机探店",@"车险直销",@"产品超市",@"即将上线",@"即将上线"];
    imgItms=@[@"home_icon_hongbao",@"home_icon_recommend"];
    contentItms=@[@"领取优惠券和红包",@"热门推荐"];
    //home_icon_hongbao 领取优惠券和红包
    //home_icon_recommend 热门推荐
    
    self.containerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (ICON_HEIGHT+TOP_SPACE)*2)];
    [self.containerView setBackgroundColor:[UIColor whiteColor]];
    
    self.tdScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, AD_HEIGHT+64, self.view.frame.size.width,self.view.frame.size.height-AD_HEIGHT-64)];
    
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,self.containerView.frame.origin.y+self.containerView.frame.size.height+TOP_SPACE*2, self.view.frame.size.width,ROW_HEIGHT*2)];
    self.tableView.rowHeight=ROW_HEIGHT;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    
    
    [self.view addSubview:_adView];
    [self.view addSubview:_tdScrollView];
    
    
    [_tdScrollView addSubview:_containerView];
    [_tdScrollView addSubview:_tableView];
    
    
    [self initHomeView];
    
    TDLoginViewController *tdLoginVC=[[TDLoginViewController alloc] init];
    [self presentViewController:tdLoginVC animated:YES completion:^{
        
    }];

}
-(void)initHomeView{
    /*
     2行
     4列
     0 1
     2 3
     4 5
     */
    for (int i=0; i<8; i++) {
        
        int col=i%4;
        int row=i/4;
        
        UIButton *button=[[UIButton alloc] initWithFrame:[self createCGRect:row col:col]];
        [button setTag:i];
        [button setImage:[UIImage imageNamed:[self imageName:i]] forState:UIControlStateNormal];
        [button setTitle:[_serviceItems objectAtIndex:i] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self initButtonProperties:button];
        
        [_containerView addSubview:button];
    }
    
    
    
}
-(void)initButtonProperties:(UIButton *)button{
   
    button.imageEdgeInsets = UIEdgeInsetsMake(5,15,35,15);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    
    button.titleLabel.font = [UIFont systemFontOfSize:10];//title字体大小
    button.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    
     button.titleEdgeInsets = UIEdgeInsetsMake(33,-button.titleLabel.frame.origin.x+5,0,10);
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
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
           
        }
            break;
            
    }
}
-(void)viewDidLayoutSubviews{
  self.tdScrollView.contentSize=CGSizeMake(self.view.frame.size.width,400);
}

-(CGRect)createCGRect:(int)row col:(int)col{

    
    float colSpace=(self.view.frame.size.width-ICON_WIDTH*4-LEFT_SPACE*2)/3;
   
    return  CGRectMake(LEFT_SPACE+col*(ICON_WIDTH+colSpace), TOP_SPACE+row*(ICON_HEIGHT+TOP_SPACE), ICON_WIDTH, ICON_HEIGHT);

}

-(NSString *)imageName:(int)tag{
    NSString *imageName=@"homepage_gridview_8";
    switch (tag) {
        case 0:
            imageName=@"homepage_gridview_8";
            break;
        case 1:
            imageName=@"homepage_gridview_6";
            break;
        case 2:
            imageName=@"homepage_gridview_7";
            break;
        case 3:
            imageName=@"homepage_gridview_3";
            break;
        case 4:
            imageName=@"homepage_gridview_4";
            break;
        case 5:
            imageName=@"homepage_gridview_1";
            break;
        case 6:
            imageName=@"default_icon_serve";
            break;
        case 7:
            imageName=@"default_icon_serve";
            break;
    }
    return imageName;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableViewCell=[tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if(tableViewCell==nil){
        tableViewCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
    }
    tableViewCell.textLabel.text=[contentItms objectAtIndex:indexPath.section];
    [tableViewCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [tableViewCell.imageView setImage:[UIImage imageNamed:[imgItms objectAtIndex:indexPath.section]]];
    
    
    return tableViewCell;
}

@end
