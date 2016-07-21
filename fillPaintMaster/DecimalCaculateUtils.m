//
//  DecimalCaculateUtils.m
//  fillPaintMaster
//
//  Created by admin on 16/7/18.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "DecimalCaculateUtils.h"

@implementation DecimalCaculateUtils
+(NSString *)addWithA:(NSString *)_a andB:(NSString *)_b{
    NSDecimalNumber *number0=[NSDecimalNumber decimalNumberWithString:_a];
    NSDecimalNumber *number1=[NSDecimalNumber decimalNumberWithString:_b];
    
    NSDecimalNumber *result=[number0 decimalNumberByAdding:number1];
    
    return [result stringValue];
}
+(NSString *)subtractWithA:(NSString *)_a andB:(NSString *)_b{
    NSDecimalNumber *number0=[NSDecimalNumber decimalNumberWithString:_a];
    NSDecimalNumber *number1=[NSDecimalNumber decimalNumberWithString:_b];
    
    NSDecimalNumber *result=[number0 decimalNumberBySubtracting:number1];
    
    return [result stringValue];
}
+(NSString *)mutiplyWithA:(NSString *)_a andB:(NSString *)_b{
    NSDecimalNumber *number0=[NSDecimalNumber decimalNumberWithString:_a];
    NSDecimalNumber *number1=[NSDecimalNumber decimalNumberWithString:_b];
    
    NSDecimalNumber *result=[number0 decimalNumberByMultiplyingBy:number1];
    
    return [result stringValue];
}
+(NSString *)divideWithA:(NSString *)_a andB:(NSString *)_b{
    NSDecimalNumber *number0=[NSDecimalNumber decimalNumberWithString:_a];
    NSDecimalNumber *number1=[NSDecimalNumber decimalNumberWithString:_b];
    
    NSDecimalNumber *result=[number0 decimalNumberByDividingBy:number1];
    
    return [result stringValue];
}

+(NSString *)showDecimalFloat:(float)_c{
    return [self showDecimalString:[NSString stringWithFormat:@"%f",_c]];
}
+(NSString *)showDecimalString:(NSString *)_c{
    NSDecimalNumber *number=[NSDecimalNumber decimalNumberWithString:_c];
    
    return [NSString stringWithFormat:@"%@元",[number stringValue]];
}
+(NSString *)decimalFloat:(float)_c{
     return [self decimalString:[NSString stringWithFormat:@"%f",_c]];
}
+(NSString *)decimalString:(NSString *)_c{
    NSDecimalNumber *number=[NSDecimalNumber decimalNumberWithString:_c];
    
    return [number stringValue];
}

@end
