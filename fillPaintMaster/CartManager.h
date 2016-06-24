//
//  CartManager.h
//  fillPaintMaster
//
//  Created by admin on 16/4/27.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ElApiService.h"
@class MyCartClass;
@interface CartManager : NSObject
+(instancetype)defaultManager;
@property(nonatomic,strong,readonly) NSMutableArray *myCartClassList;
-(void)addGoodsToCart:(MyCartClass *)cartClass;
-(void)clearCartClassList;
@end

@interface MyCartClass :NSObject
@property(nonatomic,assign) int goodsId;
@property(nonatomic,assign) int count;
@property(nonatomic,strong) TDGoodInfo *goodInfo;
@property(nonatomic,assign) BOOL checkYN;
@property(nonatomic,strong) NSString *imageUrl;
@end
