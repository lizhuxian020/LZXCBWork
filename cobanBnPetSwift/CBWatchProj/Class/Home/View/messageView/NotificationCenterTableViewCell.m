//
//  NotificationCenterTableViewCell.m
//  Watch
//
//  Created by lym on 2018/3/7.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "NotificationCenterTableViewCell.h"
#import "MessageModel.h"

@interface NotificationCenterTableViewCell()

@property (nonatomic, strong) UIView *bgmView;
@property (nonatomic, strong) UIButton *statusBtn;

@end

@implementation NotificationCenterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
        [self addAction];
    }
    return self;
}

- (void)addAction
{
    [self.refuseBtn addTarget: self action: @selector(refuseBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [self.agreeBtn addTarget: self action: @selector(agreeBtnClick) forControlEvents: UIControlEventTouchUpInside];
}

- (void)refuseBtnClick
{
    if (self.refuseBtnClickBlock) {
        self.refuseBtnClickBlock();
    }
//    self.refuseBtn.hidden = YES;
//    self.agreeBtn.hidden = YES;
//    self.applyStatueLabel.hidden = NO;
//    self.applyStatueLabel.text = @"已拒绝";
}

- (void)agreeBtnClick
{
    if (self.agreeBtnClickBlock) {
        self.agreeBtnClickBlock();
    }
//    self.refuseBtn.hidden = YES;
//    self.agreeBtn.hidden = YES;
//    self.applyStatueLabel.hidden = NO;
//    self.applyStatueLabel.text = @"已同意";
}
- (void)setupView {
    self.contentView.backgroundColor = KWtBackColor;
    [self bgmView];
    [self statusBtn];
    
    self.notiTypeImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"位置反馈"]];
    [self.bgmView addSubview: self.notiTypeImageView];
    [self.notiTypeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.statusBtn.mas_right).offset(12.5 * KFitWidthRate);
        make.centerY.mas_equalTo(self.bgmView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60*frameSizeRate, 60*frameSizeRate));
    }];
    self.titleLabel = [CBWtMINUtils createLabelWithText: @"" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor:[UIColor blackColor]];
    self.titleLabel.font = [UIFont fontWithName:CBPingFang_SC_Bold size:15*frameSizeRate];
    [self.bgmView addSubview: self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.notiTypeImageView.mas_right).offset(12.5 * KFitWidthRate);
        make.bottom.equalTo(self.notiTypeImageView.mas_top).with.offset(10 * KFitWidthRate);
        make.height.mas_equalTo(20 * KFitWidthRate);
    }];
    self.timeLabel = [CBWtMINUtils createLabelWithText: @"今天 11:31" size: 12 * KFitWidthRate alignment: NSTextAlignmentRight textColor: KWt137Color];
    [self.bgmView addSubview: self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgmView).with.offset(-20 * KFitWidthRate);
        make.centerY.equalTo(self.titleLabel);
        make.height.mas_equalTo(20 * KFitWidthRate);
    }];
    self.detailLabel = [CBWtMINUtils createLabelWithText: @"" size: 12 alignment:NSTextAlignmentLeft textColor:KWt137Color];
    self.detailLabel.numberOfLines = 0;
    [self.bgmView addSubview: self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgmView.mas_centerY);
        make.right.equalTo(self.bgmView).with.offset(-20 * KFitWidthRate);
        make.left.equalTo(self.titleLabel);
    }];

    self.agreeBtn = [CBWtMINUtils createNoBorderBtnWithTitle:Localized(@"同意") titleColor: [UIColor whiteColor] fontSize: 12 * KFitWidthRate  backgroundColor: KWtBlueColor Radius: 13 * KFitWidthRate];
    [self.bgmView addSubview: self.agreeBtn];
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgmView).with.offset(-20 * KFitWidthRate);
        make.bottom.equalTo(self.bgmView).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(26 * KFitWidthRate);
        make.width.mas_equalTo(60 * KFitWidthRate);
    }];
    self.refuseBtn = [CBWtMINUtils createNoBorderBtnWithTitle:Localized(@"拒绝") titleColor: [UIColor whiteColor] fontSize: 12 * KFitWidthRate  backgroundColor: KWtLineColor Radius: 13 * KFitWidthRate];
    [self.bgmView addSubview: self.refuseBtn];
    [self.refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.agreeBtn.mas_left).with.offset(-15 * KFitWidthRate);
        make.bottom.equalTo(self.bgmView).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(26 * KFitWidthRate);
        make.width.mas_equalTo(60 * KFitWidthRate);
    }];
    self.agreeBtn.hidden = YES;
    self.refuseBtn.hidden = YES;
    
    self.applyStatueLabel = [CBWtMINUtils createLabelWithText:Localized(@"已拒绝") size: 12 * KFitWidthRate alignment: NSTextAlignmentRight textColor: KWt137Color];
    [self.bgmView addSubview: self.applyStatueLabel];
    [self.applyStatueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgmView).with.offset(-20 * KFitWidthRate);
        make.bottom.equalTo(self.bgmView).with.offset(-12.5 * KFitWidthRate);
        make.height.mas_equalTo(20 * KFitWidthRate);
    }];
}
#pragma mark -- gettsing && setting
- (UIView *)bgmView {
    if (!_bgmView) {
        _bgmView = [UIView new];
        _bgmView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgmView];
        [_bgmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.and.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-15*KFitWidthRate);
        }];
    }
    return _bgmView;
}
- (UIButton *)statusBtn {
    if (!_statusBtn) {
        _statusBtn = [UIButton new];
        UIImage *imgSelect = [UIImage imageNamed:@"选项-选中"];
        UIImage *imgNormal = [UIImage imageNamed:@"选项-未选中"];
        [_statusBtn setEnlargeEdge:15*KFitWidthRate];
        [_statusBtn setImage:imgNormal forState:UIControlStateNormal];
        [_statusBtn setImage:imgSelect forState:UIControlStateSelected];
        [_statusBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_statusBtn];
        [_statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bgmView.mas_left).offset(12.5*KFitWidthRate);
            make.centerY.mas_equalTo(self.bgmView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(imgSelect.size.width, imgSelect.size.height));
        }];
    }
    return _statusBtn;
}
// 位置反馈 参数设置 上学守护信息 报警 监护人申请
- (void)selectAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _messageModel.isCheck = sender.selected;
}
- (void)setMessageModel:(MessageModel *)messageModel {
    _messageModel = messageModel;
    if (messageModel) {
        
        if (messageModel.isEdit) {
            UIImage *imgSelect = [UIImage imageNamed:@"选项-选中"];
            [_statusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.bgmView.mas_left).offset(12.5*KFitWidthRate);
                make.centerY.mas_equalTo(self.bgmView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(imgSelect.size.width, imgSelect.size.height));
            }];
            self.statusBtn.selected = messageModel.isCheck;
        } else {
            UIImage *imgNormal = [UIImage imageNamed:@"选项-未选中"];
            [_statusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.bgmView.mas_left).offset(12.5*KFitWidthRate);
                make.centerY.mas_equalTo(self.bgmView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(0, imgNormal.size.height));
            }];
        }
        // type 为nil时，默认为0
        messageModel.type = messageModel.type?messageModel.type:0;
        
        // 0-监护人申请，1-欠压报警，2-拆除报警，3-进/出区域，4-迟到，5-逗留，6-未按时到家
        self.titleLabel.text = [self typeStr:messageModel.type isRead:messageModel.isRead];
        _messageModel.title = self.titleLabel.text;
        
        NSString *status = [self statusStr:messageModel.status];
        if ([status isEqualToString:Localized(@"待处理")]) {
            if (messageModel.status) {
                self.agreeBtn.hidden = NO;
                self.refuseBtn.hidden = NO;
                self.applyStatueLabel.text = @"";
            } else {
                self.agreeBtn.hidden = YES;
                self.refuseBtn.hidden = YES;
                self.applyStatueLabel.text = @"";
            }
        } else {
            self.agreeBtn.hidden = YES;
            self.refuseBtn.hidden = YES;
            self.applyStatueLabel.text = status;
        }
        self.timeLabel.text = [CBWtMINUtils getTimeFromTimestamp:messageModel.createTime formatter: @"yyyy-MM-dd HH:mm:ss"];
        
        if (messageModel.type == 0) {
            //监护人申请
            [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.notiTypeImageView.mas_right).offset(12.5 * KFitWidthRate);
                make.bottom.equalTo(self.notiTypeImageView.mas_top).with.offset(10 * KFitWidthRate);
                make.height.mas_equalTo(20 * KFitWidthRate);
            }];
            [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bgmView).with.offset(-20 * KFitWidthRate);
                make.centerY.equalTo(self.titleLabel);
                make.height.mas_equalTo(20 * KFitWidthRate);
            }];
            [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.bgmView.mas_centerY);
                make.right.equalTo(self.bgmView).with.offset(-20 * KFitWidthRate);
                make.left.equalTo(self.titleLabel);
            }];
            messageModel.cellHeigt = 60*frameSizeRate + 15 + 40;
        } else {
            [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.notiTypeImageView.mas_right).offset(12.5 * KFitWidthRate);
                make.bottom.equalTo(self.notiTypeImageView.mas_top).with.offset(25*KFitWidthRate);
                make.height.mas_equalTo(20 * KFitWidthRate);
            }];
            [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bgmView).with.offset(-20 * KFitWidthRate);
                make.centerY.equalTo(self.titleLabel);
                make.height.mas_equalTo(20 * KFitWidthRate);
            }];
            [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.notiTypeImageView.mas_bottom).offset(-5);
                make.right.equalTo(self.bgmView).with.offset(-20 * KFitWidthRate);
                make.left.equalTo(self.titleLabel);
            }];
            messageModel.cellHeigt = 60*frameSizeRate + 15 + 20;
        }
    }
}
- (NSString *)statusStr:(NSString *)status {
    switch (status.integerValue) {
    case 0:
        return Localized(@"待处理");
        break;
    case 1:
        return Localized(@"已接受");
        break;
    case 2:
        return Localized(@"已拒绝");
        break;
    default:
        return @"";
        break;
    }
}
- (NSString *)typeStr:(NSUInteger)type isRead:(BOOL)isRead {
    switch (type) {
        case 0:
        {
//            if (isRead == YES) {
//                [self.notiTypeImageView setImage: [UIImage imageNamed: @"监护人申请"]];
//            }else {
//                [self.notiTypeImageView setImage: [UIImage imageNamed: @"监护人申请-未读"]];
//            }
            [self.notiTypeImageView setImage: [UIImage imageNamed: @"监护人申请"]];
            self.detailLabel.text = [NSString stringWithFormat:@"%@%@",_messageModel.phone?:Localized(@"未知号码"),Localized(@"申请成为监护人,是否同意?")];
            self.messageModel.content = self.detailLabel.text;
            return Localized(@"监护人申请");
        }
            break;
        case 1:
        {
            if (isRead == YES) {
                [self.notiTypeImageView setImage: [UIImage imageNamed: @"报警"]];
            } else {
                [self.notiTypeImageView setImage: [UIImage imageNamed: @"报警信息-未读"]];
            }
            self.detailLabel.text = Localized(@"手表电量低,请及时充电");
            self.messageModel.content = Localized(@"手机电量已低于20%,请及时连接USB充电");
            return Localized(@"电量低");//@"欠压报警";
        }
            break;
        case 2:
        {
            if (isRead == YES) {
                [self.notiTypeImageView setImage: [UIImage imageNamed: @"报警"]];
            } else {
                [self.notiTypeImageView setImage: [UIImage imageNamed: @"报警信息-未读"]];
            }
            self.detailLabel.text = Localized(@"拆除报警");
            self.messageModel.content = self.detailLabel.text;
            return Localized(@"拆除报警");;
        }
            break;
        case 3:
        {
            if (isRead == YES) {
                [self.notiTypeImageView setImage: [UIImage imageNamed: @"位置反馈"]];
            } else {
                [self.notiTypeImageView setImage: [UIImage imageNamed: @"位置反馈-未读"]];
            }
            self.detailLabel.text = Localized(@"进/出区域");
            self.messageModel.content = self.detailLabel.text;
            return Localized(@"进/出区域");
        }
            break;
        case 4:
        {
            if (isRead == YES) {
                [self.notiTypeImageView setImage: [UIImage imageNamed: @"上学守护信息"]];
            } else {
                [self.notiTypeImageView setImage: [UIImage imageNamed: @"上学守护信息-未读"]];
            }
            self.detailLabel.text = Localized(@"上学迟到");
            self.messageModel.content = Localized(@"上学时间到了,宝贝还未到达学校");
            return Localized(@"迟到");
        }
            break;
        case 5:
        {
            if (isRead == YES) {
                [self.notiTypeImageView setImage: [UIImage imageNamed: @"上学守护信息"]];
            } else {
                [self.notiTypeImageView setImage: [UIImage imageNamed: @"上学守护信息-未读"]];
            }
            self.detailLabel.text = Localized(@"在学校逗留");
            self.messageModel.content = Localized(@"已放学超过30分钟了,宝贝还在学校逗留");
            return Localized(@"逗留");
        }
            break;
        case 6:
        {
            if (isRead == YES) {
                [self.notiTypeImageView setImage: [UIImage imageNamed: @"上学守护信息"]];
            } else {
                [self.notiTypeImageView setImage: [UIImage imageNamed: @"上学守护信息-未读"]];
            }
            self.detailLabel.text = Localized(@"未按时到家");
            self.messageModel.content = Localized(@"最晚回家时间到了，宝贝还未回家");
            return Localized(@"未按时到家");
        }
            break;
        case 7:
        {
            if (isRead == YES) {
                [self.notiTypeImageView setImage: [UIImage imageNamed: @"位置反馈"]];
            } else {
                [self.notiTypeImageView setImage: [UIImage imageNamed: @"位置反馈-未读"]];
            }
            self.detailLabel.text = Localized(@"到达学校区域");
            self.messageModel.content = Localized(@"宝贝已经到达学校");
            return Localized(@"到校");
        }
            break;
        case 8:
        {
            if (isRead == YES) {
                [self.notiTypeImageView setImage: [UIImage imageNamed: @"报警"]];
            } else {
                [self.notiTypeImageView setImage: [UIImage imageNamed: @"报警信息-未读"]];
            }
            self.detailLabel.text = Localized(@"离开学校区域");
            self.messageModel.content = self.detailLabel.text;
            return Localized(@"离校");
        }
            break;
        case 9:
        {
            if (isRead == YES) {
                [self.notiTypeImageView setImage: [UIImage imageNamed: @"报警"]];
            } else {
                [self.notiTypeImageView setImage: [UIImage imageNamed: @"报警信息-未读"]];
            }
            self.detailLabel.text = Localized(@"到达家庭区域");
            self.messageModel.content = self.detailLabel.text;
            return Localized(@"到家");
        }
            break;
        case 10:
        {
            if (isRead == YES) {
                [self.notiTypeImageView setImage: [UIImage imageNamed: @"报警"]];
            } else {
                [self.notiTypeImageView setImage: [UIImage imageNamed: @"报警信息-未读"]];
            }
            self.detailLabel.text = Localized(@"离开家庭区域");
            self.messageModel.content = self.detailLabel.text;
            return Localized(@"离家");
        }
            break;
        default:
            self.detailLabel.text = [NSString stringWithFormat:@""];
            self.messageModel.content = @"";
            return @"";
            break;
    }
}

@end
