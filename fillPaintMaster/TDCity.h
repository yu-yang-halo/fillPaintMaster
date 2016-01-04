//
//  TDCity.h
//  fillPaintMaster
//
//  Created by admin on 16/1/4.
//  Copyright (c) 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDCity : NSObject
@property(nonatomic,assign) NSUInteger cityID;
@property(nonatomic,retain) NSString *cityName;
@property(nonatomic,assign) BOOL activeYN;//城市是否覆盖，YES 才会有效
@end
