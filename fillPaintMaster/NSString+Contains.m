//
//  NSString+Contains.m
//  fillPaintMaster
//
//  Created by apple on 16/4/16.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "NSString+Contains.h"

@implementation NSString(Contains)
-(BOOL)myContainsString:(NSString*)other {
    NSRange range = [self rangeOfString:other];
    return range.length != 0;
}
@end
