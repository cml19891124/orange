//
//  StorageManager.m
//  WanchangLawFirms
//
//  Created by lh on 2019/2/11.
//  Copyright © 2019 gaming17. All rights reserved.
//

#import "StorageManager.h"

@interface StorageManager ()

@end

@implementation StorageManager
+ (instancetype)initWithShare {
    static StorageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [StorageManager new];
    });
    return manager;
}

- (NSArray<StorageModel *> *)getFileListInFolderWithPath:(NSString *)path {
    if ([path isEqualToString:@""]) {
        path = NSHomeDirectory();
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:path error:nil];
    NSMutableArray *mulArr = [NSMutableArray new];
    for (NSString *name in fileList) {
        StorageModel *model = [self modelFromFatherPath:path name:name fileManager:fileManager];
        [mulArr addObject:model];
    }
    return mulArr;
}

- (float)cachesSize {
    NSString *folderPath1 = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Caches/default"];
    NSString *folderPath2 = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Caches/WebKit"];
    
    long long folderSize = 0;
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:folderPath1]) {
        NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath1] objectEnumerator];
        NSString* fileName;
        while ((fileName = [childFilesEnumerator nextObject]) != nil){
            NSString* fileAbsolutePath = [folderPath1 stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:fileAbsolutePath];
        }
    }
    if ([manager fileExistsAtPath:folderPath2]) {
        NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath2] objectEnumerator];
        NSString* fileName;
        while ((fileName = [childFilesEnumerator nextObject]) != nil){
            NSString* fileAbsolutePath = [folderPath1 stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:fileAbsolutePath];
        }
    }
    
    return folderSize/(1024.0*1024.0);
}

- (long long)fileSizeAtPath:(NSString*) filePath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (void)clearCaches {
    NSString *path1 = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Caches/default"];
    NSString *path2 = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Caches/WebKit"];
    
    NSArray *files1 = [[NSFileManager defaultManager] subpathsAtPath:path1];
    for (NSString *p in files1) {
        NSError *error;
        NSString *Path = [path1 stringByAppendingPathComponent:p];
        if ([[NSFileManager defaultManager] fileExistsAtPath:Path]) {
            //清理缓存，保留Preference，里面含有NSUserDefaults保存的信息
            if (![Path containsString:@"Preferences"]) {
                [[NSFileManager defaultManager] removeItemAtPath:Path error:&error];
            }
        }
    }
    
    NSArray *files2 = [[NSFileManager defaultManager] subpathsAtPath:path2];
    for (NSString *p in files2) {
        NSError *error;
        NSString *Path = [path2 stringByAppendingPathComponent:p];
        if ([[NSFileManager defaultManager] fileExistsAtPath:Path]) {
            //清理缓存，保留Preference，里面含有NSUserDefaults保存的信息
            if (![Path containsString:@"Preferences"]) {
                [[NSFileManager defaultManager] removeItemAtPath:Path error:&error];
            }
        }
    }
}

#pragma mark - 内部方法
- (NSArray<StorageModel *> *)getAllRootDiretories {
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *library = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *home = NSHomeDirectory();
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *temp = NSTemporaryDirectory();
    NSArray *nameArr = @[@"Document",@"Library",@"Home",@"Cache",@"Temp"];
    NSArray *pathArr = @[document, library, home, cache, temp];
    NSMutableArray *mulArr = [NSMutableArray new];
    for (int i = 0; i < 5; i++) {
        StorageModel *model = [StorageModel new];
        model.name = nameArr[i];
        model.path = pathArr[i];
        model.isDir = YES;
        [mulArr addObject:model];
    }
    return mulArr;
}

- (StorageModel *)modelFromFatherPath:(NSString *)path name:(NSString *)name fileManager:(NSFileManager *)fileManager {
    StorageModel *model = [StorageModel new];
    model.name = name;
    model.path = [path stringByAppendingPathComponent:name];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:model.path error:nil];
    model.created = [NSString stringWithFormat:@"%@",[fileAttributes objectForKey:NSFileCreationDate]];
    model.fileLength = [[fileAttributes objectForKey:NSFileSize] unsignedLongLongValue];
    BOOL isDir;
    [fileManager fileExistsAtPath:model.path isDirectory:&isDir];
    model.isDir = isDir;
    return model;
}

@end
