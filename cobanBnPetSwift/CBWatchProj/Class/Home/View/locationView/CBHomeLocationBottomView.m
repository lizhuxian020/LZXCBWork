//
//  CBHomeLocationBottomView.m
//  Watch
//
//  Created by coban on 2019/8/16.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBHomeLocationBottomView.h"

@interface CBHomeLocationBottomView ()

/** 头像ImageView */
@property (nonatomic,strong) UIImageView *avtarImgView;
/** 状态view */
@property (nonatomic,strong) UILabel *labStatus;
/** 步数view */
@property (nonatomic,strong) UILabel *labStep;

@end
@implementation CBHomeLocationBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    [self avtarImgView];
    [self labStatus];
    [self labStep];
}
#pragma mark -- setting && getting
- (UIImageView *)avtarImgView {
    if (!_avtarImgView) {
        _avtarImgView = [UIImageView new];
        _avtarImgView.layer.masksToBounds = YES;
        _avtarImgView.layer.cornerRadius = 25*frameSizeRate;
        _avtarImgView.contentMode = UIViewContentModeScaleAspectFill;
        //_avtarImgView.backgroundColor = [UIColor redColor];
        [self addSubview:_avtarImgView];
        [_avtarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(15*frameSizeRate);
            make.size.mas_equalTo(CGSizeMake(50*frameSizeRate, 50*frameSizeRate));
        }];
    }
    return _avtarImgView;
}
- (UILabel *)labStatus {
    if (!_labStatus) {
        
        UILabel *labTitle = [UILabel new];
        labTitle.font = [UIFont fontWithName:CBPingFangSC_Regular size:12];
        labTitle.textColor = KWtRGB(73, 73, 73);
        labTitle.text = [NSString stringWithFormat:@"%@:",Localized(@"状态")];
        [self addSubview:labTitle];
        [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avtarImgView.mas_top);
            make.left.mas_equalTo(self.avtarImgView.mas_right).offset(10*frameSizeRate);
        }];
        
        _labStatus = [UILabel new];
        _labStatus.text = @"";
        _labStatus.textColor = KWt137Color;
        _labStatus.font = [UIFont fontWithName:CBPingFangSC_Regular size:12];
        [self addSubview:_labStatus];
        [_labStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avtarImgView.mas_top);
            make.left.mas_equalTo(labTitle.mas_right).offset(10*frameSizeRate);
        }];
    }
    return _labStatus;
}
- (UILabel *)labStep {
    if (!_labStep) {
        
        UILabel *labTitle = [UILabel new];
        labTitle.font = [UIFont fontWithName:CBPingFangSC_Regular size:12];
        labTitle.textColor = KWtRGB(73, 73, 73);
        labTitle.text = [NSString stringWithFormat:@"%@:",Localized(@"今日步数")];
        [self addSubview:labTitle];
        [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.avtarImgView.mas_bottom);
            make.left.mas_equalTo(self.avtarImgView.mas_right).offset(10*frameSizeRate);
        }];
        
        _labStep = [UILabel new];
        _labStep.text = @"";
        _labStep.textColor = KWt137Color;
        _labStep.font = [UIFont fontWithName:CBPingFangSC_Regular size:12];
        [self addSubview:_labStep];
        [_labStep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.avtarImgView.mas_bottom);
            make.left.mas_equalTo(labTitle.mas_right).offset(10*frameSizeRate);
        }];
    }
    return _labStep;
}
- (void)setHomeInfoModel:(HomeModel *)homeInfoModel {
    _homeInfoModel = homeInfoModel;
    if (homeInfoModel) {
        //"status": "2,1",//状态1-欠压报警，2-拆除报警，，4-迟到，5-逗留，6-未按时到家  7-到校  8-离校  9-到家  10-离家
        if ([homeInfoModel.tbWatchMain.status containsString:@"1"] || [homeInfoModel.tbWatchMain.status containsString:@"2"] || [homeInfoModel.tbWatchMain.status containsString:@"4"] || [homeInfoModel.tbWatchMain.status containsString:@"5"] || [homeInfoModel.tbWatchMain.status containsString:@"6"]) {
            _labStatus.textColor = [UIColor redColor];
        } else {
           _labStatus.textColor = KWt137Color;
        }
        NSArray *arrayStatus = [homeInfoModel.tbWatchMain.status componentsSeparatedByString:@","];
        NSMutableArray *arrayStatusStr = [NSMutableArray array];
        for (NSString *str in arrayStatus) {
            NSString *statusDes = [self returnStatusStr:str];
            if (!kStringIsEmpty(statusDes)) {
                [arrayStatusStr addObject:statusDes];
            }
        }
        
        
        [_avtarImgView sd_setImageWithURL:[NSURL URLWithString:homeInfoModel.tbWatchMain.head?:@""] placeholderImage:[UIImage imageNamed:@"默认宝贝头像"] options:SDWebImageLowPriority | SDWebImageRetryFailed | SDWebImageRefreshCached];
        
        NSString *statusStr = [arrayStatusStr componentsJoinedByString:@","];
        if (kStringIsEmpty(statusStr)) {
            _labStatus.text = [NSString stringWithFormat:@"%@",Localized(@"状态正常")];
        } else {
            _labStatus.text = [NSString stringWithFormat:@"%@",statusStr];
        }
        
        _labStep.text = [NSString stringWithFormat:@"%@ %@",homeInfoModel.tbWatchMain.stepSport?:@"",Localized(@"步")];
    }
}
- (NSString *)returnStatusStr:(NSString *)str {
    switch (str.integerValue) {
        case 1:
        {
            return Localized(@"欠压报警");
        }
            break;
        case 2:
        {
            return Localized(@"拆除报警");
        }
            break;
        case 4:
        {
            return Localized(@"迟到");
        }
            break;
        case 5:
        {
            return Localized(@"逗留");
        }
            break;
        case 6:
        {
            return Localized(@"未按时到家");
        }
            break;
        case 7:
        {
            return Localized(@"到校");
        }
            break;
        case 8:
        {
            return Localized(@"离校");
        }
            break;
        case 9:
        {
            return Localized(@"到家");
        }
            break;
        case 10:
        {
            return Localized(@"离家");
        }
            break;
        default:
        {
            return @"";
        }
            break;
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
