//
//  CBAlertSelectableView.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/30.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBAlertSelectableView.h"

@interface CBAlertSelectableView ()

@property (nonatomic, strong) NSArray<NSString *> *dataArr;

@property (nonatomic, strong) NSMutableArray *lblArr;
@end

@implementation CBAlertSelectableView

- (instancetype)initWithData:(NSArray<NSString *> *)datas {
    self = [super init];
    if (self) {
        self.dataArr = datas;
        [self createView];
    }
    return self;
}

- (void)createView {
    self.backgroundColor = UIColor.whiteColor;
    self.lblArr = [NSMutableArray new];
    UILabel *lastLbl = nil;
    kWeakSelf(self);
    for(int i = 0; i < self.dataArr.count; i++) {
        UILabel *lbl = [MINUtils createLabelWithText:self.dataArr[i] size:14];
        [self.lblArr addObject:lbl];
        lbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastLbl) {
                make.top.equalTo(lastLbl.mas_bottom).mas_offset(10);
            } else {
                make.top.equalTo(@10);
            }
            make.left.equalTo(@15);
            make.right.equalTo(@-15);
            make.height.equalTo(@50);
        }];
        lastLbl = lbl;
        lbl.layer.cornerRadius = 25;
        [lbl.layer setMasksToBounds:YES];
        lbl.userInteractionEnabled = YES;
        [lbl bk_whenTapped:^{
            weakself.currentIndex = i;
        }];
    }
    [lastLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-10);
    }];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    for (int i = 0; i < self.lblArr.count; i++) {
        UILabel *lbl = self.lblArr[i];
        if (i == _currentIndex) {
            [self makeSelected:lbl];
        } else {
            [self makeUnSelected:lbl];
        }
    }
}

- (void)makeSelected:(UILabel *)lbl {
    lbl.textColor = UIColor.whiteColor;
    lbl.backgroundColor = kAppMainColor;
    lbl.layer.borderWidth = 0;
}

- (void)makeUnSelected:(UILabel *)lbl {
    lbl.textColor = kCellTextColor;
    lbl.backgroundColor = UIColor.whiteColor;
    lbl.layer.borderColor = KCarLineColor.CGColor;
    lbl.layer.borderWidth = 1;
}
@end
