//
//  GoodsDetailViewController.m
//  fillPaintMaster
//
//  Created by admin on 16/4/26.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import <RBBAnimation/RBBTweenAnimation.h>
#import "ElApiService.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GoodsCartViewController.h"
#import <UIView+Toast.h>
#import "CartManager.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "PaddingLabel.h"
#import "GoodsDetailHrefViewController.h"
@interface GoodsDetailViewController (){
    UIButton *cartButton;
}
@property (weak, nonatomic) IBOutlet UIView *bannerView;

@property (weak, nonatomic) IBOutlet PaddingLabel *descLabel;
@property (weak, nonatomic) IBOutlet PaddingLabel *priceLabel;

- (IBAction)miusOne:(id)sender;

- (IBAction)addOne:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *numberTF;

@property (weak, nonatomic) IBOutlet UIButton *addToCartButton;

@property (weak, nonatomic) IBOutlet UIButton *payForButton;
@property (retain, nonatomic)  SDCycleScrollView *cycleScrollView;
@property(nonatomic,strong)  NSMutableArray *imageURLs;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic)  UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *detailView;

@end

@implementation GoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    cartButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [cartButton setImage:[UIImage imageNamed:@"cart6"] forState:UIControlStateNormal];
    [cartButton setImageEdgeInsets:UIEdgeInsetsMake(2,10,2,-10)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:cartButton];
    [cartButton addTarget:self action:@selector(goMyCart:) forControlEvents:UIControlEventTouchUpInside];
    self.descLabel.text=_goodInfo.desc;
    self.priceLabel.text=[NSString stringWithFormat:@"%.1f元",_goodInfo.price];
    
    
    [self initView];
    
    
    
}
-(void)initView{
    
    
    [self.descLabel setLabelEdgeInsets:UIEdgeInsetsMake(0,10, 0, 10)];
    [self.priceLabel setLabelEdgeInsets:UIEdgeInsetsMake(0,10, 0, 10)];
    
    
    self.scrollView=[[UIScrollView alloc] initWithFrame:_containerView.frame];
    
   
    
    [self.numberTF setTitle:@"1" forState:UIControlStateNormal];

    self.addToCartButton.layer.cornerRadius=5.0;
    self.payForButton.layer.cornerRadius=5.0;
    
    [_addToCartButton addTarget:self action:@selector(addToCart:) forControlEvents:UIControlEventTouchUpInside];
    [_payForButton addTarget:self action:@selector(payFor:) forControlEvents:UIControlEventTouchUpInside];
    
    // 网络加载图片的轮播器
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.bannerView.bounds delegate:self placeholderImage:nil];
    
    [self.bannerView addSubview:_cycleScrollView];
    
    [_cycleScrollView setBackgroundColor:[UIColor whiteColor]];
    _cycleScrollView.currentPageDotColor=[UIColor greenColor];
    _cycleScrollView.pageDotColor=[UIColor colorWithWhite:1 alpha:0.4];
    _cycleScrollView.autoScroll=NO;
    _cycleScrollView.bannerImageViewContentMode=UIViewContentModeScaleAspectFit;
    
    
    

    self.imageURLs=[NSMutableArray new];
    
    NSArray *imageNames=[_goodInfo.src componentsSeparatedByString:@","];
    
    for (NSString *name in imageNames) {
        NSString *imageURL=[[ElApiService shareElApiService] getGoodsURL:name shopId:_goodInfo.shopId];
        
        [_imageURLs addObject:imageURL];
    }
    
    _cycleScrollView.imageURLStringsGroup=_imageURLs;
    
    
    UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toDetailView:)];
    [self.detailView addGestureRecognizer:tapGR];
    
}

-(void)toDetailView:(UIGestureRecognizer *)gr{
    
     int number=[self.numberTF.titleLabel.text intValue];
    
    GoodsDetailHrefViewController *goodsDetailHrefVC=[[GoodsDetailHrefViewController alloc] init];
    
    goodsDetailHrefVC.title=self.title;
    goodsDetailHrefVC.goodInfo=_goodInfo;
    goodsDetailHrefVC.count=number;
    goodsDetailHrefVC.imageUrl=_imageURLs.firstObject;
    
    
    [self.navigationController pushViewController:goodsDetailHrefVC animated:YES];
}

-(void)goMyCart:(UIButton *)sender{
    
    if([[[CartManager defaultManager] myCartClassList] count]>0){
        GoodsCartViewController *goodsCartVC=[[GoodsCartViewController alloc] init];
        [self.navigationController pushViewController:goodsCartVC animated:YES];
    }else{
        [self.view makeToast:@"您的购物车还没有任何的商品~"];
    }
    
    
}

-(void)execAnimation{
    RBBTweenAnimation *bounce = [RBBTweenAnimation animationWithKeyPath:@"position.y"];
    bounce.fromValue = @(-6);
    bounce.toValue = @(6);
    bounce.easing = RBBEasingFunctionEaseOutBounce;
    
    bounce.additive = YES;
    bounce.duration = 0.6;
    [cartButton.layer addAnimation:bounce forKey:@"Animation"];
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

- (IBAction)miusOne:(id)sender {
    int number=[self.numberTF.titleLabel.text intValue];
    number--;
    if(number<=0){
         [self.numberTF setTitle:@"1" forState:UIControlStateNormal];
    }else{
         [self.numberTF setTitle:[NSString stringWithFormat:@"%d",number] forState:UIControlStateNormal];
    }
    
}

- (IBAction)addOne:(id)sender {
    int number=[self.numberTF.titleLabel.text intValue];
    number++;
    if(number>=100){
        [self.numberTF setTitle:@"100" forState:UIControlStateNormal];
    }else{
        [self.numberTF setTitle:[NSString stringWithFormat:@"%d",number] forState:UIControlStateNormal];
    }
    
}
-(void)payFor:(id)sender{
    [self addToCart:sender];
    [self goMyCart:sender];
    
}
- (void)addToCart:(id)sender {
    
    [self execAnimation];
    
    int count=[self.numberTF.titleLabel.text intValue];
    MyCartClass *myCartClass=[[MyCartClass alloc] init];
    [myCartClass setCount:count];
    [myCartClass setGoodInfo:_goodInfo];
    [myCartClass setImageUrl:_imageURLs.firstObject];
    
    [myCartClass setGoodsId:_goodInfo.goodId];
    
    
    [[CartManager defaultManager] addGoodsToCart:myCartClass];
    
   
}
@end
