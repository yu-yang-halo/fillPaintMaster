//
//  TDActiveTableViewCell.h
//  fillPaintMaster
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDActiveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *activeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *activeNumsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *activeImageView;

@end

