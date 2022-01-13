//
//  CBPetMsgCterViewModel.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/4.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

enum CBPetMsgUpdType:String {
    /* 获取消息列表主页*/
    case getMainMsg = "getMainMsg"
    /* 系统消息 */
    case getSystemMsg  = "getSystemMsg"
    /* 围栏动态 */
    case getFenceDynamic = "getFenceDynamic"
    /* 听听记录 */
    case getListenRcd = "getListenRcd"
    /* 电量动态 */
    case getPowerDynamic = "getPowerDynamic"
    /* 获取定位记录 */
    case getLocateRcdList = "getLocateRcdList"
}
class CBPetMsgCterViewModel: CBPetBaseViewModel {
    
    var msgModel:CBPetMsgCterModel?
    
    
    /* 点击cell缩展block*/
    var showMoreClickBlock:((_ model:CBPetMsgCterModel) -> Void)?
    
    
    //MARK: - 数据源刷新
    var updateDataBlock:((_ type:CBPetMsgUpdType,_ objc:Any) -> Void)?
    
    
    /* 获取消息列表主页未读记录和最新动态回调刷新UI block*/
    var getNewestMessageUpdateUIBlock:((_ model:[CBPetMsgCterModel]) -> Void)?
    
    /* 系统消息回调刷新UI block*/
    var systemMsgUpdateUIBlock:((_ model:[CBPetMsgCterModel]) -> Void)?
    /* 处理系统消息 block*/
    var dealWithSystemMsgBlock:((_ state:String,_ messageId:String) -> Void)?
    
    /* 围栏动态回调刷新UI block*/
    var fenceDynamicUpdateUIBlock:((_ model:[CBPetMsgCterFenceDynamicModel]) -> Void)?
    /* 听听记录回调刷新UI block*/
    var listenRcdUpdateUIBlock:((_ model:[CBPetMsgCterModel]) -> Void)?
    /* 听听记录播放录音刷新UI block*/
    var listenRcdPlayUIBlock:((_ model:CBPetMsgCterModel) -> Void)?
    /* 电量动态回调刷新UI block*/
    var powerDynamicUpdateUIBlock:((_ model:[CBPetMsgCterModel]) -> Void)?
    
    
    
    /* 获取定位记录回调刷新UI block*/
    var getLocateRcdListUpdateUIBlock:((_ dataSource:[CBPetMsgCterModel]) -> Void)?
}
