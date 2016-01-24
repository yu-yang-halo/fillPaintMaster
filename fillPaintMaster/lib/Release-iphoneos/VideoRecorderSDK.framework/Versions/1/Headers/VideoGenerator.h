//
//  VideoGenerator.h
//  IOTCamViewer
//
//  Created by David Lin on 1/16/13.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import "MyCamera.h"

#define kNOTF_RECORDING_STARTED     @"kNOTIF_RECORDING_STARTED"
#define kNOTF_RECORDING_STOPPED     @"kNOTIF_RECORDING_STOPPED"

@interface VideoGenerator : NSObject

@property (nonatomic) CGSize size;
@property (nonatomic, assign) NSURL* url;
@property (nonatomic) NSInteger targetChannel;
@property (nonatomic) CMAudioFormatDescriptionRef audioFormatDescription;

@property (readonly) MyCamera* camera;

@property (readonly, nonatomic) BOOL isRecording;

+(uint64_t)freeDiskspace;

// can be called *after* the recording has stopped
-(void)saveToAlbumWithCompletionHandler: (void (^)(NSError*)) handler;

-(id)initWithDestinationURL:(NSURL*)url andCamera:(MyCamera*)camera;
-(void)startRecordingForChannel:(NSInteger) channel withDuration:(NSTimeInterval)duration;
-(void)stopRecordingWithCompletionHandler:(void (^)(NSError* error)) handler;

@end
