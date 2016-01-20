//
//  TDMetalplateInfo.h
//  fillPaintMaster
//
//  Created by apple on 16/1/20.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDMetalplateInfo : NSObject
@property(nonatomic,assign) int metalplateId;
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *desc;
@property(nonatomic,assign) float price;
@property(nonatomic,assign) int number;
@property(nonatomic,assign) int shopId;
@end
