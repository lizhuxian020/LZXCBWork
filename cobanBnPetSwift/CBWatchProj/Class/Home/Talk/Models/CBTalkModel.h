//
//  CBTalkModel.h
//  Watch
//
//  Created by coban on 2019/9/5.
//  Copyright © 2019 Coban. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBTalkModel : NSObject
/**   */
@property (nonatomic, copy) NSString *create_time;
/**   */
@property (nonatomic, copy) NSString *from_sno;
/**   */
@property (nonatomic, copy) NSString *to_sno;
/**   */
@property (nonatomic, copy) NSString *head;
/**   */
@property (nonatomic, copy) NSString *ids;
/**   */
@property (nonatomic, copy) NSString *name;
/**   */
@property (nonatomic, copy) NSString *phone;
/**   */
@property (nonatomic, copy) NSString *read;
/**   */
@property (nonatomic, copy) NSString *sno;
/** type = 5 自己  */
@property (nonatomic, copy) NSString *type;
/**   */
@property (nonatomic, copy) NSString *voiceUrl;

@property (nonatomic, assign) BOOL isPlay;

@end

@interface CBTalkMemberModel : NSObject
/**   */
@property (nonatomic, copy) NSString *create_time;
/**   */
@property (nonatomic, copy) NSString *family;
/**   */
@property (nonatomic, copy) NSString *head;
/**   */
@property (nonatomic, copy) NSString *ids;
/**   */
@property (nonatomic, copy) NSString *isAutoConnect;
/**   */
@property (nonatomic, copy) NSString *phone;
/**   */
@property (nonatomic, copy) NSString *relation;
/**   */
@property (nonatomic, copy) NSString *sno;
/**   */
@property (nonatomic, copy) NSString *status;
/**   */
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isAddBtn;
@end

@interface CBTalkListModel : NSObject
/**   */
@property (nonatomic, copy) NSString *create_time;
/**   */
@property (nonatomic, copy) NSString *family;
/**   */
@property (nonatomic, copy) NSString *head;
/**   */
@property (nonatomic, copy) NSString *groupId;
/**   */
@property (nonatomic, copy) NSString *ids;
/**   */
@property (nonatomic, copy) NSString *name;
/**   */
@property (nonatomic, copy) NSString *unRead;
/**   */
@property (nonatomic, copy) NSString *voice_url;

@end


NS_ASSUME_NONNULL_END
