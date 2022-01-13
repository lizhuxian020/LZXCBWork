//
//  PhoneBookModel.h
//  Telematics
//
//  Created by lym on 2017/12/23.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneBookModel : NSObject
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *phoneId; // 修改电话的时候传这个
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *paramId;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
