//
//  AppDelegate.h
//  fillPaintMaster
//
//  Created by apple on 15/9/14.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,assign) CLLocationCoordinate2D myLocation;

@end


