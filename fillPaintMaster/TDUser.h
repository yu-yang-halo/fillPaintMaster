//
//  TDUser.h
//  fillPaintMaster
//
//  Created by admin on 16/1/4.
//  Copyright (c) 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDUser : NSObject

@property(nonatomic,retain) NSString* accoutName;//一般为手机号 唯一
@property(nonatomic,retain) NSString* realName;//用户的真实姓名
@property(nonatomic,retain) NSString* aliasName;//用户的别名

@property(nonatomic,retain) NSArray *relativeCarInfos;//TDCarInfo

@end
