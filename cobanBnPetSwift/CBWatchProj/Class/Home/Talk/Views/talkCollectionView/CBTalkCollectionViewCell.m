//
//  CBTalkCollectionViewCell.m
//  Watch
//
//  Created by coban on 2019/9/6.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBTalkCollectionViewCell.h"
/* oc 调用 swift*/
#import "cobanBnPetSwift-Swift.h"

@interface CBTalkCollectionViewCell ()
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) NSMutableArray *imageArr;
@end
@implementation CBTalkCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    [self iconImageView];
    [self titleLabel];
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.image = [UIImage imageNamed:@"LOGO1"];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 60*frameSizeRate/2;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(60*frameSizeRate, 60*frameSizeRate));
        }];
    }
    return _iconImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"团长特供发";
        _titleLabel.textColor = [UIColor colorWithHexString:@"#282828"];
        _titleLabel.font = [UIFont fontWithName:CBPingFangSC_Regular size:14*fontRate];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(2);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(20*frameSizeRate);
        }];
    }
    return _titleLabel;
}
- (NSMutableArray *)imageArr {
    if (!_imageArr) {
        _imageArr = [NSMutableArray arrayWithObjects:@"爸爸", @"妈妈", @"姐姐", @"爷爷", @"奶奶", @"哥哥", @"外公", @"外婆", @"老师", @"自定义", @"校讯通", nil];
    }
    return _imageArr;
}
- (void)setTalkModel:(CBTalkMemberModel *)talkModel {
    _talkModel = talkModel;
    if (talkModel) {
        _titleLabel.text = talkModel.relation;
        if (!kStringIsEmpty(talkModel.relation)) {
            if ([talkModel.phone isEqualToString:[CBPetLoginModelTool getUser].phone]) {
                _titleLabel.text = Localized(@"我");
            } else {
                _titleLabel.text = talkModel.relation;
            }
        } else {
            _titleLabel.text = talkModel.name;
        }
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:talkModel.head] placeholderImage:[UIImage imageNamed:self.imageArr[self.talkModel.type.integerValue]] options:SDWebImageLowPriority | SDWebImageRetryFailed | SDWebImageRefreshCached];
        if (talkModel.isAddBtn) {
            _titleLabel.text = Localized(@"添加");
            _iconImageView.image = [UIImage imageNamed:@"chat_add"];
        }
    }
}
@end
