//
//  DecimalCaculateUtils.h
//  fillPaintMaster
//
//  Created by admin on 16/7/18.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DecimalCaculateUtils : NSObject
+(NSString *)addWithA:(NSString *)_a andB:(NSString *)_b;
+(NSString *)subtractWithA:(NSString *)_a andB:(NSString *)_b;
+(NSString *)mutiplyWithA:(NSString *)_a andB:(NSString *)_b;
+(NSString *)divideWithA:(NSString *)_a andB:(NSString *)_b;

+(NSString *)showDecimalFloat:(float)_c;
+(NSString *)showDecimalString:(NSString *)_c;

+(NSString *)decimalFloat:(float)_c;
+(NSString *)decimalString:(NSString *)_c;

@end
