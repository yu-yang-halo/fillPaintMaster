//
//  UILabel+Padding.m
//  fillPaintMaster
//
//  Created by admin on 16/6/20.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "PaddingLabel.h"
@interface PaddingLabel(){
    UIEdgeInsets edgeInsets;
}
@end
@implementation PaddingLabel
-(void)drawTextInRect:(CGRect)rect{
   
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, edgeInsets)];
    
}
-(void)setLabelEdgeInsets:(UIEdgeInsets)insets{
    edgeInsets=insets;
}
@end
