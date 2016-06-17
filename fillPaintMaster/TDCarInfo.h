//
//  TDCarInfo.h
//  fillPaintMaster
//
//  Created by admin on 16/1/4.
//  Copyright (c) 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDCarInfo : NSObject
@property(nonatomic,assign) int carId;
@property(nonatomic,assign) int type;
@property(nonatomic,retain) NSString *number;
@property(nonatomic,assign) int userId;
@property(nonatomic,strong) NSString *model;
@end
