//
//  GoodsDetailHrefViewController.h
//  fillPaintMaster
//
//  Created by admin on 16/6/23.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDGoodInfo.h"
@interface GoodsDetailHrefViewController : UIViewController
@property(nonatomic,strong) TDGoodInfo *goodInfo;
@property(nonatomic,assign) int count;
@property(nonatomic,strong) NSString *imageUrl;
@end
