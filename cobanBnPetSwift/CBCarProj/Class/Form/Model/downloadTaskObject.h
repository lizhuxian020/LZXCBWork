//
//  downloadTaskObject.h
//  webViewDemo
//
//  Created by Tal on 2017/5/9.
//  Copyright © 2017年 Tal. All rights reserved.
//

#import <Foundation/Foundation.h>
@class downloadTaskObject;
@protocol DownLoadDelegate
// 已经收到收到的数据
- (void)downLoadTask:(downloadTaskObject *)task WithProgressCompletedUnitCount:(int64_t) completedUnitCount andTotalUnitCount:(int64_t) totalUnitCount;
- (void)downLaodDidCompletedTask:(downloadTaskObject *)task;
@end
@interface downloadTaskObject : NSObject
/* 当前任务名称 */
@property (nonatomic, copy) NSString *taskName;
/* 下载的文件夹地址 */
@property (nonatomic, copy) NSString *folderPath;
/** 下载任务 */
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic, weak) id <DownLoadDelegate> delegate;

- (instancetype)initDownLoadTaskObjectWithString:(NSString *)urlString folderPath:(NSString *)folderPath;
+ (instancetype)downLoadTaskObjectWithString:(NSString *)urlString folderPath:(NSString *)folderPath;
@end
