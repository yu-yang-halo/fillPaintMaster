//
//  TDPassFindViewController.h
//  fillPaintMaster
//
//  Created by apple on 16/1/2.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, TDPassSetType){
    TDPassSetType_FINDPASS,
    TDPassSetType_REGISTER
};

@interface TDPassSetViewController : UIViewController
@property(nonatomic,assign) TDPassSetType passSetType;
@end
