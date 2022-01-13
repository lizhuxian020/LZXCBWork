//
//  CBFriendListFootView.m
//  Watch
//
//  Created by coban on 2019/8/27.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBFriendListFootView.h"

@interface CBFriendListFootView ()
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *checkAllBtn;
@end
@implementation CBFriendListFootView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.backgroundColor = KWtBackColor;
    [self checkAllBtn];
    [self deleteBtn];
}
#pragma mark -- setting && getting
- (UIButton *)checkAllBtn {
    if (!_checkAllBtn) {
        _checkAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 40)];
        _checkAllBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_checkAllBtn setTitle:Localized(@"全选") forState: UIControlStateNormal];
        [_checkAllBtn setTitle:Localized(@"全选") forState: UIControlStateSelected];
        [_checkAllBtn setImage: [UIImage imageNamed: @"选项-未选中"] forState: UIControlStateNormal];
        [_checkAllBtn setImage: [UIImage imageNamed: @"选项-选中"] forState: UIControlStateSelected];
        [_checkAllBtn setImageEdgeInsets: UIEdgeInsetsMake(0, 0, 0, 12.5 * KFitWidthRate)];
        [_checkAllBtn setTitleEdgeInsets: UIEdgeInsetsMake(0, 12.5 * KFitWidthRate, 0, 0)];
        _checkAllBtn.titleLabel.font = [UIFont systemFontOfSize: 12 * KFitWidthRate];
        [_checkAllBtn setTitleColor: KWt137Color forState: UIControlStateNormal];
        [_checkAllBtn setTitleColor: KWt137Color forState: UIControlStateSelected];
        [self addSubview: _checkAllBtn];
        [_checkAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(125 * KFitWidthRate, 40 * KFitWidthRate));
        }];
        [_checkAllBtn addTarget: self action: @selector(checkAllBtnClick) forControlEvents: UIControlEventTouchUpInside];
    }
    return _checkAllBtn;
}
- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [CBWtMINUtils createNoBorderBtnWithTitle:Localized(@"删除") titleColor: [UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: KWtBlueColor];
        _deleteBtn.layer.cornerRadius = 20*KFitWidthRate;
        [self addSubview: _deleteBtn];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(150*KFitWidthRate, 40*KFitWidthRate));
            make.centerX.equalTo(self);
            make.height.mas_equalTo(40*KFitWidthRate);
        }];
        [_deleteBtn addTarget: self action: @selector(deleteBtnClick) forControlEvents: UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
- (void)deleteBtnClick {
    if (self.deleteBtnClickBlock) {
        self.deleteBtnClickBlock();
    }
}

- (void)checkAllBtnClick {
    if (self.checkAllBtnClickBlock) {
        if (self.checkAllBtn.selected == NO) {
            self.checkAllBtn.selected = YES;
            self.checkAllBtnClickBlock(YES);
        } else {
            self.checkAllBtn.selected = NO;
            self.checkAllBtnClickBlock(NO);
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
