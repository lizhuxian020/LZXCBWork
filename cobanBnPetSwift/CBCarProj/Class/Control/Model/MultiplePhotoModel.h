//
//  MultiplePhotoModel.h
//  Telematics
//
//  Created by lym on 2017/12/22.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MultiplePhotoModel : NSObject
@property (nonatomic, copy) NSString *channel;      // 通道；(1,1).(2,1).(3,1).(4,1).(5,1) 第一个通道号 第二个存储 如果通道关闭则不返回
@property (nonatomic, copy) NSString *dno;          // 设备编号
@property (nonatomic, assign) int chroma;           // 色度
@property (nonatomic, assign) int contrast;         // 对比度
@property (nonatomic, copy) NSString *disPhoto;     // 定距离拍照
@property (nonatomic, assign) int luminance;        // 亮度
@property (nonatomic, assign) int quality;          // 图片/视频质量
@property (nonatomic, assign) int saturation;       // 饱和度
@property (nonatomic, copy) NSString *timePhoto;    // 定时拍照
@end
