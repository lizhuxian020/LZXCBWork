//
//  CBPetMultiViewModel.swift
//  cobanBnPetSwift
//
//  Created by lee on 2022/1/16.
//  Copyright © 2022 coban. All rights reserved.
//

import Foundation

class CBPetMultiViewModel: CBPetBaseViewModel {
    
    /* 点击导航栏标题*/
    var clickNaviTitleBLK : ((_ idx: Int) -> Void)?
    
    /* 点击导航栏返回*/
    var clickBackBtnBLK : (() -> Void)?
}
