//
//  TDButtonView.m
//  fillPaintMaster
//
//  Created by admin on 15/12/29.
//  Copyright (c) 2015年 LZTech. All rights reserved.
//

#import "TDButtonView.h"
@interface TDButtonView()
@property (readwrite, nonatomic)  UILabel *textLabel;
@property (readwrite, nonatomic)  UILabel *numbersLabel;
@property (readwrite, nonatomic)  UIImageView *imageView;

@end
@implementation TDButtonView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if(self){
        
        [self initOtherView:frame];
        
        
    }
    return self;
    
}

-(void)initOtherView:(CGRect)frame{
    self.textLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 18)];
    [self.textLabel setTextAlignment:NSTextAlignmentCenter];
    [self.textLabel setFont:[UIFont systemFontOfSize:13]];
    
    
    self.imageView=[[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-40)/2,(frame.size.height-40)/2,40,40)];
    
    
    self.numbersLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,frame.size.height-25, frame.size.width,25)];
    [self.numbersLabel setTextAlignment:NSTextAlignmentCenter];
    [self.numbersLabel setBackgroundColor:[UIColor colorWithRed:160/255.0 green:217/255.0 blue:246/255.0 alpha:1]];
    [self.numbersLabel setFont:[UIFont systemFontOfSize:20]];
    [self.numbersLabel setTextColor:[UIColor whiteColor]];
    
    [self.layer setCornerRadius:3];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self.layer setBorderWidth:1];
    [self.layer setBorderColor:[[UIColor grayColor] CGColor]];
    
    [self.numbersLabel.layer setCornerRadius:3];
    
    [self addSubview:_textLabel];
    [self addSubview:_imageView];
    [self addSubview:_numbersLabel];
    
    
    
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self initOtherView:self.frame];


}




@end
