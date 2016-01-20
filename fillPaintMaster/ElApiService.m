//
//  ElApiService.m
//  ehome
//
//  Created by admin on 14-7-21.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "ElApiService.h"
#import "GDataXMLNode.h"
#import "TDUser.h"
#import "TDStationInfo.h"
#import "TDShopInfo.h"
#import "TDOilInfo.h"
#import "TDMetalplateInfo.h"
#import "TDDecorationInfo.h"
#import "TDCouponInfo.h"
#import "TDCityInfo.h"
#import "TDCarInfo.h"
#import "TDGoodInfo.h"
const static int DEFAULT_TIME_OUT=11;
const static NSString* WEBSERVICE_IP=@"192.168.2.1";
const static int WEBSERVICE_PORT=8080;
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
            shareService.connect_header=[NSString stringWithFormat:@"http://%@:%d/elws/services/elwsapi/",WEBSERVICE_IP,WEBSERVICE_PORT];
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
    NSString *service=[NSString stringWithFormat:@"%@appUserLogin?name=%@&password=%@clientEnv=ios&logoutYN=0%@",self.connect_header,name,pass,appendHttpStr];
    NSLog(@"appUserLogin service:%@",service);
    NSData *data=[self requestURLSync:service];
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* userIdVal=[[[rootElement elementsForName:@"userId"] objectAtIndex:0] stringValue];
        NSString* secTokenVal=[[[rootElement elementsForName:@"secToken"] objectAtIndex:0] stringValue];
        NSString* errorMsgVal=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        
        NSLog(@"errorCode:%@, userId:%@ ,secToken:%@",errorCodeVal,userIdVal,secTokenVal);
        if([errorCodeVal isEqualToString:@"0"]){
            [[NSUserDefaults standardUserDefaults] setObject:userIdVal forKey:KEY_USERID];
            [[NSUserDefaults standardUserDefaults] setObject:secTokenVal forKey:KEY_SECTOKEN];
            
            return YES;
        }else{
            [self notificationErrorCode:errorMsgVal];
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
    return rootElement;
}

-(NSData *)requestURLSync:(NSString *)service{
    NSURL* url=[NSURL URLWithString:service];
    NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:DEFAULT_TIME_OUT];
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
