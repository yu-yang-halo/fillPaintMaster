//
//  GoodsTopCollectionViewCell.h
//  fillPaintMaster
//
//  Created by admin on 16/6/23.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
@interface GoodsTopCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodImageVIew;
@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
