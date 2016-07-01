//
//  DelegateViewController.h
//  fillPaintMaster
//
//  Created by admin on 15/12/29.
//  Copyright (c) 2015年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OutOfViewLoadDelegate<NSObject>

- (void)clickButton:(UIButton *)sender;
- (void)clickView:(id)sender;
- (void)clickLabel:(id)sender;
@end

@interface DelegateViewController : UIViewController

@property(nonatomic,weak) id<OutOfViewLoadDelegate> viewDelegate;

@end
