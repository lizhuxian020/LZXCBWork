//
//  CBAvatarAnnotationView.m
//  Watch
//
//  Created by coban on 2019/8/16.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBAvatarAnnotationView.h"

@interface CBAvatarAnnotationView ()
/** 头像底部图片 */
@property (nonatomic, strong) UIImageView *defaultImgView;
/** 头像imageView */
@property (nonatomic, strong) UIImageView *avtarImgView;

//@property (nonatomic, strong) UILabel *statusLb;
@property (nonatomic,strong) UIButton *btnStatus;
@end
@implementation CBAvatarAnnotationView
- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        _statusLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 36)];
//        _statusLb.text = @"状态正常";
//        _statusLb.layer.masksToBounds = YES;
//        _statusLb.layer.cornerRadius = 18.0f;
//        _statusLb.backgroundColor = KWtRGB(26, 151, 251);
//        _statusLb.textColor = [UIColor whiteColor];
//        _statusLb.textAlignment = NSTextAlignmentCenter;
//        _statusLb.hidden = YES;
//        [self addSubview:_statusLb];
        
        //arrow-右边-白
        UIImage *imgArrow = [UIImage imageNamed:@"arrow-右边-白"];
        _btnStatus = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 36)];
        [_btnStatus setTitle:@"状态正常" forState:UIControlStateNormal];
        [_btnStatus setImage:imgArrow forState:UIControlStateNormal];
        _btnStatus.layer.masksToBounds = YES;
        _btnStatus.layer.cornerRadius = 18.0f;
        _btnStatus.backgroundColor = KWtRGB(26, 151, 251);
        [_btnStatus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnStatus.titleLabel.textAlignment = NSTextAlignmentCenter;
        _btnStatus.hidden = YES;
        [self addSubview:_btnStatus];
        [_btnStatus horizontalCenterTitleAndImage:10];
        _btnStatus.adjustsImageWhenHighlighted = NO;
        [_btnStatus addTarget:self action:@selector(annotationClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *imageDefault = [UIImage imageNamed:@"宝贝定位头像-空"];
        [self setBounds:CGRectMake(0.f, 0.f, imageDefault.size.width, imageDefault.size.height)];
        _defaultImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.0, imageDefault.size.width, imageDefault.size.height)];
        _defaultImgView.userInteractionEnabled = YES;
        _defaultImgView.image = imageDefault;
        [self addSubview:_defaultImgView];
        
        _avtarImgView = [UIImageView new];
        [_defaultImgView addSubview:_avtarImgView];
        [_avtarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.defaultImgView.mas_centerX);
            make.top.mas_equalTo(self.defaultImgView.mas_top).offset(5);
            make.size.mas_equalTo(CGSizeMake(imageDefault.size.width*0.6, imageDefault.size.width*0.6));
        }];
        _avtarImgView.userInteractionEnabled = YES;
        _avtarImgView.layer.masksToBounds = YES;
        _avtarImgView.layer.cornerRadius = (imageDefault.size.width*0.6)/2;
        _avtarImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}
- (void)setIconImage:(UIImage *)iconImage {
    _iconImage = iconImage;
    if (iconImage) {
        _avtarImgView.image = iconImage;
    }
}
- (void)setStatusStr:(NSString *)statusStr {
    _statusStr = statusStr;
    if (statusStr) {
        _btnStatus.hidden = NO;

        if ([statusStr containsString:@"1"] || [statusStr containsString:@"2"] || [statusStr containsString:@"4"] || [statusStr containsString:@"5"] || [statusStr containsString:@"6"] || [statusStr containsString:@"7"]) {
            statusStr = Localized(@"状态异常");
            _btnStatus.backgroundColor = [UIColor redColor];
            //_statusLb.text = statusStr;
            [_btnStatus setTitle:statusStr forState:UIControlStateNormal];
        } else {
            statusStr = Localized(@"状态正常");
            _btnStatus.backgroundColor = KWtRGB(26, 151, 251);
            //_statusLb.text = statusStr;
            [_btnStatus setTitle:statusStr forState:UIControlStateNormal];
        }
        
        UIImage *imageDefault = [UIImage imageNamed:@"宝贝定位头像-空"];
        
        CGFloat width = [NSString getWidthWithText:statusStr font:[UIFont systemFontOfSize:17.0] height:36];
        width = width <= 80?(80+30):(width + 30);
        _btnStatus.frame = CGRectMake(0, 0, width, 36);
        [_btnStatus horizontalCenterTitleAndImage:10];
        
        [self setBounds:CGRectMake(0.f, 0.f, width, 41 + imageDefault.size.height)];
        _defaultImgView.frame = CGRectMake((width - imageDefault.size.width)/2, 41.0, imageDefault.size.width, imageDefault.size.height);
    } else {
        _btnStatus.hidden = YES;
    }
}
- (void)setHomeModel:(HomeModel *)homeModel {
    _homeModel = homeModel;
    if (homeModel) {
        UIImage *imageDefault = [UIImage imageNamed:@"宝贝定位头像-空"];
        UIImage *imageAlarm = [UIImage imageNamed:@"宝贝定位头像-空-报警"];
        
        //"status": "2,1",//状态1-欠压报警，2-拆除报警，，4-迟到，5-逗留，6-未按时到家  7-到校  8-离校  9-到家  10-离家
        if ([homeModel.tbWatchMain.status containsString:@"1"] || [homeModel.tbWatchMain.status containsString:@"2"] || [homeModel.tbWatchMain.status containsString:@"4"] || [homeModel.tbWatchMain.status containsString:@"5"] || [homeModel.tbWatchMain.status containsString:@"6"]) {
            _defaultImgView.image = imageAlarm;
        } else {
            _defaultImgView.image = imageDefault;
        }
    }
}
- (void)annotationClick {
    if (self.avtarClickBlock) {
        self.avtarClickBlock(@"");
    }
}
@end
