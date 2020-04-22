//
//  OSSManager.m
//  zhirong
//
//  Created by lh on 2017/10/25.
//  Copyright © 2017年 gaming17. All rights reserved.
//

#import "OSSManager.h"
#import <AliyunOSSiOS/OSSService.h>
#import "WanchangLawFirms-Swift.h"
#import "OCConfigure.h"
#import "OCBase.h"
#import <CommonCrypto/CommonDigest.h>

#define BASE_CLIPSIZE @"image/resize,m_lfit,w_300,h_300,limit_0/auto-orient,1/quality,q_90"


@interface OSSManager()
@property (nonatomic, strong) OSSFederationToken *ossToken;
@property (nonatomic, assign) long long ossTime;
@end

@implementation OSSManager
@synthesize ossToken = _ossToken;
+ (instancetype)initWithShare {
    static OSSManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [OSSManager new];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createCacheSavePath];
    }
    return self;
}

- (void)setOssToken:(OSSFederationToken *)ossToken {
    _ossToken = ossToken;
    self.ossTime = (long long)[[NSDate date] timeIntervalSince1970];
}

- (OSSFederationToken *)ossToken {
    return _ossToken;
}

- (OSSFederationToken *)getHistoryOSSTOken {
    if (!_ossTime) {
        return nil;
    }
    long long currentTime = (long long)[[NSDate date] timeIntervalSince1970];
    if (currentTime - _ossTime > 30 * 60) {
        return nil;
    }
    return _ossToken;
}

//使用token方式进行上传
- (OSSFederationToken *) getFederationToken {
    OSSFederationToken *token = [self getHistoryOSSTOken];
    if (token) {
        return token;
    }
    OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
    
    NSString *timestamp = [NSString stringWithFormat:@"%lld", (long long)[[NSDate date] timeIntervalSince1970]];
    NSString *sign = [self getmd5WithString:[NSString stringWithFormat:@"szcy%@GET10",timestamp]];
    
//    NSDictionary *prams = @{@"timestamp":timestamp,@"sign":sign};
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?timestamp=%@&sign=%@",OCConfigure.share.STSServer, timestamp, sign];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    request.HTTPMethod = @"GET";
    
//    NSData *data = [NSJSONSerialization dataWithJSONObject:prams options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *bodyData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSData *pramsData = [NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])];
    
//    NSString *pramsStr = prams.mj_JSONString;
////    NSString *pramsStr = [NSString stringWithFormat:@"{\"timestamp\" : \"%@\", \"sign\" : \"%@\"}", timestamp, sign];
//    NSData *pramsData = [pramsStr dataUsingEncoding:NSUTF8StringEncoding];
    
//    request.HTTPBody = pramsData;
    
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [tcs setError:error];
        } else {
            [tcs setResult:data];
        }
    }];
    [sessionTask resume];
    
    // 实现这个回调需要同步返回Token，所以要waitUntilFinished
    [tcs.task waitUntilFinished];
    if (tcs.task.error) {
        return nil;
    } else {
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:tcs.task.result
                                                                options:kNilOptions
                                                                  error:nil];
        NSDictionary *dataDict = object[@"result"];
        OSSFederationToken * token = [OSSFederationToken new];
        token.tAccessKey = [dataDict objectForKey:@"AccessKeyId"];
        token.tSecretKey = [dataDict objectForKey:@"AccessKeySecret"];
        token.tToken = [dataDict objectForKey:@"SecurityToken"];
        token.expirationTimeInGMTFormat = [dataDict objectForKey:@"Expiration"];
        DebugLog(@"AccessKey: %@ \n SecretKey: %@ \n Token:%@ expirationTime: %@ \n", token.tAccessKey, token.tSecretKey, token.tToken, token.expirationTimeInGMTFormat);
        if (token.tAccessKey) {
            self.ossToken = token;
        }
        return token;
    }
}

- (NSString *)allUrlStrBy:(NSString *)objKey {
    id<OSSCredentialProvider> credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
        return [self getFederationToken];
    }];
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:OCConfigure.share.end_point credentialProvider:credential];
    
    OSSTask *task = [client presignConstrainURLWithBucketName:OCConfigure.share.bucket_name withObjectKey:objKey withExpirationInterval:600];
    if (!task.error) {
        return task.result;
    } else {
        return nil;
    }
}

- (NSString *)allSnapUrlStrBy:(NSString *)objKey {
    id<OSSCredentialProvider> credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
        return [self getFederationToken];
    }];
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:OCConfigure.share.end_point credentialProvider:credential];
    OSSTask *task = [client presignConstrainURLWithBucketName:OCConfigure.share.bucket_name withObjectKey:objKey withExpirationInterval:600 withParameters:@{@"x-oss-process":BASE_CLIPSIZE}];
    if (!task.error) {
        return task.result;
    } else {
        return nil;
    }
}

- (void)uploadImage:(UIImage *)img isOriginal:(BOOL)isOriginal objKey:(NSString *)objKey progress:(void(^)(float value))progress response:(void (^)(NSString *path))success {
    NSString *endpoint = OCConfigure.share.end_point;
    id<OSSCredentialProvider> credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
        return [self getFederationToken];
    }];
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
    put.bucketName = OCConfigure.share.bucket_name;
    NSString *objectKey = [self uniqueStringBy:objKey pathExten:@"jpeg"];
    put.objectKey = objectKey;
    if (isOriginal) {
        put.uploadingData = UIImageJPEGRepresentation(img, 0.9f);
    } else {
        put.uploadingData = UIImageJPEGRepresentation(img, .3f);
    }
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        DebugLog(@"%lld, totalBytesSent--:%lld, %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
//        progress((float)totalBytesSent / totalBytesExpectedToSend);
    };
    OSSTask *putTask =[client putObject:put];
    [putTask continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
        task = [client presignPublicURLWithBucketName:OCConfigure.share.bucket_name withObjectKey:objectKey];
        NSString *result = @"";
        if (!task.error) {
            DebugLog(@"上传成功 urlStr = %@",objectKey);
            result = objectKey;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            success(result);
        });
        return nil;
    }];
}
    
- (void)uploadFilePath:(NSString *)filePath objKey:(NSString *)objKey progress:(void(^)(float value))progress  complete:(void(^)(NSString *remotePath))success {
    NSString *endpoint = OCConfigure.share.end_point;
    id<OSSCredentialProvider> credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
        return [self getFederationToken];
    }];
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
    put.bucketName = OCConfigure.share.bucket_name;
    NSString *objectKey = objKey;
    put.objectKey = objectKey;
    put.uploadingFileURL = [NSURL fileURLWithPath:filePath];
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        DebugLog(@"%lld, totalBytesSent--:%lld, %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
        progress((float)totalBytesSent / totalBytesExpectedToSend);
    };
    OSSTask *putTask = [client putObject:put];
    [putTask continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
        task = [client presignPublicURLWithBucketName:OCConfigure.share.bucket_name withObjectKey:objectKey];
        if (!task.error) {
            DebugLog(@"上传成功 urlStr = %@",objectKey);
            if (HTTPManager.share.net_unavaliable) {
                success(@"");
            } else {
                success(objectKey);
            }
        } else {
            success(@"");
        }
        return nil;
    }];
}

- (void)uploadFileURL:(NSURL *)fileUrl objKey:(NSString *)objKey progress:(void(^)(float value))progress  complete:(void(^)(NSString *remotePath))success {
    NSString *endpoint = OCConfigure.share.end_point;
    id<OSSCredentialProvider> credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
        return [self getFederationToken];
    }];
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
    put.bucketName = OCConfigure.share.bucket_name;
    NSString *objectKey = objKey;
    put.objectKey = objectKey;
    put.uploadingFileURL = fileUrl;
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        DebugLog(@"%lld, totalBytesSent--:%lld, %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
        dispatch_async(dispatch_get_main_queue(), ^{
            progress((float)totalBytesSent / totalBytesExpectedToSend);
        });
    };
    OSSTask *putTask = [client putObject:put];
    [putTask continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
        task = [client presignPublicURLWithBucketName:OCConfigure.share.bucket_name withObjectKey:objectKey];
        NSString *result = @"";
        if (!task.error) {
            DebugLog(@"上传成功 urlStr = %@",objectKey);
            if (!HTTPManager.share.net_unavaliable) {
                result = objectKey;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            success(result);
        });
        return nil;
    }];
}

- (void)downloadFile:(NSString *)urlPath localPath:(NSString *)localPath progress:(void(^)(float value))progress response:(void (^)(NSString *endPath))success {
    NSString *endPath = [self savePath:localPath];
    NSString *endpoint = OCConfigure.share.end_point;
    id<OSSCredentialProvider> credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
        return [self getFederationToken];
    }];
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
    OSSGetObjectRequest *request = [OSSGetObjectRequest new];
    request.bucketName = OCConfigure.share.bucket_name;
    NSString *objectKey = urlPath;
    request.objectKey = objectKey;
    request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        DebugLog(@"%lld, totalBytesWriten--:%lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        dispatch_async(dispatch_get_main_queue(), ^{
            progress((float)totalBytesWritten / totalBytesExpectedToWrite);
        });
    };
    request.downloadToFileURL = [NSURL fileURLWithPath:endPath];
    OSSTask *getTask = [client getObject:request];
    [getTask continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
        task = [client presignPublicURLWithBucketName:OCConfigure.share.bucket_name withObjectKey:objectKey];
        NSString *result = @"";
        if (!task.error) {
            if (!HTTPManager.share.net_unavaliable) {
                if ([[NSFileManager defaultManager] fileExistsAtPath:endPath]) {
                    result = endPath;
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            success(result);
        });
        return nil;
    }];
}
    
- (void)downloadImage:(NSString *)urlPath progress:(void(^)(float value))progress response:(void (^)(NSString *endPath))success {
    NSString *endPath = [self savePath:urlPath];
    if ([[RealmManager shareManager] judgeDownload:urlPath]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            success(endPath);
        });
        return;
    }
    NSString *endpoint = OCConfigure.share.end_point;
    id<OSSCredentialProvider> credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
        return [self getFederationToken];
    }];
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
    OSSGetObjectRequest *request = [OSSGetObjectRequest new];
    request.bucketName = OCConfigure.share.bucket_name;
    NSString *objectKey = urlPath;
    request.objectKey = objectKey;
    request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        DebugLog(@"%lld, totalBytesWriten--:%lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        dispatch_async(dispatch_get_main_queue(), ^{
            progress((float)totalBytesWritten / totalBytesExpectedToWrite);
        });
    };
    request.downloadToFileURL = [NSURL fileURLWithPath:endPath];
    OSSTask *getTask = [client getObject:request];
    [getTask continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
        task = [client presignPublicURLWithBucketName:OCConfigure.share.bucket_name withObjectKey:objectKey];
        NSString *result = @"";
        if (!task.error) {
            if (!HTTPManager.share.net_unavaliable) {
                if ([[NSFileManager defaultManager] fileExistsAtPath:endPath]) {
                    [[RealmManager shareManager] addDownload:urlPath];
                    result = endPath;
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            success(result);
        });
        return nil;
    }];
}

- (void)downloadSnapImg:(NSString *)urlPath progress:(void(^)(float value))progress response:(void (^)(NSString *endPath))success {
    NSString *name = [[urlPath componentsSeparatedByString:@"/"] lastObject];
    NSString *endPath = [self snapSavePath:name];
    if ([[NSFileManager defaultManager] fileExistsAtPath:endPath]) {
        success(endPath);
        return;
    }
    id<OSSCredentialProvider> credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
        return [self getFederationToken];
    }];
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:OCConfigure.share.end_point credentialProvider:credential];
    OSSGetObjectRequest *request = [OSSGetObjectRequest new];
    request.bucketName = OCConfigure.share.bucket_name;
    request.objectKey = urlPath;
    request.downloadToFileURL = [NSURL fileURLWithPath:endPath];
    request.xOssProcess = BASE_CLIPSIZE;
    request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        DebugLog(@"%lld, totalBytesWriten--:%lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    };
    OSSTask *getTask = [client getObject:request];
    [getTask continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
        task = [client presignPublicURLWithBucketName:OCConfigure.share.bucket_name withObjectKey:request.objectKey];
        NSString *result = @"";
        if (!task.error) {
            if (!HTTPManager.share.net_unavaliable) {
                if ([[NSFileManager defaultManager] fileExistsAtPath:endPath]) {
                    result = endPath;
                }
            }
        }
        success(result);
        return nil;
    }];
}

- (void)createCacheSavePath {
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *ossDirectory = [cacheDirectory stringByAppendingPathComponent:@"/OSSDirectory/"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:ossDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:ossDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (NSString *)savePath:(NSString *)urlPath {
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *ossDirectory = [cacheDirectory stringByAppendingPathComponent:@"/OSSDirectory/"];
//    NSString *endPath = [ossDirectory stringByAppendingPathComponent:urlPath];
//    return endPath;
    return [cacheDirectory stringByAppendingPathComponent:urlPath];
}

- (NSString *)snapSavePath:(NSString *)urlPath {
    NSString *temp = [NSString stringWithFormat:@"snap_%@", urlPath];
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *ossDirectory = [cacheDirectory stringByAppendingPathComponent:@"/OSSDirectory/"];
//    NSString *endPath = [ossDirectory stringByAppendingPathComponent:temp];
//    return endPath;
    return [cacheDirectory stringByAppendingPathComponent:temp];
}
    
- (NSString *)uniqueStringBy:(NSString *)filePath pathExten:(nonnull NSString *)pathExten {
    NSString *objKey = filePath;
    NSDate *date = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970] * 1000];
    srand((unsigned) time(0));
    int i = arc4random() % 1000000;
    NSString *str = [NSString stringWithFormat:@"%06d",i];
    objKey = [objKey stringByAppendingString:[NSString stringWithFormat:@"%@_%@%@.%@", UserInfo.share.uid, timeSp, str, pathExten]];
    return objKey;
}


- (NSString*)getmd5WithString:(NSString *)string
{
    const char* original_str=[string UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (uint)strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [outPutStr appendFormat:@"%02x", digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return [outPutStr lowercaseString];
}
@end
