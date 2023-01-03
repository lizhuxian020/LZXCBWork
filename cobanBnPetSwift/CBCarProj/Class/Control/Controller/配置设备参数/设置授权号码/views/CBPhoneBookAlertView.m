//
//  CBPhoneBookAlertView.m
//  cobanBnPetSwift
//
//  Created by zzer on 2023/1/3.
//  Copyright © 2023 coban. All rights reserved.
//

#import "CBPhoneBookAlertView.h"

@interface CBPhoneBookAlertView ()

@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) NSMutableArray *btnArr;

@property (nonatomic, assign) int selectedIndex;
@end

@implementation CBPhoneBookAlertView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self craeteUI];
    }
    return self;
}

- (void)craeteUI {
    self.backgroundColor = kBackColor;
    UITextField *tf = nil;
    UIView *nameView = [self createTF:Localized(@"输入设备名称(必填)") tf:&tf];
    self.nameTF = tf;
    UIView *phoneView = [self createTF:Localized(@"输入手机号码(必填)") tf:&tf];
    self.phoneTF = tf;
    [self addSubview:nameView];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@40);
    }];
    
    [self addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameView.mas_bottom).mas_offset(10);
        make.height.left.right.equalTo(nameView);
    }];
    
    self.titleLbl = [MINUtils createLabelWithText:Localized(@"号码类型") size:18 alignment:NSTextAlignmentLeft textColor:kCellTextColor];
    [self addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneView.mas_bottom).mas_offset(15);
        make.left.equalTo(phoneView);
    }];
    
    NSArray *chooseData = @[Localized(@"授权号码"),Localized(@"短信监控中心号码")];
    
    UIView *lastBtn = self.titleLbl;
    NSMutableArray *btnArr = [NSMutableArray new];
    for (int i = 0 ; i < chooseData.count ; i ++ ) {

        UIButton *btn = [UIButton new];
        [btnArr addObject:btn];
        btn.tag = 100 + i;
        [btn setTitle:chooseData[i] forState:UIControlStateNormal];
        [btn setTitle:chooseData[i] forState:UIControlStateSelected];
        [btn setTitleColor:kCellTextColor forState:UIControlStateNormal];
        [btn setTitleColor:kAppMainColor forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"未选中2"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"已选中2"] forState:UIControlStateSelected];
        [btn horizontalCenterImageAndTitle:20];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.adjustsImageWhenHighlighted = NO;
        btn.adjustsImageWhenDisabled = NO;
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastBtn);
            make.top.equalTo(lastBtn.mas_bottom).mas_offset(10);
        }];
        [btn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [btn setSelected:true];
        }
        lastBtn = btn;
    }
    self.btnArr = btnArr;
    
    [lastBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-10);
    }];
}

- (void)selectTime:(UIButton *)sender {
    int index = sender.tag - 100;
    UIButton *lastBtn = self.btnArr[self.selectedIndex];
    [lastBtn setSelected:false];
    
    self.selectedIndex = index;
    [sender setSelected:true];
}

- (UIView *)createTF:(NSString *)placeHolder tf:(UITextField **)ttf{
    UIView *view = [UIView new];
    view.layer.borderColor = KCarLineColor.CGColor;
    view.layer.borderWidth = 1;
    view.layer.cornerRadius = 20;
    UITextField *tf = [UITextField new];
    tf.placeholder = placeHolder;
    *ttf = tf;
    [view addSubview:tf];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.top.bottom.equalTo(@0);
    }];
    return view;
}

- (void)setPhoneModel:(PhoneBookModel *)phoneModel {
    _phoneModel = phoneModel;
    self.nameTF.text = phoneModel.name;
    self.phoneTF.text = phoneModel.phone;
    int idx = phoneModel.type == 5 ? 1 : 0;
    [self selectTime:self.btnArr[idx]];
}


- (BOOL)canDismiss {
    if (kStringIsEmpty(self.nameTF.text) ||
        kStringIsEmpty(self.phoneTF.text)
        ) {
        [CBTopAlertView alertFail:Localized(@"任何一项不能为空")];
        return NO;
    }
    return YES;
}

- (NSDictionary *)getRequestParam {
    if (self.phoneModel) {
        return @{
            @"name": self.nameTF.text,
            @"phone": self.phoneTF.text,
            @"type": _selectedIndex == 0 ? @"4": @"5",
            @"aid": self.phoneModel.phoneId ?: @""
        };
    }
    return @{
        @"name": self.nameTF.text,
        @"phone": self.phoneTF.text,
        @"type": _selectedIndex == 0 ? @"4": @"5",
    };
}
@end
