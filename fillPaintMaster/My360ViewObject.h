//
//  My360View.h
//  fillPaintMaster
//
//  Created by apple on 16/4/17.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
@interface My360ViewObject : NSObject

@property(nonatomic,strong) UIView *m360View;
@property (weak, nonatomic) IBOutlet UIImageView *my360Button;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *gpsBtn;

@end
