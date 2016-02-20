//
//  ElApiService.m
//  ehome
//
//  Created by admin on 14-7-21.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "ElApiService.h"
#import "GDataXMLNode.h"

const static int DEFAULT_TIME_OUT=11;
const static NSString* WEBSERVICE_IP=@"liuzhi1212.gicp.net";
const static int WEBSERVICE_PORT=9000;
static  NSString* KEY_USERID=@"userID_KEY";
static  NSString* KEY_SECTOKEN=@"sectoken_KEY";

@interface ElApiService()
-(NSData *)requestURLSync:(NSString *)service;
-(NSData *)requestURL:(NSString *)service;
-(GDataXMLElement *)getRootElementByData:(NSData *)data;
#pragma mark 网络错误汇报
-(void)notificationErrorCode:(NSString *)errorCode;
@end

@implementation ElApiService

+(ElApiService *) shareElApiService{
    @synchronized([ElApiService class]){
        if(shareService==nil){
            shareService=[[ElApiService alloc] init];
            shareService.connect_header=[NSString stringWithFormat:@"http://%@:%d/car/services/carwsapi/",WEBSERVICE_IP,WEBSERVICE_PORT];
        }
        return shareService;
    }
    
}
/***********************************
 * webService API begin...
 ***********************************
 */

-(BOOL)appUserLogin:(NSString *)name password:(NSString *)pass shopId:(int)shopId{
    NSMutableString *appendHttpStr=[[NSMutableString alloc] init];
    if(shopId>0){
        [appendHttpStr appendFormat:@"&shopId=%d",shopId];
    }
    NSString *service=[NSString stringWithFormat:@"%@appUserLogin?name=%@&password=%@&clientEnv=ios&logoutYN=0%@",self.connect_header,name,pass,appendHttpStr];
    NSLog(@"appUserLogin service:%@",service);
    NSData *data=[self requestURLSync:service];
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* userIdVal=[[[rootElement elementsForName:@"userId"] objectAtIndex:0] stringValue];
        NSString* secTokenVal=[[[rootElement elementsForName:@"secToken"] objectAtIndex:0] stringValue];
        NSString* shopIdVal=[[[rootElement elementsForName:@"shopId"] objectAtIndex:0] stringValue];
        
        NSLog(@"errorCode:%@, userId:%@ ,secToken:%@",errorCodeVal,userIdVal,secTokenVal);
        if([errorCodeVal isEqualToString:@"0"]){
            [[NSUserDefaults standardUserDefaults] setObject:userIdVal forKey:KEY_USERID];
            [[NSUserDefaults standardUserDefaults] setObject:secTokenVal forKey:KEY_SECTOKEN];
            
            return YES;
        }else{
            [self notificationErrorCode:nil];
        }
        
    }
    
    return NO;
}
-(BOOL)createUser:(NSString *)loginName password:(NSString *)pass email:(NSString *)email phone:(NSString *)phoneNumber type:(int)type shopId:(int)shopId{
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@createUser?senderId=%@&secToken=%@loginName=%@&password=%@&email=%@&phone=%@&type=%d&shopId=%d",self.connect_header,userID,secToken,loginName,pass,email,phoneNumber,type,shopId];
    NSLog(@"createUser service:%@",service);
    NSData *data=[self requestURLSync:service];
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* shopIdVal=[[[rootElement elementsForName:@"shopId"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSLog(@"errorCode:%@, shopId:%@ ,errorMsg:%@",errorCodeVal,shopIdVal,errorMsgVal);
        if([errorCodeVal isEqualToString:@"0"]){
            return YES;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return NO;
}
-(BOOL)updUser:(TDUser *)tdUser{
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSMutableString *appendHttpStr=[[NSMutableString alloc] init];
    if(tdUser.loginName!=nil){
        [appendHttpStr appendFormat:@"&loginName=%@",tdUser.loginName];
    }
    if(tdUser.password!=nil){
        [appendHttpStr appendFormat:@"&password=%@",tdUser.password];
    }
    if(tdUser.email!=nil){
        [appendHttpStr appendFormat:@"&email=%@",tdUser.email];
    }
    if(tdUser.phone!=nil){
        [appendHttpStr appendFormat:@"&phone=%@",tdUser.phone];
    }
    if(tdUser.type>0){
        [appendHttpStr appendFormat:@"&type=%d",tdUser.type];
    }
    if(tdUser.shopId>0){
        [appendHttpStr appendFormat:@"&shopId=%d",tdUser.shopId];
    }

    
    NSString *service=[NSString stringWithFormat:@"%@createUser?senderId=%@&secToken=%@userId=%@%@",self.connect_header,userID,secToken,userID,appendHttpStr];
    NSLog(@"updUser service:%@",service);
    NSData *data=[self requestURLSync:service];
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* shopIdVal=[[[rootElement elementsForName:@"shopId"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSLog(@"errorCode:%@, shopId:%@ ,errorMsg:%@",errorCodeVal,shopIdVal,errorMsgVal);
        if([errorCodeVal isEqualToString:@"0"]){
            return YES;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return NO;
}
-(TDUser *)getUserInfo{
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@getUserInfoById?senderId=%@&secToken=%@userId=%@",self.connect_header,userID,secToken,userID];
    NSLog(@"getUserInfoById  service:%@",service);
    NSData *data=[self requestURLSync:service];
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            TDUser *user=[[TDUser alloc] init];
            user.loginName=[[[rootElement elementsForName:@"loginName"] objectAtIndex:0] stringValue];
            user.email=[[[rootElement elementsForName:@"email"] objectAtIndex:0] stringValue];
            user.phone=[[[rootElement elementsForName:@"phone"] objectAtIndex:0] stringValue];
            user.wechatId=[[[rootElement elementsForName:@"wechatId"] objectAtIndex:0] stringValue];
            user.type=[[[[rootElement elementsForName:@"type"] objectAtIndex:0] stringValue] intValue];
            user.shopId=[[[[rootElement elementsForName:@"shopId"] objectAtIndex:0] stringValue] intValue];
            user.regTime=[[[rootElement elementsForName:@"regTime"] objectAtIndex:0] stringValue];
            
            return user;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return nil;
}
-(NSArray *)getShopList{
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@getShopList?senderId=%@&secToken=%@",self.connect_header,userID,secToken];
    NSLog(@"getShopList  service:%@",service);
    NSData *data=[self requestURLSync:service];
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSString* numOfShopVal=[[[rootElement elementsForName:@"numOfShop"] objectAtIndex:0] stringValue];
        
        if([errorCodeVal isEqualToString:@"0"]){
            NSArray *shopListNode=[rootElement elementsForName:@"shopList"];
            NSMutableArray *shopInfoArr=[[NSMutableArray alloc] init];
            
            for (GDataXMLElement *element in shopListNode) {
                
                TDShopInfo *tdShopInfo= [self parseTDShopInfoXML:element];
                
                [shopInfoArr addObject:tdShopInfo];
                
            }
            
            
            return shopInfoArr;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return nil;
}


-(NSArray *)getOilListByshopId:(int)shopId{
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@getOilList?senderId=%@&secToken=%@&shopId=%d",self.connect_header,userID,secToken,shopId];
    NSLog(@"getOilList  service:%@",service);
    NSData *data=[self requestURLSync:service];
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSString* numOfOilVal=[[[rootElement elementsForName:@"numOfOil"] objectAtIndex:0] stringValue];
        
        if([errorCodeVal isEqualToString:@"0"]){
            NSArray *oilListNode=[rootElement elementsForName:@"oilList"];
            NSMutableArray *oilArr=[[NSMutableArray alloc] init];
            
            for (GDataXMLElement *element in oilListNode) {
                
                TDOilInfo *tdOilInfo= [self parseTDOilInfoXML:element];
                
                [oilArr addObject:tdOilInfo];
                
            }
            
            
            return oilArr;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return nil;
}
-(NSArray *)getMetalplateList:(int)shopId{
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@getMetalplateList?senderId=%@&secToken=%@&shopId=%d",self.connect_header,userID,secToken,shopId];
    NSLog(@"getMetalplateList  service:%@",service);
    NSData *data=[self requestURLSync:service];
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSString* numOfMetalplateVal=[[[rootElement elementsForName:@"numOfMetalplate"] objectAtIndex:0] stringValue];
        
        if([errorCodeVal isEqualToString:@"0"]){
            NSArray *metalplateListNode=[rootElement elementsForName:@"metalplateList"];
            NSMutableArray *metalplateArr=[[NSMutableArray alloc] init];
            
            for (GDataXMLElement *element in metalplateListNode) {
                
                TDMetalplateInfo *tdMetalplateInfo= [self parseTDMetalplateInfoXML:element];
                
                [metalplateArr addObject:tdMetalplateInfo];
                
            }
            
            
            return metalplateArr;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return nil;
}
-(NSArray *)getDecorationList:(int)shopId{
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@getDecorationList?senderId=%@&secToken=%@&shopId=%d",self.connect_header,userID,secToken,shopId];
    NSLog(@"getDecorationList  service:%@",service);
    NSData *data=[self requestURLSync:service];
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSString* numOfDecorationVal=[[[rootElement elementsForName:@"numOfDecoration"] objectAtIndex:0] stringValue];
        
        if([errorCodeVal isEqualToString:@"0"]){
            NSArray *decorationListNode=[rootElement elementsForName:@"decorationList"];
            NSMutableArray *decorationArr=[[NSMutableArray alloc] init];
            
            for (GDataXMLElement *element in decorationListNode) {
                
                TDDecorationInfo *tdDecorationInfo= [self parseTDDecorationInfoXML:element];
                
                [decorationArr addObject:tdDecorationInfo];
                
            }
            
            
            return decorationArr;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return nil;
}

-(NSArray *)getCouponList:(int)shopId{
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@getCouponList?senderId=%@&secToken=%@&shopId=%d",self.connect_header,userID,secToken,shopId];
    NSLog(@"getCouponList  service:%@",service);
    NSData *data=[self requestURLSync:service];
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSString* numOfCouponVal=[[[rootElement elementsForName:@"numOfCoupon"] objectAtIndex:0] stringValue];
        
        if([errorCodeVal isEqualToString:@"0"]){
            NSArray *couponListNode=[rootElement elementsForName:@"couponList"];
            NSMutableArray *couponArr=[[NSMutableArray alloc] init];
            
            for (GDataXMLElement *element in couponListNode) {
                
                TDCouponInfo *tdCouponInfo= [self parseTDCouponInfoXML:element];
                
                [couponArr addObject:tdCouponInfo];
                
            }
            
            return couponArr;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return nil;
}

-(NSArray *)getCityList:(int)shopId{
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@getCityList?senderId=%@&secToken=%@",self.connect_header,userID,secToken];
    NSLog(@"getCityList  service:%@",service);
    NSData *data=[self requestURLSync:service];
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSString* numOfCityVal=[[[rootElement elementsForName:@"numOfCity"] objectAtIndex:0] stringValue];
        
        if([errorCodeVal isEqualToString:@"0"]){
            NSArray *cityListNode=[rootElement elementsForName:@"cityList"];
            NSMutableArray *cityArr=[[NSMutableArray alloc] init];
            
            for (GDataXMLElement *element in cityListNode) {
                
                TDCityInfo *tdCityInfo= [self parseTDCityInfoXML:element];
                
                [cityArr addObject:tdCityInfo];
                
            }
            
            return cityArr;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return nil;
}

-(NSArray *)getCarByCurrentUser{
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@getCarByUserId?senderId=%@&secToken=%@&userId=%@",self.connect_header,userID,secToken,userID];
    NSLog(@"getCarByUserId  service:%@",service);
    NSData *data=[self requestURLSync:service];
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        
        
        if([errorCodeVal isEqualToString:@"0"]){
            NSArray *carListNode=[rootElement elementsForName:@"carList"];
            NSMutableArray *carArr=[[NSMutableArray alloc] init];
            
            for (GDataXMLElement *element in carListNode) {
                
                TDCarInfo *tdCarInfo= [self parseTDCarInfoXML:element];
                
                [carArr addObject:tdCarInfo];
                
            }
            
            return carArr;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return nil;
}

-(NSArray *)getGoodsList:(int)shopId{
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@getGoodsList?senderId=%@&secToken=%@",self.connect_header,userID,secToken];
    NSLog(@"getGoodsList  service:%@",service);
    NSData *data=[self requestURLSync:service];
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSString* numOfGoodsVal=[[[rootElement elementsForName:@"numOfGoods"] objectAtIndex:0] stringValue];
        
        if([errorCodeVal isEqualToString:@"0"]){
            NSArray *goodsListNode=[rootElement elementsForName:@"goodsList"];
            NSMutableArray *goodsArr=[[NSMutableArray alloc] init];
            
            for (GDataXMLElement *element in goodsListNode) {
                
                TDGoodInfo *tdGoodInfo= [self parseTDGoodInfoXML:element];
                
                [goodsArr addObject:tdGoodInfo];
                
            }
            
            return goodsArr;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return nil;
}
-(BOOL)createOilOrder:(TDOilOrder *)oilOrder{
    
    NSMutableString *appendHttpStr=[[NSMutableString alloc] init];
    if(oilOrder.type>0){
        [appendHttpStr appendFormat:@"&type=%d",oilOrder.type];
    }
    if(oilOrder.state>0){
        [appendHttpStr appendFormat:@"&state=%d",oilOrder.state];
    }
    if(oilOrder.payState>0){
        [appendHttpStr appendFormat:@"&payState=%d",oilOrder.payState];
    }
    if(oilOrder.userId!=nil){
        [appendHttpStr appendFormat:@"&userId=%@",oilOrder.userId];
    }
    if(oilOrder.carId>0){
        [appendHttpStr appendFormat:@"&carId=%d",oilOrder.carId];
    }
    if(oilOrder.shopId>0){
        [appendHttpStr appendFormat:@"&shopId=%d",oilOrder.shopId];
    }
    if(oilOrder.stationId>0){
        [appendHttpStr appendFormat:@"&stationId=%d",oilOrder.stationId];
    }
    if(oilOrder.price>0){
        [appendHttpStr appendFormat:@"&price=%f",oilOrder.price];
    }
    if(oilOrder.couponId>0){
        [appendHttpStr appendFormat:@"&couponId=%d",oilOrder.couponId];
    }
    if(oilOrder.orderTime!=nil){
        [appendHttpStr appendFormat:@"&orderTime=%@",oilOrder.orderTime];
    }
    
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@createOilOrder?senderId=%@&secToken=%@%@",self.connect_header,userID,secToken,appendHttpStr];
    NSLog(@"createOilOrder  service:%@",service);
    NSData *data=[self requestURLSync:service];
    
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSString* createTimeVal=[[[rootElement elementsForName:@"createTime"] objectAtIndex:0] stringValue];
        NSString* idVal=[[[rootElement elementsForName:@"id"] objectAtIndex:0] stringValue];
        
        if([errorCodeVal isEqualToString:@"0"]){
            return YES;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return NO;
}
-(BOOL)delOilOrder:(int)oilOrderId{
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@delOilOrder?senderId=%@&secToken=%@&id=%d",self.connect_header,userID,secToken,oilOrderId];
    NSLog(@"delOilOrder  service:%@",service);
    NSData *data=[self requestURLSync:service];
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSString* idVal=[[[rootElement elementsForName:@"id"] objectAtIndex:0] stringValue];
        
        if([errorCodeVal isEqualToString:@"0"]){
           
            
            return YES;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return NO;
}
-(BOOL)updOilOrder:(TDOilOrder *)oilOrder{
    
    NSMutableString *appendHttpStr=[[NSMutableString alloc] init];
    if(oilOrder.oilOrderId<0){
        return NO;
    }
    
    [appendHttpStr appendFormat:@"&id=%d",oilOrder.oilOrderId];
    if(oilOrder.type>0){
        [appendHttpStr appendFormat:@"&type=%d",oilOrder.type];
    }
    if(oilOrder.state>0){
        [appendHttpStr appendFormat:@"&state=%d",oilOrder.state];
    }
    if(oilOrder.payState>0){
        [appendHttpStr appendFormat:@"&payState=%d",oilOrder.payState];
    }
    if(oilOrder.userId!=nil){
        [appendHttpStr appendFormat:@"&userId=%@",oilOrder.userId];
    }
    if(oilOrder.carId>0){
        [appendHttpStr appendFormat:@"&carId=%d",oilOrder.carId];
    }
    if(oilOrder.shopId>0){
        [appendHttpStr appendFormat:@"&shopId=%d",oilOrder.shopId];
    }
    if(oilOrder.stationId>0){
        [appendHttpStr appendFormat:@"&stationId=%d",oilOrder.stationId];
    }
    if(oilOrder.price>0){
        [appendHttpStr appendFormat:@"&price=%f",oilOrder.price];
    }
    if(oilOrder.couponId>0){
        [appendHttpStr appendFormat:@"&couponId=%d",oilOrder.couponId];
    }
    if(oilOrder.orderTime!=nil){
        [appendHttpStr appendFormat:@"&orderTime=%@",oilOrder.orderTime];
    }
    
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@updOilOrder?senderId=%@&secToken=%@%@",self.connect_header,userID,secToken,appendHttpStr];
    NSLog(@"updOilOrder  service:%@",service);
    NSData *data=[self requestURLSync:service];
    
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
      
        NSString* idVal=[[[rootElement elementsForName:@"id"] objectAtIndex:0] stringValue];
        
        if([errorCodeVal isEqualToString:@"0"]){
            return YES;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return NO;
}


-(NSArray *)getOilOrderList:(TDOrderSearch *)orderSearch{
    NSMutableString *appendHttpStr=[[NSMutableString alloc] init];
    if(orderSearch.searchType==SEARCH_TYPE_SHOPID){
        [appendHttpStr appendFormat:@"&shopId=%d",orderSearch.shopId];
    }else{
        [appendHttpStr appendFormat:@"&userId=%@",orderSearch.userId];
    }
    if(orderSearch.startTime!=nil){
        [appendHttpStr appendFormat:@"&startTime=%@",orderSearch.startTime];
    }
    if(orderSearch.maxNum>0){
        [appendHttpStr appendFormat:@"&maxNum=%d",orderSearch.maxNum];
    }
   
    
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@getOilOrderList?senderId=%@&secToken=%@%@",self.connect_header,userID,secToken,appendHttpStr];
    NSLog(@"getOilOrderList  service:%@",service);
    NSData *data=[self requestURLSync:service];
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSString* numOfOilOrderVal=[[[rootElement elementsForName:@"numOfOilOrder"] objectAtIndex:0] stringValue];
        
        if([errorCodeVal isEqualToString:@"0"]){
            NSArray *oilOrderListNode=[rootElement elementsForName:@"oilOrderList"];
            NSMutableArray *oilOrderArr=[[NSMutableArray alloc] init];
            
            for (GDataXMLElement *element in oilOrderListNode) {
                
                TDOilOrder *tdOilOrder= [self parseTDOilOrderInfoXML:element];
                
                [oilOrderArr addObject:tdOilOrder];
                
            }
            
            return oilOrderArr;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return nil;
}

-(BOOL)createOilOrderNumber:(int)oilOrderId oilId:(int)oilId{
    
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@createOilOrderNumber?senderId=%@&secToken=%@&oilOrderId=%d&oilId=%d",self.connect_header,userID,secToken,oilOrderId,oilId];
    NSLog(@"createOilOrderNumber  service:%@",service);
    NSData *data=[self requestURLSync:service];
    
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSString* idVal=[[[rootElement elementsForName:@"id"] objectAtIndex:0] stringValue];
        
        if([errorCodeVal isEqualToString:@"0"]){
            return YES;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return NO;
}

-(BOOL)createMetaOrder:(TDMetaOrder *)metaOrder{
    
    NSMutableString *appendHttpStr=[[NSMutableString alloc] init];
    if(metaOrder.type>0){
        [appendHttpStr appendFormat:@"&type=%d",metaOrder.type];
    }
    if(metaOrder.state>0){
        [appendHttpStr appendFormat:@"&state=%d",metaOrder.state];
    }
    if(metaOrder.payState>0){
        [appendHttpStr appendFormat:@"&payState=%d",metaOrder.payState];
    }
    if(metaOrder.userId!=nil){
        [appendHttpStr appendFormat:@"&userId=%@",metaOrder.userId];
    }
    if(metaOrder.carId>0){
        [appendHttpStr appendFormat:@"&carId=%d",metaOrder.carId];
    }
    if(metaOrder.shopId>0){
        [appendHttpStr appendFormat:@"&shopId=%d",metaOrder.shopId];
    }
    if(metaOrder.stationId>0){
        [appendHttpStr appendFormat:@"&stationId=%d",metaOrder.stationId];
    }
    if(metaOrder.price>0){
        [appendHttpStr appendFormat:@"&price=%f",metaOrder.price];
    }
    if(metaOrder.couponId>0){
        [appendHttpStr appendFormat:@"&couponId=%d",metaOrder.couponId];
    }
    if(metaOrder.orderTime!=nil){
        [appendHttpStr appendFormat:@"&orderTime=%@",metaOrder.orderTime];
    }
    
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@createMetaOrder?senderId=%@&secToken=%@%@",self.connect_header,userID,secToken,appendHttpStr];
    NSLog(@"createMetaOrder  service:%@",service);
    NSData *data=[self requestURLSync:service];
    
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
       
        NSString* idVal=[[[rootElement elementsForName:@"id"] objectAtIndex:0] stringValue];
        
        if([errorCodeVal isEqualToString:@"0"]){
            return YES;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return NO;
}
-(BOOL)delMetaOrder:(int)metaOrderId{
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@delMetaOrder?senderId=%@&secToken=%@&id=%d",self.connect_header,userID,secToken,metaOrderId];
    NSLog(@"delMetaOrder  service:%@",service);
    NSData *data=[self requestURLSync:service];
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSString* idVal=[[[rootElement elementsForName:@"id"] objectAtIndex:0] stringValue];
        
        if([errorCodeVal isEqualToString:@"0"]){
            
            
            return YES;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return NO;
}
-(BOOL)updMetaOrder:(TDMetaOrder *)metaOrder{
    
    NSMutableString *appendHttpStr=[[NSMutableString alloc] init];
    if(metaOrder.metaOrderId<0){
        return NO;
    }
    
    [appendHttpStr appendFormat:@"&id=%d",metaOrder.metaOrderId];
    if(metaOrder.type>0){
        [appendHttpStr appendFormat:@"&type=%d",metaOrder.type];
    }
    if(metaOrder.state>0){
        [appendHttpStr appendFormat:@"&state=%d",metaOrder.state];
    }
    if(metaOrder.payState>0){
        [appendHttpStr appendFormat:@"&payState=%d",metaOrder.payState];
    }
    if(metaOrder.userId!=nil){
        [appendHttpStr appendFormat:@"&userId=%@",metaOrder.userId];
    }
    if(metaOrder.carId>0){
        [appendHttpStr appendFormat:@"&carId=%d",metaOrder.carId];
    }
    if(metaOrder.shopId>0){
        [appendHttpStr appendFormat:@"&shopId=%d",metaOrder.shopId];
    }
    if(metaOrder.stationId>0){
        [appendHttpStr appendFormat:@"&stationId=%d",metaOrder.stationId];
    }
    if(metaOrder.price>0){
        [appendHttpStr appendFormat:@"&price=%f",metaOrder.price];
    }
    if(metaOrder.couponId>0){
        [appendHttpStr appendFormat:@"&couponId=%d",metaOrder.couponId];
    }
    if(metaOrder.orderTime!=nil){
        [appendHttpStr appendFormat:@"&orderTime=%@",metaOrder.orderTime];
    }
    
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@updMetaOrder?senderId=%@&secToken=%@%@",self.connect_header,userID,secToken,appendHttpStr];
    NSLog(@"updMetaOrder  service:%@",service);
    NSData *data=[self requestURLSync:service];
    
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        
        NSString* idVal=[[[rootElement elementsForName:@"id"] objectAtIndex:0] stringValue];
        
        if([errorCodeVal isEqualToString:@"0"]){
            return YES;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return NO;
}


-(NSArray *)getMetaOrderList:(TDOrderSearch *)orderSearch{
    NSMutableString *appendHttpStr=[[NSMutableString alloc] init];
    if(orderSearch.searchType==SEARCH_TYPE_SHOPID){
        [appendHttpStr appendFormat:@"&shopId=%d",orderSearch.shopId];
    }else{
        [appendHttpStr appendFormat:@"&userId=%@",orderSearch.userId];
    }
    if(orderSearch.startTime!=nil){
        [appendHttpStr appendFormat:@"&startTime=%@",orderSearch.startTime];
    }
    if(orderSearch.maxNum>0){
        [appendHttpStr appendFormat:@"&maxNum=%d",orderSearch.maxNum];
    }
    
    
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@getMetaOrderList?senderId=%@&secToken=%@%@",self.connect_header,userID,secToken,appendHttpStr];
    NSLog(@"getMetaOrderList  service:%@",service);
    NSData *data=[self requestURLSync:service];
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSString* numOfOilOrderVal=[[[rootElement elementsForName:@"numofMetaOrder"] objectAtIndex:0] stringValue];
        
        if([errorCodeVal isEqualToString:@"0"]){
            NSArray *metaOrderListNode=[rootElement elementsForName:@"metaOrderList"];
            NSMutableArray *metaOrderArr=[[NSMutableArray alloc] init];
            
            for (GDataXMLElement *element in metaOrderListNode) {
                
                TDMetaOrder *tdMetaOrder= [self parseTDMetaOrderInfoXML:element];
                
                [metaOrderArr addObject:tdMetaOrder];
                
            }
            
            return metaOrderArr;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return nil;
}

-(BOOL)createMetaOrderNumber:(int)metaOrderId metaId:(int)metaId{
    
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@createMetaOrderNumber?senderId=%@&secToken=%@&metaOrderId=%d&metaId=%d",self.connect_header,userID,secToken,metaOrderId,metaId];
    NSLog(@"createMetaOrderNumber  service:%@",service);
    NSData *data=[self requestURLSync:service];
    
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSString* idVal=[[[rootElement elementsForName:@"id"] objectAtIndex:0] stringValue];
        
        if([errorCodeVal isEqualToString:@"0"]){
            return YES;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return NO;
}
-(BOOL)createMetaOrderImg:(int)metaOrderId imgName:(NSString *)imgName{
    
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@createMetaOrderImg?senderId=%@&secToken=%@&metaOrderId=%d&imgName=%@",self.connect_header,userID,secToken,metaOrderId,imgName];
    NSLog(@"createMetaOrderImg  service:%@",service);
    NSData *data=[self requestURLSync:service];
    
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSString* idVal=[[[rootElement elementsForName:@"id"] objectAtIndex:0] stringValue];
        
        if([errorCodeVal isEqualToString:@"0"]){
            return YES;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return NO;
}


-(BOOL)createDecoOrder:(TDDecoOrder *)decoOrder{
    
    NSMutableString *appendHttpStr=[[NSMutableString alloc] init];
    if(decoOrder.type>0){
        [appendHttpStr appendFormat:@"&type=%d",decoOrder.type];
    }
    if(decoOrder.state>0){
        [appendHttpStr appendFormat:@"&state=%d",decoOrder.state];
    }
    if(decoOrder.payState>0){
        [appendHttpStr appendFormat:@"&payState=%d",decoOrder.payState];
    }
    if(decoOrder.userId!=nil){
        [appendHttpStr appendFormat:@"&userId=%@",decoOrder.userId];
    }
    if(decoOrder.carId>0){
        [appendHttpStr appendFormat:@"&carId=%d",decoOrder.carId];
    }
    if(decoOrder.shopId>0){
        [appendHttpStr appendFormat:@"&shopId=%d",decoOrder.shopId];
    }
    if(decoOrder.stationId>0){
        [appendHttpStr appendFormat:@"&stationId=%d",decoOrder.stationId];
    }
    if(decoOrder.price>0){
        [appendHttpStr appendFormat:@"&price=%f",decoOrder.price];
    }
    if(decoOrder.couponId>0){
        [appendHttpStr appendFormat:@"&couponId=%d",decoOrder.couponId];
    }
    if(decoOrder.orderTime!=nil){
        [appendHttpStr appendFormat:@"&orderTime=%@",decoOrder.orderTime];
    }
    
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@createDecoOrder?senderId=%@&secToken=%@%@",self.connect_header,userID,secToken,appendHttpStr];
    NSLog(@"createDecoOrder  service:%@",service);
    NSData *data=[self requestURLSync:service];
    
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        
        NSString* idVal=[[[rootElement elementsForName:@"id"] objectAtIndex:0] stringValue];
        
        NSString* createTimeVal=[[[rootElement elementsForName:@"createTime"] objectAtIndex:0] stringValue];
        
        if([errorCodeVal isEqualToString:@"0"]){
            return YES;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return NO;
}
-(BOOL)delDecoOrder:(int)decoOrderId{
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@delDecoOrder?senderId=%@&secToken=%@&id=%d",self.connect_header,userID,secToken,decoOrderId];
    NSLog(@"delDecoOrder  service:%@",service);
    NSData *data=[self requestURLSync:service];
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSString* idVal=[[[rootElement elementsForName:@"id"] objectAtIndex:0] stringValue];
        
        if([errorCodeVal isEqualToString:@"0"]){
            
            
            return YES;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return NO;
}

-(BOOL)updDecoOrder:(TDDecoOrder *)decoOrder{
    
    NSMutableString *appendHttpStr=[[NSMutableString alloc] init];
    if(decoOrder.decoOrderId<=0){
        return NO;
    }
    [appendHttpStr appendFormat:@"&id=%d",decoOrder.decoOrderId];
    if(decoOrder.type>0){
        [appendHttpStr appendFormat:@"&type=%d",decoOrder.type];
    }
    if(decoOrder.state>0){
        [appendHttpStr appendFormat:@"&state=%d",decoOrder.state];
    }
    if(decoOrder.payState>0){
        [appendHttpStr appendFormat:@"&payState=%d",decoOrder.payState];
    }
    if(decoOrder.userId!=nil){
        [appendHttpStr appendFormat:@"&userId=%@",decoOrder.userId];
    }
    if(decoOrder.carId>0){
        [appendHttpStr appendFormat:@"&carId=%d",decoOrder.carId];
    }
    if(decoOrder.shopId>0){
        [appendHttpStr appendFormat:@"&shopId=%d",decoOrder.shopId];
    }
    if(decoOrder.stationId>0){
        [appendHttpStr appendFormat:@"&stationId=%d",decoOrder.stationId];
    }
    
    if(decoOrder.couponId>0){
        [appendHttpStr appendFormat:@"&couponId=%d",decoOrder.couponId];
    }
    if(decoOrder.orderTime!=nil){
        [appendHttpStr appendFormat:@"&orderTime=%@",decoOrder.orderTime];
    }
    
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@updDecoOrder?senderId=%@&secToken=%@%@",self.connect_header,userID,secToken,appendHttpStr];
    NSLog(@"updDecoOrder  service:%@",service);
    NSData *data=[self requestURLSync:service];
    
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        
        NSString* idVal=[[[rootElement elementsForName:@"id"] objectAtIndex:0] stringValue];
        
        
        if([errorCodeVal isEqualToString:@"0"]){
            return YES;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return NO;
}


-(NSArray *)getDecoOrderList:(TDOrderSearch *)orderSearch{
    NSMutableString *appendHttpStr=[[NSMutableString alloc] init];
    if(orderSearch.searchType==SEARCH_TYPE_SHOPID){
        [appendHttpStr appendFormat:@"&shopId=%d",orderSearch.shopId];
    }else{
        [appendHttpStr appendFormat:@"&userId=%@",orderSearch.userId];
    }
    if(orderSearch.startTime!=nil){
        [appendHttpStr appendFormat:@"&startTime=%@",orderSearch.startTime];
    }
    if(orderSearch.maxNum>0){
        [appendHttpStr appendFormat:@"&maxNum=%d",orderSearch.maxNum];
    }
    
    
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@getDecoOrderList?senderId=%@&secToken=%@%@",self.connect_header,userID,secToken,appendHttpStr];
    NSLog(@"getDecoOrderList  service:%@",service);
    NSData *data=[self requestURLSync:service];
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSString* numOfOilOrderVal=[[[rootElement elementsForName:@"numOfDecoOrder"] objectAtIndex:0] stringValue];
        
        if([errorCodeVal isEqualToString:@"0"]){
            NSArray *decoOrderListNode=[rootElement elementsForName:@"decoOrderList"];
            NSMutableArray *decoOrderArr=[[NSMutableArray alloc] init];
            
            for (GDataXMLElement *element in decoOrderListNode) {
                
                TDDecoOrder *tdDecoOrder= [self parseTDDecoOrderInfoXML:element];
                
                [decoOrderArr addObject:tdDecoOrder];
                
            }
            
            return decoOrderArr;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return nil;
}


-(BOOL)createDecoOrderNumber:(int)decoOrderId decoId:(int)decoId{
    
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@createDecoOrderNumber?senderId=%@&secToken=%@&decoOrderId=%d&decoId=%d",self.connect_header,userID,secToken,decoOrderId,decoId];
    NSLog(@"createDecoOrderNumber  service:%@",service);
    NSData *data=[self requestURLSync:service];
    
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSString* idVal=[[[rootElement elementsForName:@"id"] objectAtIndex:0] stringValue];
        
        if([errorCodeVal isEqualToString:@"0"]){
            return YES;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return NO;
}

/***********************************
 * webService API end...
 ***********************************
 */

-(TDShopInfo *)parseTDShopInfoXML:(GDataXMLElement *)element{
    TDShopInfo *tdShopInfo=[[TDShopInfo alloc] init];
    
    tdShopInfo.shopId=[[[[element elementsForName:@"shopId"] objectAtIndex:0] stringValue] intValue];
    tdShopInfo.name=[[[element elementsForName:@"name"] objectAtIndex:0] stringValue];
    tdShopInfo.longitude=[[[[element elementsForName:@"longitude"] objectAtIndex:0] stringValue] floatValue];
    tdShopInfo.latitude=[[[[element elementsForName:@"latitude"] objectAtIndex:0] stringValue] floatValue];
    tdShopInfo.cityId=[[[[element elementsForName:@"cityId"] objectAtIndex:0] stringValue] intValue];
    tdShopInfo.desc=[[[element elementsForName:@"desc"] objectAtIndex:0] stringValue];
    return tdShopInfo;
}
-(TDOilInfo *)parseTDOilInfoXML:(GDataXMLElement *)element{
    TDOilInfo *tdOilInfo=[[TDOilInfo alloc] init];
    
    tdOilInfo.oilId=[[[[element elementsForName:@"id"] objectAtIndex:0] stringValue] intValue];
    tdOilInfo.name=[[[element elementsForName:@"name"] objectAtIndex:0] stringValue];
    tdOilInfo.price=[[[[element elementsForName:@"price"] objectAtIndex:0] stringValue] floatValue];
    tdOilInfo.shopId=[[[[element elementsForName:@"shopId"] objectAtIndex:0] stringValue] intValue];
    tdOilInfo.desc=[[[element elementsForName:@"desc"] objectAtIndex:0] stringValue];
    return tdOilInfo;
}
-(TDCityInfo *)parseTDCityInfoXML:(GDataXMLElement *)element{
    TDCityInfo *tdCityInfo=[[TDCityInfo alloc] init];
    
    tdCityInfo.cityId=[[[[element elementsForName:@"cityId"] objectAtIndex:0] stringValue] intValue];
    tdCityInfo.name=[[[element elementsForName:@"name"] objectAtIndex:0] stringValue];
    tdCityInfo.shopNum=[[[[element elementsForName:@"shopNum"] objectAtIndex:0] stringValue] intValue];
    return tdCityInfo;
}
-(TDGoodInfo *)parseTDGoodInfoXML:(GDataXMLElement *)element{
    TDGoodInfo *tdGoodInfo=[[TDGoodInfo alloc] init];
    
    tdGoodInfo.goodId=[[[[element elementsForName:@"id"] objectAtIndex:0] stringValue] intValue];
    tdGoodInfo.name=[[[element elementsForName:@"name"] objectAtIndex:0] stringValue];
    tdGoodInfo.desc=[[[element elementsForName:@"desc"] objectAtIndex:0] stringValue];
    
    tdGoodInfo.src=[[[element elementsForName:@"src"] objectAtIndex:0] stringValue];
    tdGoodInfo.price=[[[[element elementsForName:@"price"] objectAtIndex:0] stringValue] floatValue];
     tdGoodInfo.shopId=[[[[element elementsForName:@"shopId"] objectAtIndex:0] stringValue] intValue];
    tdGoodInfo.isShow=[[[[element elementsForName:@"isShow"] objectAtIndex:0] stringValue] boolValue];
    tdGoodInfo.isChange=[[[[element elementsForName:@"isChange"] objectAtIndex:0] stringValue] boolValue];
    return tdGoodInfo;
}
-(TDOilOrder *)parseTDOilOrderInfoXML:(GDataXMLElement *)element{
    TDOilOrder *tdOilOrder=[[TDOilOrder alloc] init];
    
    tdOilOrder.oilOrderId=[[[[element elementsForName:@"id"] objectAtIndex:0] stringValue] intValue];
    tdOilOrder.type=[[[[element elementsForName:@"type"] objectAtIndex:0] stringValue] intValue];
    tdOilOrder.createTime=[[[element elementsForName:@"createTime"] objectAtIndex:0] stringValue];
    
    tdOilOrder.finishTime=[[[element elementsForName:@"finishTime"] objectAtIndex:0] stringValue];
    tdOilOrder.state=[[[[element elementsForName:@"state"] objectAtIndex:0] stringValue] intValue];
    tdOilOrder.shopId=[[[[element elementsForName:@"shopId"] objectAtIndex:0] stringValue] intValue];
    tdOilOrder.payState=[[[[element elementsForName:@"payState"] objectAtIndex:0] stringValue] intValue];
    tdOilOrder.userId=[[[element elementsForName:@"userId"] objectAtIndex:0] stringValue];
    tdOilOrder.carId=[[[[element elementsForName:@"carId"] objectAtIndex:0] stringValue] intValue];
    tdOilOrder.stationId=[[[[element elementsForName:@"stationId"] objectAtIndex:0] stringValue] intValue];
    tdOilOrder.price=[[[[element elementsForName:@"price"] objectAtIndex:0] stringValue] floatValue];
    tdOilOrder.couponId=[[[[element elementsForName:@"couponId"] objectAtIndex:0] stringValue] intValue];
    
    NSArray *oilOrderNumberListNode=[element elementsForName:@"oilOrderNumber"];
    NSMutableArray *oilOrderNumberArr=[[NSMutableArray alloc] init];
    
    for (GDataXMLElement *child in oilOrderNumberListNode) {
        OilOrderNumberInfo *oilOrderNumberInfo=[[OilOrderNumberInfo alloc] init];
        oilOrderNumberInfo.orderNumberId=[[[[child elementsForName:@"id"] objectAtIndex:0] stringValue] intValue];
        oilOrderNumberInfo.oilId=[[[[child elementsForName:@"oilId"] objectAtIndex:0] stringValue] intValue];
        oilOrderNumberInfo.oilOrderId=[[[[child elementsForName:@"oilOrderId"] objectAtIndex:0] stringValue] intValue];
        [oilOrderNumberArr addObject:oilOrderNumberInfo];
    }
    
    tdOilOrder.oilOrderNumber=oilOrderNumberArr;
    
    return tdOilOrder;
}
-(TDMetaOrder *)parseTDMetaOrderInfoXML:(GDataXMLElement *)element{
    TDMetaOrder *tdMetaOrder=[[TDMetaOrder alloc] init];
    
    tdMetaOrder.metaOrderId=[[[[element elementsForName:@"id"] objectAtIndex:0] stringValue] intValue];
    tdMetaOrder.type=[[[[element elementsForName:@"type"] objectAtIndex:0] stringValue] intValue];
    tdMetaOrder.createTime=[[[element elementsForName:@"createTime"] objectAtIndex:0] stringValue];
    
    tdMetaOrder.finishTime=[[[element elementsForName:@"finishTime"] objectAtIndex:0] stringValue];
    tdMetaOrder.state=[[[[element elementsForName:@"state"] objectAtIndex:0] stringValue] intValue];
    tdMetaOrder.shopId=[[[[element elementsForName:@"shopId"] objectAtIndex:0] stringValue] intValue];
    tdMetaOrder.payState=[[[[element elementsForName:@"payState"] objectAtIndex:0] stringValue] intValue];
    tdMetaOrder.userId=[[[element elementsForName:@"userId"] objectAtIndex:0] stringValue];
    tdMetaOrder.carId=[[[[element elementsForName:@"carId"] objectAtIndex:0] stringValue] intValue];
    tdMetaOrder.stationId=[[[[element elementsForName:@"stationId"] objectAtIndex:0] stringValue] intValue];
    tdMetaOrder.price=[[[[element elementsForName:@"price"] objectAtIndex:0] stringValue] floatValue];
    tdMetaOrder.couponId=[[[[element elementsForName:@"couponId"] objectAtIndex:0] stringValue] intValue];
    
    NSArray *metaOrderNumberListNode=[element elementsForName:@"metaOrderNumber"];
    NSMutableArray *metaOrderNumberArr=[[NSMutableArray alloc] init];
    
    for (GDataXMLElement *child in metaOrderNumberListNode) {
        MetaOrderNumberInfo *metaOrderNumberInfo=[[MetaOrderNumberInfo alloc] init];
        metaOrderNumberInfo.metaNumberId=[[[[child elementsForName:@"id"] objectAtIndex:0] stringValue] intValue];
        metaOrderNumberInfo.metaId=[[[[child elementsForName:@"metaId"] objectAtIndex:0] stringValue] intValue];
        metaOrderNumberInfo.metaOrderId=[[[[child elementsForName:@"metaOrderId"] objectAtIndex:0] stringValue] intValue];
        [metaOrderNumberArr addObject:metaOrderNumberInfo];
    }
    
    NSArray *metaOrderImgListNode=[element elementsForName:@"metaOrderImg"];
    NSMutableArray *metaOrderImgArr=[[NSMutableArray alloc] init];
    
    for (GDataXMLElement *child1 in metaOrderImgListNode) {
        MetaOrderImg *metaOrderImg=[[MetaOrderImg alloc] init];
        metaOrderImg.metaOrderImgId=[[[[child1 elementsForName:@"id"] objectAtIndex:0] stringValue] intValue];
        metaOrderImg.imgName=[[[child1 elementsForName:@"imgName"] objectAtIndex:0] stringValue];
        metaOrderImg.metaOrderId=[[[[child1 elementsForName:@"metaOrderId"] objectAtIndex:0] stringValue] intValue];
        [metaOrderImgArr addObject:metaOrderImg];
    }
    
    tdMetaOrder.metaOrderNumber=metaOrderNumberArr;
    tdMetaOrder.metaOrderImg=metaOrderImgArr;
    return tdMetaOrder;
}
-(TDDecoOrder *)parseTDDecoOrderInfoXML:(GDataXMLElement *)element{
    TDDecoOrder *tdDecoOrder=[[TDDecoOrder alloc] init];
    
    tdDecoOrder.decoOrderId=[[[[element elementsForName:@"id"] objectAtIndex:0] stringValue] intValue];
    tdDecoOrder.type=[[[[element elementsForName:@"type"] objectAtIndex:0] stringValue] intValue];
    tdDecoOrder.createTime=[[[element elementsForName:@"createTime"] objectAtIndex:0] stringValue];
    
    tdDecoOrder.finishTime=[[[element elementsForName:@"finishTime"] objectAtIndex:0] stringValue];
    tdDecoOrder.state=[[[[element elementsForName:@"state"] objectAtIndex:0] stringValue] intValue];
    tdDecoOrder.shopId=[[[[element elementsForName:@"shopId"] objectAtIndex:0] stringValue] intValue];
    tdDecoOrder.payState=[[[[element elementsForName:@"payState"] objectAtIndex:0] stringValue] intValue];
    tdDecoOrder.userId=[[[element elementsForName:@"userId"] objectAtIndex:0] stringValue];
    tdDecoOrder.carId=[[[[element elementsForName:@"carId"] objectAtIndex:0] stringValue] intValue];
    tdDecoOrder.stationId=[[[[element elementsForName:@"stationId"] objectAtIndex:0] stringValue] intValue];
    tdDecoOrder.price=[[[[element elementsForName:@"price"] objectAtIndex:0] stringValue] floatValue];
    tdDecoOrder.couponId=[[[[element elementsForName:@"couponId"] objectAtIndex:0] stringValue] intValue];
    
    NSArray *decoOrderNumberListNode=[element elementsForName:@"decoOrderNumber"];
    NSMutableArray *decoOrderNumberArr=[[NSMutableArray alloc] init];
    
    for (GDataXMLElement *child in decoOrderNumberListNode) {
        DecoOrderNumber *decoOrderNumberInfo=[[DecoOrderNumber alloc] init];
        decoOrderNumberInfo.decoOrderNumberId=[[[[child elementsForName:@"id"] objectAtIndex:0] stringValue] intValue];
        decoOrderNumberInfo.decoOrderId=[[[[child elementsForName:@"decoOrderId"] objectAtIndex:0] stringValue] intValue];
        decoOrderNumberInfo.decoId=[[[[child elementsForName:@"decoId"] objectAtIndex:0] stringValue] intValue];
        [decoOrderNumberArr addObject:decoOrderNumberInfo];
    }
    
    tdDecoOrder.decoOrderNumber=decoOrderNumberArr;
    return tdDecoOrder;
}

-(TDCarInfo *)parseTDCarInfoXML:(GDataXMLElement *)element{
    TDCarInfo *tdCarInfo=[[TDCarInfo alloc] init];
    
    tdCarInfo.carId=[[[[element elementsForName:@"id"] objectAtIndex:0] stringValue] intValue];
    tdCarInfo.type=[[[[element elementsForName:@"type"] objectAtIndex:0] stringValue] intValue];
    tdCarInfo.number=[[[element elementsForName:@"number"] objectAtIndex:0] stringValue];
    tdCarInfo.userId=[[[[element elementsForName:@"userId"] objectAtIndex:0] stringValue] intValue];
    return tdCarInfo;
}
-(TDDecorationInfo *)parseTDDecorationInfoXML:(GDataXMLElement *)element{
    TDDecorationInfo *tdDecorationInfo=[[TDDecorationInfo alloc] init];
    
    tdDecorationInfo.decorationId=[[[[element elementsForName:@"id"] objectAtIndex:0] stringValue] intValue];
    tdDecorationInfo.name=[[[element elementsForName:@"name"] objectAtIndex:0] stringValue];
    tdDecorationInfo.price=[[[[element elementsForName:@"price"] objectAtIndex:0] stringValue] floatValue];
    tdDecorationInfo.shopId=[[[[element elementsForName:@"shopId"] objectAtIndex:0] stringValue] intValue];
    tdDecorationInfo.desc=[[[element elementsForName:@"desc"] objectAtIndex:0] stringValue];
    return tdDecorationInfo;
}
-(TDCouponInfo *)parseTDCouponInfoXML:(GDataXMLElement *)element{
    TDCouponInfo *tdCouponInfo=[[TDCouponInfo alloc] init];
    
    tdCouponInfo.couponId=[[[[element elementsForName:@"id"] objectAtIndex:0] stringValue] intValue];
    tdCouponInfo.name=[[[element elementsForName:@"name"] objectAtIndex:0] stringValue];
    tdCouponInfo.price=[[[[element elementsForName:@"price"] objectAtIndex:0] stringValue] floatValue];
    tdCouponInfo.shopId=[[[[element elementsForName:@"shopId"] objectAtIndex:0] stringValue] intValue];
    tdCouponInfo.desc=[[[element elementsForName:@"desc"] objectAtIndex:0] stringValue];
    tdCouponInfo.discount=[[[[element elementsForName:@"discount"] objectAtIndex:0] stringValue] floatValue];
    tdCouponInfo.type=[[[[element elementsForName:@"type"] objectAtIndex:0] stringValue] intValue];
    tdCouponInfo.createTime=[[[element elementsForName:@"createTime"] objectAtIndex:0] stringValue];
    tdCouponInfo.endTime=[[[element elementsForName:@"endTime"] objectAtIndex:0] stringValue];
     tdCouponInfo.useUserId=[[[[element elementsForName:@"useUserId"] objectAtIndex:0] stringValue] intValue];
    tdCouponInfo.isUsed=[[[[element elementsForName:@"isUsed"] objectAtIndex:0] stringValue] boolValue];
    tdCouponInfo.orderType=[[[[element elementsForName:@"orderType"] objectAtIndex:0] stringValue] intValue];
    return tdCouponInfo;
}
-(TDMetalplateInfo *)parseTDMetalplateInfoXML:(GDataXMLElement *)element{
    TDMetalplateInfo *tdMetalplateInfo=[[TDMetalplateInfo alloc] init];
    
    tdMetalplateInfo.metalplateId=[[[[element elementsForName:@"id"] objectAtIndex:0] stringValue] intValue];
    tdMetalplateInfo.name=[[[element elementsForName:@"name"] objectAtIndex:0] stringValue];
    tdMetalplateInfo.price=[[[[element elementsForName:@"price"] objectAtIndex:0] stringValue] floatValue];
    tdMetalplateInfo.shopId=[[[[element elementsForName:@"shopId"] objectAtIndex:0] stringValue] intValue];
    tdMetalplateInfo.number=[[[[element elementsForName:@"number"] objectAtIndex:0] stringValue] intValue];
    tdMetalplateInfo.desc=[[[element elementsForName:@"desc"] objectAtIndex:0] stringValue];
    return tdMetalplateInfo;
}
-(TDShopInfo *)getShopById:(int)shopId{
    NSString *userID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSString *service=[NSString stringWithFormat:@"%@getShopById?senderId=%@&secToken=%@&shopId=%d",self.connect_header,userID,secToken,shopId];
    NSLog(@"getShopById  service:%@",service);
    NSData *data=[self requestURLSync:service];
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        
        
        if([errorCodeVal isEqualToString:@"0"]){
            TDShopInfo *tdShopInfo=[self parseTDShopInfoXML:rootElement];
            
            
            return tdShopInfo;
        }else{
            [self notificationErrorCode:errorMsgVal];
        }
        
    }
    return nil;
}



#pragma private

-(void)notificationErrorCode:(NSString *)errorCode{
    return ;
}
-(GDataXMLElement *)getRootElementByData:(NSData *)data{
    GDataXMLDocument *doc=[[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    GDataXMLElement *rootElement=[doc rootElement];
    return [rootElement copy];
}

-(NSData *)requestURLSync:(NSString *)service{
    NSURL* url=[NSURL URLWithString:service];
    NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:12];
    [request setHTTPMethod:@"GET"];
    NSURLResponse* response=nil;
    NSError* error=nil;
    NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(data!=nil){
        return data;
    }else{
        NSString *errorDescription=nil;
        errorDescription=error.localizedDescription;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self notificationErrorCode:errorDescription];
            
        });
    }
    return nil;
}





#pragma nouse
-(NSData *)requestURL:(NSString *)service{
    NSURL* url=[NSURL URLWithString:service];
    NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:DEFAULT_TIME_OUT];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue* queue=[[NSOperationQueue alloc] init];
     [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         NSLog(@"asyn RESPONSE :%@  NSDATA :%@  NSERROR:%@",response,[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],connectionError);
     }];
    return nil;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    @synchronized(self){
        if(shareService==nil){
            shareService=[super allocWithZone:zone];
            return shareService;
        }
    }
    return nil;
}
-(id)copyWithZone:(NSZone *)zone{
    return self;
}

- (instancetype)init
{
    @synchronized(self){
        self=[super init];
        return self;
    }
    
}

@end
