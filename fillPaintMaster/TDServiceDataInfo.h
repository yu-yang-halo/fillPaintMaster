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
@property(nonatomic,assign) int realShopId;
@property(nonatomic,strong) NSString *price;
@property(nonatomic,strong) NSString *address;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *phone;
@property(nonatomic,assign) int state;
@property(nonatomic,strong) NSString *processTime;
@property(nonatomic,strong) NSString *expressName;
@property(nonatomic,strong) NSString *expressWaybill;
@property(nonatomic,strong) NSString *tradeNo;

@end

@interface TDBaseItem : NSObject
@property(nonatomic,assign) int oilId;

@property(nonatomic,assign) int decorationId;

@property(nonatomic,assign) int metalplateId;

@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *desc;
@property(nonatomic,assign) float price;
@property(nonatomic,assign) int shopId;
@property(nonatomic,assign) BOOL isAddYN;

@property(nonatomic,strong) NSString *number;

@property(nonatomic,assign) int count;
@property(nonatomic,strong) NSString *src;

@end

@interface TDMetalplateInfo : TDBaseItem

@end

@interface TDDecorationInfo : TDBaseItem

@end

@interface TDOilInfo : TDBaseItem

@end




@interface CameraListType : NSObject

@property(nonatomic,assign) int cameraId;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *uid;
@property(nonatomic,strong) NSString *account;
@property(nonatomic,strong) NSString *password;
@property(nonatomic,assign) int shopId;


@end
@interface AlipayInfoType : NSObject

@property(nonatomic,strong) NSString *aliPid;
@property(nonatomic,strong) NSString *aliKey;
@property(nonatomic,strong) NSString *sellerEmail;

@end

