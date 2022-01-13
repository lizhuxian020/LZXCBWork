//
//  CBTalkOthersTableViewCell.m
//  Watch
//
//  Created by coban on 2019/8/26.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBTalkOthersTableViewCell.h"
#import "CBTalkModel.h"

@interface CBTalkOthersTableViewCell ()
/** 轮廓背景 */
@property (nonatomic, strong) UIImageView *bgmImgView;
/** 未读圆点 */
@property (nonatomic, strong) UIView *pointView;
/** 头像 */
@property (nonatomic, strong) UIImageView *avatarImgView;
/** 昵称lab */
@property (nonatomic, strong) UILabel *nameLb;
/** 播放语音btn */
@property (nonatomic, strong) UIButton *playVoiceBtn;
/** 语音icon */
@property (nonatomic, strong) UIImageView *voiceImgView;
/** 时间lab */
@property (nonatomic, strong) UILabel *timeLb;
/**  */
@property (nonatomic, strong) NSMutableArray *arrayImg;

@end
@implementation CBTalkOthersTableViewCell

+  (instancetype)cellCopyTableView:(UITableView *)tableView {
    static NSString *cellID = @"CBTalkOthersTableViewCell";
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
- (void)setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    
    [self avatarImgView];
    [self nameLb];
    [self bgmImgView];
    [self pointView];
    [self voiceImgView];
    [self playVoiceBtn];
    [self timeLb];
}
#pragma mark -- setting && getting
- (UIImageView *)avatarImgView {
    if (!_avatarImgView) {
        _avatarImgView = [UIImageView new];
        _avatarImgView.image = [UIImage imageNamed:@"爸爸"];
        _avatarImgView.layer.masksToBounds = YES;
        _avatarImgView.layer.cornerRadius = 20*frameSizeRate;
        _avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImgView.backgroundColor = [UIColor redColor];
        [self addSubview:_avatarImgView];
        [_avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40*frameSizeRate, 40*frameSizeRate));
            make.bottom.mas_equalTo(self.mas_centerY).offset(10);
            make.left.mas_equalTo(20*frameSizeRate);
        }];
    }
    return _avatarImgView;
}
- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [UILabel new];
        _nameLb.font = [UIFont fontWithName:CBPingFangSC_Regular size:12];
        //_nameLb.backgroundColor = [UIColor greenColor];
        _nameLb.textAlignment = NSTextAlignmentCenter;
        _nameLb.numberOfLines = 0;
        _nameLb.text = @"阿里主图里主图乖阿芳的";
        [self addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.centerX.mas_equalTo(self.avatarImgView.mas_centerX);
            make.left.mas_equalTo(2*frameSizeRate);
            make.top.mas_equalTo(self.mas_centerY).offset(10);
            make.width.mas_equalTo(76*frameSizeRate);//80
        }];
    }
    return _nameLb;
}
- (UIImageView *)bgmImgView {
    if (!_bgmImgView) {
        _bgmImgView = [UIImageView new];
        _bgmImgView.image = [UIImage imageNamed:@"chatfrom_bg_friend_normal"];
        _bgmImgView.userInteractionEnabled = YES;
        [self addSubview:_bgmImgView];
        [_bgmImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(85*frameSizeRate, 55*frameSizeRate));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.avatarImgView.mas_right).offset(10*frameSizeRate);//15
        }];
    }
    return _bgmImgView;
}
- (UIView *)pointView {
    if (!_pointView) {
        _pointView = [UIView new];
        _pointView.backgroundColor = [UIColor redColor];
        _pointView.layer.masksToBounds = YES;
        _pointView.layer.cornerRadius = 5;
        [self addSubview:_pointView];
        [_pointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.left.mas_equalTo(self.bgmImgView.mas_right).offset(0);
            make.top.mas_equalTo(self.bgmImgView.mas_top).offset(2);
        }];
    }
    return _pointView;
}
- (UIButton *)playVoiceBtn {
    if (!_playVoiceBtn) {
        _playVoiceBtn = [UIButton new];
        [self.bgmImgView addSubview:_playVoiceBtn];
        [_playVoiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60*frameSizeRate, 40*frameSizeRate));
            make.centerX.mas_equalTo(self.bgmImgView.mas_centerX).offset(5);
            make.centerY.mas_equalTo(self.bgmImgView.mas_centerY).offset(-2);
        }];
        [_playVoiceBtn addTarget:self action:@selector(playVoicClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playVoiceBtn;
}
- (UIImageView *)voiceImgView {
    if (!_voiceImgView) {
        
        UIImage *imge = [UIImage imageNamed:@"chatto_voice_playing"];
        UIImage *imge1 = [UIImage imageNamed:@"chatto_voice_playing_f1"];
        UIImage *imge2 = [UIImage imageNamed:@"chatto_voice_playing_f2"];
        UIImage *imge3 = [UIImage imageNamed:@"chatto_voice_playing_f3"];
        
        _voiceImgView = [UIImageView new];
        _voiceImgView.image = [UIImage imageNamed:@"chatto_voice_playing"];
        _voiceImgView.userInteractionEnabled = YES;
        [self.bgmImgView addSubview:_voiceImgView];
        [_voiceImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(imge.size.width, imge.size.height));
            make.centerX.mas_equalTo(self.bgmImgView.mas_centerX).offset(5);
            make.centerY.mas_equalTo(self.bgmImgView.mas_centerY).offset(-4);
        }];
        // 动画图片组
        _voiceImgView.animationImages = @[imge1,imge2,imge3,imge];
        // 播放一次所需时长
        _voiceImgView.animationDuration = 1.0f;
        // 图片播放次数，0 表示无限
        _voiceImgView.animationRepeatCount = 0;
    }
    return _voiceImgView;
}
- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [UILabel new];
        _timeLb.font = [UIFont fontWithName:CBPingFangSC_Regular size:10];
        _timeLb.textAlignment = NSTextAlignmentCenter;
        _timeLb.textColor = [UIColor grayColor];
        _timeLb.numberOfLines = 0;
        _timeLb.text = @"2019-09-03 11:36:51";
        [self addSubview:_timeLb];
        [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.bgmImgView.mas_bottom).offset(0);
        }];
    }
    return _timeLb;
}
- (NSMutableArray *)arrayImg {
    if (!_arrayImg) {
        _arrayImg = [NSMutableArray arrayWithObjects:@"爸爸", @"妈妈", @"姐姐", @"爷爷", @"奶奶", @"哥哥", @"外公", @"外婆", @"老师", @"自定义", @"校讯通", nil];
    }
    return _arrayImg;
}
#pragma mark -- 播放语音
- (void)playVoicClick {
    if (self.playBlock) {
        self.playBlock(self.talkModel);
    }
}
- (void)setTalkModel:(CBTalkModel *)talkModel {
    _talkModel = talkModel;
    if (talkModel) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        _timeLb.text = [CBWtUtils timeWithTimeIntervalString:talkModel.create_time];
        _nameLb.text = talkModel.name;
        [_avatarImgView sd_setImageWithURL:[NSURL URLWithString:talkModel.head] placeholderImage:[UIImage imageNamed:self.arrayImg[talkModel.type.integerValue]] options:SDWebImageLowPriority | SDWebImageRetryFailed | SDWebImageRefreshCached];
        if ([talkModel.read isEqualToString:@"1"]) {
            _pointView.hidden = YES;
        } else {
            _pointView.hidden = NO;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begin) name:[NSString stringWithFormat:@"%@_begin",talkModel.create_time] object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop) name:[NSString stringWithFormat:@"%@_stop",talkModel.create_time] object:nil];
    }
}
- (void)begin {
    [self.voiceImgView startAnimating];
}
- (void)stop {
    [self.voiceImgView stopAnimating];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
