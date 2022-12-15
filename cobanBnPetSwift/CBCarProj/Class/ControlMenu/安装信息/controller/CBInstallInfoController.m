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
    [self requestData];
}

- (void)createUI {
    [self initBarWithTitle:Localized(@"安装信息") isBack:YES];
    [self initBarRighBtnTitle:Localized(@"保存") target:self action:@selector(save)];
    
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

- (void)requestData {
    NSString *dno = [CBCommonTools CBdeviceInfo].dno?:@"";
    NSString *url = [NSString stringWithFormat:@"%@%@", @"/gpsInstallController/getGpsInstall/", dno];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared] getWithUrl:url params:@{} succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            if (response && response[@"data"]) {
                _CBInstallInfo *model = [_CBInstallInfo mj_objectWithKeyValues:response[@"data"]];
                self.infoView.model = model;
            }
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)save {
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    NSDictionary *dic = [self.infoView getSaveInfo];
    [[NetWorkingManager shared] postJSONWithUrl:@"/gpsInstallController/updGpsInstall" params:dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [CBTopAlertView alertSuccess:Localized(@"操作成功")];
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

@end
