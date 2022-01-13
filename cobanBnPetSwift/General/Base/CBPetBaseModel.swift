//
//  CBPetBaseModel.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/3/24.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

struct CBPetBaseModel:HandyJSON {
    var status:String?
    var data:AnyClass?
    var resmsg:String?
    var totalrow:String?
}

struct CBBaseNetworkModel:HandyJSON {
//    var request:URLRequest?
//    var response:HTTPURLResponse?
//    var json:AnyObject?
//    var error:NSError?
//    var data:Data?
    
    var status:String?
    var rescode:String?
    var data:Any?
    var resmsg:String?
    var totalrow:String?
    
    var response:HTTPURLResponse?
    
    /* struct 不用实现空的init()方法 class需要实现*/
//    init() {
//
//    }
}
