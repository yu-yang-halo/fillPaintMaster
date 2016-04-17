//
//  TDServiceDataInfo.h
//  fillPaintMaster
//
//  Created by admin on 16/4/7.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDServiceDataInfo : NSObject

@end

@interface TDGoodsType : NSObject

@property(nonatomic,assign) int goodTypeId;
@property(nonatomic,strong) NSString *name;

@end
@interface TDOrderStateType : NSObject
@property(nonatomic,strong) NSString *orderTime;
@property(nonatomic,assign) BOOL isFull;
@property(nonatomic,assign) BOOL isInvaild;
@end

@interface TDGoodsOrderListType : NSObject
@property(nonatomic,assign) int goodsOrderId;
@property(nonatomic,strong) NSString *goodsInfo;
@property(nonatomic,strong) NSString *createTime;
@property(nonatomic,assign) int userId;
@property(nonatomic,assign) int shopId;
@property(nonatomic,assign) float price;
@property(nonatomic,strong) NSString *address;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *phone;
@property(nonatomic,assign) int state;
@property(nonatomic,strong) NSString *processTime;
@property(nonatomic,strong) NSString *expressName;
@property(nonatomic,strong) NSString *expressWaybill;


@end

@interface TDBaseItem : NSObject
@property(nonatomic,assign) int oilId;
@property(nonatomic,assign) int decorationId;
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *desc;
@property(nonatomic,assign) float price;
@property(nonatomic,assign) int shopId;
@property(nonatomic,assign) BOOL isAddYN;

@end

@interface TDDecorationInfo : TDBaseItem

@end

@interface TDOilInfo : TDBaseItem

@end


