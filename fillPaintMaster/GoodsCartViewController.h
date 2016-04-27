//
//  GoodsCartViewController.h
//  fillPaintMaster
//
//  Created by admin on 16/4/27.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsCartViewController : UIViewController

@end

@interface CommitDataBean : NSObject
@property(nonatomic,strong) NSString *data;
@property(nonatomic,assign) float totalPrice;
@property(nonatomic,assign) int shopId;
@end