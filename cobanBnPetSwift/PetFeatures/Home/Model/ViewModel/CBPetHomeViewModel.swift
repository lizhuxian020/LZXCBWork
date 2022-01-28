//
//  CBPetHomeViewModel.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/24.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

enum CBPetHomeViewModelClickType:Error {
    case clickTypeClose        //关闭提示
    case clickTypeBind         //绑定
    case clickTypeLoginOut     //退出登录
}
enum CBPetCommandCmdType:String {
    /* 单次定位*/
    case singleLocate = "138"
    /* 喊话,录音*/
    case shoutOrRecording  = "222"
    /* 听听*/
    case lsiten = "169"
    /* 播放*/
    case playRecording = "220"
    /* 删除指定录音*/
    case deleteRecording = "223"
    /* 设置惩罚时间*/
    case setPunishment = "133"
    /* 发起/结束惩罚*/
    case punishing = "137"
    /* 设置圆形围栏*/
    case setFence = "152"
}
enum CBPetCommandType:String {
    /* 单次定位*/
    case singleLocate = "0x8A"
    /* 喊话,录音*/
    case shoutOrRecording  = "0xDE"
    /* 听听*/
    case lsiten = "0XA9"
    /* 播放*/
    case playRecording = "0XDC"
    /* 删除指定录音*/
    case deleteRecording = "0XDF"
    /* 设置惩罚*/
    case setPunishment = "0x85"
    /* 发起/结束惩罚*/
    case punishing = "0x89"
    /* 设置圆形围栏*/
    case setFence = "0x98"
}
enum CBPetHomeUpdDataType:String {
    /* 首页信息*/
    case homeInfo = "homeInfo"
    /* 参数设置*/
    case paramters  = "paramters"
    /* 设备列表*/
    case deviceList = "deviceList"
    /* 听听*/
    case lsiten = "lsiten"
    /* 设置惩罚*/
    case setPunishment = "setPunishment"
    /* 单次定位*/
    case singleLocate = "singleLocate"
    /* 设置圆形围栏*/
    case setFence = "setFence"
    /* 挂失*/
    case callPosition = "callPosition"
}
class CBPetHomeViewModel: CBPetBaseViewModel {
    
    //MARK: - 数据模型
    /* 首页信息model*/
    public var homeInfoModel:CBPetHomeInfoModel?
    /* 参数model*/
    public var paramtersObject:CBPetHomeParamtersModel?
    /* 设备列表*/
    public var deviceList : [CBPetPsnalCterPetModel]?
    /* 是否能发起惩罚*/
//    lazy var isPunish:Bool = {
//        let sss:Bool = true
//        return sss
//    }()
    public var isPunish:Bool?
    
    //MARK: - 数据源刷新
    //typealias updateHomeDataBlock = (_ objc:Any) -> Void
    var updateDataBlock:((_ type:CBPetHomeUpdDataType,_ objc:Any) -> Void)?
    
    
    /* 未曾绑定过设备、被拒绝或已发送绑定请求，绑定设备 block*/
    var bindDeviceBlock:((_ type:CBPetHomeViewModelClickType) -> Void)?
    var bindDeviceUpdateDataBlock:(() -> Void)?
    
    
    //MARK: - 导航栏titleView 事件处理
    /* 导航栏 titleView 更新导航栏 事件block*/
    var avtarTitleViewSwitchDeviceBlock:(() -> Void)?
    var avatarTitleViewUpdateUIBlock:((_ isShowHomeTitle:Bool,_ title:String,_ avatarImage:UIImage) -> Void)?
    
    
    //MARK: - 功能弹窗事件处理
    /* 功能view缩展*/
    var functionViewBlock:((_ isShow:Bool,_ title:String) -> Void)?
    /* 去录音block*/
    var toRecordBlock:(() -> Void)?

    /* 选择回家录音操作block，（获取，添加，选择,删除,播放录音）*/
    var petHomeGoHomeRecordBlock:((_ type:String,_ objc:Any) -> Void)?
    
    /* 选择时区操作block，*/
    var petHomeSetTimeZoneBlock:((_ objc:Any) -> Void)?
    
    /* 控制面板点击block*/
    var ctrlPanelClickBlock:((_ objc:Any,_ isSwitch:Bool,_ status:Bool) -> Void)?
    
    
    /* 设置虚拟电子围栏操作block，（开关，修改围栏）*/
    var petHomeSetFenceBlock:((_ type:String,_ objc:Any) -> Void)?
    
    /* paoView的围栏开关*/
    var paoViewFenceSwitch : UISwitch?
}
extension CBPetHomeViewModel {
    //MARK: - 获取首页信息request
    func getHomeInfoRequest(_ finishBLK: (()->Void)? = nil) {
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters = ["uid":value.valueStr]
        }
        CBPetNetworkingManager.share.getHomeInfoDataRequest(paramters: paramters,successBlock: { [weak self] (successModel) in
            ///返回错误信息
            guard successModel.status == "0" else {
                guard self?.updateDataBlock == nil else {
                    self?.updateDataBlock!(.homeInfo, successModel)
                    return
                }
                return;
            }
            let json = JSON.init(successModel.data as Any)
            self?.homeInfoModel = CBPetHomeInfoModel.deserialize(from: json.dictionaryObject) ?? CBPetHomeInfoModel.init()
            ///首页设备信息本地存储
            if let value = self?.homeInfoModel {
                CBPetHomeInfoTool.saveHomeInfo(homeInfoModel: value)
            }
            if let blk = finishBLK {
                blk()
            }
            guard self?.updateDataBlock == nil else {
                self?.updateDataBlock!(.homeInfo, successModel)
                return
            }
        }, failureBlock: { [weak self] (failureModel) in
            if self?.updateDataBlock != nil {
                self?.updateDataBlock!(.homeInfo, failureModel)
            }
            if let blk = finishBLK {
                blk()
            }
        })
    }
    //MARK: - 获取用户信息request
    func getUserInfoRequest() {
        guard CBPetLoginModelTool.getUser()?.uid != nil else {
            return
        }
        let userInfo = CBPetLoginModelTool.getUser()
        CBPetNetworkingManager.share.getUserInfoByUserIdRequest(userId: userInfo?.uid ?? "", successBlock: { (successModel) in
            /* 返回错误信息*/
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                return;
            }
            let ddJson = JSON.init(successModel.data as Any)
            let userInfoModelObject = CBPetUserInfoModel.deserialize(from: ddJson.dictionaryObject)
            CBPetUserInfoModelTool.saveUserInfo(userInfoModel: userInfoModelObject ?? CBPetUserInfoModel())
        }) { (failureModel) in
        }
    }
    //MARK: - 切换设备请求request
    func switchDeviceRequest(imeiStr:String, _ finishBlk : (()->Void)? = nil) {
        var paramters:Dictionary<String,Any> = ["uid":"","imei":""]
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters.updateValue(value.valueStr, forKey: "uid")
        }
        paramters.updateValue(imeiStr.valueStr, forKey: "imei")
        
        MBProgressHUD.showAdded(to: CBPetUtils.getWindow(), animated: true)
        CBPetNetworkingManager.share.switchDeviceRequest(paramters: paramters,successBlock: { [weak self] (successModel) in
            ///返回错误信息
            if successModel.status != "0" {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
            }
            self?.getHomeInfoRequest({[weak self] in
                self?.getDeviceParamtersRequest({[weak self] in
                    self?.getDeviceList({
                        MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
                        finishBlk?()
                    })
                })
            })
        }, failureBlock: { (failureModel) in
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
        })
    }
    //MARK: - 根据设备编号获取设备设置的参数request
    func getDeviceParamtersRequest(_ finishBLK: (()->Void)? = nil) {
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
            paramters["imei"] = value.valueStr
        }
        CBPetNetworkingManager.share.getParamtersByIMEIRequest(paramters: paramters,successBlock: { [weak self] (successModel) in
            let ddJson = JSON.init(successModel.data as Any)
            self?.paramtersObject = CBPetHomeParamtersModel.deserialize(from: ddJson.dictionaryObject)
            CBPetHomeParamtersModel.saveHomeParamters(homeInfoModel: self?.paramtersObject ?? CBPetHomeParamtersModel())
            guard self?.updateDataBlock == nil else {
                self?.updateDataBlock!(.paramters, self?.paramtersObject as Any)
                if let blk = finishBLK {
                    blk()
                }
                /* 更新各项参数后 刷新首页数据*/
                //lzxPS: 感觉没必要更新首页
//                self?.getHomeInfoRequest()
                return
            }
            ///返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                return;
            }
        }, failureBlock: { (failureModel) in
            if let blk = finishBLK {
                blk()
            }
        })
    }
    //MARK: - 获取设备列表以显示到地图上
    func getDeviceList(_ finishBlk : (()->Void)? = nil) {
        guard let uid = CBPetLoginModelTool.getUser()?.uid else {
            return
        }
        CBPetNetworkingManager.share.getAllDeviceRequest(paramters: ["uid":uid]) { [weak self] successModel in
            /* 返回错误信息*/
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                return;
            }
            let ddJson = JSON.init(successModel.data as Any)
            let petListModelObject = JSONDeserializer<CBPetPsnalCterPetAllModel>.deserializeFrom(dict: ddJson.dictionaryObject)
            if let value = petListModelObject?.allPet {
                self?.deviceList = value
                self?.updateDataBlock!(.deviceList, value)
            }
            if finishBlk != nil {
                finishBlk!()
            }
        } failureBlock: { failModel in
            if finishBlk != nil {
                finishBlk!()
            }
        }

    }
    //MARK: - 喊话上传语音文件到七牛云request
    func shoutUploadVoiceToQiniuRequest(msgFile:String) {
        guard msgFile.isEmpty == false else {
            return
        }
        if self.qnyToken == nil || self.qnyToken?.isEmpty == true {
            return
        }
        let voiceData = NSData(contentsOfFile: msgFile) ?? NSData()
        CBPetNetworkingManager.share.uploadVoiceToQNFileRequest(fileData: voiceData, token: self.qnyToken!, successBlock: { [weak self] (successDic:Dictionary) in
            let key = successDic["key"] as! String
            let voiceUrl = "http://cdn.clw.gpstrackerxy.com/" + key
            
            var paramters:Dictionary<String,Any> = Dictionary()
            if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
                paramters["imei"] = value.valueStr
            }
            //paramters["imei"] = "868683026467798"
            if let value = CBPetLoginModelTool.getUser()?.uid {
                paramters["uid"] = value.valueStr
            }
            
            var paramtersBody:Dictionary<String,Any> = Dictionary()
            paramtersBody["cmd"] = CBPetCommandCmdType.shoutOrRecording.rawValue
            paramtersBody["type"] = CBPetCommandType.shoutOrRecording.rawValue
            let jsonDic:Dictionary<String,Any> = ["voicePath":voiceUrl,"voiceType":"0"]
            paramtersBody["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: jsonDic as NSDictionary)
        
            paramters["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: paramtersBody as NSDictionary)
            
            self?.shoutCommandRequest(paramters:paramters)
            
        }) { (failureDic:Dictionary) in
            MBProgressHUD.showMessage(Msg: "上传语音失败".localizedStr, Deleay: 1.5)
        }
    }
    //MARK: - 喊话上传语音文件到后台request
    func shoutCommandRequest(paramters:Dictionary<AnyHashable, Any>) {
        MBProgressHUD.showAdded(to: CBPetUtils.getWindow(), animated: true)
         CBPetNetworkingManager.share.commandRequest(paramters: paramters as! Dictionary<String, Any>, successBlock: { (successModel) in
             MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
             //返回错误信息
             guard successModel.status == "0" else {
                if successModel.rescode == "0024" {
                    MBProgressHUD.showMessage(Msg: "设备已离线".localizedStr, Deleay: 1.5)
                }  else if successModel.rescode == "0029" {
                    MBProgressHUD.showMessage(Msg: "下发指令超时".localizedStr, Deleay: 1.5)
                }
                 return;
             }
         }) { (failureModel) in
             MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
         }
    }
    //MARK: - 设置听听语音时长request
    func setListenTimeCommandRequest(timeStr:String) {
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
            paramters["imei"] = value.valueStr
        }
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters["uid"] = value.valueStr
        }
        var paramtersBody:Dictionary<String,Any> = Dictionary()
        paramtersBody["cmd"] = CBPetCommandCmdType.lsiten.rawValue
        paramtersBody["type"] = CBPetCommandType.lsiten.rawValue
        let jsonDic:Dictionary<String,Any> = ["action":"1","time":timeStr]
        paramtersBody["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: jsonDic as NSDictionary)
    
        paramters["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: paramtersBody as NSDictionary)
        
        MBProgressHUD.showAdded(to: CBPetUtils.getWindow(), animated: true)
        CBPetNetworkingManager.share.commandRequest(paramters: paramters , successBlock: { [weak self] (successModel) in
             MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
             //返回错误信息
             guard successModel.status == "0" else {
                if successModel.rescode == "0024" {
                    MBProgressHUD.showMessage(Msg: "设备已离线".localizedStr, Deleay: 1.5)
                }  else if successModel.rescode == "0029" {
                    MBProgressHUD.showMessage(Msg: "下发指令超时".localizedStr, Deleay: 1.5)
                }
                guard self?.updateDataBlock == nil else {
                    self?.updateDataBlock!(.lsiten, "听听回调".localizedStr)
                    return
                }
                 return;
             }
            guard self?.updateDataBlock == nil else {
                self?.updateDataBlock!(.lsiten, "听听回调".localizedStr)
                return
            }
         }) { [weak self] (failureModel) in
             MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
            guard self?.updateDataBlock == nil else {
                self?.updateDataBlock!(.lsiten, "听听回调".localizedStr)
                return
            }
         }
    }
    //MARK: - 发送回家指令request
    func sendGoHomeCommandRequest(voiceId:String) {
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
            paramters["imei"] = value.valueStr
        }
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters["uid"] = value.valueStr
        }
        var paramtersBody:Dictionary<String,Any> = Dictionary()
        paramtersBody["cmd"] = CBPetCommandCmdType.playRecording.rawValue
        paramtersBody["type"] = CBPetCommandType.playRecording.rawValue
        let jsonDic:Dictionary<String,Any> = ["playIds":voiceId]
        paramtersBody["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: jsonDic as NSDictionary)
    
        paramters["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: paramtersBody as NSDictionary)
        
        MBProgressHUD.showAdded(to: CBPetUtils.getWindow(), animated: true)
        CBPetNetworkingManager.share.commandRequest(paramters: paramters , successBlock: { (successModel) in
             MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
             //返回错误信息
             guard successModel.status == "0" else {
                if successModel.rescode == "0024" {
                    MBProgressHUD.showMessage(Msg: "设备已离线".localizedStr, Deleay: 1.5)
                }  else if successModel.rescode == "0029" {
                    MBProgressHUD.showMessage(Msg: "下发指令超时".localizedStr, Deleay: 1.5)
                }
                 return;
             }
         }) { (failureModel) in
             MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
         }
    }
    //MARK: - 设置惩罚时间指令request
    func setPunishmentTimeCommandRequest(time:String) {
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
            paramters["imei"] = value.valueStr
        }
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters["uid"] = value.valueStr
        }
        var paramtersBody:Dictionary<String,Any> = Dictionary()
        paramtersBody["cmd"] = CBPetCommandCmdType.setPunishment.rawValue
        paramtersBody["type"] = CBPetCommandType.setPunishment.rawValue
        let jsonDic:Dictionary<String,Any> = ["shockTime":time]
        paramtersBody["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: jsonDic as NSDictionary)
    
        paramters["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: paramtersBody as NSDictionary)
        
        MBProgressHUD.showAdded(to: CBPetUtils.getWindow(), animated: true)
        CBPetNetworkingManager.share.commandRequest(paramters: paramters , successBlock: { [weak self] (successModel) in
             MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
             //返回错误信息
             guard successModel.status == "0" else {
                if successModel.rescode == "0024" {
                    MBProgressHUD.showMessage(Msg: "设备已离线".localizedStr, Deleay: 1.5)
                }  else if successModel.rescode == "0029" {
                    MBProgressHUD.showMessage(Msg: "下发指令超时".localizedStr, Deleay: 1.5)
                }
                guard self?.updateDataBlock == nil else {
                    self?.updateDataBlock!(.setPunishment,"设置惩罚时长".localizedStr)
                    return
                }
                 return;
             }
            guard self?.updateDataBlock == nil else {
                self?.updateDataBlock!(.setPunishment,"设置惩罚时长".localizedStr)
                return
            }
         }) { [weak self] (failureModel) in
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
            guard self?.updateDataBlock == nil else {
                self?.updateDataBlock!(.setPunishment,"设置惩罚时长".localizedStr)
                return
            }
         }
    }
    //MARK: - 发起惩罚指令request
    func initiatePunishmentCommandRequest(electric_pet:NSInteger) {
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
            paramters["imei"] = value.valueStr
        }
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters["uid"] = value.valueStr
        }
        var paramtersBody:Dictionary<String,Any> = Dictionary()
        paramtersBody["cmd"] = CBPetCommandCmdType.punishing.rawValue
        paramtersBody["type"] = CBPetCommandType.punishing.rawValue
        let jsonDic:Dictionary<String,Any> = ["electric_pet":NSNumber.init(value: electric_pet)]
        paramtersBody["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: jsonDic as NSDictionary)
    
        paramters["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: paramtersBody as NSDictionary)
        
        MBProgressHUD.showAdded(to: CBPetUtils.getWindow(), animated: true)
        CBPetNetworkingManager.share.commandRequest(paramters: paramters , successBlock: { (successModel) in
             MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
             //返回错误信息
             guard successModel.status == "0" else {
                if successModel.rescode == "0024" {
                    MBProgressHUD.showMessage(Msg: "设备已离线".localizedStr, Deleay: 1.5)
                }  else if successModel.rescode == "0029" {
                    MBProgressHUD.showMessage(Msg: "下发指令超时".localizedStr, Deleay: 1.5)
                }
                 return;
             }
            if (electric_pet == 1) { // 发起惩罚，三分钟后再试
                self.isPunish = false
                /* 三分钟后再试*/
                Timer.scheduledTimer(timeInterval: 180, target: self, selector: #selector(self.timerPunish), userInfo: nil, repeats: false)
            }
         }) { (failureModel) in
             MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
         }
    }
    @objc private func timerPunish() {
        self.isPunish = true
        //CBLog(message: "惩罚 定时器 惩罚 定时器惩罚 定时器惩罚 定时器惩罚 定时器惩罚 定时器惩罚 定时器")
    }
    //MARK: - 单次定位指令request
    func singleLocateCommandRequest() {
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
            paramters["imei"] = value.valueStr
        }
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters["uid"] = value.valueStr
        }
        var paramtersBody:Dictionary<String,Any> = Dictionary()
        paramtersBody["cmd"] = CBPetCommandCmdType.singleLocate.rawValue
        paramtersBody["type"] = CBPetCommandType.singleLocate.rawValue
        let jsonDic:Dictionary<String,Any> = Dictionary()
        paramtersBody["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: jsonDic as NSDictionary)
    
        paramters["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: paramtersBody as NSDictionary)
        
        MBProgressHUD.showAdded(to: CBPetUtils.getWindow(), animated: true)
        CBPetNetworkingManager.share.commandRequest(paramters: paramters , successBlock: { [weak self] (successModel) in
             MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
             //返回错误信息
             guard successModel.status == "0" else {
                if successModel.rescode == "0024" {
                    MBProgressHUD.showMessage(Msg: "设备已离线".localizedStr, Deleay: 1.5)
                }  else if successModel.rescode == "0029" {
                    MBProgressHUD.showMessage(Msg: "下发指令超时".localizedStr, Deleay: 1.5)
                }
                guard self?.updateDataBlock == nil else {
                    self?.updateDataBlock!(.singleLocate,"单次定位".localizedStr)
                    return
                }
                 return;
             }
            guard self?.updateDataBlock == nil else {
                self?.updateDataBlock!(.singleLocate,"单次定位".localizedStr)
                return
            }
         }) { [weak self] (failureModel) in
             MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
            guard self?.updateDataBlock == nil else {
                self?.updateDataBlock!(.singleLocate,"单次定位".localizedStr)
                return
            }
         }
    }
    //MARK: - 电子围栏开关指令request
    func setFenceStatusCommandRequest(status:String) {
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
            paramters["imei"] = value.valueStr
        }
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters["uid"] = value.valueStr
        }
        var paramtersBody:Dictionary<String,Any> = Dictionary()
        paramtersBody["cmd"] = CBPetCommandCmdType.setPunishment.rawValue
        paramtersBody["type"] = CBPetCommandType.setPunishment.rawValue
        let jsonDic:Dictionary<String,Any> = ["fenceSwitch":status]
        paramtersBody["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: jsonDic as NSDictionary)
    
        paramters["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: paramtersBody as NSDictionary)
        
        MBProgressHUD.showAdded(to: CBPetUtils.getWindow(), animated: true)
        CBPetNetworkingManager.share.commandRequest(paramters: paramters , successBlock: { [weak self] (successModel) in
             MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
             //返回错误信息
             if successModel.status != "0" {
                if successModel.rescode == "0024" {
                    MBProgressHUD.showMessage(Msg: "设备已离线".localizedStr, Deleay: 1.5)
                }  else if successModel.rescode == "0029" {
                    MBProgressHUD.showMessage(Msg: "下发指令超时".localizedStr, Deleay: 1.5)
                }
                 if let s = self?.paoViewFenceSwitch {
                     s.setOn(self?.paramtersObject?.fenceSwitch == "1", animated: true)
                 }
             }
            if self?.updateDataBlock != nil {
                self?.updateDataBlock!(.setFence,"电子围栏开启".localizedStr)
                return
            }
         }) { [weak self] (failureModel) in
             MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
            guard self?.updateDataBlock == nil else {
                self?.updateDataBlock!(.setFence,"电子围栏开启".localizedStr)
                return
            }
         }
    }
    //MARK: - 挂失开启指令request
    func setCallPosiActionStatusCommandRequest(status:String, _ finishBlk : (()->Void)? = nil) {
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
            paramters["imei"] = value.valueStr
        }
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters["uid"] = value.valueStr
        }
        var paramtersBody:Dictionary<String,Any> = Dictionary()
        paramtersBody["cmd"] = CBPetCommandCmdType.setPunishment.rawValue
        paramtersBody["type"] = CBPetCommandType.setPunishment.rawValue
        let jsonDic:Dictionary<String,Any> = ["callPosiAction":status]
        paramtersBody["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: jsonDic as NSDictionary)
    
        paramters["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: paramtersBody as NSDictionary)
        
        MBProgressHUD.showAdded(to: CBPetUtils.getWindow(), animated: true)
        CBPetNetworkingManager.share.commandRequest(paramters: paramters , successBlock: { [weak self] (successModel) in
             MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
             //返回错误信息
             if successModel.status != "0" {
                if successModel.rescode == "0024" {
                    MBProgressHUD.showMessage(Msg: "设备已离线".localizedStr, Deleay: 1.5)
                }  else if successModel.rescode == "0029" {
                    MBProgressHUD.showMessage(Msg: "下发指令超时".localizedStr, Deleay: 1.5)
                }
             }
            if self?.updateDataBlock == nil  {
                return
            }
            self?.updateDataBlock!(.callPosition,"挂失开启".localizedStr)
            if finishBlk != nil {
                finishBlk!()
            }
         }) { [weak self] (failureModel) in
             MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
            guard self?.updateDataBlock == nil else {
                self?.updateDataBlock!(.callPosition,"挂失开启".localizedStr)
                return
            }
         }
    }
    //MARK: - 定时报告开关指令request
    func setTimeReportStatusCommandRequest(status:String, _ finishBlk : (()->Void)? = nil) {
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
            paramters["imei"] = value.valueStr
        }
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters["uid"] = value.valueStr
        }
        var paramtersBody:Dictionary<String,Any> = Dictionary()
        paramtersBody["cmd"] = 133
        paramtersBody["type"] = CBPetCommandType.setPunishment.rawValue
        let jsonDic:Dictionary<String,Any> = ["timingSwitch":Int(status) ?? 0]
        paramtersBody["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: jsonDic as NSDictionary)
    
        paramters["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: paramtersBody as NSDictionary)
        
        MBProgressHUD.showAdded(to: CBPetUtils.getWindow(), animated: true)
        CBPetNetworkingManager.share.commandRequest(paramters: paramters , successBlock: { [weak self] (successModel) in
             MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
             //返回错误信息
             if successModel.status != "0" {
                if successModel.rescode == "0024" {
                    MBProgressHUD.showMessage(Msg: "设备已离线".localizedStr, Deleay: 1.5)
                }  else if successModel.rescode == "0029" {
                    MBProgressHUD.showMessage(Msg: "下发指令超时".localizedStr, Deleay: 1.5)
                }
             }
            if self?.updateDataBlock == nil {
                return
            }
            self?.updateDataBlock!(.callPosition,"挂失开启".localizedStr)
            if finishBlk != nil {
                finishBlk!()
            }
         }) { [weak self] (failureModel) in
             MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
            guard self?.updateDataBlock == nil else {
                self?.updateDataBlock!(.callPosition,"挂失开启".localizedStr)
                return
            }
         }
    }
    //MARK: - 获取录音列表request
    public func getRecordListReuqest() {
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
            paramters["imei"] = value.valueStr
        }
        CBPetNetworkingManager.share.getRecordingListRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            //返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                guard self?.petHomeGoHomeRecordBlock == nil else {
                    self?.petHomeGoHomeRecordBlock!("get",[CBPetHomeRcdListModel]())
                    return
                }
                return;
            }
            let ddJson = JSON.init(successModel.data as Any)
            let rcdListModelObject = JSONDeserializer<CBPetHomeRcdListModel>.deserializeModelArrayFrom(array: ddJson.arrayObject)
            guard self?.petHomeGoHomeRecordBlock == nil else {
                self?.petHomeGoHomeRecordBlock!("get",rcdListModelObject as? [CBPetHomeRcdListModel] ?? [CBPetHomeRcdListModel]())
                return
            }
        }) { [weak self] (failureModel) in
            guard self?.petHomeGoHomeRecordBlock == nil else {
                self?.petHomeGoHomeRecordBlock!("get",[CBPetHomeRcdListModel]())
                return
            }
        }
    }
    //MARK: - 添加回家指令录音语音文件到七牛云request
    func goHomeRcdUploadVoiceToQiniuRequest(msgFile:String) {
        guard msgFile.isEmpty == false else {
            return
        }
        if self.qnyToken == nil || self.qnyToken?.isEmpty == true {
            return
        }
        let voiceData = NSData(contentsOfFile: msgFile) ?? NSData()
        CBPetNetworkingManager.share.uploadVoiceToQNFileRequest(fileData: voiceData, token: self.qnyToken!, successBlock: { [weak self] (successDic:Dictionary) in
            let key = successDic["key"] as! String
            let voiceUrl = "http://cdn.clw.gpstrackerxy.com/" + key
            
            var paramters:Dictionary<String,Any> = Dictionary()
            if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
                paramters["imei"] = value.valueStr
            }
            //paramters["imei"] = "868683026467798"
            if let value = CBPetLoginModelTool.getUser()?.uid {
                paramters["uid"] = value.valueStr
            }
            
            var paramtersBody:Dictionary<String,Any> = Dictionary()
            paramtersBody["cmd"] = CBPetCommandCmdType.shoutOrRecording.rawValue
            paramtersBody["type"] = CBPetCommandType.shoutOrRecording.rawValue
            let jsonDic:Dictionary<String,Any> = ["voicePath":voiceUrl,"voiceType":"1"]
            paramtersBody["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: jsonDic as NSDictionary)
        
            paramters["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: paramtersBody as NSDictionary)
            
            self?.goHomeRcdCommandRequest(paramters:paramters)
            
        }) { (failureDic:Dictionary) in
            MBProgressHUD.showMessage(Msg: "上传语音失败".localizedStr, Deleay: 1.5)
        }
    }
    //MARK: - 添加回家指令录音语音文件到后台request
    func goHomeRcdCommandRequest(paramters:Dictionary<AnyHashable, Any>) {
        MBProgressHUD.showAdded(to: CBPetUtils.getWindow(), animated: true)
         CBPetNetworkingManager.share.commandRequest(paramters: paramters as! Dictionary<String, Any>, successBlock: { (successModel) in
             MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
             //返回错误信息
             guard successModel.status == "0" else {
                if successModel.rescode == "0024" {
                    MBProgressHUD.showMessage(Msg: "设备已离线".localizedStr, Deleay: 1.5)
                }  else if successModel.rescode == "0029" {
                    MBProgressHUD.showMessage(Msg: "下发指令超时".localizedStr, Deleay: 1.5)
                }
                 return;
             }
            self.getRecordListReuqest()
         }) { (failureModel) in
             MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
         }
    }
    //MARK: - 删除回家指令录音request
    func deleteGoHomeRecordingReuqest(voiceId:String,id:String) {
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
            paramters["imei"] = value.valueStr
        }
        //paramters["imei"] = "868683026467798"
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters["uid"] = value.valueStr
        }
        
        var paramtersBody:Dictionary<String,Any> = Dictionary()
        paramtersBody["cmd"] = CBPetCommandCmdType.deleteRecording.rawValue
        paramtersBody["type"] = CBPetCommandType.deleteRecording.rawValue
        let jsonDic:Dictionary<String,Any> = ["recordingIds":voiceId,"id":NSNumber.init(value: Int(id) ?? 0)]
        paramtersBody["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: jsonDic as NSDictionary)
    
        paramters["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: paramtersBody as NSDictionary)
        
        CBPetNetworkingManager.share.commandRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            //返回错误信息
            guard successModel.status == "0" else {
                if successModel.rescode == "0024" {
                    MBProgressHUD.showMessage(Msg: "设备已离线".localizedStr, Deleay: 1.5)
                }  else if successModel.rescode == "0029" {
                    MBProgressHUD.showMessage(Msg: "下发指令超时".localizedStr, Deleay: 1.5)
                }
                self?.getRecordListReuqest()
                return;
            }
            self?.getRecordListReuqest()
        }) { [weak self] (failureModel) in
            self?.getRecordListReuqest()
        }
    }
    //MARK: - 设置修改围栏指令request
    func updateCircleFenceReuqest(coordDataStrs:String,id:String) {
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
            paramters["imei"] = value.valueStr
        }
        //paramters["imei"] = "868683026467798"
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters["uid"] = value.valueStr
        }
        
        var paramtersBody:Dictionary<String,Any> = Dictionary()
        paramtersBody["cmd"] = CBPetCommandCmdType.setFence.rawValue
        paramtersBody["type"] = CBPetCommandType.setFence.rawValue
        let jsonDic:Dictionary<String,Any> = ["data":coordDataStrs,"warmType":NSNumber.init(value: 1),"id":NSNumber.init(value: Int(id) ?? 0)]
        paramtersBody["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: jsonDic as NSDictionary)
    
        paramters["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: paramtersBody as NSDictionary)
        
        MBProgressHUD.showAdded(to: CBPetUtils.getWindow(), animated: true)
        CBPetNetworkingManager.share.commandRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
            //返回错误信息
            guard successModel.status == "0" else {
                if successModel.rescode == "0024" {
                    MBProgressHUD.showMessage(Msg: "设备已离线".localizedStr, Deleay: 1.5)
                }  else if successModel.rescode == "0029" {
                    MBProgressHUD.showMessage(Msg: "下发指令超时".localizedStr, Deleay: 1.5)
                }
                self?.getHomeInfoRequest()
                return;
            }
            self?.getHomeInfoRequest()
            guard self?.petHomeSetFenceBlock == nil else {
                self?.petHomeSetFenceBlock!("setFenceReload", "")
                return
            }
        }) { [weak self] (failureModel) in
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
            self?.getHomeInfoRequest()
        }
    }
    //MARK: - 设置时区指令request
    func setTimeZoneReuqest(time_zoneStr:String) {
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
            paramters["imei"] = value.valueStr
        }
        //paramters["imei"] = "868683026467798"
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters["uid"] = value.valueStr
        }
        
        var paramtersBody:Dictionary<String,Any> = Dictionary()
        paramtersBody["cmd"] = CBPetCommandCmdType.setPunishment.rawValue
        paramtersBody["type"] = CBPetCommandType.setPunishment.rawValue
        let jsonDic:Dictionary<String,Any> = ["time_zone":time_zoneStr]
        paramtersBody["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: jsonDic as NSDictionary)
    
        paramters["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: paramtersBody as NSDictionary)
        
        MBProgressHUD.showAdded(to: CBPetUtils.getWindow(), animated: true)
        CBPetNetworkingManager.share.commandRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
            //返回错误信息
            guard successModel.status == "0" else {
                if successModel.rescode == "0024" {
                    MBProgressHUD.showMessage(Msg: "设备已离线".localizedStr, Deleay: 1.5)
                }  else if successModel.rescode == "0029" {
                    MBProgressHUD.showMessage(Msg: "下发指令超时".localizedStr, Deleay: 1.5)
                }
                self?.getDeviceParamtersRequest()
                return;
            }
            self?.getDeviceParamtersRequest()
            guard self?.petHomeSetTimeZoneBlock == nil else {
                self?.petHomeSetTimeZoneBlock!("")
                return
            }
        }) { [weak self] (failureModel) in
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
            self?.getDeviceParamtersRequest()
        }
    }
    //MARK: - 选择需要播放的录音request
    func selectDefaultGoHomeRcdingReuqest(voiceId:String) {
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
            paramters["imei"] = value.valueStr
        }
        paramters["voiceId"] = voiceId.valueStr
        MBProgressHUD.showAdded(to: CBPetUtils.getWindow(), animated: true)
        CBPetNetworkingManager.share.selectDefaultGoHomwRcdRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
            //返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                self?.getHomeInfoRequest()
                return;
            }
            self?.getHomeInfoRequest()
            self?.paramtersObject?.fileRecord.id = voiceId
            guard self?.petHomeGoHomeRecordBlock == nil else {
                self?.petHomeGoHomeRecordBlock!("reload","")
                return
            }
        }) { [weak self] (failureModel) in
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
            self?.getHomeInfoRequest()
        }
    }
}
