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

@property(nonatomic,retain) MonitorViewController *monitor0;
@end

@implementation ShopView1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self setImageViewStyle:self.channelImageView0];
    [self setImageViewStyle:self.channelImageView1];
    [self setImageViewStyle:self.channelImageView2];
    [self setImageViewStyle:self.channelImageView3];
   
    NSArray *uids=@[@"5NYMJK5PENUPZY98111A",@"X54G85ZXC4L8W1YG111A",@"8YM2LT63DMWXPBUG111A"];
    NSArray *views=@[self.channelImageView0,self.channelImageView1,self.channelImageView2];
    
    self.monitor0=[[MonitorViewController alloc] initUIDS:uids viewArr:views];
    
    
}
-(void)openVideoStream{
    [self.monitor0 beginShowVideos];
}
-(void)closeVideoStream{
    [self.monitor0 endShowVideos];
}
-(void)setImageViewStyle:(UIImageView *)imageView{
   imageView.layer.borderWidth=1;
   [imageView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.9]];
   imageView.layer.borderColor=[[UIColor greenColor] CGColor];
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
