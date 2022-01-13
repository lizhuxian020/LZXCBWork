//
//  CBNoDataView.h
//  Telematics
//
//  Created by coban on 2019/8/7.
//  Copyright © 2019 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBNoDataView : UIView

@property (nonatomic,strong) UIImageView *imageView_logo;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,copy) void(^noDataBlock)(void);
- (instancetype)initWithMy;
- (instancetype)initWithGrail;
- (instancetype)initWithpp;
- (instancetype)initNoDeviceUI;

@end

NS_ASSUME_NONNULL_END
