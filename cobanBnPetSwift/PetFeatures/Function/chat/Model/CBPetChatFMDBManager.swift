//
//  CBPetChatFMDBManager.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/28.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

let CBPET_CHAT_TABLE_GroupChat = "CBPetChatRecordGroupChatData.sqlite"
let CBPET_CHAT_TABLE_SingleChat = "CBPetChatRecordSingleChatData.sqlite"

class CBPetChatFMDBManager: NSObject {
    ///单例
    static let share:CBPetChatFMDBManager = {
        let view = CBPetChatFMDBManager.init()
        return view
    }()
    
    var fmdb:FMDatabase?
    
    //MARK: - 群聊
//    /** 创建并打开群聊 */
//    func createTabGruopChat() {
//        /* 拼接路径*/
//        let filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last?.appendingFormat("%@", CBPET_CHAT_TABLE_GroupChat)
//        /* 初始化FMDB*/
//        fmdb = FMDatabase(path: filePath)
//        /* 打开数据库 */
//        fmdb?.open()
//        /* 创建数据库表 不同用户创建不同的表 */
//        let createStr = String.init(format: "create table if not exists cbpet_t_GROUPCHAT_TABLE%d%@(id integer primary key, accepter text, add_time text,chatType text, id text,isPush text,isRead text,message_file text,message_text text,sendd_my_self text,sender,text,voiceUrl text,isPlay bool);", "")
//        if let isSuccess = fmdb?.executeUpdate(createStr, withArgumentsIn: [Any]()) {
//            if isSuccess {
//                CBLog(message: "创建表成功")
//            } else {
//                CBLog(message: "创建表失败")
//            }
//        }
//    }
//    /** 添加 */
//    func addGroupChat(talkModel:CBPetFuncCvstionModel) -> Bool {
//        let addSql = String.init(format: "insert into cbpet_t_GROUPCHAT_TABLE%d%@(accepter, add_time, chatType,id,isPush,isRead,message_file,message_text,sendd_my_self,sender,voiceUrl,isPlay) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%d');", "")
//        if let isSuccess = fmdb?.executeUpdate(addSql, withArgumentsIn: [Any]()) {
//            if isSuccess {
//                CBLog(message: "添加表成功")
//            } else {
//                CBLog(message: "添加表失败")
//            }
//            return isSuccess
//        }
//        return false
//    }
//    /** 查询  如果 传空 默认会查询表中所有数据 */
//    func queryGroupChat(querySql:String) -> [CBPetFuncCvstionModel] {
//        var querySqlTemp = querySql
//        if querySqlTemp.isEmpty == true {
//            querySqlTemp = String.init(format: "select * from cbpet_t_GROUPCHAT_TABLE%d%@;", "")
//        }
//        var chats:Array<CBPetFuncCvstionModel> = Array()
//        do {
//            let set = try fmdb?.executeQuery(querySqlTemp, values: [Any]())
//            while set?.next() ?? false {
//                var cvstionModel = CBPetFuncCvstionModel.init()
//                cvstionModel.isRead = set?.string(forColumn: "isRead")
//                chats.append(cvstionModel)
//            }
//        } catch {
//            CBLog(message: "创建输入流失败:\(error)")
//        }
//        return chats
//    }
//    /** 删除  如果 传空 默认会删除表中所有数据 */
//    func deleteGroupChat(deleteSql:String) -> Bool {
//        var deleteSqlTemp = deleteSql
//        if deleteSqlTemp.isEmpty == true {
//            deleteSqlTemp = String.init(format: "drop table cbpet_t_GROUPCHAT_TABLE%d%@;", "")
//        }
//        let isSuccess = fmdb?.executeUpdate(deleteSqlTemp, withArgumentsIn: [Any]()) ?? false
//        return isSuccess
//    }
//    /** 修改 */
//    func updateGroupChat(updateSql:String) -> Bool {
//        let updateSqlTemp = updateSql
//        if updateSqlTemp.isEmpty == true {
//            return false
//        }
//        let isSuccess = fmdb?.executeUpdate(updateSqlTemp, withArgumentsIn: [Any]()) ?? false
//        return isSuccess
//    }
    
    //MARK: - 单聊
    /** 创建并打开群聊 */
    func createTabSingleChat(friendId:String) {
        /* 拼接路径*/
        let filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last?.appendingFormat("/%@", CBPET_CHAT_TABLE_SingleChat)
        /* 初始化FMDB*/
        fmdb = FMDatabase(path: filePath)
        /* 打开数据库 */
        if fmdb?.open() == false {
            CBLog(message: "打开数据库失败")
            return
        }
        /* 创建数据库表 不同用户创建不同的表 */
        let createStr = String.init(format: "create table if not exists cbpet_t_SINGLECHAT_TABLE%@%@%@(ids integer primary key, accepter text, add_time text,chatType text, id text,isPush text,isRead text,message_file text,message_text text,sendd_my_self text,sender,text,photo text,voiceTime text);", CBPetLoginModelTool.getUser()?.uid ?? "",CBPetHomeInfoTool.getHomeInfo().pet.device.imei ?? "",friendId)
        if let isSuccess = fmdb?.executeUpdate(createStr, withArgumentsIn: []) {
            if isSuccess {
                CBLog(message: "创建表成功")
            } else {
                CBLog(message: "创建表失败")
            }
        }
    }
    /** 添加 */
    func addSingleChat(model:CBPetFuncCvstionModel,friendId:String) -> Bool {
        let addSql = String.init(format: "insert into cbpet_t_SINGLECHAT_TABLE%@%@%@(accepter, add_time, chatType,id,isPush,isRead,message_file,message_text,sendd_my_self,sender,photo,voiceTime) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@');",CBPetLoginModelTool.getUser()?.uid ?? "",CBPetHomeInfoTool.getHomeInfo().pet.device.imei ?? "",friendId,model.accepter ?? "",model.add_time ?? "",model.chatType ?? "",model.id ?? "",model.isPush ?? "",model.isRead ?? "",model.message_file ?? "",model.message_text ?? "",model.sendd_my_self ?? "",model.sender ?? "",model.photo ?? "",model.voiceTime ?? "")
        if let isSuccess = fmdb?.executeUpdate(addSql, withArgumentsIn: []) {
            if isSuccess {
                CBLog(message: "添加表成功")
            } else {
                CBLog(message: "添加表失败")
            }
            return isSuccess
        }
        return false
    }
    /** 查询  如果 传空 默认会查询表中所有数据 */
    func querySingleChat(querySql:String,friendId:String) -> [CBPetFuncCvstionModel] {
        var querySqlTemp = querySql
        if querySqlTemp.isEmpty == true {
            querySqlTemp = String.init(format: "select * from cbpet_t_SINGLECHAT_TABLE%@%@%@;", CBPetLoginModelTool.getUser()?.uid ?? "",CBPetHomeInfoTool.getHomeInfo().pet.device.imei ?? "",friendId)
        }
        var chats:Array<CBPetFuncCvstionModel> = Array()
        let set = fmdb?.executeQuery(querySqlTemp, withArgumentsIn: [])
        while set?.next() ?? false {
            var cvstionModel = CBPetFuncCvstionModel.init()
            cvstionModel.accepter = set?.string(forColumn: "accepter")
            cvstionModel.add_time = set?.string(forColumn: "add_time")
            cvstionModel.chatType = set?.string(forColumn: "chatType")
            cvstionModel.id = set?.string(forColumn: "id")
            cvstionModel.isPush = set?.string(forColumn: "isPush")
            cvstionModel.isRead = set?.string(forColumn: "isRead")
            cvstionModel.message_file = set?.string(forColumn: "message_file")
            cvstionModel.message_text = set?.string(forColumn: "message_text")
            cvstionModel.sendd_my_self = set?.string(forColumn: "sendd_my_self")
            cvstionModel.sender = set?.string(forColumn: "sender")
            cvstionModel.photo = set?.string(forColumn: "photo")
            cvstionModel.voiceTime = set?.string(forColumn: "voiceTime")
            chats.append(cvstionModel)
        }
        return chats
    }
    /** 删除  如果 传空 默认会删除表中所有数据 */
    func deleteSingleChat(deleteSql:String,friendId:String) -> Bool {
        var deleteSqlTemp:String? = deleteSql
        if deleteSqlTemp!.isEmpty == true {
            deleteSqlTemp = String.init(format: "drop table cbpet_t_SINGLECHAT_TABLE%@%@%@;", CBPetLoginModelTool.getUser()?.uid ?? "",CBPetHomeInfoTool.getHomeInfo().pet.device.imei ?? "",friendId)
        }
        let isSuccess = fmdb?.executeUpdate(deleteSqlTemp!, withArgumentsIn: []) ?? false
        return isSuccess
    }
    /** 修改 */
    func updateSingleChat(updateSql:String) -> Bool {
        let updateSqlTemp = updateSql
        if updateSqlTemp.isEmpty == true {
            return false
        }
        let isSuccess = fmdb?.executeUpdate(updateSqlTemp, withArgumentsIn: []) ?? false
        return isSuccess
    }
}
