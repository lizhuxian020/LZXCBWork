//
//  _CBCommandRecord.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/12/3.
//  Copyright © 2022 coban. All rights reserved.
//

#import "_CBCommandRecord.h"

@implementation _CBCommandRecord

+ (NSDictionary *)cmdData {
    return @{
        @"ESC_STRATEGY":Localized(@"上报策略"),
        @"PHONE":Localized(@"回拨电话"),
        @"MONITOR_MODE":Localized(@"听听"),
        @"DYDD_1":Localized(@"断油电"),
        @"DYDD_0":Localized(@"恢复油电"),
        @"WARN_STOP":Localized(@"停止报警"),
        @"CFBF_0":Localized(@"撤防"),
        @"CFBF_1":Localized(@"布防"),
        @"FEE_FORWARD_PHONE":Localized(@"话费查询"),
        @"SDJ":Localized(@"锁电机"),
        @"CYQD":Localized(@"远程控制"),
        @"FENCE":Localized(@"移位报警"),
        @"DCDD":Localized(@"多次定位"),
        @"OBDMSG":Localized(@"请求OBD"),
        @"WARM_DIAODIAN":Localized(@"外电断电报警"),
        @"WARM_DIDIAN":Localized(@"低电报警"),
        @"WARN_BLIND":Localized(@"盲区报警"),
        @"URGENT_WARN":Localized(@"紧急报警"),
        @"OVER_WARM":Localized(@"超速报警"),
        @"WARM_ZD":Localized(@"振动报警"),
        @"OIL_CHECK_WARN":Localized(@"油量检测报警"),
        @"TIME_ZONE":Localized(@"时区设置"),
        @"PASSWORD":Localized(@"设置短信密码"),
        @"RESET_DEVICE":Localized(@"恢复出厂设置"),
        @"REBOOT_DEVICE":Localized(@"设备重启"),
        @"REST_MOD":Localized(@"休眠模式"),
        @"VOLUME":Localized(@"设置油箱容积"),
        @"OIL_VALIDATE":Localized(@"油量校准"),
        @"MILEAGE":Localized(@"里程初始值"),
        @"DROWSY_DRIVING":Localized(@"疲劳驾驶"),
        @"PZ_CFBJ":Localized(@"碰撞报警参数设置"),
        @"ACC_NOTICE":Localized(@"ACC工作通知"),
        @"GPS_FLOAT":Localized(@"GPS漂移抑制"),
        @"ANGLE":Localized(@"转弯补传角度"),
        @"SEND_MSG_LIMIT":Localized(@"报警短信设置次数"),
        @"SENSITIVITY":Localized(@"震动等级"),
        @"NETWORK":Localized(@"编辑设备网络参数"),
        @"SET_UP":Localized(@"设置"),
        @"SHAPE_0":Localized(@"电子围栏-多边形"),
        @"SHAPE_1":Localized(@"电子围栏-圆形"),
        @"SHAPE_2":Localized(@"电子围栏-矩形"),
        @"AUTH_PHONE":Localized(@"授权号码"),
        @"DELETE_AUTH_PHONE":Localized(@"删除授权号码"),
        @"DELETE_FENCE":Localized(@"删除电子围栏"),
        @"REALTIME_VIDEO":Localized(@"实时视频"),
        @"PHOTOGRAPH":Localized(@"拍照"),
        @"WIF_HOTSPOT":Localized(@"wifi热点"),
        @"WARM_CC":Localized(@"拆除报警开关"),
        @"WARM_WD":Localized(@"温度报警开关"),
        @"HORN_SWITCH ":Localized(@"喇叭开关"),
    };
}

- (NSString *)cmdName {
    return _CBCommandRecord.cmdData[self.cmd];
}

- (NSString *)statusName {
    if (_status == 0) {
        return Localized(@"发送中");
    }
    if (_status == 1) {
        return Localized(@"发送成功");
    }
    if (_status == 2) {
        return Localized(@"发送失败");
    }
    return @(_status).description;
}
@end
