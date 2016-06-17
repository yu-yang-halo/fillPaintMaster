//
//  ShopLocationsTableViewCell.h
//  fillPaintMaster
//
//  Created by admin on 16/4/14.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopLocationsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedStatusImageView;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;


@end
