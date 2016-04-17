//
//  OrderReViewController.h
//  fillPaintMaster
//
//  Created by apple on 15/10/2.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarBeautyViewController.h"
#import "HeaderUViewController.h"
@interface OrderReViewController : HeaderUViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign) CarBeautyType carBeautyType;
@property(retain,nonatomic) NSMutableArray *items;
@end
