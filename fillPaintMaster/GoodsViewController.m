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

@interface GoodsViewController ()<JYSlideSegmentDelegate>
{
    int shopId;

    NSArray *goodsList;
    UIButton *cartButton;
}
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
    
    
    self.indicatorColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    [self.segmentBar setBackgroundColor:[UIColor blackColor]];
    shopId=[[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SHOP_ID] intValue];
    [self netDataGet];
    
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
            
            for(GoodDataSourceViewController *vc in self.viewControllers){
                [vc setAllGoods:goodsList];
                [vc setDelegateVC:self];
            }
        });
    });
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
- (void)slideSegment:(UICollectionView *)segmentBar didSelectedViewController:(UIViewController *)viewController{
    
}

- (BOOL)slideSegment:(UICollectionView *)segmentBar shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}


@end
