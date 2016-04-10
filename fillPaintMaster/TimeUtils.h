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
@end
