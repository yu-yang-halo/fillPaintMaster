//
//  CartManager.m
//  fillPaintMaster
//
//  Created by admin on 16/4/27.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "CartManager.h"
static CartManager *instance;

@interface CartManager (){
    
}
@property(nonatomic,strong,readwrite) NSMutableArray<MyCartClass *> *myCartClassList;
@end


@implementation CartManager

-(void)addGoodsToCart:(MyCartClass *)cartClass{
    if(_myCartClassList==nil){
       self.myCartClassList=[[NSMutableArray alloc] init];
    }
    int pos=-1;
    for (int i=0;i<[_myCartClassList count];i++) {
        if([[_myCartClassList objectAtIndex:i] goodsId]==cartClass.goodsId){
            [(MyCartClass *)[_myCartClassList objectAtIndex:i] setCount:cartClass.count];
            pos=i;
        }
    }
    
    if(pos<0){
        [_myCartClassList addObject:cartClass];
    }
}

-(void)clearCartClassList{
    if(_myCartClassList!=nil){
        [_myCartClassList removeAllObjects];
    }
}


+(instancetype)defaultManager{
    if(instance==nil){
        instance=[[CartManager alloc] init];
        
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

@end
