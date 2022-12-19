//
//  _CBSubAccountDeivceCell.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/12/20.
//  Copyright © 2022 coban. All rights reserved.
//

#import "_CBSubAccountDeivceCell.h"
#import "CBManagerAccountPopView.h"

@interface _CBSubAccountDeivceCell ()

@property (nonatomic, strong) CBManagerAccountPopView *accountPopView;

@end

@implementation _CBSubAccountDeivceCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UILabel *lbl = [MINUtils createLabelWithText:Localized(@"分配的设备") size:14 alignment:NSTextAlignmentLeft textColor:kCellTextColor];
    [self.contentView addSubview:lbl];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.left.equalTo(@15);
    }];
    
    UIView *tableView = [[self accountPopView] deviceTableView];
    [self.contentView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbl.mas_bottom).mas_offset(14);
        make.left.right.equalTo(@0);
        make.height.equalTo(@200);
        make.bottom.equalTo(@-15);
    }];
    
}

- (void)setAccountModel:(SubAccountModel *)accountModel {
    _accountModel = accountModel;
    [self.accountPopView popView:accountModel];
}

- (CBManagerAccountPopView *)accountPopView {
    if (!_accountPopView) {
        _accountPopView = [[CBManagerAccountPopView alloc] init];
        _accountPopView.delegate = self;
        kWeakSelf(self);
        _accountPopView.popViewBlock = ^(id  _Nonnull objc) {
            kStrongSelf(self);
        };
    }
    return _accountPopView;
}

- (void)accountPopViewClickType:(NSInteger)index {
    NSLog(@"%s", __FUNCTION__);
}
@end
