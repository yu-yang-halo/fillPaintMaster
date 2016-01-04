//
//  TDPaintItem.h
//  fillPaintMaster
//
//  Created by admin on 16/1/4.
//  Copyright (c) 2016年 LZTech. All rights reserved.
//

#import "TDBaseItem.h"
#import "TDConstants.h"
@interface TDPaintItem : TDBaseItem
@property(nonatomic,assign) CAR_TYPE carPositionType;
@property(nonatomic,assign) NSUInteger nums;//默认为1
@end
