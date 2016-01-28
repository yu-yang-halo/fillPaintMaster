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
@interface ShopView1Controller (){
    CGRect originFram0;
    CGRect originFram1;
    CGRect originFram2;
    CGRect originFram3;
}
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
@property(nonatomic,strong) LiveViewController *liveVC;
@property (weak, nonatomic) IBOutlet UIButton *closeBigVideoShowBtn;
@property (weak, nonatomic) IBOutlet UILabel *bigVideoStatusLabel;

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
    
    originFram0=self.channelImageView0.frame;
    originFram1=self.channelImageView1.frame;
    originFram2=self.channelImageView2.frame;
    originFram3=self.channelImageView3.frame;
    
    
    
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
   
  self.uids=@[@"5NYMJK5PENUPZY98111A",@"X54G85ZXC4L8W1YG111A",@"8YM2LT63DMWXPBUG111A",@"PRAD13G9VNCB43AT111A"];
    NSArray *views=@[self.channelImageView0,self.channelImageView1,self.channelImageView2,self.channelImageView3];
    
    self.monitor0=[[MonitorViewController alloc] initUIDS:_uids viewArr:views];
    
    [self openVideoStream];
    self.liveVC=[[LiveViewController alloc] init];

   [self.singleView addSubview:self.liveVC.view];
    
    
}
-(void)clickGesture:(UIButton *)sender{
    NSLog(@"sender %@ tag %d",sender,sender.tag);
  
   [self closeVideoStream];
    
    [self.button0 setEnabled:NO];
    [self.button1 setEnabled:NO];
    [self.button2 setEnabled:NO];
    [self.button3 setEnabled:NO];
   
    
    
    
   [self performSelector:@selector(showSingleVideo:) withObject:[NSNumber numberWithInt:sender.tag] afterDelay:2];
   
    
    
}
-(void)showSingleVideo:(NSNumber *)tag{
    [self.liveVC startVideoShow:[_uids objectAtIndex:[tag intValue]] withPass:@"admin"];
    [self.liveVC recordCameraState:self.bigVideoStatusLabel];
    [self.bigVideoStatusLabel setHidden:NO];
    [self.closeBigVideoShowBtn setHidden:NO];
    [self.singleView setHidden:NO];
}
-(void)closeBigVideo:(UIButton *)sender{
    [self.liveVC stop];
    
    [self.closeBigVideoShowBtn setHidden:YES];
    [self.singleView setHidden:YES];
    [self.bigVideoStatusLabel setHidden:YES];
    
    [self.button0 setEnabled:YES];
    [self.button1 setEnabled:YES];
    [self.button2 setEnabled:YES];
    [self.button3 setEnabled:YES];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self performSelector:@selector(beginShowVideos) withObject:nil afterDelay:2];
    });
    
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
   imageView.layer.borderColor=[[UIColor colorWithWhite:0 alpha:0.4] CGColor];
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
