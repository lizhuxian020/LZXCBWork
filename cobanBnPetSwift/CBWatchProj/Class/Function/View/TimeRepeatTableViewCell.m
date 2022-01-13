//
//  TimeRepeatTableViewCell.m
//  Watch
//
//  Created by lym on 2018/2/11.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "TimeRepeatTableViewCell.h"

@interface TimeRepeatTableViewCell ()
//@property (nonatomic, strong) UILabel *repeatTimeLabel;
//@property (nonatomic, strong) UIButton *selectBtn;
@end

@implementation TimeRepeatTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.whiteColor;
        self.repeatTimeLabel = [CBWtMINUtils createLabelWithText: @"星期一" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: KWt137Color];
        [self addSubview: self.repeatTimeLabel];
        [self.repeatTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5 * KFitWidthRate);
            make.top.bottom.equalTo(self);
            make.width.offset(200 * KFitWidthRate);
        }];
        self.selectBtn = [[UIButton alloc] init];
        [self.selectBtn setImage: [UIImage imageNamed: @"选项-未选中"] forState: UIControlStateNormal];
        [self.selectBtn setImage: [UIImage imageNamed: @"选项-选中"] forState: UIControlStateSelected];
        [self addSubview: self.selectBtn];
        [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(40 * KFitWidthRate);
        }];
        [CBWtMINUtils addLineToView: self isTop: NO hasSpaceToSide: NO];
    }
    return self;
}
- (void)setModel:(WatchSettingScreenTimeModel *)model {
    _model = model;
    if (model) {
        self.repeatTimeLabel.text = model.screenTime;
        self.selectBtn.selected = model.isSelect;
    }
}
@end
