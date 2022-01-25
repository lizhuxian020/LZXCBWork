//
//  CBPetUserManageViewModel.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/16.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetUserManageViewModel: CBPetBaseViewModel {

    /* 刷新用户管理列表数据 block*/
    var userManageUpdateListDataBlock:((_ daraSource:[CBPetUserManageModel]) -> Void)?
    
    /* 删除用户 block*/
    var userManageDeleteUserManageBlock:((_ daraSource:CBPetUserManageModel) -> Void)?
    
    /* 获取配置信息*/
    var userMangerUpdateParamModelBlock:((_ paramModel:CBPetHomeParamtersModel) -> Void)?
    
    /* 点击设置时区*/
    var didClickTimezone:(()->Void)?
    
    /* 点击挂失开关*/
    var didClickLossSwitch: ((_ isOn:Bool)->Void)?
    
    /* 点击定时报告开关*/
    var didClickTimeReportSwitch: ((_ isOn:Bool)->Void)?
    
    /* 点击定时报告*/
    var didClickTimeReport:(()->Void)?
}
