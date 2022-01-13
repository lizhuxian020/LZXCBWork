//
//  downloadTaskObject.m
//  webViewDemo
//
//  Created by Tal on 2017/5/9.
//  Copyright © 2017年 Tal. All rights reserved.
//

#import "downloadTaskObject.h"
//#import "AFNetworking.h"
#import <AFNetworking/AFHTTPSessionManager.h>

@interface downloadTaskObject()
/** 文件的总长度 */
@property (nonatomic, assign) NSInteger fileLength;
/** 当前下载长度 */
@property (nonatomic, assign) NSInteger currentLength;
/** 文件句柄对象 */
@property (nonatomic, strong) NSFileHandle *fileHandle;
/* AFURLSessionManager */
@property (nonatomic, strong) AFURLSessionManager *manager;
@end

@implementation downloadTaskObject
- (AFURLSessionManager *)manager {
    if (!_manager) {
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return _manager;
}

#pragma mark - 初始化方法
- (instancetype)initDownLoadTaskObjectWithString:(NSString *)urlString folderPath:(NSString *)folderPath
{
    if (self = [super init]) {
        // 设置任务名称
        NSRange range = [urlString rangeOfString:@"([a-zA-X0-9_-]+).mp4" options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            _taskName = [urlString substringWithRange:range];
        }
        NSString *path = [folderPath stringByAppendingPathComponent:_taskName];
        NSString *finallyPath =  [self getFilePathNewName:path withPosfix:@".mp4"];
        NSRange range1 = [finallyPath rangeOfString:@"([a-zA-X0-9_-]+)\\(\\d\\).mp4" options:NSRegularExpressionSearch];
        if (range1.location != NSNotFound) {
            _taskName = [finallyPath substringWithRange:range1];
            NSLog(@"%@", _taskName);
        }
        // 设置下载
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        __weak typeof(self) weakSelf = self;
        _downloadTask = [self.manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"已下载 %.2f%%", (downloadProgress.completedUnitCount * 1.0) /downloadProgress.totalUnitCount * 100);
            [weakSelf.delegate downLoadTask:weakSelf WithProgressCompletedUnitCount:downloadProgress.completedUnitCount andTotalUnitCount:downloadProgress.totalUnitCount];
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            
            return [NSURL fileURLWithPath:finallyPath];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            NSLog(@"%@", filePath);
            [self.delegate downLaodDidCompletedTask:weakSelf];
        }];
        
    }
    return self;
}
//路径中存在同名文件名，创建一个新的文件名
- (NSString*) getFilePathNewName:(NSString*)path withPosfix:(NSString*)posfix
{
    NSFileManager* manager = [NSFileManager defaultManager];
    int count = 1;
    
    NSRange range = [path rangeOfString:@"." options:NSBackwardsSearch];
    range.length = range.location;
    range.location = 0;
    NSString* namePart = [path substringWithRange:range];
    NSString* temp = namePart;
    while (YES)
    {
        temp = [temp stringByAppendingString:posfix];
        if (![manager fileExistsAtPath:temp])
        {
            break;
        }
        temp = [namePart stringByAppendingFormat:@"(%d)",count++];
    }
    return temp;
}
+ (instancetype)downLoadTaskObjectWithString:(NSString *)urlString folderPath:(NSString *)folderPath
{
    return [[self alloc]initDownLoadTaskObjectWithString:urlString folderPath: folderPath];
}
@end
