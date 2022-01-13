//
//  ForbiddenInClassModel.h
//  Watch
//
//  Created by lym on 2018/4/3.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForbiddenInClassModel : NSObject <YYModel>
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, assign) BOOL action;
@property (nonatomic, copy) NSString *endAm;
@property (nonatomic, copy) NSString *endPm;
@property (nonatomic, copy) NSString *forbiddenId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *repeat;
@property (nonatomic, copy) NSString *sno;
@property (nonatomic, copy) NSString *startAm;
@property (nonatomic, copy) NSString *startPm;
@end
