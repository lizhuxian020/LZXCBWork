//
//  _CBInstallInfoView.h
//  cobanBnPetSwift
//
//  Created by lee on 2022/12/3.
//  Copyright © 2022 coban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "_CBInstallInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface _CBInstallInfoView : UIView

@property (nonatomic, strong) _CBInstallInfo *model;

- (NSDictionary *)getSaveInfo;
@end

NS_ASSUME_NONNULL_END
