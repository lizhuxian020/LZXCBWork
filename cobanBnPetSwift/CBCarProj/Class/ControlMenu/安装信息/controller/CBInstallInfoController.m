//
//  CBInstallInfoController.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/12/3.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBInstallInfoController.h"
#import "_CBInstallInfoView.h"

@interface CBInstallInfoController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) _CBInstallInfoView *infoView;

@end

@implementation CBInstallInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)createUI {
    [self initBarWithTitle:Localized(@"安装信息") isBack:YES];
    
    self.scrollView = [UIScrollView new];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    self.infoView = [_CBInstallInfoView new];
    [self.scrollView addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@0);
        make.width.equalTo(self.view);
        make.bottom.equalTo(@0);
    }];
}

@end
