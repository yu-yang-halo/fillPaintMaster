//
//  TDTabViewController.h
//  fillPaintMaster
//
//  Created by apple on 15/9/28.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
/*
  自定义Tab界面 
 */
extern NSString *kNotificationLocationUpdate;

@protocol TDEventCallback <NSObject>

-(void)onLocationComplete:(BMKUserLocation *)userLocation;

@end


@interface TDTabViewController : UITabBarController

//@property(nonatomic,weak) id<TDEventCallback> eventDelegate;

@end
