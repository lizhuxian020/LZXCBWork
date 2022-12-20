//
//  _CBSubAccountEditView.m
//  cobanBnPetSwift
//
//  Created by zzer on 2022/12/20.
//  Copyright © 2022 coban. All rights reserved.
//

#import "_CBSubAccountEditView.h"

@interface _CBSubAccountEditView ()


@end

@implementation _CBSubAccountEditView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = kBackColor;
    
    NSArray *plArr = @[
        Localized(@"请输入子用户名"), Localized(@"请输入姓名"), Localized(@"请输入电话号码"), Localized(@"请输入邮箱"),Localized(@"hidden"), Localized(@"请输入备注"), Localized(@"请输入详细地址")
    ];
    
    self.accountTF = [self createTF:@{
        @"pl" :plArr[0],
    }];
    self.nameTF = [self createTF:@{
        @"pl" :plArr[1],
    }];
    self.phoneTF = [self createTF:@{
        @"pl" :plArr[2],
    }];
    self.emailTF = [self createTF:@{
        @"pl" :plArr[3],
    }];
    self.hiddenTF = [self createTF:@{
        @"pl" :plArr[4],
    }];
    self.markTF = [self createTF:@{
        @"pl" :plArr[5],
    }];
    self.addressTF = [self createTF:@{
        @"pl" :plArr[6],
    }];
    
    _hiddenTF.hidden = YES;
    
    NSArray *subView = @[_accountTF, _nameTF, _phoneTF, _emailTF, _hiddenTF, _markTF, _addressTF];
    UIView *lastView = nil;
    for (UIView *view in subView) {
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).mas_offset(5);
            } else {
                make.top.equalTo(@15);
            }
            make.height.equalTo(@40);
        }];
        
        lastView = view;
    }
    
    [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-15);
    }];
    
    [self lookatBtn];
    [self controlBtn];
}

- (void)setAccountModel:(SubAccountModel *)accountModel {
    _accountModel = accountModel;
    self.accountTF.text = _accountModel.account;
    self.nameTF.text = _accountModel.name;
    self.phoneTF.text = _accountModel.phone;
    self.emailTF.text = _accountModel.email;
    [self selectAuthBtnClick: _accountModel.auth.intValue == 1 ? _controlBtn : _lookatBtn];
    self.markTF.text = _accountModel.comment;
    self.addressTF.text = _accountModel.address;
}

- (UITextField *)createTF:(NSDictionary *)data {
    UITextField *tf = [UITextField new];
    tf.placeholder = data[@"pl"];
    tf.backgroundColor = kGreyColor;
    tf.layer.cornerRadius = 20;
    tf.textAlignment = NSTextAlignmentCenter;
    return tf;
}


- (UIButton *)lookatBtn {
    if (!_lookatBtn) {
        _lookatBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"确定") titleColor: [UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: UIColor.whiteColor];
        _lookatBtn.selected = YES;
        [_lookatBtn setImage: [UIImage imageNamed:@"已选中2"] forState: UIControlStateSelected];
        [_lookatBtn setImage: [UIImage imageNamed:@"未选中2"] forState: UIControlStateNormal];

        [_lookatBtn horizontalCenterImageAndTitle:10];
        [_lookatBtn setTitle: Localized(@"查看") forState: UIControlStateNormal];
        [_lookatBtn setTitle: Localized(@"查看") forState: UIControlStateSelected];
        [_lookatBtn setTitleColor:kRGB(137, 137, 137) forState: UIControlStateNormal];
        [_lookatBtn setTitleColor:kRGB(137, 137, 137) forState: UIControlStateSelected];
        _lookatBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _lookatBtn.adjustsImageWhenHighlighted = NO;
        _lookatBtn.adjustsImageWhenDisabled = NO;
        [_lookatBtn addTarget:self action:@selector(selectAuthBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_lookatBtn];
        [_lookatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_centerX).offset(-15*KFitWidthRate);
            make.centerY.equalTo(self.hiddenTF);
            make.height.mas_equalTo(40);
            //make.size.mas_equalTo(CGSizeMake(75*KFitWidthRate, 40));
        }];
    }
    return _lookatBtn;
}
- (UIButton *)controlBtn {
    if (!_controlBtn) {
        _controlBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"确定") titleColor: [UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: UIColor.whiteColor];
        [_controlBtn setImage: [UIImage imageNamed:@"已选中2"] forState: UIControlStateSelected];
        [_controlBtn setImage: [UIImage imageNamed:@"未选中2"] forState: UIControlStateNormal];
        [_controlBtn setTitle: Localized(@"控制") forState: UIControlStateNormal];
        [_controlBtn setTitle: Localized(@"控制") forState: UIControlStateSelected];
//        [_controlBtn setImageEdgeInsets: UIEdgeInsetsMake(0, 0, 0, 10 * KFitWidthRate)];
//        [_controlBtn setTitleEdgeInsets: UIEdgeInsetsMake(0, 10 * KFitWidthRate, 0, 0)];
        [_controlBtn horizontalCenterImageAndTitle:10];
        [_controlBtn setTitleColor:kRGB(137, 137, 137) forState: UIControlStateNormal];
        [_controlBtn setTitleColor:kRGB(137, 137, 137) forState: UIControlStateSelected];
        _controlBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _controlBtn.adjustsImageWhenHighlighted = NO;
        _controlBtn.adjustsImageWhenDisabled = NO;
        [_controlBtn addTarget:self action:@selector(selectAuthBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_controlBtn];
        [_controlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_centerX).offset(15*KFitWidthRate);
            make.centerY.equalTo(self.hiddenTF);
            make.height.mas_equalTo(40);
            //make.size.mas_equalTo(CGSizeMake(75*KFitWidthRate, 40));
        }];
    }
    return _controlBtn;
}
- (void)selectAuthBtnClick:(UIButton *)sender {
    if (sender == self.lookatBtn) {
        self.lookatBtn.selected = YES;
        self.controlBtn.selected = NO;
        self.authStr = @"0";
    } else {
        self.lookatBtn.selected = NO;
        self.controlBtn.selected = YES;
        self.authStr = @"1";
    }
}
@end
