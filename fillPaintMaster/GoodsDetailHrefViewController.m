//
//  GoodsDetailHrefViewController.m
//  fillPaintMaster
//
//  Created by admin on 16/6/23.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "GoodsDetailHrefViewController.h"
#import "GoodsCartViewController.h"
#import "CartManager.h"
#import <UIView+Toast.h>
#import <RBBAnimation/RBBTweenAnimation.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface GoodsDetailHrefViewController ()<UIWebViewDelegate>{
     UIButton *cartButton;
     MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *payForButton;
@property (weak, nonatomic) IBOutlet UIButton *addToCartButton;

@end

@implementation GoodsDetailHrefViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    cartButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [cartButton setImage:[UIImage imageNamed:@"cart6"] forState:UIControlStateNormal];
    [cartButton setImageEdgeInsets:UIEdgeInsetsMake(2,10,2,-10)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:cartButton];
    [cartButton addTarget:self action:@selector(goMyCart:) forControlEvents:UIControlEventTouchUpInside];
    
    self.addToCartButton.layer.cornerRadius=5.0;
    self.payForButton.layer.cornerRadius=5.0;
    
    [_addToCartButton addTarget:self action:@selector(addToCart:) forControlEvents:UIControlEventTouchUpInside];
    [_payForButton addTarget:self action:@selector(payFor:) forControlEvents:UIControlEventTouchUpInside];
    
    self.webView.delegate=self;
    
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:_goodInfo.href]];
    [self.webView loadRequest:request];
    
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";

}

-(void)payFor:(id)sender{
    [self addToCart:sender];
    [self goMyCart:sender];
    
}
- (void)addToCart:(id)sender {
    
    [self execAnimation];
   
    MyCartClass *myCartClass=[[MyCartClass alloc] init];
    [myCartClass setCount:_count];
    [myCartClass setGoodInfo:_goodInfo];
    [myCartClass setImageUrl:_imageUrl];
    
    [myCartClass setGoodsId:_goodInfo.goodId];
    
    
    [[CartManager defaultManager] addGoodsToCart:myCartClass];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if(hud!=nil){
        [hud hide:YES];
    }
}

@end
