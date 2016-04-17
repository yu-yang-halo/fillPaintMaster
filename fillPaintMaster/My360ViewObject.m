//
//  My360View.m
//  fillPaintMaster
//
//  Created by apple on 16/4/17.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "My360ViewObject.h"

@implementation My360ViewObject

-(instancetype)init{
    self=[super init];
    if(self){
        _m360View=[[[NSBundle mainBundle] loadNibNamed:@"My360View" owner:self options:nil] lastObject];
        [_m360View setFrame:CGRectMake(0, 0, 240, 128)];

    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
