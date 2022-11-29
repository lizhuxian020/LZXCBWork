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
    UILabel *lastLbl = nil;
    for(int i = 0; i < self.dataArr.count; i++) {
        UILabel *lbl = [MINUtils createLabelWithText:self.dataArr[i] size:14];
        [self addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            if (lastLbl) {
                make.top.equalTo(lastLbl.mas_bottom);
            } else {
                make.top.equalTo(@0);
            }
        }];
        lastLbl = lbl;
    }
    [lastLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
    }];
}

@end
