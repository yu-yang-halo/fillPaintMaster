//
//  ShopView1Controller.m
//  fillPaintMaster
//
//  Created by apple on 16/1/1.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "ShopView1Controller.h"
#import "MonitorViewController.h"
#import "LiveViewController.h"
@interface ShopView1Controller ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *channelImageView0;
@property (weak, nonatomic) IBOutlet UIImageView *channelImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *channelImageView2;

@property (weak, nonatomic) IBOutlet UIImageView *channelImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *singleView;

@property (weak, nonatomic) IBOutlet UIButton *button0;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property(nonatomic,retain) MonitorViewController *monitor0;
@property(nonatomic,retain) NSArray *uids;
@property(nonatomic,retain) LiveViewController *liveVC;
@property (weak, nonatomic) IBOutlet UIButton *closeBigVideoShowBtn;

@end

@implementation ShopView1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.singleView setHidden:YES];
    [self.closeBigVideoShowBtn setHidden:YES];
    
    [self setImageViewStyle:self.channelImageView0];
    [self setImageViewStyle:self.channelImageView1];
    [self setImageViewStyle:self.channelImageView2];
    [self setImageViewStyle:self.channelImageView3];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGesture:)];
    
    [tap setNumberOfTouchesRequired:1];
    [self.button0 setTag:0];
    [self.button1 setTag:1];
    [self.button2 setTag:2];
    [self.button3 setTag:3];
    
    [self.button0 addTarget:self action:@selector(clickGesture:) forControlEvents:UIControlEventTouchUpInside];
    [self.button1 addTarget:self action:@selector(clickGesture:) forControlEvents:UIControlEventTouchUpInside];
    [self.button2 addTarget:self action:@selector(clickGesture:) forControlEvents:UIControlEventTouchUpInside];
    [self.button3 addTarget:self action:@selector(clickGesture:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.closeBigVideoShowBtn addTarget:self action:@selector(closeBigVideo:) forControlEvents:UIControlEventTouchUpInside];
   
  self.uids=@[@"5NYMJK5PENUPZY98111A",@"X54G85ZXC4L8W1YG111A",@"8YM2LT63DMWXPBUG111A"];
    NSArray *views=@[self.channelImageView0,self.channelImageView1,self.channelImageView2];
    
    self.monitor0=[[MonitorViewController alloc] initUIDS:_uids viewArr:views];
    
    [self openVideoStream];
    
}
-(void)clickGesture:(UIButton *)sender{
    NSLog(@"sender %@ tag %d",sender,sender.tag);
    [self closeVideoStream];
     self.liveVC=[[LiveViewController alloc] initUID:[_uids objectAtIndex:sender.tag] withPass:@"admin"];
    CGRect frame=_liveVC.view.frame;
    frame.origin.y=-60;
    _liveVC.view.frame=frame;
    //_liveVC.view.frame=_singleView.frame;
    [self.singleView setUserInteractionEnabled:YES];
    [self.singleView addSubview:_liveVC.view];
    [self.singleView setHidden:NO];
    [self.closeBigVideoShowBtn setHidden:NO];
}
-(void)closeBigVideo:(UIButton *)sender{
    [self.liveVC stop];
    [self.singleView setHidden:YES];
    [self.closeBigVideoShowBtn setHidden:YES];
    [self openVideoStream];
    
}

-(void)openVideoStream{
    [self.monitor0 beginShowVideos];
}
-(void)closeVideoStream{
    [self.monitor0 endShowVideos];
    [self.liveVC stop];
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
