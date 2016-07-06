//
//  MessageManager.h
//  fillPaintMaster
//
//  Created by admin on 16/7/6.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface JPMessage : NSObject<NSCoding>
@property(nonatomic,strong) NSString* msgContent;

@end

@interface MessageManager : NSObject
+(void)addJPMessage:(JPMessage *)msg;
+(void)emptyJPMessage;
+(NSMutableArray *)getJPMessageArray;

@end
