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
#import "TDPaintViewController.h"
#import "YYButtonUtils.h"
#import "ElApiService.h"
#import "AppDelegate.h"
#import <MJRefresh/MJRefresh.h>
#import <UIView+Toast.h>
#import "TDWebViewController.h"
#import "Constants.h"
#import "GoodsViewController.h"
#import "GoodDataSourceViewController.h"
#import <JYSlideSegmentController/JYSlideSegmentController.h>
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "TDTabViewController.h"
#import "UserAddressManager.h"
#import "TDGoodInfo.h"
#import "GoodsTopCollectionViewCell.h"
#import "DecimalCaculateUtils.h"
static const float ICON_WIDTH=45;
static const float ICON_HEIGHT=80;
static const float AD_HEIGHT=120;
static const float TOP_SPACE=5;
static const float LEFT_SPACE=15;
static const float ROW_HEIGHT=40;


@interface TDHomeViewController ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    NSArray *imgItms;
    NSArray *contentItms;
    MJRefreshNormalHeader *refreshHeader;
    NSArray *bannerList;
    NSArray *carInfos;
    
    NSArray *goodTypeList;
    NSMutableArray *goodsList;
    
}
@property(retain, nonatomic)  UIScrollView *tdScrollView;
@property(retain, nonatomic)  UIView *containerView;
@property(retain, nonatomic)  UITableView *tableView;

@property (retain, nonatomic)  SDCycleScrollView *cycleScrollView;
@property(retain,nonatomic) NSArray *serviceItems;

@property(nonatomic,strong) UICollectionView *collectionView;

@end

@implementation TDHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 网络加载图片的轮播器
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, self.view.frame.size.width, AD_HEIGHT) delegate:self placeholderImage:nil];

    
    _cycleScrollView.currentPageDotColor=[UIColor whiteColor];
    _cycleScrollView.pageDotColor=[UIColor colorWithWhite:1 alpha:0.4];
    _cycleScrollView.autoScroll=YES;
    
    
    
    self.serviceItems=@[@"洗车美容",@"换油保养",@"钣金喷漆",@"手机探店",@"车险直销",@"门店超市",@"自助洗"];
    imgItms=@[@"home_icon_hongbao",@"home_icon_recommend"];
    contentItms=@[@"领取优惠券和红包",@"热门推荐"];

    
    self.containerView=[[UIView alloc] initWithFrame:CGRectMake(0, AD_HEIGHT, self.view.frame.size.width, (ICON_HEIGHT+TOP_SPACE)*2)];
    [self.containerView setBackgroundColor:[UIColor whiteColor]];
    
    self.tdScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0,64, self.view.frame.size.width,self.view.frame.size.height-64-49)];
    
   
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,self.containerView.frame.origin.y+self.containerView.frame.size.height+TOP_SPACE*2, self.view.frame.size.width,ROW_HEIGHT*2)];
    self.tableView.rowHeight=ROW_HEIGHT;
    [self.tableView setScrollEnabled:NO];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    
    
    [self.view addSubview:_tdScrollView];
    
    
    refreshHeader=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self netDataGet];
    }];
    [refreshHeader.lastUpdatedTimeLabel setHidden:YES];
     self.tdScrollView.mj_header=refreshHeader;
    
   
    
   
    [_tdScrollView addSubview:_cycleScrollView];
    [_tdScrollView addSubview:_containerView];
    [_tdScrollView addSubview:_tableView];
    
    
    [self initHomeView];
    
                     
    TDLoginViewController *tdLoginVC=[[TDLoginViewController alloc] init];
    [self presentViewController:tdLoginVC animated:YES completion:^{
        
    }];
    
   
    /**
     *  热门商品
     */
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(158, 118);
    layout.minimumInteritemSpacing=1;
    layout.minimumLineSpacing=3;
    // Do any additional setup after loading the view from its nib.
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, _tableView.frame.origin.y+_tableView.frame.size.height+5, self.view.frame.size.width,0)collectionViewLayout:layout];
    
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"GoodsTopCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"GoodHotTopCollectionCell"];
    [_collectionView setBackgroundColor:[UIColor colorWithWhite:0.96 alpha:0.9]];
    [_collectionView setScrollEnabled:NO];
    
    [_tdScrollView addSubview:_collectionView];
    

}
-(void)viewWillAppear:(BOOL)animated{
    // 马上进入刷新状态
    [refreshHeader beginRefreshing];
}

-(void)netDataGet{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        bannerList=[[ElApiService shareElApiService] getBannerList:3];
        TDUser *user=[[ElApiService shareElApiService] getUserInfo];
        carInfos=[[ElApiService shareElApiService] getCarByCurrentUser];
        
        
        NSMutableArray *imagesURLStrings=[[NSMutableArray alloc] init];
        
        if(bannerList!=nil&&[bannerList count]>0){
            for (TDBannerInfoType *banner in bannerList) {
                NSString *imageUrl=[[ElApiService shareElApiService] getBannerURL:banner.imgName];
                [imagesURLStrings addObject:imageUrl];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if([imagesURLStrings count]>0){
                 _cycleScrollView.imageURLStringsGroup = imagesURLStrings;
            }
             [UserAddressManager cacheUserInfoToLocal:user];
            

            
            if(user.shopId>0){
                [[NSUserDefaults standardUserDefaults] setObject:@(user.shopId) forKey:KEY_SHOP_ID];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KEY_SHOP_ID];
            }
            
            
            
            [refreshHeader endRefreshing];
            
            [self hotGoodsTaskRequest];
            
            
          
        });
        
        
    });
}

-(void)hotGoodsTaskRequest{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        goodTypeList=[[ElApiService shareElApiService] getGoodsType];
        NSArray *allGoodsList=[[ElApiService shareElApiService] getGoodsList:-2];
        goodsList=[NSMutableArray new];
        
        for (TDGoodInfo *goodInfo in allGoodsList){
            if(goodInfo.isTop){
                [goodsList addObject:goodInfo];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            int size=[goodsList count];
            int rows=(size%2==0?size/2:size/2+1);
            
            CGRect frame=_collectionView.frame;
            frame.size.height=rows*118;
            
            _collectionView.frame=frame;
            
            [self.tdScrollView setContentSize:CGSizeMake(self.view.frame.size.width, _collectionView.frame.origin.y+_collectionView.frame.size.height)];
            
            
            [_collectionView reloadData];
        });
    });

}


-(void)initHomeView{
    /*
     2行
     4列
     0 1
     2 3
     4 5
     */
    for (int i=0; i<7; i++) {
        
        int col=i%4;
        int row=i/4;
        
        UIButton *button=[[UIButton alloc] initWithFrame:[self createCGRect:row col:col]];
        [button setTag:i];
        [button setImage:[UIImage imageNamed:[self imageName:i]] forState:UIControlStateNormal];
        [button setTitle:[_serviceItems objectAtIndex:i] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        //[self initButtonProperties:button];
        [YYButtonUtils imageTopTextBottom:button];
        
        
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
    
    NSNumber *shopIDObj=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SHOP_ID];
    
    if([shopIDObj intValue]<=0){
        
        [self.view.window makeToast:@"请选择店铺"];
        
        return;
    }
    if([carInfos count]<=0){
        [self.view.window makeToast:@"为了不影响您的订单提交，请添加车牌号"];
    }
    
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    switch (sender.tag) {
        case 0:{
            /*
             汽车美容
             */
            CarBeautyViewController *vc=[storyBoard instantiateViewControllerWithIdentifier:@"beautyVC"];
            [vc setCarInfos:carInfos];
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
            [vc setCarInfos:carInfos];
            [self.tabBarController.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 2:{
            /*
             钣金喷漆
             */
            TDPaintViewController *vc=[storyBoard instantiateViewControllerWithIdentifier:@"tdPaintVC"];
            [vc setCarInfos:carInfos];
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
        {
            TDWebViewController *webVC=[[TDWebViewController alloc] init];
            
            NSString *url=[[ElApiService shareElApiService] getCheXianURL];
            
            [webVC setUrl:url];
            [webVC setTitle:@"车险直销"];
            
            [self.navigationItem.backBarButtonItem setTitle:@"返回"];
            [self.navigationController pushViewController:webVC animated:YES];
             
             }
            break;
        case 5:
            /*
             门店超市
             */
        {
          
            GoodsViewController *goodVC=[[GoodsViewController alloc] init];
            [goodVC setGoodsTypeList:goodTypeList];
            
            [self.tabBarController.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
            
            [self.tabBarController.navigationController pushViewController:goodVC animated:YES];
            
        }
            break;
            
    }
}
-(void)viewDidLayoutSubviews{
   //self.tdScrollView.contentSize=CGSizeMake(self.view.frame.size.width,400);
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
    
    if(indexPath.section==0){
        [tableViewCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    [tableViewCell.imageView setImage:[UIImage imageNamed:[imgItms objectAtIndex:indexPath.section]]];
    
    
    return tableViewCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        [(TDTabViewController *)self.tabBarController toCompountPage];
    }
    
    
}

#pragma mark SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    TDBannerInfoType *banerInfo=[bannerList objectAtIndex:index];
    
    TDWebViewController *webVC=[[TDWebViewController alloc] init];
    [webVC setUrl:banerInfo.src];
    
    [self.navigationItem.backBarButtonItem setTitle:@"返回"];
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark UICollectionView Delegate


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(goodsList!=nil){
        return [goodsList count];
    }
    return 0;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodsTopCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"GoodHotTopCollectionCell" forIndexPath:indexPath];
    TDGoodInfo *goodsInfo=[goodsList objectAtIndex:indexPath.row];
    
    NSArray * imageNames=[goodsInfo.src componentsSeparatedByString:@","];
    NSString *imageName=nil;
    if([imageNames count]>0){
        imageName=[imageNames objectAtIndex:0];
    }
    
    cell.nameLabel.text=goodsInfo.name;
    
    cell.priceLabel.text=[DecimalCaculateUtils showDecimalFloat:goodsInfo.price];
    NSString *imageURL=[[ElApiService shareElApiService] getGoodsURL:imageName shopId:goodsInfo.shopId];
    
    [cell.goodImageVIew sd_setImageWithURL:[NSURL URLWithString:imageURL]
                      placeholderImage:[UIImage imageNamed:@"icon_default"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
     TDGoodInfo *goodsInfo=[goodsList objectAtIndex:indexPath.row];
    
    
    GoodsViewController *goodVC=[[GoodsViewController alloc] init];
    [goodVC setGoodsTypeList:goodTypeList];
    [goodVC setSelectGoodTypeId:goodsInfo.type];
    
    [self.tabBarController.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    
    [self.tabBarController.navigationController pushViewController:goodVC animated:YES];
}



@end
