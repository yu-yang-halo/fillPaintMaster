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
#import <JSONKit/JSONKit.h>
@interface PanoramaViewController ()<UIWebViewDelegate>
{
   
    int shopId;
     MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic,strong) NSMutableArray *imageWebPaths;
@end

@implementation PanoramaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    
    shopId=[[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SHOP_ID] intValue];
    
    self.imageWebPaths=[NSMutableArray new];
    NSArray *imageNames=[_panorama componentsSeparatedByString:@","];
    for (NSString *imageName in imageNames) {
        
        NSString *webPath=[[ElApiService shareElApiService] getPanoramaURL:imageName shopId:shopId];
        [_imageWebPaths addObject:webPath];
        
    }
    
    NSLog(@"panorama http url:%@",_imageWebPaths);
    
    NSURL *url=[NSURL URLWithString:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"album/index.html"]];
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
    
    CGFloat offsetHeight=[[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    
    CGFloat scrollHeight=[[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    
    NSLog(@"offsetHeight %f  scrollHeight %f",offsetHeight,scrollHeight);
    
    
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"loadImages(%@,%f)",[_imageWebPaths JSONString],scrollHeight]];
    
    
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
