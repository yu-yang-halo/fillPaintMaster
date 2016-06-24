//
//  UserAddressManager.m
//  fillPaintMaster
//
//  Created by admin on 16/6/23.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "UserAddressManager.h"
const NSString *KEY_NAME=@"key_name";
const NSString *KEY_PHONE=@"key_phone";
const NSString *KEY_ADDRESS=@"key_address";
@implementation UserAddressManager
+(void)cacheUserInfoToLocal:(TDUser *)user{
    NSString *receivingInfo=user.receivingInfo;
    if(receivingInfo==nil){
        return;
    }
    NSArray *namePhoneAddress=[receivingInfo componentsSeparatedByString:@","];
    if([namePhoneAddress count]==3){
        [self cacheName:namePhoneAddress[0] phone:namePhoneAddress[1] address:namePhoneAddress[2]];
    }
    
}
+(NSString *)cacheName:(NSString *)name phone:(NSString *)phone address:(NSString *)address{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:KEY_NAME];
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:KEY_PHONE];
    [[NSUserDefaults standardUserDefaults] setObject:address forKey:KEY_ADDRESS];
    
    return [NSString stringWithFormat:@"%@,%@,%@",name,phone,address];
}

@end
