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
@interface GoodsDetailViewController (){
    UIButton *cartButton;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

- (IBAction)miusOne:(id)sender;

- (IBAction)addOne:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
- (IBAction)addToCart:(id)sender;


@end

@implementation GoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.numberTF.text=@"1";
    
    cartButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [cartButton setImage:[UIImage imageNamed:@"cart6"] forState:UIControlStateNormal];
    [cartButton setImageEdgeInsets:UIEdgeInsetsMake(2,10,2,-10)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:cartButton];
    [cartButton addTarget:self action:@selector(goMyCart:) forControlEvents:UIControlEventTouchUpInside];
    self.descLabel.text=_goodInfo.desc;
    self.priceLabel.text=[NSString stringWithFormat:@"%.1f元",_goodInfo.price];
    
    NSString *imageURL=[[ElApiService shareElApiService] getGoodsURL:_goodInfo.src shopId:_goodInfo.shopId];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL]
                      placeholderImage:[UIImage imageNamed:@"icon_default"]];
    
    
    
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
    bounce.fromValue = @(-3);
    bounce.toValue = @(3);
    bounce.easing = RBBEasingFunctionEaseOutBounce;
    
    bounce.additive = YES;
    bounce.duration = 0.8;
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
    int number=[self.numberTF.text intValue];
    number--;
    if(number<=0){
        self.numberTF.text=@"1";
    }else{
        self.numberTF.text=[NSString stringWithFormat:@"%d",number];
    }
    
}

- (IBAction)addOne:(id)sender {
    int number=[self.numberTF.text intValue];
    number++;
    if(number>=100){
        self.numberTF.text=@"100";
    }else{
        self.numberTF.text=[NSString stringWithFormat:@"%d",number];
    }
    
}
- (IBAction)addToCart:(id)sender {
    
    [self execAnimation];
    
    int count=[self.numberTF.text intValue];
    MyCartClass *myCartClass=[[MyCartClass alloc] init];
    [myCartClass setCount:count];
    [myCartClass setGoodInfo:_goodInfo];
    [myCartClass setImage:self.imageView.image];
    [myCartClass setGoodsId:_goodInfo.goodId];
    
    
    [[CartManager defaultManager] addGoodsToCart:myCartClass];
    
    
   
}
@end
