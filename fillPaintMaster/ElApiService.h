//
//  ElApiService.h
//  ehome
//
//  Created by admin on 14-7-21.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//
#import "TDUser.h"
#import "TDStationInfo.h"
#import "TDShopInfo.h"
#import "TDOilInfo.h"
#import "TDMetalplateInfo.h"
#import "TDDecorationInfo.h"
#import "TDCouponInfo.h"
#import "TDCityInfo.h"
#import "TDCarInfo.h"
#import "TDGoodInfo.h"
#import "TDOilOrder.h"
#import "TDOrderSearch.h"
#import "TDMetaOrder.h"
#import "TDDecoOrder.h"
#import <Foundation/Foundation.h>

@class ElApiService;
static ElApiService* shareService=nil;
@interface ElApiService : NSObject{
    
}
@property(nonatomic,retain) NSString* connect_header;
+(ElApiService *) shareElApiService;
-(BOOL)appUserLogin:(NSString *)name password:(NSString *)pass shopId:(int)shopId;
-(BOOL)createUser:(NSString *)loginName password:(NSString *)pass email:(NSString *)email phone:(NSString *)phoneNumber type:(int)type shopId:(int)shopId;
-(BOOL)updUser:(TDUser *)tdUser;
-(TDUser *)getUserInfo;
-(NSArray *)getShopList;
-(NSArray *)getOilListByshopId:(int)shopId;
-(NSArray *)getMetalplateList:(int)shopId;
-(NSArray *)getDecorationList:(int)shopId;
-(NSArray *)getCouponList:(int)shopId;
-(NSArray *)getCityList:(int)shopId;
-(NSArray *)getCarByCurrentUser;
-(NSArray *)getGoodsList:(int)shopId;
-(BOOL)createOilOrder:(TDOilOrder *)oilOrder;
-(BOOL)delOilOrder:(int)oilOrderId;
-(BOOL)updOilOrder:(TDOilOrder *)oilOrder;
-(NSArray *)getOilOrderList:(TDOrderSearch *)orderSearch;
-(BOOL)createOilOrderNumber:(int)oilOrderId oilId:(int)oilId;
-(BOOL)createMetaOrder:(TDMetaOrder *)metaOrder;
-(BOOL)delMetaOrder:(int)metaOrderId;
-(BOOL)updMetaOrder:(TDMetaOrder *)metaOrder;
-(NSArray *)getMetaOrderList:(TDOrderSearch *)orderSearch;
-(BOOL)createMetaOrderNumber:(int)metaOrderId metaId:(int)metaId;
-(BOOL)createMetaOrderImg:(int)metaOrderId imgName:(NSString *)imgName;
-(BOOL)createDecoOrder:(TDDecoOrder *)decoOrder;
-(BOOL)delDecoOrder:(int)decoOrderId;
-(BOOL)updDecoOrder:(TDDecoOrder *)decoOrder;
-(NSArray *)getDecoOrderList:(TDOrderSearch *)orderSearch;
-(BOOL)createDecoOrderNumber:(int)decoOrderId decoId:(int)decoId;


@end

