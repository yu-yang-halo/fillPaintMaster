//
//  ImageUtils.h
//  fillPaintMaster
//
//  Created by admin on 16/4/25.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageUtils : NSObject
+(NSString *)encodeToBase64String:(UIImage *)image format:(NSString *)PNGorJPEG;
+(UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;

@end
