//
//  BindOrUnbindViewController.m
//  Watch
//
//  Created by lym on 2018/3/1.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "BindOrUnbindViewController.h"
#import "HomeModel.h"

@interface BindOrUnbindViewController ()

@property (nonatomic,strong) UIView *imgCardView;
@property (nonatomic, strong) UILabel *snoLab;
@property (nonatomic, strong) UIButton *unbindBtn;
@end

@implementation BindOrUnbindViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.imgCardView.layer.cornerRadius = 8;
    self.imgCardView.layer.shadowColor = [UIColor grayColor].CGColor;  //阴影颜色
    self.imgCardView.layer.shadowRadius = 4;                           //阴影半径
    self.imgCardView.layer.shadowOpacity = 0.3;                        //阴影透明度
    self.imgCardView.layer.shadowOffset  = CGSizeMake(0, 3);           // 阴影偏移量
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}
- (void)setupView {
    self.view.backgroundColor = KWtBackColor;
    [self initBarWithTitle:Localized(@"绑定与解绑") isBack:YES];
    
    [self imgCardView];
    [self unbindBtn];
}
- (UIView *)imgCardView {
    if (!_imgCardView) {
        _imgCardView = [UIView new];
        _imgCardView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_imgCardView];
        [_imgCardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(PPNavigationBarHeight + 30);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(150, 150));
        }];
        
        UIImageView *codeImageView = [UIImageView new];
        codeImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_imgCardView addSubview:codeImageView];
        [codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 5, 5));
        }];
        codeImageView.image = [CBWtCommonTools createQRCodeByStringLogo:[HomeModel CBDevice].tbWatchMain.sno?:@""];
        
        UILabel *titleLb = [UILabel new];
        [self.view addSubview:titleLb];
        titleLb.text = Localized(@"手表的二维码");
        titleLb.textColor = UIColor.grayColor;
        titleLb.font = [UIFont fontWithName:CBPingFang_SC size:15];
        titleLb.textAlignment = NSTextAlignmentCenter;
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(codeImageView.mas_bottom).offset(15);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        
        _snoLab = [UILabel new];
        [self.view addSubview:_snoLab];
        _snoLab.text = [NSString stringWithFormat:@"%@:%@",Localized(@"绑定号"),[HomeModel CBDevice].tbWatchMain.sno];
        _snoLab.textColor = UIColor.grayColor;
        _snoLab.font = [UIFont fontWithName:CBPingFang_SC size:18];
        _snoLab.textAlignment = NSTextAlignmentCenter;
        [_snoLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLb.mas_bottom).offset(30);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        [CBWtCommonTools labelColorWithKeywords:[HomeModel CBDevice].tbWatchMain.sno label:_snoLab color:UIColor.blackColor];
    }
    return _imgCardView;
}
- (UIButton *)unbindBtn {
    if (!_unbindBtn) {
        _unbindBtn = [CBWtMINUtils createNoBorderBtnWithTitle:Localized(@"解除绑定") titleColor: [UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: KWtBlueColor Radius: 20 * KFitWidthRate];
        [self.view addSubview:_unbindBtn];
        [_unbindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_snoLab.mas_bottom).with.offset(100 * KFitWidthRate);
            make.size.mas_equalTo(CGSizeMake(190 * KFitWidthRate, 40 * KFitWidthRate));
        }];
        [_unbindBtn addTarget: self action: @selector(unbindBtnClick) forControlEvents: UIControlEventTouchUpInside];
    }
    return _unbindBtn;
}
#pragma mark -- 解除绑定
- (void)unbindBtnClick {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    paramters[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno;
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/persion/unbindWatch" params:paramters succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [self.navigationController popToRootViewControllerAnimated: YES];
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
