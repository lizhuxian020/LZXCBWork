//
//  CBAddAddressBKView.h
//  Telematics
//
//  Created by coban on 2019/8/6.
//  Copyright © 2019 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBAddAddressBKView : UIView
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *mobileTextField;
@property (nonatomic, strong) UILabel *alramLabel;
@property (nonatomic, strong) UIButton *alramTypeBtn;
@property (nonatomic, copy) void (^alramTypeBtnClickBlock)();
@end

NS_ASSUME_NONNULL_END
