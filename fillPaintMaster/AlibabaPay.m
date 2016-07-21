//
//  AliPayUtil.m
//  fillPaintMaster
//
//  Created by admin on 16/7/18.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "AlibabaPay.h"
#import "Order.h"

@interface AlibabaPay()
{
    
}
@property(nonatomic,strong) NSString *partner;
@property(nonatomic,strong) NSString *seller;
@end

@implementation AlibabaPay
-(instancetype)initPartner:(NSString *)partner seller:(NSString *)seller{
    self=[super init];
    if(self){
        self.partner=partner;
        self.seller=seller;
    }
    return self;
}


-(NSString *)getTradInfo:(Product *)product{
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = _partner;
    order.sellerID = _seller;
    order.outTradeNO =product.orderId; //订单ID（由商家自行制定）
    order.subject = product.subject; //商品标题
    order.body = product.body; //商品描述
    order.totalFee = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
    order.notifyURL =  @"http://112.124.106.131/kele/Notify_aliNotify"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showURL = @"m.alipay.com";
      //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
   // NSLog(@"orderSpec = %@",orderSpec);
    
    return orderSpec;
}
-(NSString *)getPayInfoData:(Product *)product{
    NSString *orderSpec=[self getTradInfo:product];
    NSString *signedString = [self urlEncodedString:product.sign];
     //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec, signedString, @"RSA"];
    
    return orderString;

}
-(void)aliPay:(Product *)product callback:(CompletionBlock) block{
    self.block=block;
    NSString *orderString=[self getPayInfoData:product];
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alipayScheme";

   
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:_block];
    
}

-(NSString*)urlEncodedString:(NSString *)string
{
    NSString * encodedString = (__bridge_transfer  NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
    
    return encodedString;
}
@end

@implementation Product


@end
