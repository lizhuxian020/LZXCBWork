//
//  CBPetNetworkingReachability.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/3/11.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import Alamofire

class CBPetNetworkingReachability: NSObject {
    
    ///单例
    static let share:CBPetNetworkingReachability = {
        let reachAbility = CBPetNetworkingReachability.init()
        return reachAbility
    }()
    var reachAble:Bool = true
    var checkBlock:((_ reach:Bool) -> Void)?
    func checkNetReachAble(checkNetBlock:@escaping ((_ reach:Bool) -> Void)) {
        self.checkBlock = checkNetBlock
        var reach = true
        let manager = NetworkReachabilityManager(host:"www.baidu.com") //"http://www.baidu.com" "https://www.baidu.com"
        manager?.startListening()
        manager?.listener = { status in
            switch status {
            case .unknown:
                reach = false
            case .notReachable:
                reach = false
            case .reachable(.ethernetOrWiFi):
                reach = true
            case .reachable(.wwan):
                reach = true
            }
            self.reachAble = reach
            guard self.checkBlock == nil else {
                self.checkBlock!(reach)
                return
            }
        }
    }
}
