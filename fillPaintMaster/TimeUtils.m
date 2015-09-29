//
//  TimeUtils.m
//  fillPaintMaster
//
//  Created by apple on 15/9/29.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import "TimeUtils.h"

@implementation TimeUtils
+(NSString *)createTimeString:(int)row column:(int)col{
    /*
        7:00 7:30 8:00 8:30 9:00 9:30
     
     
     */
    NSString *minuteStr;
    if(col%2==0){
        minuteStr=@"00";
    }else{
        minuteStr=@"30";
    }
    int hourINT=row*3+7+col/2;
    
    return [NSString stringWithFormat:@"%d:%@",hourINT,minuteStr];
}
@end
