//
//  TimeUtils.h
//  fillPaintMaster
//
//  Created by apple on 15/9/29.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeUtils : NSObject
+(NSString *)createTimeString:(int)row column:(int)col;
+(NSString *)normalShowTime:(NSString *)serverTime;
+(NSString *)normalShowTime:(NSString *)serverTime format:(NSString *)format;
+(BOOL)isOverTime:(NSString *)endTime;
+(NSString *)newDate:(int)incre;
+(NSString *)createTimeHHMM:(NSString *)hhmm incre:(int)incre;
+(NSString *)createTimeHHMM2:(NSString *)hhmm incre:(int)incre;
@end
