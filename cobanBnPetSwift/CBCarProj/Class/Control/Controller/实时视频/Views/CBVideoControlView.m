//
//  CBVideoControlView.m
//  cobanBnPetSwift
//
//  Created by zzer on 2023/4/11.
//  Copyright © 2023 coban. All rights reserved.
//

#import "CBVideoControlView.h"

@interface CBVideoControlView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImageView *topBtnView;
@property (nonatomic, strong) UIImageView *leftBtnView;
@property (nonatomic, strong) UIImageView *rightBtnView;
@property (nonatomic, strong) UIImageView *bottomBtnView;
@property (nonatomic, strong) UIImageView *captureBtnView;

@end

@implementation CBVideoControlView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.contentView = [UIView new];
    [self addSubview:self.contentView];
    self.contentView.backgroundColor = UIColor.whiteColor;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@150);
        make.edges.equalTo(@0);
    }];
    self.contentView.layer.cornerRadius = 75;
    
    kWeakSelf(self);
    self.topBtnView = [self getBtn:@"向上" blk:^{
        NSLog(@"%s", __FUNCTION__);
        weakself.didTop();
    }];
    [self addSubview:self.topBtnView];
    [self.topBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.centerX.equalTo(@0);
    }];
    
    self.captureBtnView = [self getBtn:@"拍照 1" blk:^{
        NSLog(@"%s", __FUNCTION__);
        weakself.didClickCapture();
    }];
    [self addSubview:self.captureBtnView];
    [self.captureBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBtnView.mas_bottom);
        make.centerX.equalTo(@0);
        make.width.height.equalTo(self.topBtnView);
    }];
    
    self.bottomBtnView = [self getBtn:@"向下" blk:^{
        NSLog(@"%s", __FUNCTION__);
        weakself.didBottom();
    }];
    [self addSubview:self.bottomBtnView];
    [self.bottomBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.captureBtnView.mas_bottom);
        make.bottom.equalTo(@0);
        make.centerX.equalTo(@0);
        make.width.height.equalTo(self.captureBtnView);
    }];
    
    self.leftBtnView = [self getBtn:@"向左" blk:^{
        NSLog(@"%s", __FUNCTION__);
        weakself.didLeft();
    }];
    [self addSubview:self.leftBtnView];
    [self.leftBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.centerY.equalTo(@0);
        make.right.equalTo(self.captureBtnView.mas_left);
        make.height.width.equalTo(self.captureBtnView);
    }];
    
    self.rightBtnView = [self getBtn:@"向右" blk:^{
        NSLog(@"%s", __FUNCTION__);
        weakself.didRight();
    }];
    [self addSubview:self.rightBtnView];
    [self.rightBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.left.equalTo(self.captureBtnView.mas_right);
        make.height.width.equalTo(self.captureBtnView);
        make.centerY.equalTo(@0);
    }];
    
}

- (UIImageView *)getBtn:(NSString *)imgName blk:(void(^)(void))blk {
    UIImageView *btn = [UIImageView new];
    btn.image = [UIImage imageNamed:imgName];
    btn.userInteractionEnabled = YES;
    btn.contentMode = UIViewContentModeScaleAspectFit;
    [btn bk_whenTapped:^{
        blk();
    }];
//    btn.backgroundColor = RandomColor;
    return btn;
}

@end
