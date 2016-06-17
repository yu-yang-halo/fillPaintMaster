//
//  TDWebViewController.m
//  fillPaintMaster
//
//  Created by apple on 16/4/16.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "TDWebViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface TDWebViewController ()<UIWebViewDelegate>
{
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation TDWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    
    NSURL *URL=[NSURL URLWithString:self.url];
    NSURLRequest *request=[NSURLRequest requestWithURL:URL];
    
     self.webView.delegate=self;
    [self.webView loadRequest:request];
    
    if(self.title==nil){
         self.title=@"广告详情";
    }
    
    
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
   

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if(hud!=nil){
        [hud hide:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
