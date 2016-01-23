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


unsigned int _getTickCount() {
    
    struct timeval tv;
    
    if (gettimeofday(&tv, NULL) != 0)
        return 0;
    
    return (tv.tv_sec * 1000 + tv.tv_usec / 1000);
}

@interface MonitorViewController (){
    UILabel *mlabel;
}

@end

@implementation MonitorViewController

@synthesize bStopShowCompletedLock;
@synthesize mCodecId;
@synthesize glView;
@synthesize mPixelBufferPool;
@synthesize mPixelBuffer;
@synthesize mSizePixelBuffer;
@synthesize camera;
@synthesize monitor;
@synthesize image;
#define DEF_WAIT4STOPSHOW_TIME	250

-(void)stop
{
    [monitor deattachCamera];
    
    [camera stopSoundToPhone:0];
    [camera stopShow:0];
    [self waitStopShowCompleted:DEF_WAIT4STOPSHOW_TIME];
    [camera stop:0];
    [camera disconnect];
    [camera setDelegate:nil];
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
    // Release any retained subviews of the main view.
    if(glView) {
        [self.glView tearDownGL];
        [self.glView release];
    }
    CVPixelBufferRelease(mPixelBuffer);
    CVPixelBufferPoolRelease(mPixelBufferPool);
    
    [camera release];
    [monitor release];
}


-(instancetype)initUID:(NSString *)uid withPass:(NSString *)pass{
    self=[super init];
    if(self){
         [Camera initIOTC];
        camera = [[Camera alloc] initWithName:uid];
        camera.delegate=self;
        [camera connect:uid];//8YM2LT63DMWXPBUG111A
        [camera start:0 viewAccount:@"admin"  viewPassword:pass is_playback:FALSE];
        [camera startShow:0 ScreenObject:self];
        SMsgAVIoctrlGetAudioOutFormatReq *s = (SMsgAVIoctrlGetAudioOutFormatReq *)malloc(sizeof(SMsgAVIoctrlGetAudioOutFormatReq));
        s->channel = 0;
        [camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GETAUDIOOUTFORMAT_REQ Data:(char *)s DataSize:sizeof(SMsgAVIoctrlGetAudioOutFormatReq)];
        free(s);
        
        SMsgAVIoctrlGetSupportStreamReq *s2 = (SMsgAVIoctrlGetSupportStreamReq *)malloc(sizeof(SMsgAVIoctrlGetSupportStreamReq));
        [camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GETSUPPORTSTREAM_REQ Data:(char *)s2 DataSize:sizeof(SMsgAVIoctrlGetSupportStreamReq)];
        free(s2);
        
        SMsgAVIoctrlTimeZone s3={0};
        s3.cbSize = sizeof(s3);
        [camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GET_TIMEZONE_REQ Data:(char *)&s3 DataSize:sizeof(s3)];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:[UIColor clearColor]];
     self.view.frame=CGRectMake(0,0,320,200);
    self.scrollViewPortrait.frame=self.view.frame;
    monitor=[[Monitor alloc] initWithFrame:self.view.frame];
    [monitor attachCamera:camera];
    
    
    [self removeGLView:TRUE];
    NSLog( @"video frame {%d,%d}%dx%d", (int)self.monitor.frame.origin.x, (int)self.monitor.frame.origin.y, (int)self.monitor.frame.size.width, (int)self.monitor.frame.size.height);
    if( glView == nil ) {
        glView = [[CameraShowGLView alloc] initWithFrame:self.monitor.frame];
        [glView setMinimumGestureLength:100 MaximumVariance:50];
        glView.delegate = self;
        [glView attachCamera:camera];
    }
    else {
        [self.glView destroyFramebuffer];
        self.glView.frame = self.monitor.frame;
    }
    self.view.frame=self.glView.frame;
    [glView setContentMode:UIViewContentModeScaleToFill];
    [self.scrollViewPortrait addSubview:glView];
    
    if( mCodecId == MEDIA_CODEC_VIDEO_MJPEG ) {
        [self.scrollViewPortrait bringSubviewToFront:monitor/*self.glView*/];
    }
    else {
        [self.scrollViewPortrait bringSubviewToFront:/*monitor*/self.glView];
    }
    
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
- (void)camera:(Camera *)camera didChangeChannelStatus:(NSInteger)channel ChannelStatus:(NSInteger)status
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

- (void)camera:(Camera *)camera didChangeSessionStatus:(NSInteger)status
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
-(void)getWifiInfo {
    NSLog(@"***** wifi info****");
    // get WiFi info
    SMsgAVIoctrlListWifiApReq *structWiFi = (SMsgAVIoctrlListWifiApReq *)malloc(sizeof(SMsgAVIoctrlListWifiApReq));
   
    
    [camera sendIOCtrlToChannel:0
                           Type:IOTYPE_USER_IPCAM_LISTWIFIAP_REQ
                           Data:(char *)structWiFi
                       DataSize:sizeof(SMsgAVIoctrlListWifiApReq)];
    free(structWiFi);
}
- (void)camera:(Camera *)camera didReceiveFrameInfoWithVideoWidth:(NSInteger)videoWidth VideoHeight:(NSInteger)videoHeight VideoFPS:(NSInteger)fps VideoBPS:(NSInteger)videoBps AudioBPS:(NSInteger)audioBps OnlineNm:(NSInteger)onlineNm FrameCount:(unsigned long)frameCount IncompleteFrameCount:(unsigned long)incompleteFrameCount
{
    
}

- (void)camera:(Camera *)camera didReceiveIOCtrlWithType:(NSInteger)type Data:(const char *)data DataSize:(NSInteger)size
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

- (void)camera:(Camera *)camera didReceiveJPEGDataFrame:(const char *)imgData DataSize:(NSInteger)size
{
    /*
     * You may use the code snippet as below to get an image.
     
     NSData *data = [NSData dataWithBytes:imgData length:size];
     self.image = [UIImage imageWithData:data];
     
     */
}

- (void)camera:(Camera *)camera didReceiveRawDataFrame:(const char *)imgData VideoWidth:(NSInteger)width VideoHeight:(NSInteger)height
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
    unsigned short *pnCodecId = (unsigned short *)[pointer pointerValue];
    
    mCodecId = *pnCodecId;
    
    if( mCodecId == MEDIA_CODEC_VIDEO_MJPEG ) {
        [self.scrollViewPortrait bringSubviewToFront:monitor/*self.glView*/];
    }
    else {
        [self.scrollViewPortrait bringSubviewToFront:/*monitor*/self.glView];
    }
}

- (void)updateToScreen:(NSValue*)pointer
{
    LPSIMAGEBUFFINFO pScreenBmpStore = (LPSIMAGEBUFFINFO)[pointer pointerValue];
    
    //	[glView renderVideo:pScreenBmpStore->pixelBuff];
    
    int width = (int)CVPixelBufferGetWidth(pScreenBmpStore->pixelBuff);
    int height = (int)CVPixelBufferGetHeight(pScreenBmpStore->pixelBuff);
    mSizePixelBuffer = CGSizeMake( width, height );
#ifndef DEF_Using_APLEAGLView
    [glView renderVideo:pScreenBmpStore->pixelBuff];
#else
    self.test.presentationRect = mSizePixelBuffer;
    [[self test] displayPixelBuffer:pScreenBmpStore->pixelBuff withRelease:FALSE];
#endif
}

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
    [_scrollViewPortrait release];
    [super dealloc];
    if(monitor!=nil){
        [monitor deattachCamera];
        [monitor release];
        monitor=nil;
    }
    if(camera!=nil){
        [camera disconnect];
        [camera release];
        camera=nil;
    }
    [image release];
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
    char *imageFrame = (char *) malloc(MAX_IMG_BUFFER_SIZE);
    unsigned int w = 0, h = 0;
    unsigned int codec_id = mCodecId;
    int size = 0;
    size = [camera getChannel:0 Snapshot:imageFrame DataSize:MAX_IMG_BUFFER_SIZE ImageType:&codec_id   WithImageWidth:&w ImageHeight:&h];
    if (size > 0) {
        UIImage *img = NULL;
        
        if (codec_id == MEDIA_CODEC_VIDEO_H264 || codec_id == MEDIA_CODEC_VIDEO_MPEG4) {
            img = [self getUIImage:imageFrame Width:w Height:h];
            NSData *imgData = UIImageJPEGRepresentation(img, 1.0f);
           
        }
        else if (codec_id == MEDIA_CODEC_VIDEO_MJPEG) {
            NSData *data = [[NSData alloc] initWithBytes:imageFrame length:size];
            img = [[UIImage alloc] initWithData:data];
            NSData *imgData = UIImageJPEGRepresentation(img, 1.0f);
            
            [data release];
            [img release];
            
        }
    }
    
    free(imageFrame);
}
- (void)monitor:(Monitor *)monitor gesturePinched:(CGFloat)scale{
    if( mCodecId == MEDIA_CODEC_VIDEO_MJPEG ) {
        [self.scrollViewPortrait bringSubviewToFront:self.monitor/*self.glView*/];
    }
    else {
        [self.scrollViewPortrait bringSubviewToFront:/*monitor*/self.glView];
    }
    
    
    if( mCodecId == MEDIA_CODEC_VIDEO_MJPEG ) {
        [self.scrollViewPortrait setZoomScale:scale animated:YES];
        NSLog(@"MEDIA_CODEC_VIDEO_MJPEG...");
    }
    else {
        
        [self.scrollViewPortrait setContentSize:self.glView.frame.size];
        NSLog(@"w:%f h:%f scale:%f",self.glView.frame.size.width,self.glView.frame.size.height,scale);
        
    }

}
@end
