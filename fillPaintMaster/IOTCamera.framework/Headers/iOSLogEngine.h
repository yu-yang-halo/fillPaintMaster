//
//  iOSLogEngine.h
//  LogEngineTest
//
//  Created by Gavin Chang on 13/4/15.
//  Copyright (c) 2013年 張嘉文. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* g_strLogFilePath;
extern NSLock* g_idLock;

void GLogToFile (NSString *format, ...);

@interface iOSLogEngine : NSObject {
		
}

+ (void)writeLogWithDateTime:(NSString*)sz, ...;
+ (void)writeLog:(NSString*)sz, ...;
+ (void)OutputDebugString:(NSString*) string;
+ (void)initLogEngine:(NSString*)logFileName;

@end