//
//  GaVideoFrameDataGenerator.h
//  IOTCamera
//
//  Created by RD1-Gavin on 2015/6/9.
//
//

#import <Foundation/Foundation.h>

@interface GaVideoFrameDataGenerator : NSObject

- (id)initWithSubDir:(NSString*)aSubDir beginFrmNo:(int)nBeginFrmNo endFrmNo:(int)nEndFrmNo;
- (int)getFrameData:(unsigned char*)recvBuf frameData_size:(int)aFrameData_Size outFrameData_size:(int*)pOutBufSize frameInfo:(unsigned char*)pFrmInfo frameInfo_size:(int)aFrameInfo_Size outFrameInfo_size:(int*)pOutFrameInfoSize frmNo:(int*)pFrmNo;

@end
