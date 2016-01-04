//
//  CarBeautyViewController.h
//  fillPaintMaster
//
//  Created by apple on 15/9/29.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, CarBeautyType){
    CarBeautyType_beauty,
    CarBeautyType_oil,
    CarBeautyType_paint
};

@interface CarBeautyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign) CarBeautyType carBeautyType;

@end
