//
//  CBFriendListTableViewCell.m
//  Watch
//
//  Created by coban on 2019/8/27.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBFriendListTableViewCell.h"
#import "CBFriendModel.h"

@interface CBFriendListTableViewCell ()
@property (nonatomic, strong) UIView *bgmView;
@property (nonatomic, strong) UIButton *statusBtn;
@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *phoneLb;
@end
@implementation CBFriendListTableViewCell

+  (instancetype)cellCopyTableView:(UITableView *)tableView {
    static NSString *cellID = @"CBFriendListTableViewCell";
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
    self.backgroundColor = KWtBackColor;
    
    [self bgmView];
    [self statusBtn];
    [self avatarImgView];
    [self nameLb];
    [self phoneLb];
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
            make.size.mas_equalTo(CGSizeMake(0, imgSelect.size.height));
        }];
    }
    return _statusBtn;
}
- (UIImageView *)avatarImgView {
    if (!_avatarImgView) {
        _avatarImgView = [UIImageView new];
        _avatarImgView.layer.masksToBounds = YES;
        _avatarImgView.layer.cornerRadius = 25*frameSizeRate;
        [self addSubview:_avatarImgView];
        [_avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bgmView.mas_centerY);
            make.left.mas_equalTo(self.statusBtn.mas_right).offset(15*frameSizeRate);
            make.size.mas_equalTo(CGSizeMake(50*frameSizeRate, 50*frameSizeRate));
        }];
    }
    return _avatarImgView;
}
- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [CBWtMINUtils createLabelWithText:@"watcjsdfd" size:14 alignment:NSTextAlignmentLeft textColor:KWtBlackColor];
        _nameLb.textColor = KWtBlackColor;
        [self addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.avatarImgView.mas_centerY).offset(-5);
            make.left.mas_equalTo(self.avatarImgView.mas_right).offset(15*frameSizeRate);
            make.height.mas_equalTo(21*frameSizeRate);
        }];
    }
    return _nameLb;
}
- (UILabel *)phoneLb {
    if (!_phoneLb) {
        _phoneLb = [CBWtMINUtils createLabelWithText:@"1003" size:14 alignment:NSTextAlignmentLeft textColor:KWtBlackColor];
        _phoneLb.textColor = KWtLoginPartColor;
        [self addSubview:_phoneLb];
        [_phoneLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avatarImgView.mas_centerY).offset(5);
            make.left.mas_equalTo(self.avatarImgView.mas_right).offset(15*frameSizeRate);
            make.height.mas_equalTo(21*frameSizeRate);
        }];
    }
    return _phoneLb;
}
- (void)selectAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _friendModel.isCheck = sender.selected;
    kWeakSelf(self);
    if (self.selectFriendBlock) {
        kStrongSelf(self);
        self.selectFriendBlock(self.friendModel.ids);
    }
}
- (void)setFriendModel:(CBFriendModel *)friendModel {
    _friendModel = friendModel;
    if (friendModel) {
        if (friendModel.isEdit) {
            UIImage *imgSelect = [UIImage imageNamed:@"选项-选中"];
            [_statusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.bgmView.mas_left).offset(12.5*KFitWidthRate);
                make.centerY.mas_equalTo(self.bgmView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(imgSelect.size.width, imgSelect.size.height));
            }];
            self.statusBtn.selected = friendModel.isCheck;
        } else {
            UIImage *imgNormal = [UIImage imageNamed:@"选项-未选中"];
            [_statusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.bgmView.mas_left).offset(12.5*KFitWidthRate);
                make.centerY.mas_equalTo(self.bgmView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(0, imgNormal.size.height));
            }];
        }
        // 含中文url 需要编码
        NSString *headUrl = [friendModel.head stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [_avatarImgView sd_setImageWithURL:[NSURL URLWithString:headUrl?:@""] placeholderImage:[UIImage imageNamed:@"icon-60"] options:SDWebImageLowPriority | SDWebImageRetryFailed | SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"%@",error);
        }];
        _nameLb.text = friendModel.name?:Localized(@"未知");
        _phoneLb.text = friendModel.phone?:Localized(@"未知");
        //CBWtUserLoginModel *userInfo = [CBWtUserLoginModel CBaccount];
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
