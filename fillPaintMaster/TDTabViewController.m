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

#import "YYButtonUtils.h"
float BUTTON_W=30;
float BUTTON_H=49;
const NSString *kNotificationLocationUpdate=@"notification_location_update";

@interface TDTabViewController ()<BMKLocationServiceDelegate>{
    UIButton *homeBtn;
    UIButton *doorBtn;
    UIButton *activeBtn;
    UIButton *myBtn;
    
    UIButton *locBtn;
    NSString *cityName;
    
    BMKLocationService *locService;
}

@end

@implementation TDTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    [self initTDTabBar];
    
    [self initCustomView:0];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self locMyPosition];
}

-(void)initTDTabBar{
    UIView *barView=[[UIView alloc] initWithFrame:self.tabBar.frame];
    float width=self.tabBar.frame.size.width;
    float height=self.tabBar.frame.size.height;
    
    [barView setBackgroundColor:[UIColor whiteColor]];
    float margin_space=20;
    float m_space=(width-margin_space*2-4*BUTTON_W)/3;
    
    homeBtn=[[UIButton alloc] initWithFrame:CGRectMake(margin_space, (height-BUTTON_H)/2, BUTTON_W,BUTTON_H)];
    [homeBtn setTag:0];
    [homeBtn setSelected:YES];
    [homeBtn setTitle:@"首页" forState:UIControlStateNormal];
    [homeBtn setImage:[UIImage imageNamed:@"home_btn_home"] forState:UIControlStateNormal];
    [homeBtn setImage:[UIImage imageNamed:@"home_btn_home_sel"] forState:UIControlStateHighlighted];
    [homeBtn setImage:[UIImage imageNamed:@"home_btn_home_sel"] forState:UIControlStateSelected];
    [YYButtonUtils imageTopTextBottom:homeBtn];
    
    
    doorBtn=[[UIButton alloc] initWithFrame:CGRectMake(homeBtn.frame.origin.x+homeBtn.frame.size.width+m_space, (height-BUTTON_H)/2, BUTTON_W, BUTTON_H)];
    [doorBtn setTag:1];
    [doorBtn setTitle:@"门店" forState:UIControlStateNormal];
    [doorBtn setImage:[UIImage imageNamed:@"home_btn_shop"] forState:UIControlStateNormal];
    [doorBtn setImage:[UIImage imageNamed:@"home_btn_shop_sel"] forState:UIControlStateHighlighted];
    [doorBtn setImage:[UIImage imageNamed:@"home_btn_shop_sel"] forState:UIControlStateSelected];
     [YYButtonUtils imageTopTextBottom:doorBtn];
    
    activeBtn=[[UIButton alloc] initWithFrame:CGRectMake(doorBtn.frame.origin.x+doorBtn.frame.size.width+m_space, (height-BUTTON_H)/2, BUTTON_W, BUTTON_H)];
    [activeBtn setTag:3];
    [activeBtn setTitle:@"活动" forState:UIControlStateNormal];
    [activeBtn setImage:[UIImage imageNamed:@"home_btn_active"] forState:UIControlStateNormal];
    [activeBtn setImage:[UIImage imageNamed:@"home_btn_active_sel"] forState:UIControlStateHighlighted];
    [activeBtn setImage:[UIImage imageNamed:@"home_btn_active_sel"] forState:UIControlStateSelected];
     [YYButtonUtils imageTopTextBottom:activeBtn];
    
    myBtn=[[UIButton alloc] initWithFrame:CGRectMake(activeBtn.frame.origin.x+activeBtn.frame.size.width+m_space, (height-BUTTON_H)/2, BUTTON_W, BUTTON_H)];
    [myBtn setTag:2];
    [myBtn setTitle:@"我的" forState:UIControlStateNormal];
    [myBtn setImage:[UIImage imageNamed:@"home_btn_my"] forState:UIControlStateNormal];
    [myBtn setImage:[UIImage imageNamed:@"home_btn_my_sel"] forState:UIControlStateHighlighted];
    [myBtn setImage:[UIImage imageNamed:@"home_btn_my_sel"] forState:UIControlStateSelected];
    [YYButtonUtils imageTopTextBottom:myBtn];
    

    
    
    [barView addSubview:homeBtn];
    [barView addSubview:doorBtn];
    [barView addSubview:activeBtn];
    [barView addSubview:myBtn];
    
    [homeBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    [doorBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    [activeBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    [myBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:barView];
    [self.tabBar setHidden:YES];
}
-(void)click:(UIButton *)sender{
    if(sender.selected){
        [sender setSelected:NO];
    }else{
        [sender setSelected:YES];
    }
    if(sender==homeBtn){
        [doorBtn setSelected:NO];
        [activeBtn setSelected:NO];
        [myBtn setSelected:NO];
    }else if(sender==doorBtn){
        [homeBtn setSelected:NO];
        [activeBtn setSelected:NO];
        [myBtn setSelected:NO];
    }else if(sender==activeBtn){
        [homeBtn setSelected:NO];
        [doorBtn setSelected:NO];
        [myBtn setSelected:NO];
    }else if(sender==myBtn){
        [homeBtn setSelected:NO];
        [doorBtn setSelected:NO];
        [activeBtn setSelected:NO];
    }
   
    [self setSelectedIndex:sender.tag];
    [self initCustomView:sender.tag];
    
    /*
     TDCarInfoViewController *tdCarInfo=[[TDCarInfoViewController alloc] init];
     [self presentViewController:tdCarInfo animated:YES completion:^{
     
     }];
     */
}

-(void)initCustomView:(NSUInteger)tagId{
    if(tagId==0){
        [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
        locBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,(44-40)/2, 60, 40)];
       
        if(cityName!=nil){
            [locBtn setTitle:cityName forState:UIControlStateNormal];
        }
        
        
        [locBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [locBtn setTitleColor:[UIColor colorWithWhite:0 alpha:0.5] forState:UIControlStateHighlighted];
       
        [locBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-10,0,0)];
      
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:locBtn];
        UIImageView *logo=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
        CGRect framLayout=logo.frame;
        //framLayout.origin.x=-30;
        logo.frame=framLayout;
        self.navigationItem.titleView=logo;
    }else if(tagId==2){
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:20]];
        [titleLabel setText:@"我的"];
        self.navigationItem.titleView=titleLabel;
        
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectZero]];
        
    }else if(tagId==1){
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:20]];
        [titleLabel setText:@"附近门店"];
        self.navigationItem.titleView=titleLabel;
        
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectZero]];
        
    }else if(tagId==3){
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:20]];
        [titleLabel setText:@"活动"];
        self.navigationItem.titleView=titleLabel;
        
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectZero]];
        
    }
   
    
}

-(void)locMyPosition{
    //初始化BMKLocationService
    locService = [[BMKLocationService alloc]init];
    locService.delegate = self;
    //启动LocationService
    [locService startUserLocationService];
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    // NSLog(@"heading is %@ userLocation::%@",userLocation.heading,userLocation);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //[self.eventDelegate onLocationComplete:userLocation];
    
    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
    
    double lat=userLocation.location.coordinate.latitude;
    double lgt=userLocation.location.coordinate.longitude;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f,%f",lat,lgt] forKey:@"latlgt"];
    
    CLLocation *location=[[CLLocation alloc] initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    
   
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        for (CLPlacemark *mark in placemarks) {
          //  NSLog(@"%@ : %@ ",mark.thoroughfare,mark.locality);
            cityName=mark.locality;
            
            [locBtn setTitle:cityName forState:UIControlStateNormal];
            
            
        }
    }];
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
