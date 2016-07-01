//
//  TDGoodInfo.m
//  fillPaintMaster
//
//  Created by apple on 16/1/20.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "TDGoodInfo.h"

@implementation TDGoodInfo
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:self.goodId forKey:@"goodId"];
    [aCoder encodeInt:self.shopId forKey:@"shopId"];
    [aCoder encodeInt:self.type forKey:@"type"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.desc forKey:@"desc"];
    [aCoder encodeObject:self.src forKey:@"src"];
    [aCoder encodeObject:self.href forKey:@"href"];
   
    [aCoder encodeFloat:self.price forKey:@"price"];
    [aCoder encodeBool:self.isShow forKey:@"isShow"];
    [aCoder encodeBool:self.isChange forKey:@"isChange"];
    [aCoder encodeBool:self.isTop forKey:@"isTop"];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if([self init]){
        self.goodId=[aDecoder decodeIntForKey:@"goodId"];
        self.shopId=[aDecoder decodeIntForKey:@"shopId"];
        self.type=[aDecoder decodeIntForKey:@"type"];
        self.name=[aDecoder decodeObjectForKey:@"name"];
        self.desc=[aDecoder decodeObjectForKey:@"desc"];
        self.src=[aDecoder decodeObjectForKey:@"src"];
        self.href=[aDecoder decodeObjectForKey:@"href"];
        
        self.price=[aDecoder decodeFloatForKey:@"price"];
        self.isShow=[aDecoder decodeBoolForKey:@"isShow"];
        self.isChange=[aDecoder decodeBoolForKey:@"isChange"];
        self.isTop=[aDecoder decodeBoolForKey:@"isTop"];
    }
    return self;
}
@end
