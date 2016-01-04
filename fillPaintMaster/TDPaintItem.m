//
//  TDPaintItem.m
//  fillPaintMaster
//
//  Created by admin on 16/1/4.
//  Copyright (c) 2016年 LZTech. All rights reserved.
//

#import "TDPaintItem.h"
@interface TDPaintItem(){
    
}

@end
@implementation TDPaintItem
-(instancetype)init{
    self=[super init];
    if(self){
        self.nums=1;
    }
    return self;
}
-(float)totalPrice{
    return self.itemPrice*_nums;
}

@end
