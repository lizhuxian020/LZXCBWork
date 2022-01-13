//
//  MessageModel.h
//  Watch
//
//  Created by lym on 2018/4/16.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, copy) NSString *status; // 状态(用于监护人申请)：0-待处理，1-接受，2-拒绝
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) int type; // 0-监护人申请，1-欠压报警，2-拆除报警，3-进/出区域，4-迟到，5-逗留，6-未按时到家
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) CGFloat cellHeigt;
@property (nonatomic, assign) BOOL isCheck;
@property (nonatomic, assign) BOOL isEdit;

@end
