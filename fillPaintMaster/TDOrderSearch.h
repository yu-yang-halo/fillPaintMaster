//
//  TDOrderSearch.h
//  fillPaintMaster
//
//  Created by admin on 16/1/21.
//  Copyright (c) 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, SEARCH_TYPE){
    SEARCH_TYPE_SHOPID,
    SEARCH_TYPE_USERID
};

@interface TDOrderSearch : NSObject
@property(nonatomic,assign) SEARCH_TYPE searchType;
@property(nonatomic,assign) int shopId;
@property(nonatomic,retain) NSString* userId;
@property(nonatomic,assign) int carId;
@property(nonatomic,assign) int stationId;
@property(nonatomic,retain) NSString* startTime;
@property(nonatomic,assign) int maxNum;
@end
