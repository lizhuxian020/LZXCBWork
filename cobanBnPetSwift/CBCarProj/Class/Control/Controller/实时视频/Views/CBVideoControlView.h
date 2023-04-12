//
//  CBVideoControlView.h
//  cobanBnPetSwift
//
//  Created by zzer on 2023/4/11.
//  Copyright © 2023 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBVideoControlView : UIView

@property (nonatomic, copy) void(^didClickCapture)(void);
@property (nonatomic, copy) void(^didTop)(void);
@property (nonatomic, copy) void(^didLeft)(void);
@property (nonatomic, copy) void(^didRight)(void);
@property (nonatomic, copy) void(^didBottom)(void);

@end

NS_ASSUME_NONNULL_END
