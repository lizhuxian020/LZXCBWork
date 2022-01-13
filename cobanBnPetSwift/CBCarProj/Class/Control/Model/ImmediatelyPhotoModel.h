//
//  ImmediatelyPhotoModel.h
//  Telematics
//
//  Created by lym on 2017/12/22.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImmediatelyPhotoModel : NSObject
@property (nonatomic, assign) int channelId; // 通道ID
@property (nonatomic, assign) int chroma; // 色度
@property (nonatomic, assign) int contrast; // 对比度
@property (nonatomic, copy) NSString *dno; // 设备编号
@property (nonatomic, assign) int flag; // 保存标志；0-实时上传，1-保存
@property (nonatomic, assign) int luminance; // 亮度
@property (nonatomic, copy) NSString *lxTime; // 录像时长（秒）
@property (nonatomic, copy) NSString *pzCount; // 拍照张数
@property (nonatomic, copy) NSString *pzSpec; // 拍张间隔时长（秒）
@property (nonatomic, assign) int quality; // 图片/视频质量
@property (nonatomic, assign) int resolve; // 备注分辨率 0-320*240 1-640*480 2-800*600 3-1024*768 4-176*768(Qcif) 5-352*288(Cif) 6-704*288(HALFD1) 7-704*576(D1)
@property (nonatomic, assign) int saturation; // 饱和度
@end
