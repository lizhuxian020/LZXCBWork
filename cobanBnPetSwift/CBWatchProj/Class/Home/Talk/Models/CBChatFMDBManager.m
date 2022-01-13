//
//  CBChatFMDBManager.m
//  Watch
//
//  Created by coban on 2019/9/24.
//  Copyright © 2019 Coban. All rights reserved.
//
// 增 insert into XX(key,key) values (value,value);
// 删 delete from XX where key = ?
// 改 update XX set key = ?,key = ?
// 查 select from XX where key = ?

#import "CBChatFMDBManager.h"
#import "CBTalkModel.h"
/* oc 调用 swift*/
#import "cobanBnPetSwift-Swift.h"

#define CHAT_TABLE_GroupChat @"CBChatRecordGroupChatData.sqlite"
#define CHAT_TABLE_SingleChat @"CBChatRecordSingleChatData.sqlite"

@implementation CBChatFMDBManager

static FMDatabase *_fmdb;

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}
+ (instancetype)sharedFMDataBase {
    static CBChatFMDBManager *chatManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chatManager = [[self alloc]init];
    });
    return chatManager;
}
- (void)createTabGruopChat {
    //拼接路径
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:CHAT_TABLE_GroupChat];//[NSString stringWithFormat:@"%@CBChatRecordData.sqlite",[CBWtUserLoginModel CBaccount].account]
    
    //初始化FMDB
    _fmdb = [FMDatabase databaseWithPath:filePath];
    
    //打开数据库
    [_fmdb open];
    //创建数据库表 不同用户创建不同的表
    // @"create table if not exists t_STUDENT_TABLE(id integer primary key, create_time text, from_sno text, head text,ids text,name text,phone text,read text,sno text,type,text,voiceUrl text,isPlay bool);"
    NSString *createStr = [NSString stringWithFormat:@"create table if not exists t_GROUPCHAT_TABLE%@%@(id integer primary key, create_time text, from_sno text,to_sno text, head text,ids text,name text,phone text,read text,sno text,type,text,voiceUrl text,isPlay bool);",[CBPetLoginModelTool getUser].uid,[HomeModel CBDevice].tbWatchMain.sno?:@""];
    BOOL isSucc = [_fmdb executeUpdate:createStr];
    NSLog(@"%@", createStr);
    if (isSucc) {
        NSLog(@"创建表成功");
    } else {
        NSLog(@"创建表失败");
    }
}
//同一个类初始化时只会调用一次。
/**
 使用FMDB要导入 libsqlite3.0.tbd
 */
//+ (void)initialize {
//    //拼接路径
//    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:CHAT_TABLE];
//
//    //初始化FMDB
//    _fmdb = [FMDatabase databaseWithPath:filePath];
//
//    //打开数据库
//    [_fmdb open];
//
//    //创建数据库表
//    BOOL isSucc = [_fmdb executeUpdate:@"create table if not exists t_STUDENT_TABLE(id integer primary key, create_time text, from_sno text, head text,ids text,name text,phone text,read text,sno text,type,text,voiceUrl text,isPlay bool);"];
//    NSLog(@"%d", isSucc);
//}

//添加
- (BOOL)addGroupChat:(CBTalkModel *)talkModel {
    // [NSString stringWithFormat:@"insert into t_STUDENT_TABLE(create_time, from_sno, head,ids,name,phone,read,sno,type,voiceUrl,isPlay) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%d');", talkModel.create_time, talkModel.from_sno, talkModel.head,talkModel.ids,talkModel.name,talkModel.phone,talkModel.read,talkModel.sno,talkModel.type,talkModel.voiceUrl,talkModel.isPlay]
    NSString *addSql = [NSString stringWithFormat:@"insert into t_GROUPCHAT_TABLE%@%@(create_time, from_sno, to_sno,head,ids,name,phone,read,sno,type,voiceUrl,isPlay) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%d');",[CBPetLoginModelTool getUser].uid,[HomeModel CBDevice].tbWatchMain.sno?:@"",talkModel.create_time, talkModel.from_sno,talkModel.to_sno, talkModel.head,talkModel.ids,talkModel.name,talkModel.phone,talkModel.read,talkModel.sno,talkModel.type,talkModel.voiceUrl,talkModel.isPlay];
    
    BOOL isSuccess = [_fmdb executeUpdate:addSql];
    
    return isSuccess;
}

//查询
- (NSArray<CBTalkModel *> *)queryGroupChat:(NSString *)querySql {
    if (querySql == nil || querySql.length <= 0) {
        //@"select * from t_STUDENT_TABLE;"
        querySql = [NSString stringWithFormat:@"select * from t_GROUPCHAT_TABLE%@%@;",[CBPetLoginModelTool getUser].uid,[HomeModel CBDevice].tbWatchMain.sno?:@""];
    }
    NSMutableArray <CBTalkModel *> *chats = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    while ([set next]) {
        CBTalkModel *talkModel = [[CBTalkModel alloc]init];
        talkModel.create_time = [set stringForColumn:@"create_time"];
        talkModel.from_sno = [set stringForColumn:@"from_sno"];
        talkModel.to_sno = [set stringForColumn:@"to_sno"];
        talkModel.head = [set stringForColumn:@"head"];
        talkModel.ids = [set stringForColumn:@"ids"];
        talkModel.name = [set stringForColumn:@"name"];
        talkModel.phone = [set stringForColumn:@"phone"];
        talkModel.read = [set stringForColumn:@"read"];
        talkModel.sno = [set stringForColumn:@"sno"];
        talkModel.type = [set stringForColumn:@"type"];
        talkModel.voiceUrl = [set stringForColumn:@"voiceUrl"];
        talkModel.isPlay = [set boolForColumn:@"isPlay"];
        [chats addObject:talkModel];
    }
    return chats;
}

- (BOOL)deleteGroupChat:(NSString *)deleteSql {
    if (deleteSql == nil || deleteSql.length <= 0) {
        // @"delete from t_STUDENT_TABLE"
        deleteSql = [NSString stringWithFormat:@"drop table t_GROUPCHAT_TABLE%@%@;",[CBPetLoginModelTool getUser].uid,[HomeModel CBDevice].tbWatchMain.sno?:@""];//[NSString stringWithFormat:@"delete from t_GROUPCHAT_TABLE%d%@;",[CBWtUserLoginModel CBaccount].uid,[HomeModel CBDevice].tbWatchMain.sno?:@""];//[NSString stringWithFormat:@"delete * from t_GROUPCHAT_TABLE%d%@;",[CBWtUserLoginModel CBaccount].uid,[HomeModel CBDevice].tbWatchMain.sno?:@""];
    }
    BOOL isSuccess = [_fmdb executeUpdate:deleteSql];
    return isSuccess;
}
- (BOOL)updateGroupChat:(NSString *)updateSql {
    if (updateSql == nil || updateSql.length <= 0) {
        return NO;
    }
    BOOL isSuccess = [_fmdb executeUpdate:updateSql];
    return isSuccess;
}

//** 创建并打开群聊 */
- (void)createTabSingleChat {
    //拼接路径
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:CHAT_TABLE_SingleChat];
    
    //初始化FMDB
    _fmdb = [FMDatabase databaseWithPath:filePath];
    
    //打开数据库
    [_fmdb open];
    
    //创建数据库表 不同用户创建不同的表
    NSString *createStr = [NSString stringWithFormat:@"create table if not exists t_SINGLECHAT_TABLE%@%@(id integer primary key, create_time text, from_sno text,to_sno text, head text,ids text,name text,phone text,read text,sno text,type,text,voiceUrl text,isPlay bool);",[CBPetLoginModelTool getUser].uid,[HomeModel CBDevice].tbWatchMain.sno?:@""];
    BOOL isSucc = [_fmdb executeUpdate:createStr];
    NSLog(@"%@", createStr);
    if (isSucc) {
        NSLog(@"创建表成功");
    } else {
        NSLog(@"创建表失败");
    }
}
// 添加
- (BOOL)addSingleChat:(CBTalkModel *)talkModel {
    NSString *addSql = [NSString stringWithFormat:@"insert into t_SINGLECHAT_TABLE%@%@(create_time, from_sno, to_sno,head,ids,name,phone,read,sno,type,voiceUrl,isPlay) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%d');",[CBPetLoginModelTool getUser].uid,[HomeModel CBDevice].tbWatchMain.sno?:@"",talkModel.create_time, talkModel.from_sno,talkModel.to_sno, talkModel.head,talkModel.ids,talkModel.name,talkModel.phone,talkModel.read,talkModel.sno,talkModel.type,talkModel.voiceUrl,talkModel.isPlay];
    BOOL isSuccess = [_fmdb executeUpdate:addSql];
    return isSuccess;
}
// 查询  如果 传空 默认会查询表中所有数据
- (NSArray<CBTalkModel*> *)querySingleChat:(NSString *)querySql {
    if (querySql == nil || querySql.length <= 0) {
        //@"select * from t_STUDENT_TABLE;"
        querySql = [NSString stringWithFormat:@"select * from t_SINGLECHAT_TABLE%@%@;",[CBPetLoginModelTool getUser].uid,[HomeModel CBDevice].tbWatchMain.sno?:@""];
    }
    NSMutableArray <CBTalkModel *> *chats = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    while ([set next]) {
        CBTalkModel *talkModel = [[CBTalkModel alloc]init];
        talkModel.create_time = [set stringForColumn:@"create_time"];
        talkModel.from_sno = [set stringForColumn:@"from_sno"];
        talkModel.to_sno = [set stringForColumn:@"to_sno"];
        talkModel.head = [set stringForColumn:@"head"];
        talkModel.ids = [set stringForColumn:@"ids"];
        talkModel.name = [set stringForColumn:@"name"];
        talkModel.phone = [set stringForColumn:@"phone"];
        talkModel.read = [set stringForColumn:@"read"];
        talkModel.sno = [set stringForColumn:@"sno"];
        talkModel.type = [set stringForColumn:@"type"];
        talkModel.voiceUrl = [set stringForColumn:@"voiceUrl"];
        talkModel.isPlay = [set boolForColumn:@"isPlay"];
        [chats addObject:talkModel];
    }
    return chats;
}
// 删除  如果 传空 默认会删除表中所有数据
- (BOOL)deleteSingleChat:(NSString *)deleteSql {
    if (deleteSql == nil || deleteSql.length <= 0) {
        // @"delete from t_STUDENT_TABLE"
        deleteSql = [NSString stringWithFormat:@"drop table t_SINGLECHAT_TABLE%@%@;",[CBPetLoginModelTool getUser].uid,[HomeModel CBDevice].tbWatchMain.sno?:@""];//[NSString stringWithFormat:@"delete * from t_SINGLECHAT_TABLE%d%@;",[CBWtUserLoginModel CBaccount].uid,[HomeModel CBDevice].tbWatchMain.sno?:@""];//[NSString stringWithFormat:@"delete * from t_SINGLECHAT_TABLE%d%@;",[CBWtUserLoginModel CBaccount].uid,[HomeModel CBDevice].tbWatchMain.sno?:@""];
    }
    BOOL isSuccess = [_fmdb executeUpdate:deleteSql];
    return isSuccess;
}
// 修改
- (BOOL)updateSingleChat:(NSString *)updateSql {
    if (updateSql == nil || updateSql.length <= 0) {
        return NO;
    }
    BOOL isSuccess = [_fmdb executeUpdate:updateSql];
    return isSuccess;
}
@end
