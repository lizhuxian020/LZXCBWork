//
//  CBPetMsgCterGetAdreManger.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/7/22.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetMsgCterGetAdreManger: NSObject,BMKGeoCodeSearchDelegate {
    
    /// 点击完成按钮的回调
    private var clickComfirmBtnBlock:((_ address:String) -> Void)?
    
    ///单例
    static let share:CBPetMsgCterGetAdreManger = {
        let view = CBPetMsgCterGetAdreManger.init()
        return view
    }()
    public lazy var searcher:BMKGeoCodeSearch = {
        let search = BMKGeoCodeSearch.init()
        return search
    }()
    /// 带标题显示弹框
    public func getAddress(msgCterLocationRcdModel:CBPetMsgCterModel,indexTemp:Int,completeBtnBlock:((_ address:String) -> Void)?) {
        
        self.clickComfirmBtnBlock = completeBtnBlock
        
        guard AppDelegate.shareInstance.IsShowGoogleMap == true else {
            // 显示百度地图
            let reverseGeoCodeOpetion = BMKReverseGeoCodeSearchOption.init()
            reverseGeoCodeOpetion.location = CLLocationCoordinate2DMake(Double(msgCterLocationRcdModel.lat ?? "0")!, Double(msgCterLocationRcdModel.lng ?? "0")!)
            self.searcher.delegate = self
            let flag = self.searcher.reverseGeoCode(reverseGeoCodeOpetion)
            if flag == true {
                CBLog(message: "反geo检索发送成功")
            } else {
                CBLog(message: "反geo检索发送失败")
            }
            return
        }
    }
}
extension CBPetMsgCterGetAdreManger {
    // MARK: - BMKGeoCodeSearchDelegate
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeSearchResult!, errorCode error: BMKSearchErrorCode) {
//        self.timeLb.text = CBPetUtils.convertTimestampToDateStr(timestamp: self.msgCterLocationRcdModel.add_time ?? "", formateStr: "yyyy-MM-dd HH:mm:ss")
//        self.titleLb.text = self.msgCterLocationRcdModel.title
        var address = ""
        if error == BMK_SEARCH_NO_ERROR {
            CBLog(message: "地理反编码:\(result.address ?? "")")
            //self.textLb.text = "您的宠物年年位置在\(result.address ?? "")"
            //updateTextLayout(textStr: "您的宠物年年位置在\(result.address ?? "")")
            address = "您的宠物年年位置在\(result.address ?? "")"
        } else {
            CBLog(message: "未找地理位置")
            //self.textLb.text = "您的宠物年年的位置未知)"
            //updateTextLayout(textStr: "您的宠物年年的位置未知)")
            address = "您的宠物年年的位置未知)"
        }
        if self.clickComfirmBtnBlock != nil {
            self.clickComfirmBtnBlock!(address)
        }
//        self.showBtn_text.isSelected = self.msgCterLocationRcdModel.isShow
//        self.showBtn_image.isSelected = self.msgCterLocationRcdModel.isShow
    }
}
