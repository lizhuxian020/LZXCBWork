//
//  FormInfoModel.m
//  Telematics
//
//  Created by lym on 2017/12/26.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "FormInfoModel.h"
#import <GoogleMaps/GoogleMaps.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface FormInfoModel ()<BMKGeoCodeSearchDelegate>

@end
@implementation FormInfoModel

- (instancetype)mj_setKeyValues:(id)keyValues {
    [super mj_setKeyValues:keyValues];
    if (![_startTime containsString:@"-"]) {
        _startTime = [MINUtils getTimeFromTimestamp:_startTime formatter:@"yyyy-MM-dd HH:mm:ss"];
    }
    return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ids" : @"id",
             };
}
- (NSMutableArray *)getIdingOrStayModelArr
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"设备名称:"),self.dName]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"起始时间:"),self.startTime?:@""]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"结束时间:"),self.endTime?:@""]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSInteger startTimeInterval = [CBCommonTools timeStrConvertTimeInteral:self.startTime formatter:formatter].integerValue;
    NSInteger endTimeInterval = [CBCommonTools timeStrConvertTimeInteral:self.endTime formatter:formatter].integerValue;
    NSArray *timeArray = [CBCommonTools getDetailTimeWithTimestamp:(endTimeInterval - startTimeInterval)];
    
    NSNumber *dayStr = timeArray[0];
    NSNumber *hourStr = timeArray[1];
    NSNumber *minuteStr = timeArray[2];
    NSNumber *secondStr = timeArray[3];
    
    NSString *timeStr = @"";
    timeStr = [NSString stringWithFormat:@"%@ %@ %@ %@",dayStr.integerValue == 0?@"":[NSString stringWithFormat:@"%@%@",dayStr,Localized(@"天")],hourStr.integerValue == 0?@"":[NSString stringWithFormat:@"%@%@",hourStr,Localized(@"时")],minuteStr.integerValue == 0?@"":[NSString stringWithFormat:@"%@%@",minuteStr,Localized(@"分")],secondStr.integerValue == 0?@"":[NSString stringWithFormat:@"%@%@",secondStr,Localized(@"秒")]];
    if (self.formType == FormTypeStay) {
        [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"停留时长:"),timeStr]];
    } else {
        [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"怠速时长:"),timeStr]];
    }
    return array;
}

- (NSMutableArray *)getFireModelArr
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"设备名称:"),self.dName]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"起始时间:"),self.startTime?:@""]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"结束时间:"),self.endTime?:@""]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSInteger startTimeInterval = [CBCommonTools timeStrConvertTimeInteral:self.startTime formatter:formatter].integerValue;
    NSInteger endTimeInterval = [CBCommonTools timeStrConvertTimeInteral:self.endTime formatter:formatter].integerValue;
    NSArray *timeArray = [CBCommonTools getDetailTimeWithTimestamp:(endTimeInterval - startTimeInterval)];
    
    NSNumber *dayStr = timeArray[0];
    NSNumber *hourStr = timeArray[1];
    NSNumber *minuteStr = timeArray[2];
    NSNumber *secondStr = timeArray[3];
    
    NSString *timeStr = @"";
    timeStr = [NSString stringWithFormat:@"%@ %@ %@ %@",dayStr.integerValue == 0?@"":[NSString stringWithFormat:@"%@%@",dayStr,Localized(@"天")],hourStr.integerValue == 0?@"":[NSString stringWithFormat:@"%@%@",hourStr,Localized(@"时")],minuteStr.integerValue == 0?@"":[NSString stringWithFormat:@"%@%@",minuteStr,Localized(@"分")],secondStr.integerValue == 0?@"":[NSString stringWithFormat:@"%@%@",secondStr,Localized(@"秒")]];
    [array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"点火时长:"),timeStr]];
    
    [array addObject: [NSString stringWithFormat: @"%@ %@km",Localized(@"本次里程:"),self.mileage]];
    if (self.status == 0) {
        [array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"ACC状态:"),Localized(@"关")]];
    }else {
        [array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"ACC状态:"),Localized(@"关")]];
    }
//    [array addObject: [NSString stringWithFormat: @"开始位置: %@", self.startAddr]];
//    [array addObject: [NSString stringWithFormat: @"结束位置: %@", self.endAddr]];
    return array;
}

- (NSMutableArray *)getPourOilOrOilLeakModelArr
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"设备名称:"),self.dName]];
    [array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"时间:"),[MINUtils getTimeFromTimestamp: self.createTime formatter: @"yyyy-MM-dd HH:mm:ss"]]];
    [array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"当前油量:"),self.nowOil]];
    if (self.formType == FormTypePourOil) {
        [array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"加油:"),self.oilCount]];
    }else {
        [array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"漏油:"),self.oilCount]];
    }
    return array;
}

- (NSMutableArray *)getAlarmModelArr:(FormType)type {
    NSMutableArray *array = [NSMutableArray array];
    [array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"设备名称:"),self.name]];
    [array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"时间:"),[MINUtils getTimeFromTimestamp: self.createTime formatter: @"yyyy-MM-dd HH:mm:ss"]]];
    [array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"地址:"),self.address]];
    NSArray *arrayType = @[];// = [self.type componentsSeparatedByString:@","];
    if (type == FormTypeAllAlarm) {
        //全部报警类型用type拆分
        arrayType = [self.type componentsSeparatedByString:@","];
    } else {
        arrayType = [self.warmType componentsSeparatedByString:@","];
    }
    NSMutableArray *arrayTypeStr = [NSMutableArray array];
    for (NSString *str in arrayType) {
        if (!kStringIsEmpty(str)) {
            [arrayTypeStr addObject:[self convertWarmType:str]];
        }
    }
    [array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"报警类型:"),[NSString stringWithFormat:@"%@",[arrayTypeStr componentsJoinedByString:@","]]]];
    [array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"卫星数量:"),self.terminal]];// 终端状态
    [array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"油耗:"),self.oilProp]];
    [array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"总耗油:"),self.oil]];
    [array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"温度:"),self.temp]];
    [array addObject: [NSString stringWithFormat:@"%@ %@km",Localized(@"里程:"),self.mileage]];
    [array addObject: [NSString stringWithFormat:@"%@ %@km/h",Localized(@"速度:"),self.speed]];
    NSString *dirStr = [self convertDirection:self.direct];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"方向:"),dirStr]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"经度:"),self.lng]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"纬度:"),self.lat]];
    [array addObject: [NSString stringWithFormat: @"%@ %@m",Localized(@"海拔:"),self.altitude]];
    return array;
}

- (NSMutableArray *)getObdModelArr
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"设备名称:"),self.name]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"时间:"),[MINUtils getTimeFromTimestamp: self.createTime formatter: @"yyyy-MM-dd HH:mm"]]];
    [array addObject: [NSString stringWithFormat: @"%@ %@km",Localized(@"累计里程:"),self.totalMile]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"瞬时油耗:"),self.nowOil]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"平均油耗:"),self.avgOil]];
    [array addObject: [NSString stringWithFormat: @"%@ %d",Localized(@"行驶时间:"),self.driveTime]];
    [array addObject: [NSString stringWithFormat: @"%@ %@km/h",Localized(@"车速:"),self.speed]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"动力负荷:"),self.dlLoad]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"水温:"),self.temp]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"节气门开度:"),self.jqm]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"发动机转速:"),self.engineSpeed]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"蓄电池电压:"),self.batteryVol]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"故障灯行驶路程:"),self.troubleMile]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"剩余油量:"),self.leftOil]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"进气支管绝对压力值:"),self.zgyl]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"点火提前角(1缸):"),self.ignitionPos]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"进气温度:"),self.inTemp]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"故障清除行驶里程:"),self.untroubleMil]];
    return array;
}

- (NSMutableArray *)getFenceModelArr
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"设备名称:"),self.dName?:@""]];
    [array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"围栏名称:"),self.fName?:@""]];
    if (self.formType == FormTypeInFencing) {
        [array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"入围栏时间:"),[MINUtils getTimeFromTimestamp: self.createTime formatter: @"yyyy-MM-dd HH:mm:ss"]]];
    }else if (self.formType == FormTypeOutFencing) {
        [array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"出围栏时间:"),[MINUtils getTimeFromTimestamp: self.createTime formatter: @"yyyy-MM-dd HH:mm:ss"]]];
    }else if (self.formType == FormTypeInOutFencing){
        [array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"出入围栏时间:"),[MINUtils getTimeFromTimestamp: self.createTime formatter: @"yyyy-MM-dd HH:mm:ss"]]];
    }
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"地址:"),self.address]];
//    FormTypeInFencing,  // 入围栏报警报表
//    FormTypeOutFencing,  // 出围栏报警报表
//    FormTypeInOutFencing,  // 出入围栏报警报表
    switch (self.formType) {
        case FormTypeOutFencing:
            [array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"报警类型:"),[NSString stringWithFormat:@"%@",Localized(@"出围栏报警")]]];
            break;
        case FormTypeInFencing:
            [array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"报警类型:"),[NSString stringWithFormat:@"%@",Localized(@"入围栏报警")]]];
            break;
        case FormTypeInOutFencing:
            [array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"报警类型:"),[NSString stringWithFormat:@"%@",Localized(@"出入围栏报警")]]];
            break;
        case FormTypeDisplacementFencing:
            [array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"报警类型:"),[NSString stringWithFormat:@"%@",Localized(@"位移报警")]]];
            break;
        default:
            break;
    }
    //[array addObject: [NSString stringWithFormat:@"%@ %@",Localized(@"报警类型:"),[NSString stringWithFormat:@"%@",[arrayTypeStr componentsJoinedByString:@","]]]];
    [array addObject: [NSString stringWithFormat: @"%@ %@km",Localized(@"里程:"),self.mileage]];
    [array addObject: [NSString stringWithFormat: @"%@ %@kn/h",Localized(@"速度:"),self.speed]];
    NSString *dirStr = [self convertDirection:self.direct];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"方向:"),dirStr]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"经度:"),self.lng]];
    [array addObject: [NSString stringWithFormat: @"%@ %@",Localized(@"纬度:"),self.lat]];
    [array addObject: [NSString stringWithFormat: @"%@ %@m",Localized(@"海拔:"),self.altitude]];
    return array;
}
//- (NSMutableArray *)getScheduleModelArr
//{
//    NSMutableArray *array = [NSMutableArray array];
//    [array addObject: [NSString stringWithFormat: @"设备名称: %@", self.name]];
//    if (self.type == 0) {
//        [array addObject: [NSString stringWithFormat: @"消息类型: 文本"]];
//    }else if (self.type == 1) {
//        [array addObject: [NSString stringWithFormat: @"消息类型: 事件"]];
//    }else if (self.type == 2) {
//        [array addObject: [NSString stringWithFormat: @"消息类型: 提问"]];
//    }
//    [array addObject: [NSString stringWithFormat: @"发送时间: %@", [MINUtils getTimeFromTimestamp: self.createTime formatter: @"yyyy-MM-dd HH:mm:ss"]]];
//    [array addObject: [NSString stringWithFormat: @"事件: %@", self.event]];
//    if (self.status == 0) {
//        [array addObject: [NSString stringWithFormat: @"处理结果: 已收到"]];
//    }else {
//        [array addObject: [NSString stringWithFormat: @"处理结果: 未收到"]];
//    }
//    return array;
//}
//- (NSMutableArray *)getMultimediaModelArr
//{
//    NSMutableArray *array = [NSMutableArray array];
//    [array addObject: [NSString stringWithFormat: @"时间: %@", [MINUtils getTimeFromTimestamp: self.createTime formatter: @"yyyy-MM-dd HH:mm:ss"]]];
//    [array addObject: [NSString stringWithFormat: @"卡号: %@", self.cartNum]];
//    if (self.payType == 0) {
//        [array addObject: [NSString stringWithFormat: @"刷卡方式: 插卡"]];
//    }else {
//        [array addObject: [NSString stringWithFormat: @"刷卡方式: 拔卡"]];
//    }
//    if (self.type == 0) {
//        [array addObject: [NSString stringWithFormat: @"多媒体类型: 图像"]];
//    }else if (self.type == 1) {
//        [array addObject: [NSString stringWithFormat: @"多媒体类型: 音频"]];
//    }else if (self.type == 2) {
//        [array addObject: [NSString stringWithFormat: @"多媒体类型: 视频"]];
//    }
//    [array addObject: [NSString stringWithFormat: @"位置: %@", self.address]];
//    return array;
//}
- (NSString *)convertWarmType:(NSString *)str {
    switch (str.integerValue) {
        case 0:
            return Localized(@"sos");
            break;
        case 1:
            return Localized(@"超速");
            break;
        case 2:
            return Localized(@"疲劳");
            break;
        case 7:
            return Localized(@"低电");
            break;
        case 8:
            return Localized(@"掉电");
            break;
        case 12:
            return Localized(@"振动");
            break;
        case 15:
            return Localized(@"位移");
            break;
        case 16:
            return Localized(@"点火");
            break;
        case 17:
            return Localized(@"开门");
            break;
        case 20:
            return Localized(@"进出区域");
            break;
        case 25:
            return Localized(@"偷油漏油");
            break;
        case 27:
            return Localized(@"碰撞");
            break;
        case 32:
            return Localized(@"出围栏");
            break;
        case 33:
            return Localized(@"进围栏");
        default:
            return Localized(@"未知");
            break;
    }
}
- (NSString *)convertDirection:(NSString *)dirStr {
    if ([dirStr isEqualToString:@"N"]) {
        return Localized(@"正北");
    } else if ([dirStr isEqualToString:@"E"]) {
        return Localized(@"正东");
    } else if ([dirStr isEqualToString:@"S"]) {
        return Localized(@"正南");
    } else if ([dirStr isEqualToString:@"W"]) {
        return Localized(@"正西");
    } else if ([dirStr containsString:@"NE"]) {
        return Localized(@"东北");
    } else if ([dirStr containsString:@"ES"]) {
        return Localized(@"东南");
    } else if ([dirStr containsString:@"SW"]) {
        return Localized(@"西南");
    } else if ([dirStr containsString:@"WN"]) {
        return Localized(@"西北");
    }
    return @"";
}
@end
