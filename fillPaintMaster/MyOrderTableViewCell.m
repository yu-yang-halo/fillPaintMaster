//
//  MyOrderTableViewCell.m
//  fillPaintMaster
//
//  Created by apple on 16/4/10.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "MyOrderTableViewCell.h"

@implementation MyOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.cancelButton.layer setBorderColor:[[UIColor redColor] CGColor]];
    [self.cancelButton.layer setBorderWidth:1];
    
    [self.payButton.layer setBorderColor:[[UIColor redColor] CGColor]];
    [self.payButton.layer setBorderWidth:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
