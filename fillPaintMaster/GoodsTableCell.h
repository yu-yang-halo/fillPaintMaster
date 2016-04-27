//
//  GoodsTableCell.h
//  fillPaintMaster
//
//  Created by admin on 16/4/27.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
