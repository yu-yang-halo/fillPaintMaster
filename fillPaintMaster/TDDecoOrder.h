//
//  TDDecoOrder.h
//  fillPaintMaster
//
//  Created by admin on 16/1/21.
//  Copyright (c) 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDDecoOrder : NSObject
@property(nonatomic,assign) int decoOrderId;
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
@property(nonatomic,retain) NSArray *decoOrderNumber;
@end
@interface DecoOrderNumber : NSObject
@property(nonatomic,assign) int decoOrderNumberId;
@property(nonatomic,assign) int decoOrderId;
@property(nonatomic,assign) int decoId;
@end
