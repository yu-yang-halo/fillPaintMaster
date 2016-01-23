//
//  ShopView1Controller.m
//  fillPaintMaster
//
//  Created by apple on 16/1/1.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "ShopView1Controller.h"
#import "MonitorViewController.h"
@interface ShopView1Controller ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *channelImageView0;
@property (weak, nonatomic) IBOutlet UIImageView *channelImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *channelImageView2;

@property (weak, nonatomic) IBOutlet UIImageView *channelImageView3;

@end

@implementation ShopView1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    MonitorViewController  *monitor0=[[MonitorViewController alloc] initUID:@"5NYMJK5PENUPZY98111A" withPass:@"admin"];
    
    [self.channelImageView0 addSubview:monitor0.view];
    
    MonitorViewController  *monitor1=[[MonitorViewController alloc] initUID:@"X54G85ZXC4L8W1YG111A" withPass:@"admin"];
    
    [self.channelImageView0 addSubview:monitor1.view];
    
    MonitorViewController  *monitor2=[[MonitorViewController alloc] initUID:@"5NYMJK5PENUPZY98111A" withPass:@"admin"];
    
    [self.channelImageView0 addSubview:monitor2.view];
    
    MonitorViewController  *monitor3=[[MonitorViewController alloc] initUID:@"X54G85ZXC4L8W1YG111A" withPass:@"admin"];
    
    [self.channelImageView0 addSubview:monitor3.view];
    
   
}
-(void)awakeFromNib{
    
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

@end
