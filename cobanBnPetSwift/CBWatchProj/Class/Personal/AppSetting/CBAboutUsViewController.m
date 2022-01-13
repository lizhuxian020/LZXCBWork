//
//  CBAboutUsViewController.m
//  Watch
//
//  Created by coban on 2019/9/10.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBAboutUsViewController.h"

@implementation CBAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
    
}
- (void)setupView {
    self.view.backgroundColor = KWtBackColor;
    [self initBarWithTitle:Localized(@"关于我们") isBack: YES];
    
    UILabel *lbTitle = [CBWtMINUtils createLabelWithText:Localized(@"巴诺手表") size:16];
    lbTitle.textColor = UIColor.blackColor;
    lbTitle.font = [UIFont fontWithName:CBPingFang_SC_Bold size:16];
    [self.view addSubview:lbTitle];
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(120);
    }];
    
    UILabel *lbVersion = [CBWtMINUtils createLabelWithText:@"1.0"];
    lbVersion.text = [CBWtCommonTools appVersion];
    [self.view addSubview:lbVersion];
    [lbVersion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(lbTitle.mas_bottom).offset(40);
    }];
    
    UILabel *lbCopyright = [CBWtMINUtils createLabelWithText:@"Copyright(C)2015-2019深圳巴诺科技有限公司 版权所有"];
    lbCopyright.numberOfLines = 0;
    [self.view addSubview:lbCopyright];
    [lbCopyright mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15*frameSizeRate);
        make.right.mas_equalTo(-15*frameSizeRate);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(lbVersion.mas_bottom).offset(140);
    }];
}
@end
