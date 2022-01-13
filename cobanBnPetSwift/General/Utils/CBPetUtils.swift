//
//  CBPetUtils.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/3/6.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import CommonCrypto
import AVFoundation

class CBPetUtils: NSObject {
    //MARK: - md5加密
    class func md5(Str str:String) -> String {
        let cstr = str.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(str.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: digestLen)
        CC_MD5(cstr!,strLen,result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize(count: digestLen)
        
        return String(format: hash as String)
    }
    //MARK: - 时间戳 转 日期NSData
    class func convertTimestampToDate(timestamp:String) -> NSDate {
        let timeS = Double(timestamp)
        let date = NSDate.init(timeIntervalSince1970: timeS!/1000.0)
        return date
    }
    //MARK: - 时间戳 转 日期字符串
    class func convertTimestampToDateStr(timestamp:String,formateStr:String) -> String {
        if Int(timestamp) ?? 0 <= 0 {
            return ""
        }
        let interval:TimeInterval = TimeInterval.init(timestamp)!/1000
        let date = Date(timeIntervalSince1970: interval)//NSDate.init(timeIntervalSince1970: timeS!/1000.0)
        let formatter = DateFormatter()
        formatter.dateFormat = formateStr //"yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date as Date)
    }
    //MARK: - 时间戳 转 指定时区日期字符串
    class func convertTimestampToDateStr(timestamp:String,formateStr:String,timeZone:Int) -> String {
        if Int(timestamp) ?? 0 <= 0 {
            return ""
        }
        let interval:TimeInterval = TimeInterval.init(timestamp)!/1000
        let date = Date(timeIntervalSince1970: interval)//NSDate.init(timeIntervalSince1970: timeS!/1000.0)
        
        let formatter = DateFormatter()
        /// 设置为指定的时区
        let timeZ = NSTimeZone.init(forSecondsFromGMT: timeZone*3600)
        formatter.timeZone = timeZ as TimeZone
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.dateFormat = formateStr //"yyyy-MM-dd HH:mm:ss"
        
        return formatter.string(from: date as Date)
    }
    //MARK: - 设置导航栏背景色字体
    class func setupNavigationBar(navigationController:UINavigationController,barBgmColor:UIColor) {
        if #available(iOS 13.0, *) {
            navigationController.navigationBar.standardAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:  UIColor.white, NSAttributedString.Key.font: UIFont.init(name: CBPingFang_SC_Bold, size: 16*KFitHeightRate) as Any]
            navigationController.navigationBar.standardAppearance.backgroundColor = barBgmColor
        } else if #available(iOS 11.0, *) {
            navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:  UIColor.white, NSAttributedString.Key.font: UIFont.init(name: CBPingFang_SC_Bold, size: 16*KFitHeightRate) as Any]
            navigationController.navigationBar.barTintColor = barBgmColor
        } else {
            // Fallback on earlier versions
            /* 背景色*/
            navigationController.navigationBar.barTintColor = barBgmColor
            let dict:NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font : UIFont.init(name: CBPingFang_SC_Bold, size: 16*KFitHeightRate) as Any]
            navigationController.navigationBar.titleTextAttributes = dict as? [NSAttributedString.Key : AnyObject]
        }
    }
    //MARK: - 相机授权
    public class func checkCameraPermission(resultBlock:@escaping((_ isAllow:Bool) -> Void)) -> Bool  {
        let alertTitleStr = "相机权限未开启".localizedStr
        let alertMessageStr = "相机权限未开启,请进入系统【设置】>【隐私】>【相机】中打开开关,开启相机功能".localizedStr
        var grant:Bool = false
        if #available(iOS 7.0, *) {
            /* 系统高于7.0*/
            let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            /* .notDetermined  .authorized  .restricted  .denied*/
            if authStatus == .notDetermined {
                grant = false
                // 第一次触发授权 alert
                AVCaptureDevice.requestAccess(for: .video) { (granted:Bool) in
//                    grant = granted
//                    resultBlock(grant)
                    DispatchQueue.global().async {
                        DispatchQueue.main.async(execute: {
                            grant = granted
                            resultBlock(grant)
                        })
                    }
                }
            } else if authStatus == .authorized {
                grant = true
            } else if authStatus == .restricted {
                grant = false
                self.showPermissionAlert(title: alertTitleStr,message: alertMessageStr)
            } else if authStatus == .denied {
                grant = false
                self.showPermissionAlert(title: alertTitleStr,message: alertMessageStr)
            }
        }
        return grant
    }
    //MARK: - 麦克风授权
    public class func checkMicrophonePermission(resultBlock:@escaping((_ isAllow:Bool) -> Void)) -> Bool {
        let alertTitleStr = "麦克风权限未开启".localizedStr
        let alertMessageStr = "麦克风权限未开启,请进入系统【设置】>【隐私】>【麦克风】中打开开关,开启麦克风功能".localizedStr
        var grant:Bool = false
        if #available(iOS 7.0, *) {
            /* 系统高于7.0*/
            let recordingSession = AVAudioSession.sharedInstance()
            /* .granted  .undetermined  .denied */
            switch recordingSession.recordPermission {
            case .granted:
                /* 已授权*/
                grant = true
                break
            case .undetermined:
                grant = false
                /* 请求授权*/
                recordingSession.requestRecordPermission { (isAllow) in
                    DispatchQueue.main.async {
                        grant = isAllow
                        resultBlock(grant)
                    }
                }
                break
            case .denied:
                grant = false
                /* 拒绝授权授权*/
                self.showPermissionAlert(title: alertTitleStr, message: alertMessageStr)
                break
            default:
                break
            }
        }
        return grant
    }
    private class func showPermissionAlert (title:String,message:String) {
        // 授权提醒
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let actionConfirm = UIAlertAction.init(title: "去设置".localizedStr, style: .default) { (action:UIAlertAction) in
            UIApplication.shared.openURL(NSURL.init(string: UIApplication.openSettingsURLString)! as URL)
        }
        let actionCancel = UIAlertAction.init(title: "取消".localizedStr, style: .cancel) { (action:UIAlertAction) in
        }
        alertVC.addAction(actionConfirm)
        alertVC.addAction(actionCancel)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
    }
    //MARK: - 求两数之间的随机数
    //它需要一个随机数，找到该数字的余数 除以两个参数之间的差值，然后加上较小的数字。这保证了随机数在两个数字之间。
    class func randomBetween(firstNum:CGFloat,secondNum:CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX)*abs(firstNum - secondNum) + min(firstNum,secondNum)
    }
    //MARK: - 获取窗口
    class func getWindow() -> UIView {
        return UIApplication.shared.keyWindow ?? UIView()
    }
    //MARK: - 获取当前控制器
    class func getCurrentVC() -> UIViewController {
        let rootVC = UIApplication.shared.keyWindow?.rootViewController ?? UIViewController.init()
        let currentVC = self.getCurrentVCFrom(rootVC: rootVC)
        return currentVC
    }
    class func getCurrentVCFrom(rootVC:UIViewController) -> UIViewController {
        var currentVC = UIViewController.init()
        if (rootVC .presentedViewController != nil) {
            /* 视图是被presented出来的*/
            currentVC = rootVC.presentedViewController!
        }
        if rootVC is UITabBarController {
            /* 根视图为UITabBarController*/
            let tabBarBC = rootVC as! UITabBarController
            currentVC = self.getCurrentVCFrom(rootVC: tabBarBC.selectedViewController ?? UIViewController.init())
        } else if rootVC is UINavigationController {
            let navVC = rootVC as! UINavigationController
            currentVC = self.getCurrentVCFrom(rootVC: navVC.visibleViewController ?? UIViewController.init())
        } else {
            currentVC = rootVC
        }
        return currentVC
    }
    //MARK: - JSONString转换为字典
    class func getDictionaryFromJSONString(jsonString:String) -> NSDictionary {
        let jsonData:Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    //MARK: - JSONString转换为数组
    class func getArrayFromJSONString(jsonString:String) -> NSArray {
        let jsonData:Data = jsonString.data(using: .utf8)!
        let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if array != nil {
            return array as! NSArray
        }
        return array as! NSArray
    }
    //MARK: - 字典转换为JSONString
    class func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            CBLog(message: "无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData?
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
    //MARK: - 数组转换为JSONString
    class func getJSONStringFromArray(array:NSArray) -> String {
        if (!JSONSerialization.isValidJSONObject(array)) {
            CBLog(message: "无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: array, options: []) as NSData?
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
    //MARK: - 获取沙盒Caches的文件目录
    class func cachesDirectory() -> String {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last ?? ""
    }
    //MARK: - 获取缓存大小
    class func getCacheSize() -> String {
        //cache文件夹
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        //文件夹下所有文件
        let files = FileManager.default.subpaths(atPath: cachePath!)!
        //遍历计算大小
        var size = 0
        for file in files {
            //文件名拼接到路径中
            let path = cachePath! + "/\(file)"
            //取出文件属性
            do {
                let floder = try FileManager.default.attributesOfItem(atPath: path)
                for (key, fileSize) in floder {
                    //累加
                    if key == FileAttributeKey.size {
                        size += (fileSize as AnyObject).integerValue
                    }
                }
            } catch {
                print("出错了！")
            }
        }
        let totalSize = Double(size) / 1024.0 / 1024.0
        return String(format: "%.1fM", totalSize)
    }
    //MARK: - 删除缓存
    //func clearCache(completeBtnBlock:(() -> Void)?) {
    class func clearCache() {
        //MBProgressHUDSwift.showLoading()
        //cache文件夹
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        //文件夹下所有文件
        let files = FileManager.default.subpaths(atPath: cachePath!)!
        //遍历删除
        for file in files {
            //文件名
            let path = cachePath! + "/\(file)"
            //存在就删除
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                    print("出错了！")
                }
            }
        }
        //MBProgressHUDSwift.dismiss()
        //cacheSize = getCacheSize()
        
        //获取图片缓存大小
        //let sdCacheSize = SDImageCache.shared().getSize()
         //清理缓存
        SDImageCache.shared().clearDisk {
        }
    }
    
    class func convertImageToBase64(_ imageStr:String) -> String {
       let imageOrigin = UIImage.init(named: imageStr)
        if let image = imageOrigin {
            let dataTmp = image.pngData()
            if let data = dataTmp {
                let imageStrTT = data.base64EncodedString()
                return imageStrTT
            }
        }
        return ""
    }
    //Base64转UIImage
    class func getStrFromImage(_ imageStr:String) -> UIImage? {
         if let data:NSData = NSData(base64Encoded:imageStr, options:NSData.Base64DecodingOptions.ignoreUnknownCharacters)
         {
             if let image: UIImage = UIImage(data: data as Data)
             {
                 return image
             }
         }
         return nil
     }
}
//value 是AnyObject类型是因为有可能所传的值不是String类型，有可能是其他任意的类型。
func CBIsEmpty(value: AnyObject?) -> Bool {
//func CBIsEmpty(value:String) -> Bool {
    //首先判断是否为nil
    if value == nil {
        ///对象是nil，直接认为是空串
        return true
    } else {
        ///然后是否可以转化为String
        if let myValue  = value as? String {
            //然后对String做判断
            return myValue == "" || myValue == "(null)" || myValue.count == 0 || myValue == "null"
        } else {
            ///字符串都不是，直接认为是空串
            return true
        }
    }
}
