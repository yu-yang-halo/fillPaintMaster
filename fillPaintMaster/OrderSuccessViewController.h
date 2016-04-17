//
//  OrderSuccessViewController.h
//  fillPaintMaster
//
//  Created by apple on 15/10/5.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarBeautyViewController.h"
@interface OrderSuccessViewController : UIViewController
@property(nonatomic,assign) CarBeautyType carBeautyType;
@property(nonatomic,assign) BOOL resultOK;
@property(nonatomic,strong) NSArray *items;

@end
