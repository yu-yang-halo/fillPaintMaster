//
//  TDStationInfo.h
//  fillPaintMaster
//
//  Created by apple on 16/1/20.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDStationInfo : NSObject
@property(nonatomic,assign) int stationId;
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *desc;
@property(nonatomic,assign) int type;
@property(nonatomic,assign) int state;
@property(nonatomic,assign) int shopId;
@property(nonatomic,assign) int userId;

@end
