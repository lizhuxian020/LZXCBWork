//
//  MINFileObject.h
//  MCSession
//
//  Created by Tal on 2017/4/24.
//  Copyright © 2017年 北京千锋互联科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
//方向，可同时支持一个或多个方向
typedef enum _MINFileType {
    MINFileTypeFolder = 0,
    MINFileTypeMp3 ,
    MINFileTypeMp4 ,
    MINFileTypePPt ,
    MINFileTypeDoc ,
    MINFileTypePNG 
} MINFileType;
@interface MINFileObject : NSObject
@property (nonatomic, copy) NSString *fileName; // 文件名称
@property (nonatomic, assign) MINFileType fileType; // 文件类型, mp3,mp4,文件夹等
@property (nonatomic, copy) NSDate *fileCreateTime; // 文件创建时间
@property (nonatomic, assign) long long fileSize; // 文件大小
@property (nonatomic, copy) NSString *filePath; // 文件路径
@property (nonatomic, copy) NSString *fileTime; // 音频文件时长
+(instancetype)fileObjectWithFileName:(NSString *) fileName withType:(MINFileType)fileType withCreateTime:(NSDate *)createTime withSize:(long long )fileSize withFilePath:(NSString *)path;
-(instancetype)initWithfileObjectWithFileName:(NSString *) fileName withTpye:(MINFileType)fileType withCreateTime:(NSDate *)createTime withSize:(long long)fileSize withFilePath:(NSString *)path;
@end
