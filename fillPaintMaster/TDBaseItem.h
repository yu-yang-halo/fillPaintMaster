//
//  TDBaseItem.h
//  fillPaintMaster
//
//  Created by admin on 16/1/4.
//  Copyright (c) 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDBaseItem : NSObject
@property(nonatomic,retain) NSString *itemName;
@property(nonatomic,assign) float itemPrice;
@property(nonatomic,readonly) float totalPrice;
@property(nonatomic,assign) BOOL isAddYN;

@end
