//
//  OSSManager.h
//  zhirong
//
//  Created by lh on 2017/10/25.
//  Copyright © 2017年 gaming17. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface OSSManager : NSObject
+ (instancetype)initWithShare;

- (void)uploadImage:(UIImage *)img isOriginal:(BOOL)isOriginal objKey:(NSString *)objKey progress:(void(^)(float value))progress response:(void (^)(NSString *path))success;

- (void)uploadFilePath:(NSString *)filePath objKey:(NSString *)objKey progress:(void(^)(float value))progress  complete:(void(^)(NSString *remotePath))success;
- (void)uploadFileURL:(NSURL *)fileUrl objKey:(NSString *)objKey progress:(void(^)(float value))progress  complete:(void(^)(NSString *remotePath))success;

- (NSString *)savePath:(NSString *)urlPath;
- (void)downloadFile:(NSString *)urlPath localPath:(NSString *)localPath progress:(void(^)(float value))progress response:(void (^)(NSString *endPath))success;
- (void)downloadImage:(NSString *)urlPath progress:(void(^)(float value))progress response:(void (^)(NSString *endPath))success;
- (void)downloadSnapImg:(NSString *)urlPath progress:(void(^)(float value))progress response:(void (^)(NSString *endPath))success;

- (NSString *)allUrlStrBy:(NSString *)objKey;
- (NSString *)allSnapUrlStrBy:(NSString *)objKey;

- (NSString *)uniqueStringBy:(NSString *)filePath pathExten:(NSString *)pathExten;
@end
NS_ASSUME_NONNULL_END
