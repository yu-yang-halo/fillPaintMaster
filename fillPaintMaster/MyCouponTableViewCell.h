//
//  MyCouponTableViewCell.h
//  fillPaintMaster
//
//  Created by apple on 16/4/10.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCouponTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UILabel *couponContentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *invaildImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end
