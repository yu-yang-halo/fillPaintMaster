//
//  GoodsViewController.m
//  fillPaintMaster
//
//  Created by admin on 16/4/21.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "GoodsViewController.h"
#import "ElApiService.h"
#import "Constants.h"
#import "GoodDataSourceViewController.h"
#import <RBBAnimation/RBBTweenAnimation.h>
#import "GoodsCartViewController.h"
#import <UIView+Toast.h>
#import "CartManager.h"
#import "GoodsCollectionViewCell.h"
#import <SDWebImage/SDWebImageManager.h>
#import "GoodsDetailViewController.h"
@interface GoodsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    int shopId;
    SDWebImageManager *manager;
    NSArray *goodsList;
    UIButton *cartButton;
    
    NSMutableArray *currentGoodsList;
}

@property(nonatomic,strong) HMSegmentedControl *segmentedControl;
@property(nonatomic,strong) UICollectionView *collectionView;

@property(nonatomic,strong) NSMutableArray *typeStrs;
@end

@implementation GoodsViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"门店超市";
    
    [[CartManager defaultManager] clearCartClassList];
    
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    cartButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [cartButton setImage:[UIImage imageNamed:@"cart6"] forState:UIControlStateNormal];
    [cartButton setImageEdgeInsets:UIEdgeInsetsMake(2,10,2,-10)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:cartButton];
    [cartButton addTarget:self action:@selector(goMyCart:) forControlEvents:UIControlEventTouchUpInside];
    
    shopId=[[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SHOP_ID] intValue];
    
    [self initView];
    
    [self netDataGet];
    
}
-(int)segmentIndex{
    int segmentIndex=0;
    for (int i=0;i<[_goodsTypeList count];i++) {
        if([[_goodsTypeList objectAtIndex:i] goodTypeId]==_selectGoodTypeId){
            segmentIndex=i;
            break;
        }
    }
    [_segmentedControl setSelectedSegmentIndex:segmentIndex];
    return segmentIndex;
}

-(void)initView{
    /*
     * 初始化HMSegmentedControl视图
     */
    self.typeStrs=[NSMutableArray new];
    for (TDGoodsType *goodsType in _goodsTypeList) {
        [_typeStrs addObject:goodsType.name];
    }
    self.segmentedControl=[[HMSegmentedControl alloc] initWithFrame:CGRectMake(0,64,self.view.bounds.size.width,50)];
    [_segmentedControl setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    [_segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleFullWidthStripe];
    [_segmentedControl setSelectionIndicatorLocation:(HMSegmentedControlSelectionIndicatorLocationDown)];
    [_segmentedControl setSelectionIndicatorColor:[UIColor whiteColor]];
    [_segmentedControl setSelectionIndicatorHeight:2];
    
    [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [_segmentedControl setSectionTitles:_typeStrs];
   
    [self.view addSubview:_segmentedControl];
    
    
    __weak GoodsViewController *weakSelf=self;
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        NSLog(@" index %d ",index);
        
        [weakSelf reloadGoodsData:index];

    }];
    
    /*
     * 初始化UICollectionView（like GridVIew）
     */
    manager = [SDWebImageManager sharedManager];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(158, 118);
    layout.minimumInteritemSpacing=1;
    layout.minimumLineSpacing=3;
    // Do any additional setup after loading the view from its nib.
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,_segmentedControl.frame.origin.y+_segmentedControl.frame.size.height,self.view.bounds.size.width,self.view.bounds.size.height-64-50) collectionViewLayout:layout];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"GoodsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"goodsColllectionViewCell"];
    
    
    
    [self.view addSubview:_collectionView];
    
    
}
-(void)reloadGoodsData:(int)index{
    if(goodsList==nil||[goodsList count]<=0){
        return;
    }
    
    currentGoodsList=[NSMutableArray new];
    
    TDGoodsType *goodsType=[_goodsTypeList objectAtIndex:index];
    
    
    for (TDGoodInfo *goodInfo in goodsList) {
        if(goodInfo.type==goodsType.goodTypeId){
            [currentGoodsList addObject:goodInfo];
        }
    }
    
    [_collectionView reloadData];
    
    
}

-(void)goMyCart:(UIButton *)sender{
    
    [self execAnimation];
    
    if([[[CartManager defaultManager] myCartClassList] count]>0){
        GoodsCartViewController *goodsCartVC=[[GoodsCartViewController alloc] init];
        [self.navigationController pushViewController:goodsCartVC animated:YES];
    }else{
        [self.view makeToast:@"您的购物车还没有任何的商品~"];
    }
    
    
}

-(void)execAnimation{
    RBBTweenAnimation *bounce = [RBBTweenAnimation animationWithKeyPath:@"position.y"];
    bounce.fromValue = @(-3);
    bounce.toValue = @(3);
    bounce.easing = RBBEasingFunctionEaseOutBounce;
    
    bounce.additive = YES;
    bounce.duration = 0.8;
    [cartButton.layer addAnimation:bounce forKey:@"Animation"];
}
-(void)netDataGet{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        goodsList=[[ElApiService shareElApiService] getGoodsList:shopId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self reloadGoodsData:[self segmentIndex]];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionView Delegate


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(currentGoodsList!=nil){
        return [currentGoodsList count];
    }
    return 0;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodsCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"goodsColllectionViewCell" forIndexPath:indexPath];
    TDGoodInfo *goodsInfo=[currentGoodsList objectAtIndex:indexPath.row];
    
    NSArray * imageNames=[goodsInfo.src componentsSeparatedByString:@","];
    NSString *imageName=nil;
    if([imageNames count]>0){
        imageName=[imageNames objectAtIndex:0];
    }
    
    cell.nameLabel.text=goodsInfo.name;
    cell.descLabel.text=goodsInfo.desc;
    cell.priceLabel.text=[NSString stringWithFormat:@"%.1f元",goodsInfo.price];
    NSString *imageURL=[[ElApiService shareElApiService] getGoodsURL:imageName shopId:goodsInfo.shopId];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL]
                      placeholderImage:[UIImage imageNamed:@"icon_default"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TDGoodInfo *goodsInfo=[currentGoodsList objectAtIndex:indexPath.row];
    
    
    GoodsDetailViewController *goodsDetailVC=[[GoodsDetailViewController alloc] init];
    goodsDetailVC.title=goodsInfo.name;
    [goodsDetailVC setGoodInfo:goodsInfo];
    
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
    
}


@end
