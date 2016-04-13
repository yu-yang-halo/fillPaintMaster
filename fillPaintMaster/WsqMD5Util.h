//
//  MD5.h
//  ehome
//
//  Created by admin on 14-7-21.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

//
//  WsqMD5Util.h
//  Created by apple on 13-10-4.
//  Copyright (c) 2013年 All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#define FileHashDefaultChunkSizeForReadingData 1024*8 // 8K

@interface WsqMD5Util :NSObject

//计算NSData 的MD5值
+(NSString*)getMD5WithData:(NSData*)data;

//计算字符串的MD5值，
+(NSString*)getmd5WithString:(NSString*)string;

//计算大文件的MD5值
+(NSString*)getFileMD5WithPath:(NSString*)path;

+(NSString *)encodeToPercentEscapeString:(NSString *)input;

+(NSString *)decodeFromPercentEscapeString:(NSString *)input;

@end