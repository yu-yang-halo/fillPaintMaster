//
//  YYButtonUtils.m
//  fillPaintMaster
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "YYButtonUtils.h"

@implementation YYButtonUtils

///(20 0; 20 49)    (0 8; 20 33) (26.5 24.5; 0 0)
+(void)imageTopTextBottom:(UIButton *)button{
    float image_height=button.frame.size.height*0.6;
    float text_height=button.frame.size.height*0.4;
    
    button.imageEdgeInsets = UIEdgeInsetsMake(5,0,text_height,0);
    
    button.titleEdgeInsets = UIEdgeInsetsMake(image_height,-button.imageView.frame.size.width-button.titleLabel.frame.size.width,0,0);
    button.titleLabel.font = [UIFont systemFontOfSize:10];//title字体大小
    button.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    [button setTitleColor:[UIColor colorWithRed:67/255.0 green:166/255.0 blue:194/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor colorWithRed:67/255.0 green:166/255.0 blue:194/255.0 alpha:1.0] forState:UIControlStateSelected];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    
}
+(void)LimageLeftTextRight:(UIButton *)button{
    
    float image_width=button.frame.size.width*0.5;
    float text_width=button.frame.size.width*0.5;
    
    button.imageEdgeInsets = UIEdgeInsetsMake(0,-text_width+5,0,5);
    
    button.titleEdgeInsets = UIEdgeInsetsMake(0,-button.imageView.frame.size.width,0,10);
    button.titleLabel.font = [UIFont systemFontOfSize:16];//title字体大小
    button.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    [button setTitleColor:[UIColor colorWithRed:67/255.0 green:166/255.0 blue:194/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor colorWithRed:67/255.0 green:166/255.0 blue:194/255.0 alpha:1.0] forState:UIControlStateSelected];
    
    [button setTitleColor:[UIColor colorWithWhite:0 alpha:0.8] forState:UIControlStateNormal];
    
    
    
}
+(void)RimageLeftTextRight:(UIButton *)button{
    
    float image_width=button.frame.size.width*0.5;
    float text_width=button.frame.size.width*0.5;
    
    button.imageEdgeInsets = UIEdgeInsetsMake(0,-text_width+25,0,-10);
    
    button.titleEdgeInsets = UIEdgeInsetsMake(0,-button.imageView.frame.size.width,0,-30);
    button.titleLabel.font = [UIFont systemFontOfSize:16];//title字体大小
    button.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    [button setTitleColor:[UIColor colorWithRed:67/255.0 green:166/255.0 blue:194/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor colorWithRed:67/255.0 green:166/255.0 blue:194/255.0 alpha:1.0] forState:UIControlStateSelected];
    
    [button setTitleColor:[UIColor colorWithWhite:0 alpha:0.8] forState:UIControlStateNormal];
    
    
    
}

@end
