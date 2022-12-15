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
        @"ESC_STRATEGY":@"上报策略",
        @"PHONE":@"回拨电话",
        @"MONITOR_MODE":@"听听",
        @"DYDD_1":@"断油电",
        @"DYDD_0":@"恢复油电",
        @"WARN_STOP":@"停止报警",
        @"CFBF_0":@"撤防",
        @"CFBF_1":@"布防",
        @"FEE_FORWARD_PHONE":@"话费查询",
        @"SDJ":@"锁电机",
        @"CYQD":@"远程控制",
        @"FENCE":@"移位报警",
        @"DCDD":@"多次定位",
        @"OBDMSG":@"请求OBD",
        @"WARM_DIAODIAN":@"外电断电报警",
        @"WARM_DIDIAN":@"低电报警",
        @"WARN_BLIND":@"盲区报警",
        @"URGENT_WARN":@"紧急报警",
        @"OVER_WARM":@"超速报警",
        @"WARM_ZD":@"振动报警",
        @"OIL_CHECK_WARN":@"油量检测报警",
        @"TIME_ZONE":@"时区设置",
        @"PASSWORD":@"设置短信密码",
        @"RESET_DEVICE":@"恢复出厂设置",
        @"REBOOT_DEVICE":@"设备重启",
        @"REST_MOD":@"休眠模式",
        @"VOLUME":@"设置油箱容积",
        @"OIL_VALIDATE":@"油量校准",
        @"MILEAGE":@"里程初始值",
        @"DROWSY_DRIVING":@"疲劳驾驶",
        @"PZ_CFBJ":@"碰撞报警参数设置",
        @"ACC_NOTICE":@"ACC工作通知",
        @"GPS_FLOAT":@"GPS漂移抑制",
        @"ANGLE":@"转弯补传角度",
        @"SEND_MSG_LIMIT":@"报警短信设置次数",
        @"SENSITIVITY":@"震动等级",
        @"NETWORK":@"编辑设备网络参数",
        @"SET_UP":@"设置",
        @"SHAPE_0":@"电子围栏-多边形",
        @"SHAPE_1":@"电子围栏-圆形",
        @"SHAPE_2":@"电子围栏-矩形",
        @"AUTH_PHONE":@"授权号码",
        @"DELETE_AUTH_PHONE":@"删除授权号码",
        @"DELETE_FENCE":@"删除电子围栏",
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
