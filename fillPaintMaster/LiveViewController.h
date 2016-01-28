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
#import "MonitorViewController.h"
#import "CameraShowGLView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#define MAX_IMG_BUFFER_SIZE	(1280*720*4)

@interface LiveViewController : UIViewController <CameraDelegate,MonitorTouchDelegate>
{
    unsigned short mCodecId;
    CameraShowGLView *glView;
    CVPixelBufferPoolRef mPixelBufferPool;
    CVPixelBufferRef mPixelBuffer;
    CGSize mSizePixelBuffer;
    
    BOOL bStopShowCompletedLock;
    
    Camera *camera;
}
-(void)startVideoShow:(NSString *)uid withPass:(NSString *)pass;
-(instancetype)initUID:(NSString *)uid withPass:(NSString *)pass;
-(void)recordCameraState:(UILabel *)label;
@property (nonatomic, assign) BOOL bStopShowCompletedLock;
@property (nonatomic, assign) unsigned short mCodecId;
@property (nonatomic, assign) CGSize mSizePixelBuffer;
@property (nonatomic, assign) CameraShowGLView *glView;
@property CVPixelBufferPoolRef mPixelBufferPool;
@property CVPixelBufferRef mPixelBuffer;
@property (nonatomic, retain) Camera *camera;
@property (nonatomic, retain) NSString *videoUID;
@property (nonatomic, retain) NSString *videoPass;

@property (nonatomic,retain) UIImage *image;
-(void)stop;
- (void)activeAudioSession:(NSInteger)selectedAudioMode;
- (void)unactiveAudioSession;
-(void)snapshot;
@end
