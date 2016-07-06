//
//  MessageManager.m
//  fillPaintMaster
//
//  Created by admin on 16/7/6.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "MessageManager.h"
static NSString *KEY_MESSAGE_DATA=@"key_message_data";
@implementation JPMessage
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.msgContent forKey:@"msgContent"];
    
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if([self init]){
        self.msgContent=[aDecoder decodeObjectForKey:@"msgContent"];
    }
    return self;
    
}
@end

@implementation MessageManager
+(void)addJPMessage:(JPMessage *)msg{

   NSMutableArray *list=[self getJPMessageArray];
    
   [list addObject:msg];
    
    
   NSData *mdata=[NSKeyedArchiver archivedDataWithRootObject:list];
    
   [[NSUserDefaults standardUserDefaults] setObject:mdata forKey:KEY_MESSAGE_DATA];
    
}
+(void)emptyJPMessage{
   [[NSUserDefaults standardUserDefaults] removeObjectForKey:KEY_MESSAGE_DATA];

}
+(NSMutableArray *)getJPMessageArray{
    NSData *data=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_MESSAGE_DATA];
    NSMutableArray *list;
    if(data!=nil){
        list=[[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    }
    if(list==nil){
        list=[NSMutableArray new];
    }
    return list;
}
@end
