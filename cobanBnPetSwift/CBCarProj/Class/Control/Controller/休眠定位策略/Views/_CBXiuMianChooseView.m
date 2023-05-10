//
//  _CBXiuMianChooseView.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/30.
//  Copyright © 2022 coban. All rights reserved.
//

#import "_CBXiuMianChooseView.h"

@interface _CBXiuMianChooseView ()

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, strong) NSArray *idArr;

@property (nonatomic, strong) UIImageView *selectedImgV;

@property (nonatomic, assign) NSInteger restMod ; /** <##> **/
@end

@implementation _CBXiuMianChooseView

- (instancetype)initWithData:(NSArray *)data idArr:(NSArray *)idArr restMod:(NSInteger)restMod {
    self = [super init];
    if (self) {
        self.data = data;
        self.idArr = idArr;
        self.restMod = restMod;
        [self createView];
    }
    return self;
}

- (void)createView {
    self.backgroundColor = UIColor.whiteColor;
    
    NSInteger initialSelectedIndex = 0;
    
    for (int i = 0; i < self.idArr.count; i++) {
        NSNumber *idNum = self.idArr[i];
        if (idNum.integerValue == self.restMod) {
            initialSelectedIndex = i;
            break;
        }
    }
    
    UIView *lastView = nil;
    kWeakSelf(self);
    for (int i = 0; i < self.data.count; i++ ) {
        NSString *title = self.data[i];
        UIView *view = [UIView new];
        
        UILabel *lbl = [MINUtils createLabelWithText:title size:14];
        lbl.textColor = UIColor.blackColor;
        [view addSubview:lbl];
        
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@6);
            make.bottom.equalTo(@-6);
        }];
        
        UIImageView *imgV = [UIImageView new];
        imgV.image = [UIImage imageNamed: i == initialSelectedIndex ? @"已选中2" : @"未选中2"];
        [view addSubview:imgV];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.right.equalTo(@0);
        }];
        if (i == initialSelectedIndex) {
            self.selectedImgV = imgV;
        }
        
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).mas_offset(10);
            } else {
                make.top.equalTo(@0);
            }
            make.left.right.equalTo(@0);
        }];
        
        lastView = view;
        
        [view bk_whenTapped:^{
            if (weakself.currentIndex == [weakself.idArr[i] integerValue]) {
                return;
            }
            weakself.currentIndex = [weakself.idArr[i] integerValue];
            weakself.selectedImgV.image = [UIImage imageNamed:@"未选中2"];
            weakself.selectedImgV = imgV;
            imgV.image = [UIImage imageNamed:@"已选中2"];
        }];
        if (i == initialSelectedIndex) {
            self.currentIndex = [weakself.idArr[i] integerValue];
        }
    }
    
    UIView *line = [UIView new];
    line.backgroundColor = KCarLineColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.mas_bottom).mas_offset(10);
        make.bottom.equalTo(@-10);
        make.height.equalTo(@1);
        make.left.right.equalTo(lastView);
    }];
}

- (BOOL)isChooseAlwaysOnline {
    return _currentIndex == 0;
}
- (BOOL)isChooseShakeOnline {
    return _currentIndex == 1;
}

@end
