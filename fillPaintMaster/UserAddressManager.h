//
//  UserAddressManager.h
//  fillPaintMaster
//
//  Created by admin on 16/6/23.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDUser.h"
extern const NSString *KEY_NAME;
extern const NSString *KEY_PHONE;
extern const NSString *KEY_ADDRESS;

@interface UserAddressManager : NSObject
+(void)cacheUserInfoToLocal:(TDUser *)user;
+(NSString *)cacheName:(NSString *)name phone:(NSString *)phone address:(NSString *)address;

@end
