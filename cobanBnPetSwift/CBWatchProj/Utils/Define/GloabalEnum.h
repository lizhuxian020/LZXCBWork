//
//  GloabalEnum.h
//  Singapore_powerbank
//
//  Created by 麦鱼科技 on 2017/8/16.
//  Copyright © 2017年 麦鱼科技. All rights reserved.
//

#ifndef GloabalEnum_h
#define GloabalEnum_h
///**
// 用户状态
//
// - UserAccountStateNormal: 正常
// - UserAccountStateFrost: 冻结
// */
//typedef NS_ENUM(NSUInteger, UserAccountState) {
//    UserAccountStateNormal,
//    UserAccountStateFrost,
//};
///**
// 用户性别
//
// - UserSexMale: 男
// - UserSexFamale: 女
// */
//typedef NS_ENUM(NSUInteger, UserSex) {
//    UserSexMale,
//    UserSexFamale,
//};
//
///**
// 用户类型
//
// - UserTypeNormal: 普通会员
// - UserTypeBusiness: 商家
// - UserTypeSmallTwo: 小二
// */
//typedef NS_ENUM(NSUInteger, UserType) {
//    UserTypeNormal,
//    UserTypeBusiness,
//    UserTypeSmallTwo,
//};
//
///*
// 关联用户类型
// FamilyTypeWife - 妻子
// FamilyTypeDaughter - 女儿
// FamilyTypeSon - 儿子
// FamilyTypeFather - 父亲
// FamilyTypeMother - 母亲
// FamilyTypeOther - 其他
// */
//typedef NS_ENUM(NSUInteger, FamilyType) {
//    FamilyTypeWife,
//    FamilyTypeDaughter,
//    FamilyTypeSon,
//    FamilyTypeFather,
//    FamilyTypeMother,
//    FamilyTypeOther
//};
//
//
///**
// 银行卡类型
//
// - PaymentTypeBalance: 余额
// - PaymentTypeAlipay: 支付宝
// - PaymentTypeCard: 银行卡
// */
//
//typedef NS_ENUM(NSUInteger, CardType) {
//    CardTypeUnionPay,
//    CardTypeVisa,
//    CardTypeMaster,
//    CardTypeOther
//};


typedef NS_ENUM(NSInteger, DeviceImageType) {
    DeviceImageTypeDogOrCat,
    DeviceImageTypeHuman,
    DeviceImageTypeCar
};

typedef NS_ENUM(NSInteger, DeviceStatusType) {
    DeviceStatusTypeNotStart, // 未启动
    DeviceStatusTypeAtSpeed, // 行驶中
    DeviceStatusTypeStayPut, // 静止
};

typedef NS_ENUM(NSInteger, FormType) {
    FormTypeIdling, // 怠速报表
    FormTypeStay,  // 停留统计
    FormTypeFire,  // 点火报表
    FormTypePourOil,  // 加油报表
    FormTypeOilLeak,  // 漏油报表
    FormTypeAllAlarm,  // 所有报警
    FormTypeSOSAlarm,  // SOS报警
    FormTypeOverspeedAlarm,  // 超速报警
    FormTypeTiredAlarm,  // 疲劳驾驶统计
    FormTypeUnderpackingAlarm,  // 欠压统计
    FormTypePowerDownAlarm,  // 掉电报警统计报表
    FormTypeShakeAlarm,  // 振动报警统计报表
    FormTypeOpenDoorAlarm,  // 开门报警统计报表
    FormTypeFireAlarm,  // 点火报警统计报表
    FormTypeMoveAlarm,  // 位移报警统计报表
    FormTypeGasolineTheftAlarm,  // 偷油漏油报警统计报表
    FormTypeCollisionAlarm,  // 碰撞报警报表
    FormTypeOBD,  // OBD报表
    FormTypeInFencing,  // 入围栏报警报表
    FormTypeOutFencing,  // 出围栏报警报表
    FormTypeInOutFencing,  // 出入围栏报警报表
    FormTypeDisplacementFencing,  // 位移报警
    FormTypeSchedule,  // 调度记录
};

#endif /* GloabalEnum_h */
