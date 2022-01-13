//
//  MINFileObject.m
//  MCSession
//
//  Created by Tal on 2017/4/24.
//  Copyright © 2017年 北京千锋互联科技有限公司. All rights reserved.
//

#import "MINFileObject.h"

@implementation MINFileObject
-(instancetype)initWithfileObjectWithFileName:(NSString *) fileName withTpye:(MINFileType)fileType withCreateTime:(NSDate *)createTime withSize:(long long)fileSize withFilePath:(NSString *)path
{
    if (self = [super init]) {
        _fileName = fileName;
        _fileType = fileType;
        _fileCreateTime = createTime;
        _fileSize = fileSize;
        _filePath = path;
    }
    return self;
}
+ (instancetype)fileObjectWithFileName:(NSString *)fileName withType:(MINFileType)fileType withCreateTime:(NSDate *)createTime withSize:(long long)fileSize withFilePath:(NSString *)path
{
    return [[self alloc]initWithfileObjectWithFileName:fileName withTpye:fileType withCreateTime:createTime withSize:fileSize withFilePath:path];
}
@end
