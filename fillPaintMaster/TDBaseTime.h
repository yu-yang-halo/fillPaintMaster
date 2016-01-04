//
//  TDBaseTime.h
//  fillPaintMaster
//
//  Created by admin on 16/1/4.
//  Copyright (c) 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDBaseTime : NSObject
@property(nonatomic,retain) NSString* timeValue;
@property(nonatomic,assign) BOOL enableYN;//该时间无法预约
@property(nonatomic,assign) BOOL selectedYN;//是否选中
@end
