//
//  TDUser.h
//  fillPaintMaster
//
//  Created by admin on 16/1/4.
//  Copyright (c) 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDUser : NSObject

@property(nonatomic,retain) NSString* loginName;
@property(nonatomic,retain) NSString* password;
@property(nonatomic,retain) NSString* email;
@property(nonatomic,retain) NSString* phone;
@property(nonatomic,retain) NSString* wechatId;
@property(nonatomic,retain) NSString* regTime;
@property(nonatomic,assign) int type;
@property(nonatomic,assign) int shopId;

@end
