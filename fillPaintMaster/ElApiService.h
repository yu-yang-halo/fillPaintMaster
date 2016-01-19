//
//  ElApiService.h
//  ehome
//
//  Created by admin on 14-7-21.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ElApiService;
static ElApiService* shareService=nil;
@interface ElApiService : NSObject{
    
}
@property(nonatomic,retain) NSString* connect_header;
+(ElApiService *) shareElApiService;


@end

