//
//  CBProductSpecModel.h
//  cobanBnPetSwift
//
//  Created by lee on 2022/12/13.
//  Copyright © 2022 coban. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBProductSpecReportModel : NSObject
@property (nonatomic, assign) BOOL curvesSpeed;//;// 0,//速度报表
@property (nonatomic, assign) BOOL reportIdle;// 0,//怠速报表
@property (nonatomic, assign) BOOL reportStop;// 0,//停留报表
@property (nonatomic, assign) BOOL reportIgnition;// 1,//点火统计
@property (nonatomic, assign) BOOL reportMiles;// 1,//里程统计
@property (nonatomic, assign) BOOL reportOil;// 1,//油量统计
@property (nonatomic, assign) BOOL curvesTemp;// 1,//温度报表
@property (nonatomic, assign) BOOL warmAll;// 1,//所有报警报表
@property (nonatomic, assign) BOOL warmSos;// 1,//sos报警报表
@property (nonatomic, assign) BOOL warmChaosu;// 1,//疲劳报警报表
@property (nonatomic, assign) BOOL warmTired;// 1,//疲劳报警报表
@property (nonatomic, assign) BOOL warmQianya;// 1,//欠压报警报表
@property (nonatomic, assign) BOOL warmDiaodian;// 1,//外电断电报表
@property (nonatomic, assign) BOOL warmZhendong;// 1,//震动报警报表
@property (nonatomic, assign) BOOL warmKaimen;// 1,//开门报警报表
@property (nonatomic, assign) BOOL warmDianhuo;// 1,//点火报警统计报表
@property (nonatomic, assign) BOOL warmWeiyi;// 1,//位移报警报表
@property (nonatomic, assign) BOOL warmTemp;// 0,//位移报警报表
@property (nonatomic, assign) BOOL warmTouyou;// 0,//漏油报警报表
@property (nonatomic, assign) BOOL warmPz;// 0,//碰撞报警报表
@property (nonatomic, assign) BOOL reportObd;// 0,//OBD报表
@property (nonatomic, assign) BOOL reportFence;// 0,//电子围栏报表
@property (nonatomic, assign) BOOL reportDispatch;// 0,//reportDispatch
@property (nonatomic, assign) BOOL reportMedia;// 0,//媒体报表
@property (nonatomic, assign) BOOL createTime;// 1657850342000,
@property (nonatomic, assign) BOOL proto;// 0,//协议类型 0：新协议 1：老协议
@property (nonatomic, assign) BOOL productSpecId;// 35,//无意义
@property (nonatomic, assign) BOOL tbDevModelId;// 35,
@property (nonatomic, assign) BOOL reportXc;// 1//行程报表
@end

@interface CBProductSpecModel : NSObject

@property(nonatomic, copy) NSString *pId;
@property(nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL singlePosition; //单次定位
@property (nonatomic, assign) BOOL autoPosition; //多次定位
@property (nonatomic, assign) BOOL callChargeInquiry; //花费查询
@property (nonatomic, assign) BOOL oilElectricityControl; //油电控制
@property (nonatomic, assign) BOOL fuelSensorCalibration; //油量传感器校准
@property (nonatomic, assign) BOOL arm;    //布防
@property (nonatomic, assign) BOOL silentArm;    //静音布防
@property (nonatomic, assign) BOOL disarm;//    撤防
@property (nonatomic, assign) BOOL motorControl;//    电机控制
@property (nonatomic, assign) BOOL remoteStart;//    远程启动
@property (nonatomic, assign) BOOL electricFence;//    电子围栏
@property (nonatomic, assign) BOOL callBack;//    听听
@property (nonatomic, copy) NSString *alarmSwitch;// "8,3,4,6,5,1"   1低电 2外电断电 3盲区 4紧急 5移位 6超速 7油量检测 8震动, TODO: lzxTODO
@property (nonatomic, copy) NSString *hibernates;//:"0,1,2,3,4,5" ‘2,4,5,6,1,3’    休眠模式TODO: lzxTODO
@property (nonatomic, assign) BOOL setGprsHeartbeat;//: 1    设置GPRS心跳
@property (nonatomic, assign) BOOL timeSet;//: 1    终端时区设置
@property (nonatomic, assign) BOOL initializeSet;//: 1    初始化设置
@property (nonatomic, assign) BOOL hardwareReboot;//: 1    硬件重启
@property (nonatomic, assign) BOOL authCode;//: 1    授权号码
@property (nonatomic, assign) BOOL turnSupplement;//: 1    车辆转弯补报
@property (nonatomic, assign) BOOL gpsDriftSuppression;//: 1    GPS漂移抑制
@property (nonatomic, assign) BOOL passwordSet;//: 1    密码设置
@property (nonatomic, assign) BOOL accWorkNotice;//: 1    ACC工作通知
@property (nonatomic, assign) BOOL sensitivitySet;//: 1    振动灵敏度设置
@property (nonatomic, assign) BOOL tankVolume;//: 1    油箱容积设置
@property (nonatomic, assign) BOOL mileageInitialValue;//: 1    里程初始值


@property(nonatomic, copy) NSString *proto;
@property(nonatomic, copy) NSString *tbDevModelId;

@property (nonatomic, strong) CBProductSpecReportModel *devShowReport;
@end


NS_ASSUME_NONNULL_END
