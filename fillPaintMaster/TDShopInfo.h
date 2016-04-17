//
//  TDShopInfo.h
//  fillPaintMaster
//
//  Created by apple on 16/1/20.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDShopInfo : NSObject
@property(nonatomic,assign) int shopId;
@property(nonatomic,retain) NSString * name;
@property(nonatomic,assign) float longitude;
@property(nonatomic,assign) float latitude;
@property(nonatomic,assign) int cityId;
@property(nonatomic,retain) NSString * desc;
@property(nonatomic,strong) NSString *panorama;
@property(nonatomic,strong) NSString *openTime;
@property(nonatomic,strong) NSString *closeTime;


@end
