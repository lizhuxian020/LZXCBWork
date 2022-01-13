//
//  ConsoleControlViewController.m
//  Telematics
//
//  Created by lym on 2017/12/4.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "ConsoleControlViewController.h"

@interface ConsoleControlViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation ConsoleControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

#pragma mark - Action
- (void)rightBtnClick
{
    
}

#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"云台控制") isBack: YES];
    [self initBarRighBtnTitle:Localized(@"确定") target: self action: @selector(rightBtnClick)];
    [self showBackGround];
    UIImage *image = [UIImage imageNamed: @"视频"];
    self.imageView = [[UIImageView alloc] initWithImage: image];
    [self.view addSubview: self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(image.size.height * KFitHeightRate);
        make.width.mas_equalTo(image.size.width * KFitHeightRate);
        make.bottom.equalTo(self.view).with.offset(-30 * KFitHeightRate);
    }];
    self.leftBtn = [[UIButton alloc] init];
    [self.view addSubview: self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self.imageView);
        make.size.mas_equalTo(CGSizeMake(45 * KFitHeightRate, 45 * KFitHeightRate));
    }];
    self.rightBtn = [[UIButton alloc] init];
    [self.view addSubview: self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(self.imageView);
        make.size.mas_equalTo(CGSizeMake(45 * KFitHeightRate, 45 * KFitHeightRate));
    }];
}

#pragma mark - Other method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
