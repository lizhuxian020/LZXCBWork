//
//  _CBMyDeviceInfoView.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/12/6.
//  Copyright © 2022 coban. All rights reserved.
//

#import "_CBMyDeviceInfoView.h"

@interface _CBMyDeviceInfoView ()

@property (nonatomic, copy) NSArray *deviceInfoTitleArr;
@property (nonatomic, copy) NSArray *deviceInfoContentArr;
@property (nonatomic, copy) NSArray *carColorArr;
@property (nonatomic, copy) NSArray *purposeArr;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation _CBMyDeviceInfoView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    self.backgroundColor = kBackColor;
}

- (void)setModel:(MyDeviceModel *)model {
    _model = model;
    
    [self rebuildView];
}

- (void)rebuildView {
    self.deviceInfoTitleArr = @[
        Localized(@"图标"),
        Localized( @"设备IMEI"),
        Localized(@"电话号码"),
        Localized(@"车牌号码"),
        Localized(@"车辆颜色"),
        Localized(@"车辆VIN"),
        Localized(@"所属分组"),
        Localized(@"产品类型"),
        Localized(@"设备版本号"),
        Localized(@"注册日期"),
        Localized(@"有效期")];
   
    self.carColorArr = @[Localized(@"蓝色"), Localized(@"黄色"), Localized(@"黑色"), Localized(@"白色"), Localized(@"其他")];
    self.purposeArr = @[
        Localized(@"定位-默认"),
        Localized(@"人-默认"),
        Localized(@"宠物-默认"),
        Localized(@"自行车-默认"),
        Localized(@"摩托车-默认"),
        Localized(@"小车-默认"),
        Localized(@"货车-默认"),
        Localized(@"行李箱-默认"),
        Localized(@"船-默认"),
        Localized(@"电动车-默认"),
        Localized(@"公交车-默认")
    ];
    self.deviceInfoContentArr = @[
        @"",
        _model.dno?:@"",
        _model.devPhone?:@"",
        _model.carNum?:@"",
        _model.color < self.carColorArr.count ? self.carColorArr[_model.color] : @"",
        _model.vin?:@"",
        _model.groupNameStr?:@"",
        _model.devModel?:@"",
        _model.version?:@"",
        [MINUtils getTimeFromTimestamp:_model.registerTime formatter:@"yyyy-MM-dd HH:mm:ss"] ?:@"",
        [MINUtils getTimeFromTimestamp:_model.expireTime formatter:@"yyyy-MM-dd HH:mm:ss"] ?:@"",
    ];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.scrollView = [UIScrollView new];
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    self.contentView = [UIView new];
    self.contentView.backgroundColor = kBackColor;
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@0);
        make.width.equalTo(self.scrollView);
        make.bottom.equalTo(@0);
    }];
    
    UIView *lastView = nil;
    for(int i = 0; i < self.deviceInfoTitleArr.count; i++) {
        
        NSString *title = self.deviceInfoTitleArr[i];
        NSString *content = self.deviceInfoContentArr[i];
        UIView *view = [self viewWithTitle:title content:content img:nil];
        if (i == 0) {
            NSString *icon = _model.icon < self.purposeArr.count ? self.purposeArr[_model.icon] : @"";
            view = [self viewWithTitle:title content:content img:icon];
        }
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom);
            } else {
                make.top.equalTo(@0);
            }
        }];
        lastView = view;
    }
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
    }];
    
    
}

- (UIView *)viewWithTitle:(NSString *)title content:(NSString *)content img:(NSString *)img {
    UIView *view = [UIView new];
    UILabel *tLbl = [MINUtils createLabelWithText:title size:16 alignment:NSTextAlignmentLeft textColor:kCellTextColor];
    [view addSubview:tLbl];
    [tLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.left.equalTo(@15);
        make.bottom.equalTo(@-15);
    }];
    
    if (img) {
        UIImageView *imgView = [UIImageView new];
        [view addSubview:imgView];
        imgView.image = [UIImage imageNamed:img];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.right.equalTo(@-15);
        }];
    } else {
        UILabel *cLbl = [MINUtils createLabelWithText:content size:16 alignment:NSTextAlignmentLeft textColor:kCellTextColor];
        [view addSubview:cLbl];
        [cLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.right.equalTo(@-15);
        }];
    }
    
    return view;
}

@end
