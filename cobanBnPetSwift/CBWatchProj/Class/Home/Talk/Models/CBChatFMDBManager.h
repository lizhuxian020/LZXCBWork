//
//  CBChatFMDBManager.h
//  Watch
//
//  Created by coban on 2019/9/24.
//  Copyright © 2019 Coban. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CBTalkModel;

@interface CBChatFMDBManager : NSObject

///** 实例化 */
+ (instancetype)sharedFMDataBase;

#pragma mark -- 手表家庭群聊
///** 创建并打开群聊 */
- (void)createTabGruopChat;

// 添加
- (BOOL)addGroupChat:(CBTalkModel *)talkModel;

// 查询  如果 传空 默认会查询表中所有数据
- (NSArray<CBTalkModel*> *)queryGroupChat:(NSString *)querySql;

// 删除  如果 传空 默认会删除表中所有数据
- (BOOL)deleteGroupChat:(NSString *)deleteSql;

// 修改
- (BOOL)updateGroupChat:(NSString *)updateSql;

#pragma mark -- 手表单聊
//** 创建并打开群聊 */
- (void)createTabSingleChat;
// 添加
- (BOOL)addSingleChat:(CBTalkModel *)talkModel;
// 查询  如果 传空 默认会查询表中所有数据
- (NSArray<CBTalkModel*> *)querySingleChat:(NSString *)querySql;
// 删除  如果 传空 默认会删除表中所有数据
- (BOOL)deleteSingleChat:(NSString *)deleteSql;
// 修改
- (BOOL)updateSingleChat:(NSString *)updateSql;
@end

NS_ASSUME_NONNULL_END
