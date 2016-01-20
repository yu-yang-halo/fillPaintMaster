//
//  TDCouponInfo.h
//  fillPaintMaster
//
//  Created by apple on 16/1/20.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDCouponInfo : NSObject
@property(nonatomic,assign) int couponId;
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *desc;
@property(nonatomic,assign) float price;
@property(nonatomic,assign) int shopId;
@property(nonatomic,assign) int number;
@property(nonatomic,assign) float discount;
@property(nonatomic,assign) int type;
@property(nonatomic,retain) NSString *createTime;
@property(nonatomic,retain) NSString *endTime;
@property(nonatomic,assign) int createUserId;
@property(nonatomic,assign) int useUserId;
@property(nonatomic,assign) BOOL isUsed;
@property(nonatomic,assign) int orderType;

@end
