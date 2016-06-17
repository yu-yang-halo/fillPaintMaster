//
//  TDPromotionWebViewController.m
//  fillPaintMaster
//
//  Created by admin on 16/6/15.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "TDPromotionWebViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ElApiService.h"
#import <UIView+Toast.h>
@interface TDPromotionWebViewController ()<UIWebViewDelegate>{
   MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *getPromotionButton;

@end

@implementation TDPromotionWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    
    NSURL *URL=[NSURL URLWithString:self.url];
    NSURLRequest *request=[NSURLRequest requestWithURL:URL];
    
    self.webView.delegate=self;
    [self.webView loadRequest:request];
    
    self.title=@"优惠活动";
    
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    self.getPromotionButton.layer.cornerRadius=5;
    
    
    [self.getPromotionButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)buttonClick:(id)sender{
    
    MBProgressHUD *hud2 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud2.labelText = @"领取中...";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL isSUC=[[ElApiService shareElApiService] updCoupon:_promotionId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud2 hide:YES];
            if(isSUC){
                [self.view makeToast:@"活动优惠券领取成功"];
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
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if(hud!=nil){
        [hud hide:YES];
    }
}


@end
