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
    
    
}
