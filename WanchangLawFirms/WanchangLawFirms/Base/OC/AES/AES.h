//
//  AES.h
//  chat
//
//  Created by lh on 2017/7/21.
//  Copyright © 2017年 gaming17. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AES : NSObject
+(NSData *)AES256ParmEncryptWithKey:(NSString *)key Encrypttext:(NSData *)text;   //加密
+(NSData *)AES256ParmDecryptWithKey:(NSString *)key Decrypttext:(NSData *)text;   //解密
+(NSString *) aes256_encrypt:(NSString *)key Encrypttext:(NSString *)text;
+(NSString *) aes256_decrypt:(NSString *)key Decrypttext:(NSString *)text;


+ (NSString *)encryptAES:(NSString *)content key:(NSString *)key iv:(NSString *)iv;
+ (NSString *)decryptAES:(NSString *)content key:(NSString *)key iv:(NSString *)iv;

@end
