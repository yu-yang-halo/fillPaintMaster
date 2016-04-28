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
#import "CityTableViewController.h"
#import "YYButtonUtils.h"
#import "Constants.h"
#import "ElApiService.h"
#import "TDLoginViewController.h"
float BUTTON_W=30;
float BUTTON_H=49;

@interface TDTabViewController (){
    UIButton *homeBtn;
    UIButton *doorBtn;
    UIButton *activeBtn;
    UIButton *myBtn;
    
    UIButton *locBtn;
    UIButton *rightBtn;
    NSString *cityName;
    
    
    
    NSArray *cityList;
   
}

@end

@implementation TDTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"  style:UIBarButtonItemStylePlain  target:self  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
  
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    
    
    locBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,(44-40)/2, 60, 40)];
    [locBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [locBtn setTitleColor:[UIColor colorWithWhite:0 alpha:0.5] forState:UIControlStateHighlighted];
    
    [locBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-10,0,0)];
    [locBtn addTarget:self action:@selector(toCityList:) forControlEvents:UIControlEventTouchUpInside];
    
    rightBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,(44-40)/2,80, 40)];
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,10,0,-10)];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"地图模式" forState:UIControlStateNormal];
    [rightBtn setTitle:@"列表模式" forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(selectMode:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self initTDTabBar];
    
    [self initCustomView:0];
    
    [self netDataGet];
    
}

-(void)selectMode:(UIButton *)sender{
    if(sender.selected){
        [sender setSelected:NO];
    }else{
        [sender setSelected:YES];
    }
    
    [self.tabHandlerDelegate onModeSelected:sender.selected?1:0];
    
}

-(void)netDataGet{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        cityList=[[ElApiService shareElApiService] getCityList];
        TDUser *user=[[ElApiService shareElApiService] getUserInfo];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(user.shopId>0){
                [[NSUserDefaults standardUserDefaults] setObject:@(user.shopId) forKey:KEY_SHOP_ID];
            }

        });
    });
}



-(void)toCityList:(UIButton *)sender{
    CityTableViewController *cityTableVC=[[CityTableViewController alloc] init];
    [cityTableVC setCityList:cityList];
    
    self.navigationItem.backBarButtonItem.title=@"返回";
    
    [self.navigationController pushViewController:cityTableVC animated:YES];
    
    
}
-(void)toCompountPage{
    [self click:activeBtn];
}

-(void)viewWillAppear:(BOOL)animated{
    
    BOOL toDoorYN=[[[NSUserDefaults standardUserDefaults] objectForKey:KEY_TO_DOOR] boolValue];
    
    if(toDoorYN){
        
        cityName=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_CITY_NAME];
        [locBtn setTitle:cityName forState:UIControlStateNormal];
        [self click:doorBtn];
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:KEY_TO_DOOR];
    }else{
       
        [self compareCity];
        
        if(self.selectedIndex<4&&self.selectedIndex>=0){
            [[self.viewControllers objectAtIndex:self.selectedIndex] viewWillAppear:animated];
        }
        
        
        
    }
    
}
/*
 * first 比较定位城市与列表城市
 *  没有找到----显示定位城市
 */
-(void)compareCity{
    NSString *latlgtCityName=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_LATLGT_CITYNAME];
    NSString *findCityName=nil;
    for(TDCityInfo *cityInfo in cityList){
        if([cityInfo.name isEqualToString:latlgtCityName]||[latlgtCityName isEqualToString:[NSString stringWithFormat:@"%@市",cityInfo.name]]){
            
            findCityName=latlgtCityName;
            [[NSUserDefaults standardUserDefaults] setObject:@(cityInfo.cityId) forKey:KEY_CITY_ID];
            [[NSUserDefaults standardUserDefaults] setObject:findCityName forKey:KEY_CITY_NAME];
            
            break;
        }
    }
    if(findCityName==nil){
        findCityName=latlgtCityName;
        [[NSUserDefaults standardUserDefaults] setObject:@(-1) forKey:KEY_CITY_ID];
    }
    [locBtn setTitle:findCityName forState:UIControlStateNormal];
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
   [sender setSelected:YES];
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
        
        if(cityName!=nil){
            [locBtn setTitle:cityName forState:UIControlStateNormal];
        }
        
        
        
      
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:locBtn];
        UIImageView *logo=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
        CGRect framLayout=logo.frame;
        //framLayout.origin.x=-30;
        logo.frame=framLayout;
        self.navigationItem.titleView=logo;
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectZero]];
    }else if(tagId==2){
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:20]];
        [titleLabel setText:@"我的"];
        self.navigationItem.titleView=titleLabel;
        
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectZero]];
       
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(exitToLogin:)];
        
        
        
        
    }else if(tagId==1){
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:20]];
        [titleLabel setText:@"附近门店"];
        self.navigationItem.titleView=titleLabel;
        
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectZero]];
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        
    }else if(tagId==3){
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:20]];
        [titleLabel setText:@"活动"];
        self.navigationItem.titleView=titleLabel;
        
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectZero]];
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectZero]];
        
    }
   
    
}

-(void)exitToLogin:(id)sender{
    TDLoginViewController *loginVC=[[TDLoginViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
