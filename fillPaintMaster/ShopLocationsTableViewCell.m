//
//  ShopLocationsTableViewCell.m
//  fillPaintMaster
//
//  Created by admin on 16/4/14.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "ShopLocationsTableViewCell.h"

@implementation ShopLocationsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [_phoneButton addTarget:self action:@selector(phoneCall:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)phoneCall:(UIButton *)sender{
    NSString *phone=sender.titleLabel.text;
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phone]]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
