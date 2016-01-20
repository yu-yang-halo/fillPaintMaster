//
//  TDDecorationInfo.h
//  fillPaintMaster
//
//  Created by apple on 16/1/20.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDDecorationInfo : NSObject
@property(nonatomic,assign) int decorationId;
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *desc;
@property(nonatomic,assign) float price;
@property(nonatomic,assign) int shopId;
@end
