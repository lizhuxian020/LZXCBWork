//
//  CBTalkListTableViewCell.m
//  cobanBnWatch
//
//  Created by coban on 2019/12/4.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBTalkListTableViewCell.h"

@interface CBTalkListTableViewCell ()
@property (nonatomic,strong) UIView *cardView;
@property (nonatomic,strong) UIImageView *avatarImgView;
@property (nonatomic,strong) UILabel *unreadLb;
@property (nonatomic,strong) UILabel *talkNameLb;
@property (nonatomic,strong) UILabel *voiceLb;
@property (nonatomic,strong) UILabel *timeLb;
@end
@implementation CBTalkListTableViewCell

+ (instancetype)cellCopyTableView:(UITableView *)tableView {
    static NSString *cellID = @"CBTalkListTableViewCell";
    id cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupView];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.cardView.layer.cornerRadius = 4;
    self.cardView.layer.shadowColor = [UIColor grayColor].CGColor;//阴影颜色
    self.cardView.layer.shadowRadius = 4;                   //阴影半径
    self.cardView.layer.shadowOpacity = 0.3;                //阴影透明度
    self.cardView.layer.shadowOffset  = CGSizeMake(0, 3);   // 阴影偏移量
    
    self.avatarImgView.layer.masksToBounds = YES;
    self.avatarImgView.layer.cornerRadius = 30;
    
    self.unreadLb.layer.masksToBounds = YES;
    self.unreadLb.layer.cornerRadius = 10;
}
- (void)setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //self.backgroundColor = [UIColor whiteColor];
    
    [self cardView];
    [self avatarImgView];
    [self unreadLb];
    [self talkNameLb];
    [self voiceLb];
    [self timeLb];
}
#pragma mark -- setting && getting
- (UIView *)cardView {
    if (!_cardView) {
        _cardView = [UIView new];
        _cardView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_cardView];
        [_cardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(15*frameSizeRate);
            make.right.mas_equalTo(-15*frameSizeRate);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _cardView;
}
- (UIImageView *)avatarImgView {
    if (!_avatarImgView) {
        _avatarImgView = [UIImageView new];
        _avatarImgView.image = [UIImage imageNamed:@"chat_mem"];
        _avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImgView.backgroundColor = UIColor.yellowColor;
        [self addSubview:_avatarImgView];
        [_avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.centerY.mas_equalTo(self.cardView.mas_centerY);
            make.left.mas_equalTo(self.cardView.mas_left).offset(15*frameSizeRate);
        }];
    }
    return _avatarImgView;
}
- (UILabel *)unreadLb {
    if (!_unreadLb) {
        _unreadLb = [UILabel new];
        _unreadLb.font = [UIFont fontWithName:CBPingFangSC_Regular size:12];
        _unreadLb.textAlignment = NSTextAlignmentCenter;
        _unreadLb.numberOfLines = 0;
        _unreadLb.text = @"19";
        _unreadLb.backgroundColor = UIColor.redColor;
        _unreadLb.textColor = UIColor.whiteColor;
        [self addSubview:_unreadLb];
        [_unreadLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.avatarImgView.mas_right).offset(-5);
            make.centerY.mas_equalTo(self.avatarImgView.mas_top).offset(5);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    return _unreadLb;
}
- (UILabel *)talkNameLb {
    if (!_talkNameLb) {
        _talkNameLb = [UILabel new];
        _talkNameLb.font = [UIFont fontWithName:CBPingFang_SC_Bold size:18];
        _talkNameLb.textAlignment = NSTextAlignmentCenter;
        _talkNameLb.numberOfLines = 0;
        _talkNameLb.text = Localized(@"家庭群聊");
        _talkNameLb.textColor = UIColor.blackColor;
        [self addSubview:_talkNameLb];
        [_talkNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.cardView.mas_centerY).offset(-3);
            make.left.mas_equalTo(self.avatarImgView.mas_right).offset(15*frameSizeRate);
        }];
    }
    return _talkNameLb;
}
- (UILabel *)voiceLb {
    if (!_voiceLb) {
        _voiceLb = [UILabel new];
        _voiceLb.font = [UIFont fontWithName:CBPingFangSC_Regular size:14];
        _voiceLb.textAlignment = NSTextAlignmentCenter;
        _voiceLb.textColor = UIColor.redColor;
        _voiceLb.text = Localized(@"[语音]");
        [self addSubview:_voiceLb];
        [_voiceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avatarImgView.mas_centerY).offset(3);
            make.left.mas_equalTo(self.avatarImgView.mas_right).offset(15*frameSizeRate);
        }];
    }
    return _voiceLb;
}
- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [UILabel new];
        _timeLb.font = [UIFont fontWithName:CBPingFangSC_Regular size:14];
        _timeLb.textAlignment = NSTextAlignmentRight;
        _timeLb.numberOfLines = 0;
        _timeLb.text = @"11:49";
        _timeLb.textColor = [UIColor grayColor];
        [self addSubview:_timeLb];
        [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.cardView.mas_centerY);
            make.right.mas_equalTo(self.cardView.mas_right).offset(-15*frameSizeRate);
        }];
    }
    return _timeLb;
}
- (void)setTalkListModel:(CBTalkListModel *)talkListModel {
    _talkListModel = talkListModel;
    if (talkListModel) {
        _timeLb.text = [CBWtUtils timeWithTimeIntervalString:talkListModel.create_time];
        _talkNameLb.text = talkListModel.name;
        [_avatarImgView sd_setImageWithURL:[NSURL URLWithString:talkListModel.head] placeholderImage:[UIImage imageNamed:@"默认宝贝头像"] options:SDWebImageLowPriority | SDWebImageRetryFailed | SDWebImageRefreshCached];
        _unreadLb.text = talkListModel.unRead;
        if (talkListModel.unRead.integerValue <= 0) {
            _unreadLb.hidden = YES;
            _unreadLb.font = [UIFont fontWithName:CBPingFangSC_Regular size:12];
        } else if (talkListModel.unRead.integerValue > 99) {
            _unreadLb.hidden = NO;
            _unreadLb.font = [UIFont fontWithName:CBPingFangSC_Regular size:9];
            _unreadLb.text = @"99+";
        } else {
            _unreadLb.hidden = NO;
            _unreadLb.font = [UIFont fontWithName:CBPingFangSC_Regular size:12];
        }
        _voiceLb.textColor = kStringIsEmpty(talkListModel.unRead)?UIColor.grayColor:UIColor.redColor;
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        //[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setDateFormat:@"HH:mm"];
        // 毫秒值转化为秒
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[talkListModel.create_time doubleValue]/1000.0];
        NSString *dateString = [formatter stringFromDate:date];
        
        
        NSDate *time = [CBWtMINUtils getDateFromTimestamp:talkListModel.create_time];
        NSDate *nowTime = [NSDate date];
        NSTimeInterval timeInterval = [time timeIntervalSinceDate:nowTime];
        // 取绝对值
        timeInterval = fabs(timeInterval);
        //NSString *timeString = nil;
        long temp = 0;
        if (timeInterval < 60) {
            //timeString = Localized(@"刚刚");//@"1分钟以内";
        } else if ((temp = timeInterval/60)<60) {
            //timeString = [NSString stringWithFormat:@"%ld%@",temp,Localized(@"分钟前")];
        } else if ((temp = timeInterval/(60*60))<24) {
            //timeString = [NSString stringWithFormat:@"%ld%@",temp,Localized(@"小时前")];
        } else if ((temp = timeInterval/(24*60*60))<30) {
            //timeString = [NSString stringWithFormat:@"%ld%@",temp,Localized(@"天前")];
            [formatter setDateFormat:@"MM/dd"];
            date = [NSDate dateWithTimeIntervalSince1970:[talkListModel.create_time doubleValue]/1000.0];
            dateString = [formatter stringFromDate:date];
        } else if (((temp = timeInterval/(24*60*60*30)))<12) {
            //timeString = [NSString stringWithFormat:@"%ld%@",temp,Localized(@"月前")];
            [formatter setDateFormat:@"yyyy/MM/dd"];
            date = [NSDate dateWithTimeIntervalSince1970:[talkListModel.create_time doubleValue]/1000.0];
            dateString = [formatter stringFromDate:date];
        } else {
            //temp = timeInterval/(24*60*60*30*12);
            //timeString = [NSString stringWithFormat:@"%ld%@",temp,Localized(@"年前")];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            date = [NSDate dateWithTimeIntervalSince1970:[talkListModel.create_time doubleValue]/1000.0];
            dateString = [formatter stringFromDate:date];
        }
        _timeLb.text = dateString;//[Utils timeWithTimeIntervalString:talkListModel.create_time];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
