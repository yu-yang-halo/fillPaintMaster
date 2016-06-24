//
//  WashOilTableViewCell.m
//  fillPaintMaster
//
//  Created by admin on 16/6/24.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "WashOilTableViewCell.h"

@implementation WashOilTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    NSLog(@"layoutSubViews....");
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
