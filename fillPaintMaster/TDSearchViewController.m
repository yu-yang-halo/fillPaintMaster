//
//  TDSearchViewController.m
//  fillPaintMaster
//
//  Created by apple on 16/1/9.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "TDSearchViewController.h"
#import <UIView+Toast.h>
@interface TDSearchViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)back:(id)sender;

@end

@implementation TDSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view makeToastActivity:CSToastPositionCenter];
    [self initMapView];
}
-(void)initMapView{
    //search.html
    self.webView.delegate=self;
    
    NSString *path=[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"search.html"];
    
    NSString *htmlString=[[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    
    [self.webView loadHTMLString:htmlString baseURL:[[NSBundle mainBundle] bundleURL]];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"webViewDidStartLoad");
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webViewDidFinishLoad");
    [self.view hideToastActivity];
}



- (IBAction)back:(id)sender {
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Tsearch dismissViewControllerAnimated...");
        
    }];
}
@end
