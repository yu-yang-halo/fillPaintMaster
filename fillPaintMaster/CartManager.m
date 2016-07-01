//
//  CartManager.m
//  fillPaintMaster
//
//  Created by admin on 16/4/27.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "CartManager.h"
#import <JSONKit/JSONKit.h>
#import <DCKeyValueObjectMapping/DCKeyValueObjectMapping.h>
#import <DCKeyValueObjectMapping/DCParserConfiguration.h>
#import <DCKeyValueObjectMapping/DCArrayMapping.h>

static CartManager *instance;
static NSString *KEY_CART_CLASS=@"key_cart_class";
@interface CartManager (){
    
}
@property(nonatomic,strong) NSMutableArray *cartClassList;
@end


@implementation CartManager
-(NSArray *)getMyCartClassList{
    return [self getMyCartClassFromDisk];
}
-(void)addGoodsToCart:(MyCartClass *)cartClass{
    [self getMyCartClassFromDisk];
    int pos=-1;
    for (int i=0;i<[_cartClassList count];i++) {
        if([[_cartClassList objectAtIndex:i] goodsId]==cartClass.goodsId){
            [(MyCartClass *)[_cartClassList objectAtIndex:i] setCount:cartClass.count];
            pos=i;
        }
    }
    
    if(pos<0){
        [_cartClassList addObject:cartClass];
    }
    
    [self saveMyCartClassToDisk];
    
}
-(void)saveMyCartClassToDisk{
   
   [self saveMyCartClassToDisk:_cartClassList];
    
}
-(void)saveMyCartClassToDisk:(NSMutableArray *)datas{
    
    self.cartClassList=datas;
    
    NSData *data=[NSKeyedArchiver archivedDataWithRootObject:_cartClassList];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:KEY_CART_CLASS];
}
-(NSArray *)getMyCartClassFromDisk{
    NSData *data=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_CART_CLASS];
    NSArray *list=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if(list!=nil){
        
        self.cartClassList=[list mutableCopy];
        
    }
  
    return _cartClassList;
    
}

//
//-(void)clearCartClassList{
//    if(_myCartClassList!=nil){
//        [_myCartClassList removeAllObjects];
//    }
//}


+(instancetype)defaultManager{
    if(instance==nil){
        instance=[[CartManager alloc] init];
        instance.cartClassList=[NSMutableArray new];
    }
    return instance;
}
-(instancetype)init{
    if(instance==nil){
        self=[super init];
        instance=self;
    }
    return instance;
}
-(id)copy{
    if(instance!=nil){
        return instance;
    }
    return nil;
}

@end

@implementation MyCartClass
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:self.goodsId forKey:@"goodsId"];
    [aCoder encodeInt:self.count forKey:@"count"];
    [aCoder encodeBool:self.checkYN forKey:@"checkYN"];
    [aCoder encodeObject:self.imageUrl forKey:@"imageUrl"];
    [aCoder encodeObject:self.goodInfo forKey:@"goodInfo"];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if([self init]){
        self.goodsId=[aDecoder decodeIntForKey:@"goodsId"];
        self.count=[aDecoder decodeIntForKey:@"count"];
        self.checkYN=[aDecoder decodeBoolForKey:@"checkYN"];
        self.imageUrl=[aDecoder decodeObjectForKey:@"imageUrl"];
        self.goodInfo=[aDecoder decodeObjectForKey:@"goodInfo"];
    }
    return self;
}
@end

