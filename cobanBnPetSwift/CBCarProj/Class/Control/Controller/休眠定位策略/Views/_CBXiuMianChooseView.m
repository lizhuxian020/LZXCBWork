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

@property (nonatomic, strong) UIImageView *selectedImgV;

@end

@implementation _CBXiuMianChooseView

- (instancetype)initWithData:(NSArray *)data {
    self = [super init];
    if (self) {
        self.data = data;
        [self createView];
    }
    return self;
}

- (void)createView {
    self.backgroundColor = UIColor.whiteColor;
    
    UIView *lastView = nil;
    kWeakSelf(self);
    for (int i = 0; i < self.data.count; i++ ) {
        NSString *title = self.data[i];
        UIView *view = [UIView new];
        
        UILabel *lbl = [MINUtils createLabelWithText:title size:14];
        lbl.textColor = UIColor.blackColor;
        [view addSubview:lbl];
        
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(@0);
        }];
        
        UIImageView *imgV = [UIImageView new];
        imgV.image = [UIImage imageNamed: i == 0 ? @"单选-选中" : @"单选-没选中"];
        [view addSubview:imgV];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.right.equalTo(@0);
        }];
        if (i == 0) {
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
            if (weakself.currentIndex == i) {
                return;
            }
            weakself.currentIndex = i;
            weakself.selectedImgV.image = [UIImage imageNamed:@"单选-没选中"];
            weakself.selectedImgV = imgV;
            imgV.image = [UIImage imageNamed:@"单选-选中"];
        }];
        
    }
    [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
    }];
}



@end
