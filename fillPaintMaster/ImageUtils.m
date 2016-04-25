//
//  ImageUtils.m
//  fillPaintMaster
//
//  Created by admin on 16/4/25.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "ImageUtils.h"

@implementation ImageUtils
+(NSString *)encodeToBase64String:(UIImage *)image format:(NSString *)PNGorJPEG{
    if([PNGorJPEG isEqualToString:@"PNG"]){
        return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }else{
        return [UIImageJPEGRepresentation(image,0) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    
}
+(UIImage *)decodeBase64ToImage:(NSString *)strEncodeData{
    NSData *data=[[NSData alloc] initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

@end
