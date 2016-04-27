//
//  ImageUtils.m
//  fillPaintMaster
//
//  Created by admin on 16/4/25.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "ImageUtils.h"
#import "WsqMD5Util.h"
@implementation ImageUtils
+(NSString *)encodeToBase64String:(UIImage *)image format:(NSString *)PNGorJPEG{
    if([PNGorJPEG isEqualToString:@"PNG"]){
       
        NSString *base64imageString=[UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        return [WsqMD5Util encodeToPercentEscapeString:base64imageString];
    }else{
         NSString *base64imageString=[UIImageJPEGRepresentation(image,0) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        return [WsqMD5Util encodeToPercentEscapeString:base64imageString];
    }
    
}

+(UIImage *)decodeBase64ToImage:(NSString *)strEncodeData{
    NSData *data=[[NSData alloc] initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

@end
