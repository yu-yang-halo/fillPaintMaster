//
//  MyOrderTableViewController.h
//  fillPaintMaster
//
//  Created by apple on 16/4/10.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MyOrderTableViewController : UIViewController
@end


@interface OrderInterface : NSObject

@property(nonatomic,assign) int orderType;
@property(nonatomic,assign) int orderId;
@property(nonatomic,assign) int status;
@property(nonatomic,assign) int payStatus;
@property(nonatomic,strong) NSString *numlabel;
@property(nonatomic,strong) NSString *priceLabel;
@property(nonatomic,strong) NSString *createTimeLabel;

@property(nonatomic,strong) NSString *trade_no;
@property(nonatomic,assign) float payPrice;
@property(nonatomic,assign) int shopId;

@end