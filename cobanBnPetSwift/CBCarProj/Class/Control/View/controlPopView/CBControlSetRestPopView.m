//
//  CBControlSetRestPopView.m
//  Telematics
//
//  Created by coban on 2019/11/22.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBControlSetRestPopView.h"

@interface CBControlSetRestPopView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIView *bgmView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UIButton *pickBtn;
@property (nonatomic,strong) UIButton *certainBtn;
@property (nonatomic,strong) UIButton *cancelBtn;

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UITableView *pickerTableView;
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,strong) NSMutableArray *arrayDataRestType;
@property (nonatomic,strong) NSMutableArray *arrayDataUnit;

@property (nonatomic,strong) UILabel *timePadingLb;
@property (nonatomic,strong) UITextField *timePadingTF;
@property (nonatomic,strong) UIButton *pickUnitBtn;
@property (nonatomic,copy) NSArray *restArray;
@end
@implementation CBControlSetRestPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.contentView.layer.shadowRadius = 10;//5 * KFitWidthRate;
    self.contentView.layer.shadowOpacity = 1;//0.3;
    self.contentView.layer.shadowOffset  = CGSizeMake(0, 10);//CGSizeMake(0, 5);// 阴影的范围
}
- (void)setupView {
    self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taphandle:)];
    [self addGestureRecognizer:tap];
    tap.delegate = self;
    
    [self bgmView];
    [self titleLb];
    [self pickBtn];
    [self cancelBtn];
    [self certainBtn];
    
    [self contentView];
    [self pickerTableView];
    
    [self pickUnitBtn];
    [self timePadingTF];
    [self timePadingLb];
}
- (UIView *)bgmView {
    if (!_bgmView) {
        _bgmView = [UIView new];
        _bgmView.backgroundColor = [UIColor whiteColor];
        _bgmView.layer.masksToBounds = YES;
        _bgmView.layer.cornerRadius = 6*frameSizeRate;
        [self addSubview:_bgmView];
        [_bgmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30*frameSizeRate);
            make.right.mas_equalTo(-30*frameSizeRate);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(160*KFitHeightRate);
        }];
    }
    return _bgmView;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [MINUtils createLabelWithText:Localized(@"休眠模式")size: 18 * KFitWidthRate alignment: NSTextAlignmentCenter textColor:kRGB(51, 51, 51)];
        _titleLb.numberOfLines = 0;
        _titleLb.font = [UIFont fontWithName:CBPingFang_SC_Bold size:18*KFitWidthRate];
        [self.bgmView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.equalTo(self.bgmView);
            make.height.mas_equalTo(45 * KFitHeightRate);
            make.left.right.equalTo(self.bgmView);
        }];
    }
    return _titleLb;
}
- (UIButton *)pickBtn {
    if (!_pickBtn) {
        _pickBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"") titleColor: kRGB(96, 96, 96) fontSize: 15 * KFitWidthRate backgroundColor:UIColor.whiteColor];
        _pickBtn.layer.masksToBounds = YES;
        _pickBtn.layer.borderColor = kTextFieldColor.CGColor;
        _pickBtn.layer.borderWidth = 1.0f;
        [_pickBtn addTarget:self action:@selector(pickTypeClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bgmView addSubview:_pickBtn];
        [_pickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgmView.mas_left).offset(10);
            make.right.equalTo(self.bgmView.mas_right).offset(-10);
            make.top.mas_equalTo(self.titleLb.mas_bottom).offset(10);
            make.height.mas_equalTo(35*KFitHeightRate);
        }];
        
        UIImage *img = [UIImage imageNamed:@"下拉三角"];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
        [_pickBtn addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_pickBtn.mas_centerY);
            make.right.mas_equalTo(_pickBtn.mas_right).offset(-5);
        }];
    }
    return _pickBtn;
}
- (NSMutableArray *)arrayDataRestType {
    if (!_arrayDataRestType) {
        _arrayDataRestType = [NSMutableArray arrayWithObjects:Localized(@"时间休眠"),Localized(@"振动休眠"),Localized(@"深度振动休眠"),Localized(@"定时报告"),Localized(@"定时报告+深度振动休眠"),nil];
    }
    return _arrayDataRestType;
}
- (NSMutableArray *)arrayDataUnit {
    if (!_arrayDataUnit) {
        _arrayDataUnit = [NSMutableArray arrayWithObjects:@"s",@"m",@"h",nil];
    }
    return _arrayDataUnit;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgmView.mas_left).offset(10);
            make.right.equalTo(self.bgmView.mas_right).offset(-10);
            make.top.mas_equalTo(self.titleLb.mas_bottom).offset(10);
            make.height.mas_equalTo(0*KFitHeightRate);
        }];
    }
    return _contentView;
}
- (UITableView *)pickerTableView {
    if (!_pickerTableView) {
        _pickerTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 100, 100) style:UITableViewStylePlain];
        _pickerTableView.delegate = self;
        _pickerTableView.dataSource = self;
        _pickerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentView addSubview:_pickerTableView];
        [_pickerTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 5, 0, 5));
        }];
    }
    return _pickerTableView;
}
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"取消") titleColor: kRGB(96, 96, 96) fontSize: 15 * KFitWidthRate backgroundColor: kRGB(215, 215, 215)];
        [_cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self.bgmView addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgmView.mas_left).offset(10);
            make.right.equalTo(self.certainBtn.mas_left).offset(-10);
            make.bottom.mas_equalTo(self.bgmView.mas_bottom).offset(-10);
            make.width.mas_equalTo(self.certainBtn.mas_width);
            make.height.mas_equalTo(45 * KFitHeightRate);
        }];
    }
    return _cancelBtn;
}
- (UIButton *)certainBtn {
    if (!_certainBtn) {
        _certainBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"确定") titleColor: [UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: kBlueColor];
        [_certainBtn addTarget:self action:@selector(certain) forControlEvents:UIControlEventTouchUpInside];
        [self.bgmView addSubview:_certainBtn];
        [_certainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cancelBtn.mas_right).offset(10);
            make.right.equalTo(self.bgmView.mas_right).offset(-10);
            make.bottom.mas_equalTo(self.bgmView.mas_bottom).offset(-10);
            make.width.mas_equalTo(self.cancelBtn.mas_width);
            make.height.mas_equalTo(45 *KFitHeightRate);
        }];
    }
    return _certainBtn;
}
- (UIButton *)pickUnitBtn {
    if (!_pickUnitBtn) {
        _pickUnitBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"") titleColor: kRGB(96, 96, 96) fontSize: 15 * KFitWidthRate backgroundColor:UIColor.whiteColor];
        _pickUnitBtn.layer.masksToBounds = YES;
        _pickUnitBtn.layer.borderColor = kTextFieldColor.CGColor;
        _pickUnitBtn.layer.borderWidth = 1.0f;
        [_pickUnitBtn addTarget:self action:@selector(pickUnitClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bgmView addSubview:_pickUnitBtn];
        [_pickUnitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(60*frameSizeRate);
            make.right.equalTo(self.bgmView.mas_right).offset(-10);
            make.top.mas_equalTo(self.pickBtn.mas_bottom).offset(10);
            make.height.mas_equalTo(35*KFitHeightRate);
        }];
        _pickUnitBtn.hidden = YES;
        
        UIImage *img = [UIImage imageNamed:@"下拉三角"];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
        [_pickUnitBtn addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_pickUnitBtn.mas_centerY);
            make.right.mas_equalTo(_pickUnitBtn.mas_right).offset(-5);
        }];
    }
    return _pickUnitBtn;
}
- (UITextField *)timePadingTF {
    if (!_timePadingTF) {
        _timePadingTF = [MINUtils createTextFieldWithHoldText:@""  fontSize: 15];
        _timePadingTF.keyboardType = UIKeyboardTypeNumberPad;
        _timePadingTF.layer.masksToBounds = YES;
        _timePadingTF.layer.borderColor = kTextFieldColor.CGColor;//kRGB(215, 215, 215).CGColor;
        _timePadingTF.layer.cornerRadius = 4;
        _timePadingTF.layer.borderWidth = 1.0f;
        _timePadingTF.textAlignment = NSTextAlignmentCenter;
        _timePadingTF.hidden = YES;
        [self.bgmView addSubview:_timePadingTF];
        [_timePadingTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.pickUnitBtn.mas_left).offset(-10);
            make.centerY.mas_equalTo(self.pickUnitBtn.mas_centerY);
            make.height.mas_equalTo(35*KFitHeightRate);
            make.width.mas_equalTo(100*frameSizeRate);
        }];

    }
    return _timePadingTF;
}
- (UILabel *)timePadingLb {
    if (!_timePadingLb) {
        _timePadingLb = [MINUtils createLabelWithText:Localized(@"时间间隔")size: 16 * KFitWidthRate alignment: NSTextAlignmentLeft textColor:kRGB(96, 96, 96)];
        _timePadingLb.numberOfLines = 0;
        _timePadingLb.hidden = YES;
        [self.bgmView addSubview:_timePadingLb];
        [_timePadingLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.timePadingTF.mas_centerY);
            make.left.mas_equalTo(self.bgmView.mas_left).offset(10);
        }];
    }
    return _timePadingLb;
}
- (void)pickTypeClick {
    self.arrayData = self.arrayDataRestType;
    [self.pickerTableView reloadData];
    //告知需要更改约束
    //[self setNeedsUpdateConstraints];
    [self.contentView.superview layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgmView.mas_left).offset(10);
            make.right.equalTo(self.bgmView.mas_right).offset(-10);
            make.top.mas_equalTo(self.titleLb.mas_bottom).offset(10);
            make.height.mas_equalTo(45*self.arrayData.count);
        }];
        [self.contentView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}
- (void)pickUnitClick {
    self.arrayData = self.arrayDataUnit;
    [self.pickerTableView reloadData];
    //告知需要更改约束
    //[self setNeedsUpdateConstraints];
    //[self.contentView.superview layoutIfNeeded];
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45*self.arrayData.count);
        make.right.equalTo(self.bgmView.mas_right).offset(-10);
        make.top.mas_equalTo(self.pickUnitBtn.mas_top).offset(0);
        make.width.mas_equalTo(60*KFitHeightRate);
    }];
}
- (void)cancel {
    [self dismiss];
}
- (void)certain {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerRestPopViewClickIndex:time:unit:)]) {
        [self.delegate pickerRestPopViewClickIndex:[self getRestIndexWithStr:self.pickBtn.titleLabel.text] time:self.timePadingTF.text unit:self.pickUnitBtn.titleLabel.text];
    }
    [self dismiss];
}
#pragma mark -------------- 手势代理方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (CGRectContainsPoint(self.pickerTableView.frame, [gestureRecognizer locationInView:self]) ) {
        return NO;
    } else {
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgmView.mas_left).offset(10);
            make.right.equalTo(self.bgmView.mas_right).offset(-10);
            make.top.mas_equalTo(self.titleLb.mas_bottom).offset(10);
            make.height.mas_equalTo(0*frameSizeRate);
        }];
        return NO;
    }
}
- (void)taphandle:(UITapGestureRecognizer*)sender {
    //[self dismiss];
}
- (NSUInteger)getRestIndexWithStr:(NSString *)type {
    __block NSInteger index = 0;
    for (int i = 0 ; i < self.arrayDataRestType.count ; i ++ ) {
        if ([type isEqualToString:self.arrayDataRestType[i]]) {
            index = i+1;
        }
    }
    return index;
}
- (void)updateType:(NSString *)type {
    NSString *titleStr = @"";
    switch (type.integerValue) {
        case 0:
            titleStr = Localized(@"时间休眠");
            break;
        case 1:
            titleStr = Localized(@"时间休眠");
            break;
        case 2:
            titleStr = Localized(@"振动休眠");
            break;
        case 3:
            titleStr = Localized(@"深度振动休眠");
            break;
        case 4:
            titleStr = Localized(@"定时报告");
            break;
        case 5:
            titleStr = Localized(@"定时报告+深度振动休眠");
            break;
        default:
            break;
    }
    [self.pickBtn setTitle:titleStr forState:UIControlStateNormal];
    [self.pickUnitBtn setTitle:Localized(@"s") forState:UIControlStateNormal];
    if ([titleStr isEqualToString:Localized(@"定时报告")] || [titleStr isEqualToString:Localized(@"定时报告+深度振动休眠")] || (self.arrayData.count <= 3 && self.arrayData != nil)) {
        [self setHiddenMethod:NO];
        [self.bgmView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30*frameSizeRate);
            make.right.mas_equalTo(-30*frameSizeRate);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(160*KFitHeightRate + 10 + 35*KFitHeightRate);
        }];
        if (self.arrayData.count <= 3) {
            [self.pickUnitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(60*frameSizeRate);
                make.right.equalTo(self.bgmView.mas_right).offset(-10);
                make.top.mas_equalTo(self.pickBtn.mas_bottom).offset(10);
                make.height.mas_equalTo(35*KFitHeightRate);
            }];
        }
    } else {
        [self setHiddenMethod:YES];
        [self.bgmView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30*frameSizeRate);
            make.right.mas_equalTo(-30*frameSizeRate);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(160*KFitHeightRate); //160
        }];
    }
}
- (void)setHiddenMethod:(BOOL)isHidden {
    self.pickUnitBtn.hidden = isHidden;
    self.timePadingTF.hidden = isHidden;
    self.timePadingLb.hidden = isHidden;
}
- (void)popView {
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgmView.mas_left).offset(10);
        make.right.equalTo(self.bgmView.mas_right).offset(-10);
        make.top.mas_equalTo(self.titleLb.mas_bottom).offset(10);
        make.height.mas_equalTo(0*frameSizeRate);
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
- (void)dismiss {
    [self removeFromSuperview];
}
#pragma mark -- UITableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45*frameSizeRate;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"popViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.arrayData[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 收起tableView
    if (self.arrayData.count > 3) {
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgmView.mas_left).offset(10);
            make.right.equalTo(self.bgmView.mas_right).offset(-10);
            make.top.mas_equalTo(self.titleLb.mas_bottom).offset(10);
            make.height.mas_equalTo(0*frameSizeRate);
        }];
        [self.pickBtn setTitle:self.arrayData[indexPath.row] forState:UIControlStateNormal];
    } else {
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgmView.mas_left).offset(10);
            make.right.equalTo(self.bgmView.mas_right).offset(-10);
            make.top.mas_equalTo(self.titleLb.mas_bottom).offset(10);
            make.height.mas_equalTo(0*frameSizeRate);
        }];
        [self.pickUnitBtn setTitle:self.arrayData[indexPath.row] forState:UIControlStateNormal];
    }
    // 选择后，重新布局
    if (self.arrayData.count > indexPath.row) {
        NSString *title = self.arrayData[indexPath.row];
        if ([title isEqualToString:Localized(@"定时报告")] || [title isEqualToString:Localized(@"定时报告+深度振动休眠")] || self.arrayData.count <= 3) {
            [self setHiddenMethod:NO];
            [self.bgmView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(30*frameSizeRate);
                make.right.mas_equalTo(-30*frameSizeRate);
                make.centerY.mas_equalTo(self.mas_centerY);
                make.height.mas_equalTo(160*KFitHeightRate + 10 + 35*KFitHeightRate);
            }];
            if (self.arrayData.count <= 3) {
                [self.pickUnitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(60*frameSizeRate);
                    make.right.equalTo(self.bgmView.mas_right).offset(-10);
                    make.top.mas_equalTo(self.pickBtn.mas_bottom).offset(10);
                    make.height.mas_equalTo(35*KFitHeightRate);
                }];
            }
        } else {
            [self setHiddenMethod:YES];
            [self.bgmView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(30*frameSizeRate);
                make.right.mas_equalTo(-30*frameSizeRate);
                make.centerY.mas_equalTo(self.mas_centerY);
                make.height.mas_equalTo(160*KFitHeightRate);
            }];
        }
    }
}
@end
