//
//  NSDate+Extension.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/29.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class NSDate_Extension: NSObject {
}
extension Date {
    //MARK: - 获取当前秒级时间戳10位
    var timeStamp:String {
        let timeInterval:TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    //MARK: 获取当前 毫秒级 时间戳 - 13位
    var milliStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
}
