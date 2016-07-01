//
//  MyGoodsOrderItemCell.h
//  fillPaintMaster
//
//  Created by admin on 16/7/1.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyGoodsOrderItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *payNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
