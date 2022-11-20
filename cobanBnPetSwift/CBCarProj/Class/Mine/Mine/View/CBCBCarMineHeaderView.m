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
    
    UILabel *lbl = [UILabel new];
    [self addSubview:lbl];
    lbl.text = @"添加";
    lbl.textColor = KWtAppMainColor;
    lbl.font = __CM_NormalFont;
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(@-15);
    }];
    lbl.userInteractionEnabled  =YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickAdd)];
    [lbl addGestureRecognizer:tap];
    
    self.titleArr = mArr;
    self.line = [UIView new];
    self.line.backgroundColor = UIColor.blackColor;
    [self addSubview:self.line];
    
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

- (void)didClickAdd {
    NSLog(@"%s", __FUNCTION__);
}


- (void)didSelected:(int)index {
    self.index = index;
    UILabel *lbl = self.titleArr[index];
    lbl.font = __CM_SelectedFont;
    lbl.textColor = __CM_SelectedColor;
//    [self setNeedsLayout];
//    [self setupLine:index];
    self.didClickTitle(self.index);
}

- (void)unSelected:(int)index {
    UILabel *lbl = self.titleArr[index];
    lbl.font = __CM_NormalFont;
    lbl.textColor = __CM_NormalColor;
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
