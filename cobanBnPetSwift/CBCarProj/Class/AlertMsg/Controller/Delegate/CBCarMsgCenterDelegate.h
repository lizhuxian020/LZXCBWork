//
//  CBCarMsgCenterDelegate.h
//  cobanBnPetSwift
//
//  Created by zzer on 2023/1/16.
//  Copyright © 2023 coban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "_CBMsgCenterCell.h"
#import "_CBMsgCenterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBCarMsgCenterDelegate : NSObject<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) NSArray<_CBMsgCenterModel *> *dataArr;
@property (nonatomic, strong) CBNoDataView *noDataView;
@property (nonatomic, strong) UITableView *tableView;

- (void)reload;

@end

NS_ASSUME_NONNULL_END
