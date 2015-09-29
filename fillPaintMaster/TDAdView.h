//
//  TDAdView.h
//  fillPaintMaster
//
//  Created by apple on 15/9/28.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDAdView : UIView

-(instancetype)initADViewWithFrame:(CGRect)frame  adImageNames:(NSArray *)imgNames;

-(void)setAdViewImages:(NSArray *)imgNames;

@end
