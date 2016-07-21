//
//  TDOilOrder.h
//  fillPaintMaster
//
//  Created by admin on 16/1/21.
//  Copyright (c) 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDOilOrder : NSObject
@property(nonatomic,assign) int oilOrderId;
@property(nonatomic,assign) int type;
@property(nonatomic,assign) int state;
@property(nonatomic,assign) int payState;
@property(nonatomic,retain) NSString *userId;
@property(nonatomic,assign) int carId;
@property(nonatomic,assign) int shopId;
@property(nonatomic,assign) int stationId;
@property(nonatomic,retain) NSString *orderTime;
@property(nonatomic,retain) NSString *createTime;
@property(nonatomic,retain) NSString *finishTime;
@property(nonatomic,assign) float price;
@property(nonatomic,assign) int couponId;
@property(nonatomic,retain) NSString *tradeNo;
@property(nonatomic,retain) NSArray *oilOrderNumber;

@end

@interface OilOrderNumberInfo :NSObject
@property(nonatomic,assign) int orderNumberId;
@property(nonatomic,assign) int oilId;
@property(nonatomic,assign) int oilOrderId;

@end
