//
//  FormInfoModel.h
//  Telematics
//
//  Created by lym on 2017/12/26.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormInfoModel : NSObject
@property (nonatomic, copy) NSString *ids; // 
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *endAddr;
@property (nonatomic, copy) NSString *startAddr;
@property (nonatomic, copy) NSString *mileage; // 本次里程
@property (nonatomic, copy) NSString *dName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *nowOil;
@property (nonatomic, copy) NSString *oilCount;
@property (nonatomic, copy) NSString *altitude; // 海拔
@property (nonatomic, copy) NSString *carStu; // "断电",  汽车状态
@property (nonatomic, copy) NSString *direct; // 方向
@property (nonatomic, copy) NSString *oil; //  耗油量
@property (nonatomic, copy) NSString *oilProp; // 油耗
@property (nonatomic, copy) NSString *speed;
@property (nonatomic, copy) NSString *temp; // 温度
@property (nonatomic, copy) NSString *terminal; // "GPS 8颗"  终端状态
@property (nonatomic, copy) NSString *avgOil; // 平均油耗
@property (nonatomic, copy) NSString *batteryVol; // 蓄电池电压
@property (nonatomic, copy) NSString *battery;
@property (nonatomic, copy) NSString *dlLoad; // 动力负荷
@property (nonatomic, assign) int driveTime; // 行驶时间(分钟)
@property (nonatomic, copy) NSString *engineSpeed; // 发动机转速
@property (nonatomic, copy) NSString *errCode; // 故障码
@property (nonatomic, copy) NSString *ignitionPos; // 点火提前角
@property (nonatomic, copy) NSString *inTemp; // 进去温度
@property (nonatomic, copy) NSString *jqm; // 节气门开度
@property (nonatomic, copy) NSString *leftOil; // 剩余油量
@property (nonatomic, copy) NSString *totalMile; // 累计里程
@property (nonatomic, copy) NSString *troubleMile; // 故障灯亮行驶里程
@property (nonatomic, copy) NSString *untroubleMil; // 故障清除行驶里程
@property (nonatomic, copy) NSString *zgyl; // 进气支管绝对压力值
@property (nonatomic, copy) NSString *fName; // 围栏名称
@property (nonatomic, copy) NSString *event; // 调度事件名称
@property (nonatomic, copy) NSString *cartNum; // 卡号
@property (nonatomic, copy) NSString *url; // 下载地址
@property (nonatomic, assign) FormType formType;
@property (nonatomic, assign) int status; // ACC状态；0-开门，1-行驶 调度处理结果；0-已收到，1-未收到
@property (nonatomic, assign) int payType; // 刷卡类型；0-插卡，1-拔卡
@property (nonatomic, copy) NSString *type; //报警 0-sos报警，1-超速报警，2-疲劳报警，3-欠压报警，4-掉电报警，5-振动报警，6-开门报警，7-点火报警，8-位移报警，9-偷油报警，10-碰撞报警' 消息类型；0-文本，1-事件，2-提问 多媒体类型；0-图像，1-音频，2-视频
@property (nonatomic, copy) NSString *warmType;
- (NSMutableArray *)getIdingOrStayModelArr;
- (NSMutableArray *)getFireModelArr;
- (NSMutableArray *)getPourOilOrOilLeakModelArr;
- (NSMutableArray *)getAlarmModelArr:(FormType)type;
- (NSMutableArray *)getObdModelArr;
- (NSMutableArray *)getFenceModelArr;
//- (NSMutableArray *)getScheduleModelArr;
//- (NSMutableArray *)getMultimediaModelArr;
@end
