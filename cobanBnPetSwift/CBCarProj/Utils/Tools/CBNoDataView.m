//
//  CBNoDataView.m
//  Telematics
//
//  Created by coban on 2019/8/7.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBNoDataView.h"

@implementation CBNoDataView

- (instancetype)initWithGrail{
    if (self = [super init]) {
        [self initGrail];
    }
    return self;
}

- (instancetype)initWithMy{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithpp{
    if (self = [super init]) {
        [self initPP];
    }
    return self;
}
- (instancetype)initNoDeviceUI{
    if (self = [super init]) {
        [self initNoDevice];
    }
    return self;
}
- (void)initPP {
    UILabel *titleLabel = [UILabel new];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.center);
    }];
    // 暂无记录
    titleLabel.text = Localized(@"无数据");//PPLanguage(@"PPLtradingsystemupgrades");
    titleLabel.textColor = [UIColor colorWithHexString:@"#b1b1b1"];;
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:CBPingFangSC_Regular size:14];
    _titleLabel = titleLabel;
}

- (void)initGrail{
    UIImageView *imageView = [UIImageView new];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.center);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    imageView.image = [UIImage imageNamed:@"ic_empty"];
    _imageView_logo = imageView;
    
    UILabel *titleLabel = [UILabel new];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(15);
    }];
    // 暂无记录
    titleLabel.text = Localized(@"无数据");//PPLanguage(@"PPLNorecords");
    titleLabel.textColor = [UIColor colorWithHexString:@"#b1b1b1"];
    titleLabel.font = [UIFont fontWithName:CBPingFangSC_Regular size:14];
    _titleLabel = titleLabel;
}

- (void)initUI{
    UIImageView *imageView = [UIImageView new];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.center);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    imageView.image = [UIImage imageNamed:@"ic_empty"];
    _imageView_logo = imageView;
    
    UILabel *titleLabel = [UILabel new];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(15);
    }];
    // 暂无记录
    titleLabel.text = Localized(@"无数据");
    titleLabel.textColor = [UIColor colorWithHexString:@"#b1b1b1"];
    titleLabel.font = [UIFont fontWithName:CBPingFangSC_Regular size:14];
    _titleLabel = titleLabel;
}
- (void)initNoDevice {
    UIImageView *imageView = [UIImageView new];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.center);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    imageView.image = [UIImage imageNamed:@"ic_empty"];
    _imageView_logo = imageView;
    
    UILabel *titleLabel = [UILabel new];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(20);
    }];
    // 暂无记录
    titleLabel.text = Localized(@"未绑定设备");
    titleLabel.textColor = [UIColor colorWithHexString:@"#b1b1b1"];
    titleLabel.font = [UIFont fontWithName:CBPingFangSC_Regular size:14];
    _titleLabel = titleLabel;
    
    UIButton *bindBtn = [MINUtils createBtnWithRadius:20 * KFitHeightRate title: Localized(@"立即绑定")];
    [self addSubview:bindBtn];
    [bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_equalTo(40 * KFitHeightRate);
        make.width.mas_equalTo(150 * KFitHeightRate);
    }];
    [bindBtn addTarget:self action:@selector(bindDeviceAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)bindDeviceAction {
    if (self.noDataBlock != nil) {
        self.noDataBlock();
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
