//
//  ControlTableViewCell.m
//  Telematics
//
//  Created by lym on 2017/11/27.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "ControlTableViewCell.h"
#import "MINSwitchView.h"
#import "MINControlListDataModel.h"
#import "ConfigurationParameterModel.h"
#import "CBCarControlConfig.h"

@interface ControlTableViewCell() <MINSwtichViewDelegate>
{
    UIView *backView;
}
@end

@implementation ControlTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier: reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kBackColor;
//        backView = [MINUtils createViewWithRadius: 0 * KFitWidthRate];
        backView = [UIView new];
        [self.contentView addSubview: backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
            make.height.mas_equalTo(50);
        }];
        UIImage *controlImage = [UIImage imageNamed:@"超速"];
        _controlImageView = [[UIImageView alloc] initWithImage: controlImage];
        [backView addSubview: _controlImageView];
        [_controlImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backView);
            make.left.equalTo(backView).with.offset(12.5 * KFitWidthRate);
            make.height.mas_equalTo(controlImage.size.height * KFitHeightRate);
            make.width.mas_equalTo(controlImage.size.width * KFitHeightRate);
        }];
        _titleLabel = [MINUtils createLabelWithText:@"单次定位" size: 14 * KFitHeightRate alignment: NSTextAlignmentLeft textColor: kRGB(73, 73, 73)];
        _titleLabel.numberOfLines = 0;
        [backView addSubview: _titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView).with.offset(45 * KFitWidthRate);
            make.centerY.equalTo(backView);
//            make.height.mas_equalTo(40*KFitHeightRate);
//            make.width.mas_equalTo(180*KFitWidthRate);
        }];

        
        UIImage *detailImage = [UIImage imageNamed: @"右边"];
        _detailImageView = [[UIImageView alloc] initWithImage: detailImage];
        [backView addSubview: _detailImageView];
        [_detailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backView);
            make.right.equalTo(backView).with.offset(-12.5 * KFitWidthRate);
            make.size.mas_equalTo(CGSizeMake(detailImage.size.width * KFitHeightRate, detailImage.size.height * KFitHeightRate));
        }];
        
//        _switchView = [[MINSwitchView alloc] initWithOnImage:[UIImage imageNamed: @"开关-关"] offImage:[UIImage imageNamed: @"开关-开"] switchImage:[UIImage imageNamed: @"开关-按钮"]];
        _switchView = [UISwitch new];
//        _switchView.delegate = self;
        [_switchView addTarget:self action:@selector(switchViewDidChange:) forControlEvents:UIControlEventValueChanged];
        [backView addSubview: _switchView];
        [_switchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backView);
            make.right.equalTo(backView).with.offset(-35*KFitWidthRate);
//            make.size.mas_equalTo(CGSizeMake(75 * KFitWidthRate, 27 * KFitHeightRate));
        }];
        _centerLabel = [MINUtils createLabelWithText:@"" size:12 * KFitHeightRate alignment: NSTextAlignmentRight textColor: k137Color];
        _centerLabel.numberOfLines = 0;
        [backView addSubview: _centerLabel];
        [_centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backView);
            make.right.mas_equalTo(self->_switchView.mas_left).offset(-2*KFitWidthRate);
            make.height.mas_equalTo(40*KFitHeightRate);
        }];

        
        _detailLabel = [MINUtils createLabelWithText:@"" size:12 * KFitHeightRate alignment: NSTextAlignmentRight textColor: k137Color];
        _detailLabel.numberOfLines = 0;
        [backView addSubview: _detailLabel];
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backView);
            make.right.mas_equalTo(self->_detailImageView.mas_left).offset(-10*KFitWidthRate);
            make.height.mas_equalTo(40*KFitHeightRate);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = KCarLineColor;
        [backView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
            make.height.equalTo(@1);
            make.left.equalTo(_titleLabel);
            make.right.equalTo(_detailImageView);
        }];

    }
    return self;
}
- (NSArray *)restArr {
    return @[@[Localized(@"始终在线"), Localized(@"时间休眠"), Localized(@"振动休眠"), Localized(@"深度振动休眠"), Localized(@"定时报告"), Localized(@"定时报告+深度振动休眠")]];
}
- (void)setControlModel:(CBControlModel *)controlModel {
    _controlModel = controlModel;
    if (controlModel) {
        self.titleLabel.text = controlModel.titleStr;
        [self.controlImageView setImage:[UIImage imageNamed:controlModel.leftImageStr?:@""]];
        
        NSString *titleStr = controlModel.titleStr;
        self.detailLabel.hidden = NO;
        self.detailImageView.hidden = NO;
        self.switchView.hidden = NO;
        self.switchView.enabled = YES;
        // 控制
        if ([titleStr isEqualToString:_ControlConfigTitle_DCJW]) {
            self.detailLabel.hidden = YES;
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:_ControlConfigTitle_XMJWCL]) {
            self.detailLabel.hidden = YES;
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:_ControlConfigTitle_TT]) {
            self.detailLabel.hidden = YES;
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:_ControlConfigTitle_DYD]) {
            self.detailLabel.hidden = YES;
            self.switchView.hidden = YES;
//            [self.switchView updateSwitchImageView:@"断油断电"];
//            [self.switchView.switchImageBtn setImage: [UIImage imageNamed: @"开关-断油"] forState: UIControlStateSelected]; // offImage
//            [self.switchView.switchImageBtn setImage: [UIImage imageNamed: @"开关-加油"] forState: UIControlStateNormal]; // onImage
        } else if ([titleStr isEqualToString:_ControlConfigTitle_HFYD]) {
            self.switchView.hidden = YES;
            self.detailImageView.hidden = YES;
        } else if ([titleStr isEqualToString:_ControlConfigTitle_TZBJ]) {
            self.switchView.hidden = YES;
            self.detailImageView.hidden = YES;
        } else if ([titleStr isEqualToString:_ControlConfigTitle_SDJ]) {
            self.switchView.hidden = YES;
            self.detailImageView.hidden = YES;
        } else if ([titleStr isEqualToString:_ControlConfigTitle_YCKZ]) {
            self.switchView.hidden = YES;
            self.detailImageView.hidden = YES;
        } else if ([titleStr isEqualToString:_ControlConfigTitle_BFCF]) {
            self.detailLabel.hidden = YES;
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:_ControlConfigTitle_HFCX]) {
            self.detailLabel.hidden = YES;
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:_ControlConfigTitle_CSBJ]) {
            self.switchView.enabled = NO;
            self.detailLabel.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"电话唤醒")]) {
            self.switchView.hidden = YES;
            self.detailImageView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"电话回拨")]) {
            self.switchView.hidden = YES;
            self.detailImageView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"电子围栏")]) {
            self.detailLabel.hidden = YES;
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"请求OBD消息")]) {
            self.detailLabel.hidden = YES;
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"报警设置")]) {
            self.detailLabel.hidden = YES;
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"终端设置")]) {
            self.detailLabel.hidden = YES;
            self.switchView.hidden = YES;
        }
        // 报警设置
        else if ([titleStr isEqualToString:Localized(@"位移报警")]) {
            self.detailLabel.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"掉电报警")]) {
            self.detailLabel.hidden = YES;
            self.detailImageView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"低电报警")]) {
            self.detailLabel.hidden = YES;
            self.detailImageView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"盲区报警")]) {
            self.detailLabel.hidden = YES;
            self.detailImageView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"紧急报警")]) {
            self.detailLabel.hidden = YES;
            self.detailImageView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"振动报警")]) {
            self.detailLabel.hidden = YES;
            self.detailImageView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"油量检测报警")]) {
            self.detailLabel.hidden = YES;
            self.detailImageView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"保养通知")]) {
        }
        // 其他（待删，待梳理有无用处）
        else if ([titleStr isEqualToString:Localized(@"录音")]) {
            self.detailLabel.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"立即拍照")]) {
            self.detailLabel.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"信息服务下发")]) {
            self.detailLabel.hidden = YES;
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"云台控制")]) {
            self.detailLabel.hidden = YES;
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"多次拍照")]) {
            self.detailLabel.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"休眠模式")]) {
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"配置设备参数")]) {
            self.detailLabel.hidden = YES;
            self.switchView.hidden = YES;
        }
        // 终端设置
        else if ([titleStr isEqualToString:_ControlConfigTitle_SQSZ]) {
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:_ControlConfigTitle_SZYLJZ]) {
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"设置短信密码")]) {
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"设置授权号码")]) {
            self.detailLabel.hidden = YES;
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"初始化设置")]) {
            self.detailLabel.hidden = YES;
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"始终在线")]) {
            self.detailLabel.hidden = YES;
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"休眠模式")]) {
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"设置油箱容积(L)")]) {
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"设置里程初始值(m)")]) {
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"疲劳驾驶参数设置")]) {
            self.detailLabel.hidden = YES;
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"碰撞报警参数设置")]) {
            self.detailLabel.hidden = YES;
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:_ControlConfigTitle_ACCGZTZ]) {
            self.detailLabel.hidden = YES;
            self.detailImageView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"漂移抑制")]) {
            self.detailLabel.hidden = YES;
            self.detailImageView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"设置转弯补报角度(<180°)")]) {
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"设置报警短信发送次数")]) {
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"设置心跳间隔")]) {
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"设备重启")]) {
            self.detailLabel.hidden = YES;
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"振动灵敏度")]) {
            self.switchView.hidden = YES;
        } else if ([titleStr isEqualToString:Localized(@"服务器转移")]) {
            self.detailLabel.hidden = YES;
            self.switchView.hidden = YES;
        }
    }
}
- (void)setControlListModel:(MINControlListDataModel *)controlListModel {
    _controlListModel = controlListModel;
    if (controlListModel) {
        NSString *titleStr = _controlModel.titleStr;
        // 控制
        if ([titleStr isEqualToString:Localized(@"电话回拨")]) {
            self.detailLabel.hidden = NO;
            self.detailLabel.text = controlListModel.phone?:@"";
        } else if ([titleStr isEqualToString:_ControlConfigTitle_CSBJ]) {
            self.switchView.on = controlListModel.warmSpeed;
            self.centerLabel.text = [NSString stringWithFormat: @"%@Km/h", controlListModel.overWarm?:@"0"];
        } else if ([titleStr isEqualToString:Localized(@"多次定位")]) {
            self.switchView.on = !controlListModel.dcdd;
        } else if ([titleStr isEqualToString:Localized(@"断油断电")]) {
            self.switchView.on = !controlListModel.dydd;
        }
        // 报警设置
        else if ([titleStr isEqualToString:Localized(@"掉电报警")]) {
            self.switchView.on = !controlListModel.warmDiaodan;
        }  else if ([titleStr isEqualToString:Localized(@"低电报警")]) {
            self.switchView.on = !controlListModel.warmDidian;
        } else if ([titleStr isEqualToString:Localized(@"盲区报警")]) {
            self.switchView.on = !controlListModel.warnBlind;
        } else if ([titleStr isEqualToString:Localized(@"紧急报警")]) {
            self.switchView.on = !controlListModel.urgentWarn;
        } else if ([titleStr isEqualToString:Localized(@"振动报警")]) {
            self.switchView.on = !controlListModel.warmZd;
        } else if ([titleStr isEqualToString:Localized(@"油量检测报警")]) {
            self.switchView.on = !controlListModel.oilCheckWarn;
        } else if ([titleStr isEqualToString:Localized(@"保养通知")]) {
            self.switchView.on = !controlListModel.serviceFlag;
            if (kStringIsEmpty(controlListModel.serviceInterval)) {
                self.centerLabel.text = [NSString stringWithFormat: @"%@",@"请设置保养间隔"];
            } else {
                self.centerLabel.text = [NSString stringWithFormat:@"%@%@-%@KM",controlListModel.serviceInterval,Localized(@"天"),controlListModel.serviceMileage];//[NSString stringWithFormat: @"%@",@"请设置保养间隔"];
            }
        }
        // 终端设置
        else if ([titleStr isEqualToString:_ControlConfigTitle_SQSZ]) {
            self.detailLabel.text = _controlListModel.timeZone;
       } else if ([titleStr isEqualToString:Localized(@"休眠模式")]) {
            if (controlListModel.restMod < 6) {
                self.detailLabel.text = [self restArr][0][controlListModel.restMod];
            } else {
                self.detailLabel.text = Localized(@"始终在线");
            }
        } else if ([titleStr isEqualToString:_ControlConfigTitle_ACCGZTZ]) {
            self.switchView.on = !controlListModel.accNotice;
        } else if ([titleStr isEqualToString:Localized(@"漂移抑制")]) {
            self.switchView.on = !controlListModel.gpsFloat;
        } else if ([titleStr isEqualToString:Localized(@"振动灵敏度")]) {
            switch (controlListModel.sensitivity) {
                case 1:
                    self.detailLabel.text = Localized(@"高");
                    break;
                case 2:
                    self.detailLabel.text = Localized(@"中");
                    break;
                case 3:
                    self.detailLabel.text = Localized(@"低");
                    break;
                default:
                    break;
            }
        }
    } else {
        // isNO = YES 关闭状态， = NO 打开状态
        self.switchView.on = YES;
    }
}
- (void)setConfigurationModel:(ConfigurationParameterModel *)configurationModel {
    _configurationModel = configurationModel;
    if (configurationModel) {
        NSString *titleStr = self.controlModel.titleStr;
        if (([titleStr isEqualToString:Localized(@"设置油箱容积(L)")])) {
            self.detailLabel.text = [NSString stringWithFormat: @"%d", configurationModel.volume];
        } else if ([titleStr isEqualToString:Localized(@"设置里程初始值(m)")]) {
            self.detailLabel.text = [NSString stringWithFormat: @"%d", configurationModel.mileage];
        } else if ([titleStr isEqualToString:Localized(@"设置转弯补报角度(<180°)")]) {
            self.detailLabel.text = [NSString stringWithFormat: @"%d", configurationModel.angle];
        } else if ([titleStr isEqualToString:Localized(@"设置报警短信发送次数")]) {
            self.detailLabel.text = [NSString stringWithFormat: @"%d", configurationModel.sendMsgLimit];
        } else if ([titleStr isEqualToString:Localized(@"设置心跳间隔")]) {
            self.detailLabel.text = [NSString stringWithFormat: @"%@", configurationModel.heartbeatInterval];
        } else if ([titleStr isEqualToString:Localized(@"设置短信密码")]) {
            self.detailLabel.hidden = NO;
            self.detailLabel.text = configurationModel.password?:@"";
        }
    }
}
- (void)showDetailViewWithIndexPath:(NSIndexPath *)indexPath titleStr:(NSString *)titleStr {
    self.detailLabel.hidden = NO;
    self.detailImageView.hidden = NO;
    self.switchView.hidden = NO;
    
    [self.switchView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView).with.offset(-12.5 * KFitWidthRate);
    }];
    
    if ([titleStr isEqualToString:Localized(@"恢复原厂设置")]) {
        self.detailLabel.hidden = YES;
        self.switchView.hidden = YES;
    } else if ([titleStr isEqualToString:Localized(@"设置短信控制密码")]) {
        self.switchView.hidden = YES;
    } else if ([titleStr isEqualToString:Localized(@"设置授权号码")]) {
        self.detailLabel.hidden = YES;
        self.switchView.hidden = YES;
    } else if ([titleStr isEqualToString:Localized(@"设置转弯补报角度(180°)")]) {
        self.switchView.hidden = YES;
    } else if ([titleStr isEqualToString:Localized(@"设置里程初始值(m)")]) {
        self.switchView.hidden = YES;
    } else if ([titleStr isEqualToString:Localized(@"设置低压报警值(V)")]) {
        self.switchView.hidden = YES;
    } else if ([titleStr isEqualToString:Localized(@"设置油箱容积(L)")]) {
        self.switchView.hidden = YES;
    } else if ([titleStr isEqualToString:_ControlConfigTitle_SZYLJZ]) {
        self.detailLabel.hidden = YES;
        self.switchView.hidden = YES;
    } else if ([titleStr isEqualToString:Localized(@"电气锁转换")]) {
        self.detailImageView.hidden = YES;
        self.detailLabel.hidden = YES;
//        [self.switchView.switchImageBtn setImage: [UIImage imageNamed: @"开关-布防-撤防"] forState: UIControlStateSelected]; // offImage  @"开关-布防-撤防-1"
//        [self.switchView.switchImageBtn setImage: [UIImage imageNamed: @"开关-布防-撤防-1"] forState: UIControlStateNormal]; // onImage
    } else if ([titleStr isEqualToString:Localized(@"设置报警短信发送次数")]) {
        self.switchView.hidden = YES;
    } else if ([titleStr isEqualToString:Localized(@"设置心跳间隔")]) {
           self.switchView.hidden = YES;
    } else if ([titleStr isEqualToString:Localized(@"超速报警预警差值(1/100km/h)")]) {
        self.switchView.hidden = YES;
    } else if ([titleStr isEqualToString:Localized(@"消息应答超时机制")]) {
        self.detailLabel.hidden = YES;
        self.switchView.hidden = YES;
    } else if ([titleStr isEqualToString:Localized(@"疲劳驾驶参数设置")]) {
        self.detailLabel.hidden = YES;
        self.switchView.hidden = YES;
    } else if ([titleStr isEqualToString:Localized(@"碰撞报警参数设置")]) {
        self.detailLabel.hidden = YES;
        self.switchView.hidden = YES;
    } else if ([titleStr isEqualToString:Localized(@"网络设置")]) {
        self.detailLabel.hidden = YES;
        self.switchView.hidden = YES;
    } else if ([titleStr isEqualToString:Localized((@"设备重启"))]) {
        self.detailLabel.hidden = YES;
        self.switchView.hidden = YES;
    } else {
//        [self.switchView.switchImageBtn setImage: [UIImage imageNamed: @"开关-关"] forState: UIControlStateSelected]; // offImage
//        [self.switchView.switchImageBtn setImage: [UIImage imageNamed: @"开关-开"] forState: UIControlStateNormal]; // onImage
    }
}
- (void)switchView:(MINSwitchView *)switchView stateChange:(BOOL)isON {
    if (self.switchStateChangeBlock) {
        self.switchStateChangeBlock(self.indexPath, !isON);
    }
}
- (void)switchViewDidChange:(UISwitch *)switchView {
    if (self.switchStateChangeBlock) {
        self.switchStateChangeBlock(self.indexPath, !switchView.isOn);
    }
}
@end


@implementation CBControlModel
@end
