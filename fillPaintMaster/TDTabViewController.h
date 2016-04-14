//
//  TDTabViewController.h
//  fillPaintMaster
//
//  Created by apple on 15/9/28.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
  自定义Tab界面 
 */

@protocol MyTabHandlerDelegate <NSObject>

-(void)onModeSelected:(int)mode;

@end

@interface TDTabViewController : UITabBarController

@property(nonatomic,weak) id<MyTabHandlerDelegate> tabHandlerDelegate;

@end

