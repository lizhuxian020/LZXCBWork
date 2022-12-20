//
//  _CBSubAccountEditView.h
//  cobanBnPetSwift
//
//  Created by zzer on 2022/12/20.
//  Copyright © 2022 coban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubAccountModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface _CBSubAccountEditView : UIView

@property (nonatomic, strong) SubAccountModel *accountModel;

@property (nonatomic, strong) UITextField *accountTF;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *emailTF;
@property (nonatomic, strong) UITextField *hiddenTF;
@property (nonatomic,strong) UIButton *lookatBtn;
@property (nonatomic,strong) UIButton *controlBtn;
@property (nonatomic, strong) UITextField *markTF;
@property (nonatomic, strong) UITextField *addressTF;
@property (nonatomic,copy) NSString *authStr;
@end

NS_ASSUME_NONNULL_END
