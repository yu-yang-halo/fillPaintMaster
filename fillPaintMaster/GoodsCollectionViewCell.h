//
//  GoodsCollectionViewCell.h
//  fillPaintMaster
//
//  Created by admin on 16/4/26.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface GoodsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
