//
//  CBOBDModel.h
//  Telematics
//
//  Created by coban on 2019/11/26.
//  Copyright © 2019 coban. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBOBDModel : NSObject
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *ids;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *type;
@end

NS_ASSUME_NONNULL_END
