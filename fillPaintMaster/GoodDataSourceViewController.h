//
//  GoodDataSourceViewController.h
//  fillPaintMaster
//
//  Created by admin on 16/4/26.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodDataSourceViewController : UIViewController

@property(nonatomic,assign) int clazzType;
@property(nonatomic,strong) NSArray *allGoods;
@property(nonatomic,strong) UIColor *bgColor;
@property(nonatomic,weak) UIViewController *delegateVC;

@end
