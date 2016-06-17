//
//  GoodsViewController.h
//  fillPaintMaster
//
//  Created by admin on 16/4/21.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "ElApiService.h"
@interface GoodsViewController : UIViewController
@property(nonatomic,strong) NSArray<TDGoodsType *> *goodsTypeList;
@end
