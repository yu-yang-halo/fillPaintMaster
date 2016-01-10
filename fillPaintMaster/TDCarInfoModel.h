//
//  TDCarInfoModel.h
//  fillPaintMaster
//
//  Created by apple on 16/1/10.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TDCarInfoData : NSObject

@property (retain, nonatomic) NSString *cphTxt;
@property (retain, nonatomic) NSString *cxTxt;
@property (retain, nonatomic) NSString *fdjTxt;
@property (retain, nonatomic) NSString *cjhTxt;
@property (retain, nonatomic) NSString *gcsjTxt;
@property (retain, nonatomic) NSString *lcTxt;

@end

@interface TDCarInfoModel : NSObject

-(UIView *)carInfoView;

-(TDCarInfoData *)carInfoData;

@end

