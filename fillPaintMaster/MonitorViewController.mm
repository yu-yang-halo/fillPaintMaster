//
//  AppMonitorViewController.m
//  IOTCamSample
//
//  Created by Cloud Hsiao on 12/7/17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MonitorViewController.h"
#import <IOTCamera/AVFRAMEINFO.h>
#import <IOTCamera/ImageBuffInfo.h>
#import <AVFoundation/AVFoundation.h>
#import <sys/time.h>

#define DEF_SplitViewNum		4
#define DEF_ReTryConnectInterval 25*1000
#define DEF_ReTryTimes			10
unsigned int _getTickCount() {
    
    struct timeval tv;
    
    if (gettimeofday(&tv, NULL) != 0)
        return 0;
    
    return (tv.tv_sec * 1000 + tv.tv_usec / 1000);
}

@interface MonitorViewController (){
    UILabel *mlabel;
    int mchannel;
    NSTimer* mTimerStartShowRevoke;
    int mnReTryTimesArray[DEF_SplitViewNum];
    unsigned int mnLastReTryTickArray[DEF_SplitViewNum];
    
}
@property(nonatomic,retain) NSArray *mUIDList;
@property(nonatomic,retain) NSArray *mViewList;
@property(nonatomic,retain) NSMutableArray *mCameraList;
@end

@implementation MonitorViewController

@synthesize bStopShowCompletedLock;
@synthesize mCodecId;
@synthesize glView;
@synthesize mPixelBufferPool;
@synthesize mPixelBuffer;
@synthesize mSizePixelBuffer;
@synthesize monitor;
@synthesize image;
#define DEF_WAIT4STOPSHOW_TIME	250

-(void)stop
{
//    if(mTimerStartShowRevoke!=nil){
//        [mTimerStartShowRevoke invalidate];
//        mTimerStartShowRevoke = nil;
//    }
   
    for (MyCamera *camera in _mCameraList) {
        [camera disconnect];
        [camera stopSoundToPhone:0];
        [camera stopShow:0];
        
        [camera stop:0];
        
        [camera setDelegate2:nil];
    }
    [self waitStopShowCompleted:DEF_WAIT4STOPSHOW_TIME];
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
//    if(mTimerStartShowRevoke!=nil){
//        [mTimerStartShowRevoke invalidate];
//        mTimerStartShowRevoke = nil;
//    }
    
}


-(instancetype)initUIDS:(NSArray *)uids viewArr:(NSArray *)views{
    self=[super init];
    if(self){
        self.mUIDList=uids;
        self.mViewList=views;
        self.mCameraList=[[NSMutableArray alloc] init];
        
    }
    return self;
}
-(void)endShowVideos{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self stop];
    });
    
}
-(void)beginShowVideos{
    mchannel=0;
    for (NSString *uid in _mUIDList) {
        MyCamera *camera = [[MyCamera alloc] initWithName:uid];
        camera.delegate2=self;
        [camera connect:uid];//8YM2LT63DMWXPBUG111A
        [camera start:0 viewAccount:@"admin"  viewPassword:@"admin" is_playback:FALSE];
        [camera startShow:mchannel ScreenObject:self];
        SMsgAVIoctrlGetAudioOutFormatReq *s = (SMsgAVIoctrlGetAudioOutFormatReq *)malloc(sizeof(SMsgAVIoctrlGetAudioOutFormatReq));
        s->channel = mchannel;
        [camera sendIOCtrlToChannel:mchannel Type:IOTYPE_USER_IPCAM_GETAUDIOOUTFORMAT_REQ Data:(char *)s DataSize:sizeof(SMsgAVIoctrlGetAudioOutFormatReq)];
        free(s);
        
        SMsgAVIoctrlGetSupportStreamReq *s2 = (SMsgAVIoctrlGetSupportStreamReq *)malloc(sizeof(SMsgAVIoctrlGetSupportStreamReq));
        [camera sendIOCtrlToChannel:mchannel Type:IOTYPE_USER_IPCAM_GETSUPPORTSTREAM_REQ Data:(char *)s2 DataSize:sizeof(SMsgAVIoctrlGetSupportStreamReq)];
        free(s2);
        
        SMsgAVIoctrlTimeZone s3={0};
        s3.cbSize = sizeof(s3);
        [camera sendIOCtrlToChannel:mchannel Type:IOTYPE_USER_IPCAM_GET_TIMEZONE_REQ Data:(char *)&s3 DataSize:sizeof(s3)];
        [self.mCameraList addObject:camera];
        [camera release];
    }
    
//    mTimerStartShowRevoke = [NSTimer scheduledTimerWithTimeInterval:3.6 target:self selector:@selector(onTimerStartShowRevoke:) userInfo:nil repeats:YES];

}


-(void)onTimerStartShowRevoke:(NSTimer*)aTimer {
    
    int idx = 0;
    for( MyCamera* theCamera in _mCameraList ) {
       
        
        if( theCamera.sessionState == CONNECTION_STATE_CONNECTED &&
           [theCamera getConnectionStateOfChannel:0] == CONNECTION_STATE_CONNECTED &&
           ![theCamera isAVChannelStartShow:0] ) {
            
            [theCamera startShow:0 ScreenObject:self];
            theCamera.delegate2 = self;
            
        }
        else if( theCamera.sessionState != CONNECTION_STATE_CONNECTING &&
                theCamera.sessionState != CONNECTION_STATE_WRONG_PASSWORD ) {
            
            unsigned int now = _getTickCount();
            if( now - mnLastReTryTickArray[idx] > DEF_ReTryConnectInterval &&
               mnReTryTimesArray[idx] <= DEF_ReTryTimes ) {
                
                [theCamera connect:theCamera.uid];
                [theCamera start:0 viewAccount:@"admin"  viewPassword:@"admin" is_playback:FALSE];
                
                mnLastReTryTickArray[idx] = _getTickCount();
                mnReTryTimesArray[idx] += 1;
                
            }
        }
        
        idx++;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:[UIColor clearColor]];
  
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(cameraStopShowCompleted:) name: @"CameraStopShowCompleted" object: nil];
    
    
    
}
-(void)recordCameraState:(UILabel *)label{
    mlabel=label;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Camera Delegate
- (void)camera:(MyCamera *)camera didChangeChannelStatus:(NSInteger)channel ChannelStatus:(NSInteger)status
{
    switch (status) {
        case CONNECTION_STATE_CONNECTED:
            break;
            
        case CONNECTION_STATE_CONNECTING:
            break;
            
        case CONNECTION_STATE_DISCONNECTED:
            break;
            
        case CONNECTION_STATE_CONNECT_FAILED:
            break;
            
        case CONNECTION_STATE_TIMEOUT:
            break;
            
        case CONNECTION_STATE_UNKNOWN_DEVICE:
            break;
            
        case CONNECTION_STATE_UNSUPPORTED:
            break;
            
        case CONNECTION_STATE_WRONG_PASSWORD:
            break;
            
        default:
            break;
    }
}

- (void)camera:(MyCamera *)camera didChangeSessionStatus:(NSInteger)status
{
    NSString *message=nil;
    switch (status) {
        case CONNECTION_STATE_CONNECTED:
            message=NSLocalizedString(@"connect_suc", nil);
          
            break;
            
        case CONNECTION_STATE_CONNECTING:
            message=NSLocalizedString(@"connecting",nil);
            break;
            
        case CONNECTION_STATE_DISCONNECTED:
            message=NSLocalizedString(@"unconnect",nil);
            break;
            
        case CONNECTION_STATE_CONNECT_FAILED:
            message=NSLocalizedString(@"connect_fail",nil);
            break;
            
        case CONNECTION_STATE_TIMEOUT:
            message=NSLocalizedString(@"connect_timeout",nil);
            break;
            
        case CONNECTION_STATE_UNKNOWN_DEVICE:
            message=NSLocalizedString(@"unknown_device",nil);
            break;
            
        case CONNECTION_STATE_UNSUPPORTED:
            message=@"";
            break;
            
        case CONNECTION_STATE_WRONG_PASSWORD:
             message=NSLocalizedString(@"passerror", nil);
            break;
            
        default:
             message=@"";
            break;
    }
    mlabel.text=message;
    if(status==CONNECTION_STATE_CONNECTED){
        
    }
    
}

- (void)camera:(MyCamera *)camera didReceiveFrameInfoWithVideoWidth:(NSInteger)videoWidth VideoHeight:(NSInteger)videoHeight VideoFPS:(NSInteger)fps VideoBPS:(NSInteger)videoBps AudioBPS:(NSInteger)audioBps OnlineNm:(NSInteger)onlineNm FrameCount:(unsigned long)frameCount IncompleteFrameCount:(unsigned long)incompleteFrameCount
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"videoWidth %d videoHeight %d",videoWidth,videoHeight);
    });
    
    
}

- (void)camera:(MyCamera *)camera didReceiveIOCtrlWithType:(NSInteger)type Data:(const char *)data DataSize:(NSInteger)size
{
    NSLog(@"didReceiveIOCtrlWithType %d %s",type,data);
    if (type == IOTYPE_USER_IPCAM_LISTWIFIAP_RESP) {
       NSLog(@"**********IOTYPE_USER_IPCAM_LISTWIFIAP_RESP********");
        
        SMsgAVIoctrlListWifiApResp *s = (SMsgAVIoctrlListWifiApResp *)data;
        int wifiStatus = 0;
        
        NSLog( @"AP num:%d", s->number );
        for (int i = 0; i < s->number; ++i) {
            
            SWifiAp ap = s->stWifiAp[i];
            NSLog( @" [%d] ssid:%s, mode => %d, enctype => %d, signal => %d%%, status => %d", i, ap.ssid, ap.mode, ap.enctype, ap.signal, ap.status );
            if (ap.status == 1 || ap.status == 2 || ap.status == 3 || ap.status == 4) {
                NSString* wifiSSID = [NSString stringWithCString:ap.ssid encoding:NSUTF8StringEncoding];
                wifiStatus = ap.status;
                NSLog(@"wifiStatus %d wifiSSID %@",wifiStatus,wifiSSID);
            }
            
        }
        
       
    }
}

- (void)camera:(MyCamera *)camera didReceiveJPEGDataFrame:(const char *)imgData DataSize:(NSInteger)size
{
    /*
     * You may use the code snippet as below to get an image.
     
     NSData *data = [NSData dataWithBytes:imgData length:size];
     self.image = [UIImage imageWithData:data];
     
     */
}

- (void)camera:(MyCamera *)camera didReceiveRawDataFrame:(const char *)imgData VideoWidth:(NSInteger)width VideoHeight:(NSInteger)height
{
    /* You may use the code snippet as below to get an image. */
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgData, width * height * 3, NULL);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef imgRef = CGImageCreate(width, height, 8, 24, width * 3, colorSpace, kCGBitmapByteOrderDefault, provider, NULL, true,  kCGRenderingIntentDefault);
    
    UIImage *img = [[UIImage alloc] initWithCGImage:imgRef];
    
    /* Set "img" to your own image object. */
    // self.image = img;
    
    [img release];
    
    if (imgRef != nil) {
        CGImageRelease(imgRef);
        imgRef = nil;
    }
    
    if (colorSpace != nil) {
        CGColorSpaceRelease(colorSpace);
        colorSpace = nil;
    }
    
    if (provider != nil) {
        CGDataProviderRelease(provider);
        provider = nil;
    }
}

- (void)removeGLView :(BOOL)toPortrait
{
    if( glView ) {
        BOOL bRemoved = FALSE;
        
        for (UIView *subView in self.view.subviews) {
            
            if ([subView isKindOfClass:[CameraShowGLView class]]) {
                
                [subView removeFromSuperview];
                NSLog( @"glView has been removed from view <OK>" );
                bRemoved = TRUE;
                break;
            }
        }
        if( !bRemoved ) {
            for (UIView *subView in self.view.subviews) {
                
                if ([subView isKindOfClass:[CameraShowGLView class]]) {
                    
                    [subView removeFromSuperview];
                    NSLog( @"glView has been removed from view <OK>" );
                    bRemoved = TRUE;
                    break;
                }
            }
        }
    }
}

- (void)glFrameSize:(NSArray*)param
{
    CGSize* pglFrameSize_Original = (CGSize*)[(NSValue*)[param objectAtIndex:0] pointerValue];
    CGSize* pglFrameSize_Scaling = (CGSize*)[(NSValue*)[param objectAtIndex:1] pointerValue];
    
    
    *pglFrameSize_Scaling = *pglFrameSize_Original;
}

- (void)reportCodecId:(NSValue*)pointer
{
   
}


- (void)updateToScreen2:(NSArray*)arrs {
   
    @autoreleasepool
    {
        CIImage *ciImage = [arrs objectAtIndex:0];
        NSString *uid = [arrs objectAtIndex:1];
        NSNumber *channel = [arrs objectAtIndex:2];
        UIImage *img = [UIImage imageWithCIImage:ciImage scale:0.8 orientation:UIImageOrientationUp];
        int index=0;
        for (int i=0;i<[_mCameraList count];i++) {
            MyCamera *cm=[_mCameraList objectAtIndex:i];
            if([cm.uid isEqualToString:uid]){
                index=i;
                break;
            }
            
        }
        NSLog(@"#####channel %@  uid %@",channel,uid);
        [(UIImageView *)[self.mViewList objectAtIndex:index] setImage:img];
        
        
           
    }
}

//
//- (void)updateToScreen:(NSValue*)pointer
//{
//    LPSIMAGEBUFFINFO pScreenBmpStore = (LPSIMAGEBUFFINFO)[pointer pointerValue];
//    if( mPixelBuffer == nil ||
//       mSizePixelBuffer.width != pScreenBmpStore->nWidth ||
//       mSizePixelBuffer.height != pScreenBmpStore->nHeight ) {
//        
//        if(mPixelBuffer) {
//            CVPixelBufferRelease(mPixelBuffer);
//            CVPixelBufferPoolRelease(mPixelBufferPool);
//        }
//        
//        NSMutableDictionary* attributes;
//        attributes = [NSMutableDictionary dictionary];
//        [attributes setObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(NSString*)kCVPixelBufferPixelFormatTypeKey];
//        [attributes setObject:[NSNumber numberWithInt:pScreenBmpStore->nWidth] forKey: (NSString*)kCVPixelBufferWidthKey];
//        [attributes setObject:[NSNumber numberWithInt:pScreenBmpStore->nHeight] forKey: (NSString*)kCVPixelBufferHeightKey];
//        
//        CVReturn err = CVPixelBufferPoolCreate(kCFAllocatorDefault, NULL, (CFDictionaryRef) attributes, &mPixelBufferPool);
//        if( err != kCVReturnSuccess ) {
//            NSLog( @"mPixelBufferPool create failed!" );
//        }
//        err = CVPixelBufferPoolCreatePixelBuffer (NULL, mPixelBufferPool, &mPixelBuffer);
//        if( err != kCVReturnSuccess ) {
//            NSLog( @"mPixelBuffer create failed!" );
//        }
//        mSizePixelBuffer = CGSizeMake(pScreenBmpStore->nWidth, pScreenBmpStore->nHeight);
//        NSLog( @"CameraLiveViewController - mPixelBuffer created %dx%d nBytes_per_Row:%d", pScreenBmpStore->nWidth, pScreenBmpStore->nHeight, pScreenBmpStore->nBytes_per_Row );
//    }
//    CVPixelBufferLockBaseAddress(mPixelBuffer,0);
//    
//    UInt8* baseAddress = (UInt8*)CVPixelBufferGetBaseAddress(mPixelBuffer);
//    
//    memcpy(baseAddress, pScreenBmpStore->pData_buff, pScreenBmpStore->nBytes_per_Row * pScreenBmpStore->nHeight );
//    
//    CVPixelBufferUnlockBaseAddress(mPixelBuffer,0);
//    
//    [glView renderVideo:mPixelBuffer];
//
//}

- (void)waitStopShowCompleted:(unsigned int)uTimeOutInMs
{
    unsigned int uStart = _getTickCount();
    while( self.bStopShowCompletedLock == FALSE ) {
        usleep(1000);
        unsigned int now = _getTickCount();
        if( now - uStart >= uTimeOutInMs ) {
            NSLog( @"CameraLiveViewController - waitStopShowCompleted !!!TIMEOUT!!!" );
            break;
        }
    }
    
}

- (void)cameraStopShowCompleted:(NSNotification *)notification
{
    bStopShowCompletedLock = TRUE;
    NSLog(@"cameraStopShowCompleted...bStopShowCompletedLock = TRUE");
   
}

-(void)dealloc{
    
    [super dealloc];
    
    NSLog(@"monitorVC release...");
}

#pragma mark - AudioSession implementations
- (void)activeAudioSession:(NSInteger)selectedAudioMode
{
    
#if 0
    OSStatus error;
    
    UInt32 category = kAudioSessionCategory_LiveAudio;
    
    if (selectedAudioMode == 1) {
        category = kAudioSessionCategory_LiveAudio;
        NSLog(@"kAudioSessionCategory_LiveAudio");
    }
    
    if (selectedAudioMode == 2) {
        category = kAudioSessionCategory_PlayAndRecord;
        NSLog(@"kAudioSessionCategory_PlayAndRecord");
    }
    
    error = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
    if (error) printf("couldn't set audio category!");
    
    error = AudioSessionSetActive(true);
    if (error) printf("AudioSessionSetActive (true) failed");
#else
    
    NSString *audioMode = nil;
    if (selectedAudioMode == 1) {
        NSLog(@"kAudioSessionCategory_LiveAudio");
        audioMode = AVAudioSessionCategoryPlayback;
    }
    
    else if (selectedAudioMode == 2) {;
        NSLog(@"kAudioSessionCategory_PlayAndRecord");
        audioMode = AVAudioSessionCategoryPlayAndRecord;
    }
    
    if ( nil == audioMode){
        return ;
    }
    
    //get your app's audioSession singleton object
    AVAudioSession* session = [AVAudioSession sharedInstance];
    
    //error handling
    BOOL success;
    NSError* error;
    
    //set the audioSession category.
    //Needs to be Record or PlayAndRecord to use audioRouteOverride:
    
    success = [session setCategory:audioMode error:&error];
    
    if (!success)  NSLog(@"AVAudioSession error setting category:%@",error);
    
    //set the audioSession override
    success = [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker
                                         error:&error];
    if (!success)  NSLog(@"AVAudioSession error overrideOutputAudioPort:%@",error);
    
    //activate the audio session
    success = [session setActive:YES error:&error];
    if (!success) NSLog(@"AVAudioSession error activating: %@",error);
    else NSLog(@"audioSession active");
    
    
#endif
}

- (void)unactiveAudioSession {
    
    
#if 0
    AudioSessionSetActive(false);
#else
    BOOL success;
    NSError* error;
    
    //get your app's audioSession singleton object
    AVAudioSession* session = [AVAudioSession sharedInstance];
    
    //activate the audio session
    success = [session setActive:NO error:&error];
    if (!success) NSLog(@"AVAudioSession error deactivating: %@",error);
    else NSLog(@"audioSession deactive");
    
#endif
    
}
- (UIImage *) getUIImage:(char *)buff Width:(NSInteger)width Height:(NSInteger)height {
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buff, width * height * 3, NULL);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef imgRef = CGImageCreate(width, height, 8, 24, width * 3, colorSpace, kCGBitmapByteOrderDefault, provider, NULL, true,  kCGRenderingIntentDefault);
    
    
    UIImage *img = [UIImage imageWithCGImage:imgRef];
    
    
    if (imgRef != nil) {
        CGImageRelease(imgRef);
        imgRef = nil;
    }
    
    if (colorSpace != nil) {
        CGColorSpaceRelease(colorSpace);
        colorSpace = nil;
    }
    
    if (provider != nil) {
        CGDataProviderRelease(provider);
        provider = nil;
    }
    
    return [[img copy] autorelease];
}

-(void)snapshot
{
    
}
- (void)monitor:(Monitor *)monitor gesturePinched:(CGFloat)scale{
    

}
@end
