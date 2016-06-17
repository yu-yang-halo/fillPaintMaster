//
//  MyCollectionViewCell.m
//  fillPaintMaster
//
//  Created by apple on 16/4/16.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.timeButton.layer setBorderColor:[[UIColor colorWithWhite:0.7 alpha:0.3] CGColor]];
    [self.timeButton.layer setBorderWidth:1];
    [self.timeButton.layer setCornerRadius:1];
    
    [self.timeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
}

@end
