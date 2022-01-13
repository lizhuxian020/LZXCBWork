//
//  FenceAdreesInfoView.m
//  Watch
//
//  Created by lym on 2018/4/19.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "FenceAdreesInfoView.h"

@interface FenceAdreesInfoView()<UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *searchImgView;
@property (nonatomic, strong) UIImageView *locationImgView;
@property (nonatomic, strong) UITextField *searchTextField;

@end

@implementation FenceAdreesInfoView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = KWtRGB(255, 255, 255);
        
        [self searchTextField];
        
        [self locationImgView];
    }
    return self;
}
- (UITextField *)searchTextField {
    if (!_searchTextField) {
        
        _searchImgView = [[UIImageView alloc]init];
        _searchImgView.image = [UIImage imageNamed: @"search_icon_white"];
        [self addSubview:_searchImgView];
        [_searchImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(15*frameSizeRate);
            make.size.mas_equalTo(CGSizeMake(15*frameSizeRate, 15));
        }];
        
        _searchTextField = [[UITextField alloc]init];
        _searchTextField.textColor = KWtRGB(73, 73, 73);
        _searchTextField.font = [UIFont systemFontOfSize:15];
        [_searchTextField addTarget:self action:@selector(textFieldValeChange:) forControlEvents:UIControlEventEditingChanged];
        _searchTextField.placeholder = Localized(@"请输入关键字");
        _searchTextField.delegate = self;
        [self addSubview:_searchTextField];
        [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_searchImgView.mas_centerY);
            make.left.mas_equalTo(_searchImgView.mas_right).offset(15*frameSizeRate);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(22);
        }];
    }
    return _searchTextField;
}
- (UIImageView *)locationImgView {
    if (!_locationImgView) {
        _locationImgView = [[UIImageView alloc]init];
        _locationImgView.image = [UIImage imageNamed: @"设置地址-定位-小"];
        _locationImgView.contentMode = UIViewContentModeCenter;
        [self addSubview:_locationImgView];
        [_locationImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.searchTextField.mas_bottom).offset(20);
            make.left.mas_equalTo(15*frameSizeRate);
            make.size.mas_equalTo(CGSizeMake(15*frameSizeRate, 15));
        }];
        
        self.addressLabel = [CBWtMINUtils createLabelWithText: @"" size:15 alignment: NSTextAlignmentLeft textColor: KWtRGB(73, 73, 73)];
        [self addSubview: self.addressLabel];
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.locationImgView.mas_right).with.offset(15*frameSizeRate);
            make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
            make.centerY.mas_equalTo(self.locationImgView.mas_centerY);
            make.height.mas_equalTo(22);
        }];
    }
    return _locationImgView;
}
#pragma mark -- UITextField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.returnBlock) {
        self.returnBlock(@"beginEdit",textField.text);
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.returnBlock) {
        self.returnBlock(@"endEdit",textField.text);
    }
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (self.returnBlock) {
//        self.returnBlock(@"valueChage",[NSString stringWithFormat:@"%@%@",string,self.searchTextField.text]);
//    }
//    return YES;
//}
- (void)textFieldValeChange:(UITextField *)textField {
    if (self.returnBlock) {
        self.returnBlock(@"valueChage",textField.text);
    }
}
- (void)updateInfoViewIsGoogle:(BOOL)isGoogle {
    if (isGoogle) {
        [_searchImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(15*frameSizeRate);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        [_searchTextField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_searchImgView.mas_centerY);
            make.left.mas_equalTo(_searchImgView.mas_right).offset(15*frameSizeRate);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0);
        }];
        [_locationImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.searchTextField.mas_bottom).offset(15);
            make.left.mas_equalTo(15*frameSizeRate);
            make.size.mas_equalTo(CGSizeMake(15*frameSizeRate, 15));
        }];
        [_addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.locationImgView.mas_right).with.offset(15*frameSizeRate);
            make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
            make.centerY.mas_equalTo(self.locationImgView.mas_centerY);
            make.height.mas_equalTo(22);
        }];
    }
}
@end
