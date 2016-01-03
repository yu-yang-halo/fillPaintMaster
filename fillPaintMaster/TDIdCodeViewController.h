//
//  TDIdCodeViewController.h
//  fillPaintMaster
//
//  Created by apple on 16/1/2.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, TDIdCodeType){
    TDIdCodeType_GETVCODE,
    TDIdCodeType_REGISTER
};
@interface TDIdCodeViewController : UIViewController
@property(nonatomic,assign) TDIdCodeType idCodeType;
@end
