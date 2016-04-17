//
//  My360View.h
//  fillPaintMaster
//
//  Created by apple on 16/4/17.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface My360ViewObject : NSObject

@property(nonatomic,strong) UIView *m360View;
@property (weak, nonatomic) IBOutlet UIButton *my360Button;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
