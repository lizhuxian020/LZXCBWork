//
//  CBPetLoginModel.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/4/1.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import HandyJSON

@objcMembers class CBPetLoginModel: NSObject,NSCoding,HandyJSON,CBMappable {
    
    var name:String?
    var status:String?
    var uid:String?
    var email:String?
    var fid:String?
    var level:String?
    var code:String?
    var account:String?
    var phone:String?
    var token:String?
    var auth:String?
    
    required override init() {
        //
    }
    
    // MARK: - 归档
    func encode(with coder: NSCoder) {
        // 归档前删除原来的以避免错误
        CBPetLoginModelTool.removeUser()
        for name in getAllPropertys() {
            guard let value = self.value(forKey: name) else {
                return
            }
            coder.encode(value, forKey: name)
        }
    }
    // MARK: - 解档
    internal required init?(coder: NSCoder) {
        super.init()
        for name in getAllPropertys() {
            guard let value = coder.decodeObject(forKey: name) else {
                return
            }
            setValue(value, forKey: name)
        }
    }
    // MARK: - 获取属性数组
    func getAllPropertys() -> [String] {
        var count:UInt32 = 0 // 这个类型可以使用CUnsignedInt,对应Swift中的UInt32
        let properties = class_copyPropertyList(self.classForCoder, &count)
        var propertyNames:[String] = []
        for i in 0..<Int(count) { // Swift中类型是严格检查的 必须转换成同一类型
            if let property = properties?[i] {
                // UnsafeMutablePointer<objc_property_t>是可变指针，因此properties就是类似数组一样，可以通过下标获取
                let name = property_getName(property)
                // 这里转成字符串
                let strName = String(cString: name)
                propertyNames.append(strName)
            }
        }
        // 不要忘记释放内存，否则C语言很容易成野指针的
        free(properties)
        return propertyNames
    }
    // MARK: - 获取对应属性的值 没有则返回nil
    func getValueOfProperty(property:String) -> AnyObject? {
        let allPropertys = self.getAllPropertys()
        if allPropertys.contains(property) {
            return self.value(forKey: property) as AnyObject
        } else {
            return nil
        }
    }
}

enum CBMapError:Error {
    case jsonToModelFail    //json转model失败
    case jsonToDataFail     //json转data失败
    //    case dictToJsonFail     //字典转json失败
    //    case jsonToArrFail      //json转数组失败
    //    case modelToJsonFail    //model转json失败
}

public protocol CBMappable:Codable {
    //func cb_model
}

extension CBMappable {
    public func cb_modelMapFinished() {
        // 外部自己实现
    }
    public mutating func cb_structMapFinished() {
        // 外部自己实现
    }
    /* JSON转模型*/
    static func cb_mapFromJson<T:CBMappable>(_ JSONString:String,_ type:T.Type) throws -> T {
        guard let jsonData = JSONString.data(using: .utf8) else {
            throw CBMapError.jsonToModelFail
        }
        let decoder = JSONDecoder()
        do {
            let obj = try decoder.decode(type, from: jsonData)
            var vobj = obj
            let mirro = Mirror(reflecting: vobj)
            if mirro.displayStyle == Mirror.DisplayStyle.struct {
                vobj.cb_structMapFinished()
            }
            if mirro.displayStyle == Mirror.DisplayStyle.class {
                vobj.cb_modelMapFinished()
            }
            return vobj
        } catch {
            CBLog(message: error)
        }
        throw CBMapError.jsonToModelFail
    }
}

@objcMembers class CBPetLoginModelTool:NSObject {
    // MARK: - 归档路径设置
    static private var Path:String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        return (path as NSString).appendingPathComponent("account.plist")
    }
    //static func
    
    /* 存档*/
    static func saveUser(_ userModel:CBPetLoginModel) {
        guard userModel.uid != nil else {
            CBLog(message: "用户信息存档失败")
            return;
        }
        let isSuccess = NSKeyedArchiver.archiveRootObject(userModel, toFile: Path)
        if isSuccess {
            CBLog(message: "用户信息存档成功")
        } else {
            CBLog(message: "用户信息存档失败")
        }
    }
    /* 获取用户信息*/
    @objc public static func getUser() -> CBPetLoginModel? { ///static
        let user = NSKeyedUnarchiver.unarchiveObject(withFile: Path) as? CBPetLoginModel
        return user
    }
    /* 删档*/
    static func removeUser() {
        if FileManager.default.fileExists(atPath: Path) {
            //try! FileManager.default.removeItem(atPath: Path) // 删除文件
            do {
                try FileManager.default.removeItem(atPath: Path) // 删除文件
                CBLog(message: "用户信息删档成功")
            } catch {
                CBLog(message: "用户信息删档失败")
            }
        } else {
            CBLog(message: "没有文档路径,用户信息删除失败")
        }
    }
}
struct CBPetVerifyGraphicsModel:HandyJSON,Codable {
    var image:String?
    var key:String?
    var numericalValue:String?
}
