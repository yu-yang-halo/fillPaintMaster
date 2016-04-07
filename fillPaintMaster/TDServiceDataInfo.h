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
@end

