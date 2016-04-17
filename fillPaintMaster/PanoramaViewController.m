//
//  PanoramaViewController.m
//  fillPaintMaster
//
//  Created by apple on 16/4/17.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "PanoramaViewController.h"
#import "ElApiService.h"
#import "Constants.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface PanoramaViewController ()<UIWebViewDelegate>
{
    NSString *webPath;
    int shopId;
     MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation PanoramaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    
    shopId=[[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SHOP_ID] intValue];
    
    webPath=[[ElApiService shareElApiService] getPanoramaURL:_panorama shopId:shopId];
    
    NSLog(@"panorama http url:%@",webPath);
    
    NSURL *url=[NSURL URLWithString:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"panorama/demo.html"]];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    [self.webView setScalesPageToFit:YES];
     self.webView.delegate=self;
    
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"加载中...";
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [hud hide:YES];
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"initImageURL('%@')",webPath]];
    
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
