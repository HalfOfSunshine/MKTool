//
//  MKCryptoProtocol.h
//  MKTool
//
//  Created by 麻明康 on 2024/1/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//策略接口
@protocol MKCryptoProtocol <NSObject>
//加密
+(NSString *)encrypt:(NSString *)dataIn key:(NSString *)key iv:(nullable NSData*)iv;
//解密
+(NSString *)decrypt:(NSString* )dataIn key:(NSString *)key iv:(nullable NSData*)iv;
@end

NS_ASSUME_NONNULL_END
