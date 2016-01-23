//
//  TDGoodInfo.h
//  fillPaintMaster
//
//  Created by apple on 16/1/20.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDGoodInfo : NSObject
@property(nonatomic,assign) int goodId;
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *desc;
@property(nonatomic,assign) BOOL isShow;
@property(nonatomic,assign) BOOL isChange;
@property(nonatomic,assign) BOOL price;
@property(nonatomic,assign) int shopId;
@property(nonatomic,retain) NSString *src;

@end