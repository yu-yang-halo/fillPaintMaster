//
//  TDBeautyTableViewCell.m
//  fillPaintMaster
//
//  Created by apple on 15/9/29.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import "TDBeautyTableViewCell.h"

@implementation TDBeautyTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    //NSLog(@"awakeFromNib...");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

@end
