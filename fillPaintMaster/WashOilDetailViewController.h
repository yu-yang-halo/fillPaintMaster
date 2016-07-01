//
//  WashOilDetailViewController.h
//  fillPaintMaster
//
//  Created by admin on 16/6/24.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarBeautyViewController.h"
@interface WashOilDetailViewController : UIViewController
@property(nonatomic,strong) NSString *src;
@property(nonatomic,strong) NSString *desc;
@property(nonatomic,assign) int pos;
@property(nonatomic,assign) int itemId;
@property(nonatomic,assign) CarBeautyType type;
@property(nonatomic,weak) CarBeautyViewController *vcDelegate;
@end
