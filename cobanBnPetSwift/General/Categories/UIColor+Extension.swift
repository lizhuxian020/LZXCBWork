//
//  UIColor+Extension.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/3/2.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    public func colorWithHex(rgb:Int,alpha:CGFloat) -> UIColor {
        return UIColor(red: ((CGFloat)((rgb&0xFF0000) >> 16))/255.0, green: ((CGFloat)((rgb&0xFF00) >> 8))/255.0, blue: ((CGFloat)(rgb&0xFF)) / 255.0, alpha: alpha)
    }
    public func colorWithHexString(hexString:String,alpha:CGFloat) -> UIColor {
        var cString:String = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if cString.count < 6 {
            return UIColor.black
        }
        if cString.hasPrefix("#") {
//            // 字符串截取
//            let start = cString.index(cString.startIndex, offsetBy: 2)
//            let end = cString.index(cString.startIndex, offsetBy: 10)
//            cString = String(cString[start...end])
            cString = cString.subString(fromIndex: 1, endIndex: cString.count - 1)
        }
        if cString.count != 6 {
            return UIColor.black
        }
        var range:NSRange = NSMakeRange(0, 2) //loc lenth
        let rString = (cString as NSString).substring(with: range)
        range.location = 2;
        let gString = (cString as NSString).substring(with: range)
        range.location = 4;
        let bString = (cString as NSString).substring(with: range)
        
        var r:UInt32 = 0x0
        var g:UInt32 = 0x0
        var b:UInt32 = 0x0
        Scanner.init(string: rString).scanHexInt32(&r)
        Scanner.init(string: gString).scanHexInt32(&g)
        Scanner.init(string: bString).scanHexInt32(&b)
        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(alpha));
    }
    public func colorWithHexString(hexString:String) -> UIColor {
        var cString:String = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if cString.count < 6 {
            return UIColor.black
        }
        if cString.hasPrefix("#") {
//            // 字符串截取
//            let start = cString.index(cString.startIndex, offsetBy: 2)
//            let end = cString.index(cString.startIndex, offsetBy: 10)
//            cString = String(cString[start...end])
            cString = cString.subString(fromIndex: 1, endIndex: cString.count - 1)
        }
        if cString.count != 6 {
            return UIColor.black
        }
        var range:NSRange = NSMakeRange(0, 2) //loc lenth
        let rString = (cString as NSString).substring(with: range)
        range.location = 2;
        let gString = (cString as NSString).substring(with: range)
        range.location = 4;
        let bString = (cString as NSString).substring(with: range)
        
        var r:UInt32 = 0x0
        var g:UInt32 = 0x0
        var b:UInt32 = 0x0
        Scanner.init(string: rString).scanHexInt32(&r)
        Scanner.init(string: gString).scanHexInt32(&g)
        Scanner.init(string: bString).scanHexInt32(&b)
        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1));
    }
}


