//
//  ShopView0Controller.m
//  fillPaintMaster
//
//  Created by apple on 16/1/1.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "ShopView0Controller.h"
#import <UIView+Toast.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "TDAlbumViewController.h"
@interface ShopView0Controller ()
{
  
}
@property (retain, nonatomic) UIWebView *webView;
@end

@implementation ShopView0Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad....");
    [self initMapView];
}
-(void)initMapView{
    //panoroma.html
    self.webView=[[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate=self;
    
    NSString *path=[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"location.html"];
    
    NSString *htmlString=[[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    
    [self.webView loadHTMLString:htmlString baseURL:[[NSBundle mainBundle] bundleURL]];
    
    [self.view addSubview:_webView];
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"clickToAlbum"]=^(){
        NSLog(@"clickToAlbum....");
        
        NSArray *args=[JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"argument : %@",jsVal.toString);
        }
        JSValue *thiz=[JSContext currentThis];
        
        NSLog(@"end....%@",thiz);
        [self toggleAlbumVC];
       
    };
}

-(void)toggleAlbumVC{
    TDAlbumViewController *tdAlbumVC=[[TDAlbumViewController alloc] init];
    
    [self.tdShopVCDelegate.navigationController pushViewController:tdAlbumVC animated:YES];
}

-(void)viewDidLayoutSubviews{
    self.webView.frame=self.view.bounds;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"webViewDidStartLoad");
    [self.view makeToastActivity:CSToastPositionCenter];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webViewDidFinishLoad");
    [self.view hideToastActivity];
    
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
