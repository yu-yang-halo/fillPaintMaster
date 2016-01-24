//
//  AppMonitorViewController.h
//  IOTCamSample
//
//  Created by Cloud Hsiao on 12/7/17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IOTCamera/AVIOCTRLDEFs.h>
#import <IOTCamera/Camera.h>
#import <IOTCamera/Monitor.h>

#import "CameraShowGLView.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "MyCamera.h"
#define MAX_IMG_BUFFER_SIZE	(1280*720*4)
@interface MonitorViewController : UIViewController <MyCameraDelegate,MonitorTouchDelegate>
{
	unsigned short mCodecId;
	CameraShowGLView *glView;
	CVPixelBufferPoolRef mPixelBufferPool;
	CVPixelBufferRef mPixelBuffer;
	CGSize mSizePixelBuffer;

	BOOL bStopShowCompletedLock;
	

    Monitor *monitor;
}
-(instancetype)initUIDS:(NSArray *)uids viewArr:(NSArray *)views;
-(void)beginShowVideos;
-(void)endShowVideos;
-(void)recordCameraState:(UILabel *)label;
@property (nonatomic, assign) BOOL bStopShowCompletedLock;
@property (nonatomic, assign) unsigned short mCodecId;
@property (nonatomic, assign) CGSize mSizePixelBuffer;
@property (nonatomic, assign) CameraShowGLView *glView;
@property CVPixelBufferPoolRef mPixelBufferPool;
@property CVPixelBufferRef mPixelBuffer;

@property (nonatomic, retain) Monitor *monitor;
@property (nonatomic, retain) NSString *videoUID;
@property (nonatomic, retain) NSString *videoPass;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollViewPortrait;

@property (nonatomic,retain) UIImage *image;
-(void)stop;
- (void)activeAudioSession:(NSInteger)selectedAudioMode;
- (void)unactiveAudioSession;
-(void)snapshot;
@end
