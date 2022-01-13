//
//  FenceListModel.h
//  Telematics
//
//  Created by lym on 2017/12/18.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FenceListModel : NSObject
@property (nonatomic, copy) NSString *data; // 备注：（纬度，经度）3个参数为圆形，最后一个参数为半径  矩形 四个坐标 分别是对角线的四个点坐标 多变行 >4个坐标 线性  可能是多个坐标
@property (nonatomic, copy) NSString *dno;      // 设备编号
@property (nonatomic, copy) NSString *fid;      // 创建者的ID
@property (nonatomic, assign) int from;     // 0-系统创建，1-个人创建
@property (nonatomic, copy) NSString *name;     // 围栏名称
@property (nonatomic, assign) int shape;    // 形状：0-多边形，1-圆形，2-矩形，3-线路
@property (nonatomic, copy) NSString *speed;    // 速度
@property (nonatomic, copy) NSString *userId;   // 创建者id
@property (nonatomic, assign) int status;       // 状态：0-未处理，1-已处理
@property (nonatomic, assign) int warmType;     // 0-出围栏报警 1-入围栏报警 2-出入围栏报警 3-位移报警
@property (nonatomic, copy) NSString *areaId;   // 区域iD
@property (nonatomic, copy) NSString *sn;   // 区域iD
@end
