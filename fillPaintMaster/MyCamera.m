//
//  MyCamera.m
//  IOTCamViewer
//
//  Created by Cloud Hsiao on 12/7/2.
//  Copyright (c) 2012年 TUTK. All rights reserved.
//

#import "MyCamera.h"
#import <IOTCamera/GLog.h>
#import <IOTCamera/GLogZone.h>
#import <IOTCamera/AVIOCTRLDEFs.h>
#import <IOTCamera/AVFrameInfo.h>

BOOL g_bDiagnostic = FALSE;

@interface MyCamera()

@property(readwrite) NSInteger remoteNotifications;

@end

@implementation MyCamera
@synthesize delegate2;
@synthesize lastChannel;
@synthesize remoteNotifications;
@synthesize viewAcc, viewPwd;
@synthesize bIsSupportTimeZone;
@synthesize bIsSyncOnCloud;
@synthesize bisAddFromCloud;
@synthesize nGMTDiff;
@synthesize strTimeZone;
@synthesize isSupportDropbox;
@synthesize isLinkDropbox;

#pragma mark - Public Methods

- (NSArray *)getSupportedStreams 
{
    return [arrayStreamChannel count] == 0 ? nil : [[[NSArray alloc] initWithArray:arrayStreamChannel] autorelease];
}

- (BOOL)getAudioInSupportOfChannel:(NSInteger)channel
{
    return ([self getServiceTypeOfChannel:channel] & 1) == 0;
}

- (BOOL)getAudioOutSupportOfChannel:(NSInteger)channel
{
    return ([self getServiceTypeOfChannel:channel] & 2) == 0;
}

- (BOOL)getPanTiltSupportOfChannel:(NSInteger)channel
{
    return ([self getServiceTypeOfChannel:channel] & 4) == 0;    
}

- (BOOL)getEventListSupportOfChannel:(NSInteger)channel
{
    return ([self getServiceTypeOfChannel:channel] & 8) == 0;   
}

- (BOOL)getPlaybackSupportOfChannel:(NSInteger)channel
{
    return ([self getServiceTypeOfChannel:channel] & 16) == 0;   
}

- (BOOL)getWiFiSettingSupportOfChannel:(NSInteger)channel
{
    return ([self getServiceTypeOfChannel:channel] & 32) == 0;
}

- (BOOL)getMotionDetectionSettingSupportOfChannel:(NSInteger)channel
{
    return ([self getServiceTypeOfChannel:channel] & 64) == 0;  
}

- (BOOL)getRecordSettingSupportOfChannel:(NSInteger)channel
{
    return ([self getServiceTypeOfChannel:channel] & 128) == 0;   
}

- (BOOL)getFormatSDCardSupportOfChannel:(NSInteger)channel
{
    return ([self getServiceTypeOfChannel:channel] & 256) == 0;
}

- (BOOL)getVideoFlipSupportOfChannel:(NSInteger)channel
{
    return ([self getServiceTypeOfChannel:channel] & 512) == 0;  
}

- (BOOL)getEnvironmentModeSupportOfChannel:(NSInteger)channel
{
    return ([self getServiceTypeOfChannel:channel] & 1024) == 0;
}

- (BOOL)getMultiStreamSupportOfChannel:(NSInteger)channel
{
    return ([self getServiceTypeOfChannel:channel] & 2048) == 0;
}

- (NSInteger)getAudioOutFormatOfChannel:(NSInteger)channel
{
    return ([self getServiceTypeOfChannel:channel] & 4096) == 0 ? MEDIA_CODEC_AUDIO_SPEEX : MEDIA_CODEC_AUDIO_ADPCM;  
}

- (BOOL)getVideoQualitySettingSupportOfChannel:(NSInteger)channel
{
    return ([self getServiceTypeOfChannel:channel] & 8192) == 0;
}

- (BOOL)getDeviceInfoSupportOfChannel:(NSInteger)channel
{
    return ([self getServiceTypeOfChannel:channel] & 16384) == 0;
}

- (BOOL)getTimeZoneSupportOfChannel:(NSInteger)channel
{
    return ([self getServiceTypeOfChannel:channel] & (0x01<<15)) == 0;
}

#pragma mark - 

- (id)init
{
    self = [super init];
    if (self) {
        arrayStreamChannel = [[NSMutableArray alloc] init];
        self.remoteNotifications = 0;
        self.delegate = self;
        
        self.isSupportDropbox = NO;
        self.isLinkDropbox = NO;
    }
    return self;
}

- (id)initWithName:(NSString *)name viewAccount:(NSString *)viewAcc_ viewPassword:(NSString *)viewPwd_
{
    self = [super initWithName:name];
    
    if (self) {
        self.viewAcc = viewAcc_;
        self.viewPwd = viewPwd_;
        self.remoteNotifications = 0;
        self.delegate = self;
        
        self.isSupportDropbox = NO;
        self.isLinkDropbox = NO;
    }
    
    return self;
}

- (void)setSync:(NSInteger)isSync {
    
    if (isSync==0){
        self.bIsSyncOnCloud = NO;
    } else {
        self.bIsSyncOnCloud = YES;
    }
}

- (void)setCloud:(NSInteger)isFromCloud {
    
    if (isFromCloud==0){
        self.bisAddFromCloud = NO;
    } else {
        self.bisAddFromCloud = YES;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didReceiveIOCtrl" object:nil];
    [arrayStreamChannel release];
	[strTimeZone release];
    self.delegate2 = nil;
    [super dealloc];
}

- (void)start:(NSInteger)channel
{
	//bIsSupportTimeZone = 1;
	//nGMTDiff = 8*60;
	strTimeZone = [[NSString alloc] init];
	
    [super start:channel viewAccount:viewAcc viewPassword:viewPwd is_playback:FALSE];
    
#ifdef SUPPORT_DROPBOX
    SMsgAVIoctrlGetDropbox dummy ={0};
    [self sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GET_SAVE_DROPBOX_REQ Data:(char *)&dummy DataSize:sizeof(dummy)];
#endif
    
}

- (void)start4EventPlayback:(NSInteger)channel
{
	//bIsSupportTimeZone = 1;
	//nGMTDiff = 8*60;
	strTimeZone = [[NSString alloc] init];
	
    [super start:channel viewAccount:viewAcc viewPassword:viewPwd is_playback:TRUE];
}

- (void)setRemoteNotification:(NSInteger)type EventTime:(long)time
{
    remoteNotifications++;
    
    NSLog(@"remoteNotifications:%d", (int)remoteNotifications);
    
    if (self.delegate2 != nil && [self.delegate2 respondsToSelector:@selector(camera:_didReceiveRemoteNotification:EventTime:)]) {
        [self.delegate2 camera:self _didReceiveRemoteNotification:type EventTime:time];
    }
}

- (void)clearRemoteNotifications
{
    remoteNotifications = 0;
}

- (NSString*)getOverAllQualityString
{
	NSString* result = nil;
	
	float val = (float)self.nDispFrmPreSec / (float)self.nRecvFrmPreSec;
	
	if( 0.7 <= val ) {
		if( g_bDiagnostic ) {
			result = [NSString stringWithFormat:@"%@ (%d/%d)", NSLocalizedString(@"Good", @""), self.nDispFrmPreSec, self.nRecvFrmPreSec];
		}
		else {
			result = NSLocalizedString(@"Good", @"");
		}
	}
	else if( 0.3 <= val && val < 0.7 ) {
		if( g_bDiagnostic ) {
			result = [NSString stringWithFormat:@"%@ (%d/%d)", NSLocalizedString(@"Normal", @""), self.nDispFrmPreSec, self.nRecvFrmPreSec];
		}
		else {
			result = NSLocalizedString(@"Normal", @"");
		}
	}
	else {
		if( g_bDiagnostic ) {
			result = [NSString stringWithFormat:@"%@ (%d/%d)", NSLocalizedString(@"Bad", @""), self.nDispFrmPreSec, self.nRecvFrmPreSec];
		}
		else {
			result = NSLocalizedString(@"Bad", @"");
		}
	}
	return result;
}

+ (NSString*) getConnModeString:(NSInteger)connMode
{
	NSString* result = nil;
	
	switch(connMode) {
		case CONNECTION_MODE_P2P:
			result = @"P2P";
			break;
		case CONNECTION_MODE_RELAY:
			result = @"Relay";
			break;
		case CONNECTION_MODE_LAN:
			result = @"Lan";
			break;
		default:
			result = @"None";
			break;
	}
	return result;
}

#pragma mark - CameraDelegate Methods
- (void)camera:(Camera *)camera didReceiveRawDataFrame:(const char *)imgData VideoWidth:(NSInteger)width VideoHeight:(NSInteger)height
{
    if (self.delegate2 && [self.delegate2 respondsToSelector:@selector(camera:_didReceiveRawDataFrame:VideoWidth:VideoHeight:)]) {
        [self.delegate2 camera:self _didReceiveRawDataFrame:imgData VideoWidth:width VideoHeight:height];
    }
}

- (void)camera:(Camera *)camera didReceiveJPEGDataFrame:(const char *)imgData DataSize:(NSInteger)size
{
    if (self.delegate2 && [self.delegate2 respondsToSelector:@selector(camera:_didReceiveJPEGDataFrame:DataSize:)]) {
        [self.delegate2 camera:self _didReceiveJPEGDataFrame:imgData DataSize:size];
    }
}

- (void)camera:(Camera *)camera didReceiveFrameInfoWithVideoWidth:(NSInteger)videoWidth VideoHeight:(NSInteger)videoHeight VideoFPS:(NSInteger)fps VideoBPS:(NSInteger)videoBps AudioBPS:(NSInteger)audioBps OnlineNm:(NSInteger)onlineNm FrameCount:(unsigned int)frameCount IncompleteFrameCount:(unsigned int)incompleteFrameCount
{
    if (self.delegate2 && [self.delegate2 respondsToSelector:@selector(camera:_didReceiveFrameInfoWithVideoWidth:VideoHeight:VideoFPS:VideoBPS:AudioBPS:OnlineNm:FrameCount:IncompleteFrameCount:)]) {
        [self.delegate2 camera:self _didReceiveFrameInfoWithVideoWidth:videoWidth VideoHeight:videoHeight VideoFPS:fps VideoBPS:videoBps AudioBPS:audioBps OnlineNm:onlineNm FrameCount:frameCount IncompleteFrameCount:incompleteFrameCount];
    }
}

- (void)camera:(Camera *)camera didChangeSessionStatus:(NSInteger)status
{
    if (self.delegate2 && [self.delegate2 respondsToSelector:@selector(camera:_didChangeSessionStatus:)]) {
        [self.delegate2 camera:self _didChangeSessionStatus:status];
    }
    
    if (self.sessionState == CONNECTION_STATE_UNKNOWN_DEVICE ||
        self.sessionState == CONNECTION_STATE_UNSUPPORTED ||
        self.sessionState == CONNECTION_STATE_CONNECT_FAILED) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
           
            [self disconnect];

        });
    }
}

- (void)camera:(Camera *)camera didChangeChannelStatus:(NSInteger)channel ChannelStatus:(NSInteger)status
{
    if (self.delegate2 && [self.delegate2 respondsToSelector:@selector(camera:_didChangeChannelStatus:ChannelStatus:)]) {
        [self.delegate2 camera:self _didChangeChannelStatus:channel ChannelStatus:status];
    }

    if (status == CONNECTION_STATE_WRONG_PASSWORD) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            [self stop:channel];
            
            usleep(500 * 1000);
            
            [self disconnect];
        });
    }
}

- (void)camera:(Camera *)camera didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size
{
    
    if (self.delegate2 && [self.delegate2 respondsToSelector:@selector(camera:_didReceiveIOCtrlWithType:Data:DataSize:)]) {
        [self.delegate2 camera:self _didReceiveIOCtrlWithType:type Data:data DataSize:size];
    }
    
    NSData *buf = [NSData dataWithBytes:data length:size];
    NSNumber *t = [NSNumber numberWithInt:(int)type];    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: buf, @"recvData", t, @"type", self.uid, @"uid", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didReceiveIOCtrl" object:self userInfo:dict];
        
    if (type == (int)IOTYPE_USER_IPCAM_GETSUPPORTSTREAM_RESP) {
        
        [arrayStreamChannel removeAllObjects];
        
        SMsgAVIoctrlGetSupportStreamResp *s = (SMsgAVIoctrlGetSupportStreamResp *)data;
        MyCamera* myCamera = (MyCamera*)camera;
		
        NSLog( @"==================================================" );
		NSLog( @"IOTYPE_USER_IPCAM_GETSUPPORTSTREAM_RESP total:%d", s->number );
        NSLog( @"==================================================" );
        if ( [myCamera getMultiStreamSupportOfChannel:0] ) {
            SStreamDef *def = malloc(size - (sizeof(s->number)));
            memcpy(def, s->streams, size - (sizeof(s->number)));
            
            for (int i = 0; i < s->number; i++) {
                
                SubStream_t ch;
                ch.index = def[i].index;
                ch.channel = def[i].channel;
				NSLog( @"\t[%d] index:%d channel:%d", i, ch.index, ch.channel );
                
                NSValue *objCh = [[NSValue alloc] initWithBytes:&ch objCType:@encode(SubStream_t)];
                [arrayStreamChannel addObject:objCh];
                [objCh release];
                
                if (def[i].channel != 0) {
                    // NSString *acc = [self getViewAccountOfChannel:0];
                    // NSString *pwd = [self getViewPasswordOfChannel:0];
                    
                    [self start:def[i].channel viewAccount:self.viewAcc viewPassword:self.viewPwd is_playback:FALSE];
                }
            }
            free(def);
        }
    }
	else if(type == (int)IOTYPE_USER_IPCAM_GET_TIMEZONE_RESP) {
        SMsgAVIoctrlTimeZone* p = (SMsgAVIoctrlTimeZone*)data;
				
		if( p->cbSize == sizeof(SMsgAVIoctrlTimeZone) ) {
			NSLog( @">>>> IOTYPE_USER_IPCAM_GET_TIMEZONE_RESP <OK>\n\tbIsSupportTimeZone:%d\n\tnGMTDiff:%d\n\tstrTimeZone:%@", p->nIsSupportTimeZone, p->nGMTDiff, ( strlen(p->szTimeZoneString) > 0 ) ? [NSString stringWithUTF8String:p->szTimeZoneString]:@"(null)" );
			bIsSupportTimeZone = p->nIsSupportTimeZone;
			nGMTDiff = p->nGMTDiff;
			NSString* pTimeZoneStringFromDevice = nil;
			if( strlen(p->szTimeZoneString) > 0 )
				pTimeZoneStringFromDevice = [NSString stringWithUTF8String:p->szTimeZoneString];
    
            self.strTimeZone =pTimeZoneStringFromDevice ;
		}
	}
    
#ifdef SUPPORT_DROPBOX
    else if (type == IOTYPE_USER_IPCAM_GET_SAVE_DROPBOX_RESP) {
        
        SMsgAVIoctrlGetDropbox *s = (SMsgAVIoctrlGetDropbox *)data;
        
        self.isSupportDropbox = NO;
        self.isLinkDropbox = NO;
        
        if ( 1 == s->nSupportDropbox ){
            self.isSupportDropbox = YES;
                
            if ( 1 == s->nLinked){
                NSString *uuid = [[[ UIDevice currentDevice] identifierForVendor] UUIDString];
                if ( [uuid isEqualToString:[ NSString stringWithUTF8String:s->szLinkUDID]]){
                    self.isLinkDropbox = YES;
                }
            }
        }
    }
    
    else if (type == IOTYPE_USER_IPCAM_SET_SAVE_DROPBOX_RESP){
        //SMsgAVIoctrlSetDropbox *s = (SMsgAVIoctrlSetDropbox *)data;
        NSLog(@"get IOTYPE_USER_IPCAM_SET_SAVE_DROPBOX_RESP");
    }
#endif
    
}

- (void)startShow:(NSInteger)channel ScreenObject:(NSObject*)obScreen
{
	GLogREL( tUI, (@"startShow obScreen:@%p... UID:%@ channel:%d", obScreen, self.uid, (int)channel) );
	[super startShow:channel ScreenObject:obScreen];
}
//- (void)setVideoRecorderDelegate:(Camera *)camera {
//    NSLog(@"TEST!!!");
//    return;
//}

@end
