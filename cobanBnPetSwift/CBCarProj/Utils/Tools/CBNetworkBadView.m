//
//  CBNetworkBadView.m
//  Telematics
//
//  Created by coban on 2019/8/7.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBNetworkBadView.h"

@implementation CBNetworkBadView

- (instancetype)initWithGrail {
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
    UIButton *btnReload = [UIButton new];
    [self addSubview:btnReload];
    UIImage *image_off = [UIImage imageNamed:@"ic_cloud_off"];
    [btnReload setImage:image_off forState:UIControlStateNormal];
    [btnReload mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.center);
        make.size.mas_equalTo(CGSizeMake(image_off.size.width, image_off.size.height));
    }];
    [btnReload addTarget:self action:@selector(noNetworkReload) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel = [UILabel new];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(btnReload.mas_bottom).offset(15);
    }];
    // 暂无记录
    titleLabel.text = @"网络异常，点击重试~";//PPLanguage(@"PPLNorecords");
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
- (void)noNetworkReload {
    if (self.reloadBlock) {
        self.reloadBlock(@"");
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
