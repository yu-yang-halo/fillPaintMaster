//
//  AppDelegate.m
//  fillPaintMaster
//
//  Created by apple on 15/9/14.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import "AppDelegate.h"
#import "ElApiService.h"
#import <IOTCamera/Camera.h>
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import <UIView+Toast.h>


@interface AppDelegate ()
{
    BMKMapManager *mapManager;
   
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [Camera initIOTC];
  
   
    mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [mapManager start:@"r3ZVUYbY8K40NBY4D11uchiKIbPHBATj"  generalDelegate:nil];
    //r3ZVUYbY8K40NBY4D11uchiKIbPHBATj
    //zM1g4ZYRsDAQAfK8kiZtVBiVx3FPo9Tj
    if (!ret) {
        NSLog(@"manager start failed!");
    }else{
        NSLog(@"manager start success");
    }
    
    

    [[ElApiService shareElApiService] setIWSErrorCodeListenerBlock:^(NSString * errorCode, NSString *errorMsg) {
        if(errorMsg!=nil){
           [self.window makeToast:errorMsg];
        }
        
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
