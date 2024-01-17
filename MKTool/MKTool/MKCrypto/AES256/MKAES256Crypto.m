//
//  MKAES256Crypto.m
//  MKTool
//
//  Created by 麻明康 on 2024/1/16.
//

#import "MKAES256Crypto.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation MKAES256Crypto
/**AES 256 加密方法 */
+(NSString *)encrypt:(NSString *)dataIn key:(NSString *)key iv:(NSString *)iv{
    NSData *data = [dataIn dataUsingEncoding:NSUTF8StringEncoding];
    NSData *AESData = [self AES256operation:kCCEncrypt
                                       data:data
                                        key:key
                                         iv:iv];
    NSData *base64Data = [AESData base64EncodedDataWithOptions:0];
    NSString *baseStr = [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
    return baseStr;
}

/**AES 256 解密方法 */
+(NSString *)decrypt:(NSString* )dataIn key:(NSString *)key iv:(NSString *)iv{
    NSData *data = [dataIn dataUsingEncoding:NSUTF8StringEncoding];
    NSData *base64Data = [data initWithBase64EncodedData:data options:0];
    NSData *AESData = [self AES256operation:kCCDecrypt
                                           data:base64Data
                                            key:key
                                             iv:iv];
    NSString *decStr = [[NSString alloc] initWithData:AESData encoding:NSUTF8StringEncoding];
    return decStr;
}

/**
 *  AES加解密算法
 *  @param operation kCCEncrypt（加密）kCCDecrypt（解密）
 *  @param data      待操作Data数据
 *  @param key       key
 *  @param iv        向量
 */
+ (NSData *)AES256operation:(CCOperation)operation data:(NSData *)data key:(NSString *)key iv:(NSString *)iv{
    char keyPtr[kCCKeySizeAES256 + 1];  //kCCKeySizeAES128是加密位数 可以替换成256位的
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    // IV
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    // 设置加密参数
    /**
     这里设置的参数ios默认为CBC加密方式，如果需要其他加密方式如ECB，在kCCOptionPKCS7Padding这个参数后边加上kCCOptionECBMode，即kCCOptionPKCS7Padding | kCCOptionECBMode，但是记得修改上边的偏移量，因为只有CBC模式有偏移量之说
     */
    CCCryptorStatus cryptorStatus = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                            keyPtr, kCCKeySizeAES256,
                                            ivPtr,
                                            [data bytes], [data length],
                                            buffer, bufferSize,
                                            &numBytesEncrypted);
    
    if(cryptorStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    } else {
//        NSLog(@"Error");
    }
    
    free(buffer);
    return nil;
}
@end
