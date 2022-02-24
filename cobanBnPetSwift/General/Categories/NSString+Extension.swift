//
//  NSString+Extension.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/3/3.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import Foundation
import CommonCrypto

extension String {
    /// 字符串截取
    func subString(fromIndex index:Int,endIndex:Int) -> String {
        let start = self.index(self.startIndex, offsetBy: index)
        let end = self.index(self.startIndex, offsetBy: endIndex)
        return String(self[start...end])
    }
    
    /// 国际化拓展
    var localizedStr:String {
        get {
            return NSLocalizedString(self, comment: self)
        }
    }
    /// 去除null
    var valueStr:String {
        get {
            if self == "null" {
                return ""
            } else if self == "(null)" {
                return ""
            } else {
                return self
            }
        }
    }
    /// 判断是否为空
    var isEmpty:Bool {
        get {
            if self == "null" || self == "" || self.count <= 0 {
                return true
            } else {
                return false
            }
        }
    }
    func isEmptyFunc(value:String) {
        
    }
    /// 根据字符串计算高度
    public func getHeightText(text:String,font:UIFont,width:CGFloat) -> CGFloat {
        let dic = [NSAttributedString.Key.font:font]
        let textTemp = text as NSString
        let rect = textTemp.boundingRect(with: CGSize(width: width, height: 1000000), options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue), attributes: dic, context: nil)
        return ceil(rect.size.height)
    }
    /// 根据字符串计算宽度
    public func getWidthText(text:String,font:UIFont,height:CGFloat) -> CGFloat {
        let dic = [NSAttributedString.Key.font:font]
        let textTemp = text as NSString
        let rect = textTemp.boundingRect(with: CGSize(width: 10000, height: height), options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue), attributes: dic, context: nil)
        return ceil(rect.size.width)
    }
    ///创建文件路径
    /* folderName 文件夹名称 formateStr:后缀名*/
    public func createFilePath(folderName:String,formateStr:String) -> String {
        let timeStr = "\(Date().timeStamp)\(formateStr)"//.amr
        let newFilePath = (self.createDocmentPath(folderName: folderName) as NSString).appendingPathComponent(timeStr)
        if FileManager.default.fileExists(atPath: newFilePath) {
            if FileManager.default.createFile(atPath: newFilePath, contents: nil, attributes: nil) {
                CBLog(message: "文件夹地址创建成功")
            } else {
                CBLog(message: "文件夹地址创建失败")
            }
        }
        return newFilePath
    }
    ///获取某存储数据的文件夹，如果是第一次，则直接创建
    public func createDocmentPath(folderName:String) -> String {
        let homePath:String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first ?? ""
        let docPath = (homePath as NSString).appendingPathComponent(folderName)
        //var directoryExists = ObjCBool.init(false)
        //if FileManager.default.fileExists(atPath: docPath, isDirectory: &directoryExists) {
        if FileManager.default.fileExists(atPath: docPath) {
            CBLog(message: "文件夹已经存在，不需要创建")
        } else {
            do {
                try FileManager.default.createDirectory(atPath: docPath, withIntermediateDirectories: true, attributes: nil)
                CBLog(message: "文件夹创建成功")
            } catch {
                CBLog(message: "文件夹创建失败:\(error.localizedDescription)")
            }
        }
        return docPath
    }
    ///获取某存储数据的文件夹，如果是第一次，则直接创建
    public func fillterStr(keyStr1:String,keyStr2:String) -> String {
        let valueStr1 = self.replacingOccurrences(of: keyStr1, with: "")
        let valueStr2 = valueStr1.replacingOccurrences(of: keyStr2, with: "")
        
        return valueStr2
    }
    /// 截取到任意位置
    func subString(to: Int) -> String {
        let index: String.Index = self.index(startIndex, offsetBy: to)
        return String(self[..<index])
    }
    /// 从任意位置开始截取
    func subString(from: Int) -> String {
        let index: String.Index = self.index(startIndex, offsetBy: from)
        return String(self[index ..< endIndex])
    }
    /// 从任意位置开始截取到任意位置
    func subString(from: Int, to: Int) -> String {
        let beginIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[beginIndex...endIndex])
    }
    //使用下标截取到任意位置
    subscript(to: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: to)
        return String(self[..<index])
    }
    //使用下标从任意位置开始截取到任意位置
    subscript(from: Int, to: Int) -> String {
        let beginIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[beginIndex...endIndex])
    }
    /// 验证邮箱格式
    func isValidateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailPredicate = NSPredicate.init(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    //有效的字母数字密码 6-12位
    func isValidateAlphaNumberPwd() -> Bool {
        let regex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,12}$"
        let identityCardPredicate = NSPredicate.init(format: "SELF MATCHES %@", regex)
        return identityCardPredicate.evaluate(with: self)
    }
    func isValidatePhoneNumber() -> Bool {
//        let regex = "^((1[0-9])|(1[0-9])|(1[0-9]))\\d{9}$"
//        let identityCardPredicate = NSPredicate.init(format: "SELF MATCHES %@", regex)
//        return identityCardPredicate.evaluate(with: self)
        return self.isEmpty == false
    }
}
extension Float {
    /// 小数点后如果只是0，显示整数，如果不是，显示原来的值
    var cleanZero : String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self):String(self)
    }
}
extension Double {
    /// 小数点后如果只是0，显示整数，如果不是，显示原来的值
    var cleanZero : String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self):String(self)
    }
}

