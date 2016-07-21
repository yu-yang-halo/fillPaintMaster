//
//  AliPayUtil.h
//  fillPaintMaster
//
//  Created by admin on 16/7/18.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>
//
//测试商品信息封装在Product中,外部商户可以根据自己商品实际情况定义
//
@interface Product : NSObject{
@private
    float     _price;
    NSString *_subject;
    NSString *_body;
    NSString *_orderId;
    NSString *_sign;
}

@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *sign;
@end


@interface AlibabaPay : NSObject

@property(nonatomic,strong) CompletionBlock block;
-(instancetype)initPartner:(NSString *)partner seller:(NSString *)seller;
-(void)aliPay:(Product *)product callback:(CompletionBlock) block;


-(NSString *)getTradInfo:(Product *)product;





@end
