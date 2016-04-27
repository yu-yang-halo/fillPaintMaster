//
//  CarBeautyViewController.h
//  fillPaintMaster
//
//  Created by apple on 15/9/29.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderUViewController.h"
typedef NS_ENUM(NSUInteger, CarBeautyType){
    CarBeautyType_beauty=5,
    CarBeautyType_oil=6,
    CarBeautyType_paint=7,
    CarBeautyType_none=-1
};

@interface CarBeautyViewController : HeaderUViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign) CarBeautyType carBeautyType;


@end
