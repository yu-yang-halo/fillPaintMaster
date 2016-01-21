//
//  TDMetaOrder.h
//  fillPaintMaster
//
//  Created by admin on 16/1/21.
//  Copyright (c) 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDMetaOrder : NSObject
@property(nonatomic,assign) int metaOrderId;
@property(nonatomic,assign) int type;
@property(nonatomic,assign) int state;
@property(nonatomic,assign) int payState;
@property(nonatomic,retain) NSString *userId;
@property(nonatomic,assign) int carId;
@property(nonatomic,assign) int shopId;
@property(nonatomic,assign) int stationId;
@property(nonatomic,assign) float price;
@property(nonatomic,assign) int couponId;
@property(nonatomic,retain) NSString *orderTime;

@property(nonatomic,retain) NSString *createTime;
@property(nonatomic,retain) NSString *finishTime;


@property(nonatomic,retain) NSArray *metaOrderNumber;
@property(nonatomic,retain) NSArray *metaOrderImg;
@end
@interface MetaOrderNumberInfo :NSObject
@property(nonatomic,assign) int metaNumberId;
@property(nonatomic,assign) int metaId;
@property(nonatomic,assign) int metaOrderId;

@end
@interface MetaOrderImg :NSObject
@property(nonatomic,assign) int metaOrderImgId;
@property(nonatomic,retain) NSString* imgName;
@property(nonatomic,assign) int metaOrderId;
@end
