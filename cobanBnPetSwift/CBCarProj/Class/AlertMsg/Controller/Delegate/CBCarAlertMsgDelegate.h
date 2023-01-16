//
//  CBCarAlertMsgDelegate.h
//  cobanBnPetSwift
//
//  Created by zzer on 2023/1/16.
//  Copyright © 2023 coban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "_CBCarAlertMsgCell.h"
#import "_CBCarAlertMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBCarAlertMsgDelegate : NSObject<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) NSArray<_CBCarAlertMsgModel *> *dataArr;

@property (nonatomic, strong) UITableView *tableView;

- (void)reload;

@end

NS_ASSUME_NONNULL_END
