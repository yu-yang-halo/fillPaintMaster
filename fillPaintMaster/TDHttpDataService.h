//
//  TDHttpDataService.h
//  fillPaintMaster
//
//  Created by admin on 16/1/4.
//  Copyright (c) 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDHttpDataService : NSObject



-(NSArray *)fetchAllCitys;
-(NSArray *)fetchAllOrderTimes;
-(NSArray *)fetchAllBeautyItems;
-(NSArray *)fetchAllOilMaintainItems;
-(NSArray *)fetchAllPaintItems;

@end
