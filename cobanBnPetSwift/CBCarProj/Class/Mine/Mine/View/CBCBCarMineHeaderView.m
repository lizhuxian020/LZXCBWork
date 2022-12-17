//
//  CBCBCarMineHeaderView.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/20.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBCBCarMineHeaderView.h"

#define __CM_SelectedColor UIColor.blackColor
#define __CM_NormalColor UIColor.grayColor
#define __CM_SelectedFont [UIFont systemFontOfSize:19]
#define __CM_NormalFont [UIFont systemFontOfSize:14]

@interface CBCBCarMineHeaderView ()

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) NSArray<UIView *> *subTitleArr;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) NSMutableArray<UILabel *> *titleArr;

@property (nonatomic, assign) int index;
@end

@implementation CBCBCarMineHeaderView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.dataSource = @[Localized(@"设备管理"), Localized(@"分组管理"), Localized(@"子账户管理")];
    
    UILabel *lastLbl = nil;
    NSMutableArray *mArr = [NSMutableArray new];
    int baseTag = 100;
    for (NSString *title in self.dataSource) {
        UILabel *lbl = [[UILabel alloc] init];
        lbl.text = title;
        lbl.font = baseTag == 100 ? __CM_SelectedFont : __CM_NormalFont;
        lbl.textColor =baseTag == 100 ? __CM_SelectedColor : __CM_NormalColor;
        [self addSubview:lbl];
        [mArr addObject:lbl];
        
        lbl.tag = baseTag++;
        
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            if (lastLbl) {
                make.left.equalTo(lastLbl.mas_right).mas_offset(10);
            } else {
                make.left.equalTo(@(15*KFitWidthRate));
            }
                
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTitle:)];
        
        [lbl addGestureRecognizer:tap];
        
        lbl.userInteractionEnabled  =YES;
        lastLbl = lbl;
    }
    
    [self createSubTitle];
    
    self.titleArr = mArr;
    self.line = [UIView new];
    self.line.backgroundColor = UIColor.blackColor;
    [self addSubview:self.line];
    
}

- (void)createSubTitle {
    
    UIButton *scanBtn = [MINUtils createBtnWithNormalImage:[UIImage imageNamed:@"扫码"] selectedImage:[UIImage imageNamed:@"扫码"]];
    UITapGestureRecognizer *scanBtnTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickAdd:)];
    [scanBtn addGestureRecognizer:scanBtnTap];
    
    
    UILabel *addGroupLbl = [UILabel new];
    addGroupLbl.text = @"添加组";
    addGroupLbl.textColor = kAppMainColor;
    addGroupLbl.font = __CM_NormalFont;
    addGroupLbl.userInteractionEnabled  =YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickAdd:)];
    [addGroupLbl addGestureRecognizer:tap];
    
    UILabel *addSubAccountLbl = [UILabel new];
    addSubAccountLbl.text = @"添加";
    addSubAccountLbl.textColor = kAppMainColor;
    addSubAccountLbl.font = __CM_NormalFont;
    addSubAccountLbl.userInteractionEnabled  =YES;
    UITapGestureRecognizer *addSubAccountLblTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickAdd:)];
    [addSubAccountLbl addGestureRecognizer:addSubAccountLblTap];
    
    self.subTitleArr = @[scanBtn, addGroupLbl, addSubAccountLbl];
    
    for (UIView *view in self.subTitleArr) {
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.right.equalTo(@-15);
        }];
        view.hidden = YES;
    }
    scanBtn.hidden = NO;
}

- (void)didMoveToIndex:(int)index {
    if (index == self.index) {
        return;
    }
    [self unSelected:self.index];
    [self didSelected:index];
}

- (void)didClickTitle:(UITapGestureRecognizer *)tap {
    int index = tap.view.tag - 100;
    if (index == self.index) {
        return;
    }
    [self unSelected:self.index];
    [self didSelected:index];
}

- (void)didClickAdd:(UIGestureRecognizer *)gesture {
    if (self.didClickSubTitle) {
        self.didClickSubTitle([self.subTitleArr indexOfObject:gesture.view]);
    }
}


- (void)didSelected:(int)index {
    self.index = index;
    UILabel *lbl = self.titleArr[index];
    lbl.font = __CM_SelectedFont;
    lbl.textColor = __CM_SelectedColor;
    
    [self setupSubTitle:index];
//    [self setNeedsLayout];
//    [self setupLine:index];
    self.didClickTitle(self.index);
}

- (void)unSelected:(int)index {
    UILabel *lbl = self.titleArr[index];
    lbl.font = __CM_NormalFont;
    lbl.textColor = __CM_NormalColor;
}

- (void)setupSubTitle:(int)index {
    [self.subTitleArr enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = idx != index;
    }];
}

- (void)setupLine:(int)index {
    
    UIView *currentLbl = self.titleArr[index];
    
    CGFloat height = 2;
    CGFloat width = 30;
    
    CGFloat x = currentLbl.left + (currentLbl.width - width) / 2.0;
    CGFloat y = currentLbl.bottom + 3;
    self.line.frame = CGRectMake(x, y, width, height);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSLog(@"%@", self);
    [self setupLine:self.index];
}

@end
