//
//  MKRSACrypto.h
//  MKTool
//
//  Created by 麻明康 on 2024/1/16.
//
//  原作者：https://github.com/muzipiao/RSAObjC/tree/master
#import <MKTool/MKCryptoProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKRSACrypto : NSObject<MKCryptoProtocol>
/**
 * -------RSA 字符串公钥加密-------
 @param dataIn 明文，待加密的字符串
 @param key 公钥字符串
 @return 密文，加密后的字符串
 */
+(NSString *)encrypt:(NSString *)dataIn key:(NSString *)key iv:(nullable NSString *)iv;
/**
 * -------RSA 私钥字符串解密-------
 @param dataIn 密文，需要解密的字符串
 @param key 私钥字符串
 @return 明文，解密后的字符串
 */
+(NSString *)decrypt:(NSString* )dataIn key:(NSString *)key iv:(nullable NSString *)iv;


/**
 * -------RSA 公钥文件加密-------
 @param plaintext 明文，待加密的字符串
 @param path 公钥文件路径，p12或pem格式
 @return 密文，加密后的字符串
 */
+ (NSString *)encrypt:(NSString *)plaintext KeyFilePath:(NSString *)path;



/**
 * -------RSA 私钥文件解密-------
 @param ciphertext 密文，需要解密的字符串
 @param path 私钥文件路径，p12或pem格式(pem私钥需为pcks8格式)
 @param pwd 私钥文件的密码
 @return 明文，解密后的字符串
 */
+ (NSString *)decrypt:(NSString *)ciphertext KeyFilePath:(NSString *)path FilePwd:(NSString *)pwd;
@end
NS_ASSUME_NONNULL_END
