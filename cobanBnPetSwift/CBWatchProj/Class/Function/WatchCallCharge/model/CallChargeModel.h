//
//  CallChargeModel.h
//  Watch
//
//  Created by lym on 2018/4/12.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CallChargeModel : NSObject
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *callChargeId;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *sno;
@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) BOOL isSelect;

@end
