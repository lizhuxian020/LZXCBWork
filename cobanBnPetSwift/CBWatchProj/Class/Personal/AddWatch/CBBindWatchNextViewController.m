//
//  CBBindWatchNextViewController.m
//  cobanBnWatch
//
//  Created by coban on 2019/11/27.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBBindWatchNextViewController.h"
#import "MINInputView.h"
#import "AddressBookModel.h"

@interface CBBindWatchNextViewController ()
@property (nonatomic,strong) MINInputView *wathcNumberInputView;
@property (nonatomic,strong) MINInputView *watchNickNameInputView;
@property (nonatomic,strong) MINInputView *contactInputView;
@property (nonatomic, strong) UIButton *saveBtn;
@end

@implementation CBBindWatchNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}
- (void)setupView {
    [self initBarWithTitle:Localized(@"绑定手表") isBack: YES];
    self.view.backgroundColor = KWtBackColor;
    
    if (self.hasAdmin) {
        [self.contactInputView updateLeftTitle:Localized(@"联系人:") text:self.model.name?:@"" placehold:Localized(@"")];
        [self saveBtn];
    } else {
        [self.wathcNumberInputView updateLeftTitle:Localized(@"手表号码:") text:@"" placehold:Localized(@"请输入正确的手表号码")];
        [self.watchNickNameInputView updateLeftTitle:Localized(@"手表昵称:") text:@"" placehold:Localized(@"请输入手表昵称")];
        [self.contactInputView updateLeftTitle:Localized(@"联系人:") text:self.model.name?:@"" placehold:Localized(@"")];
        [self saveBtn];
    }
}
- (MINInputView *)wathcNumberInputView {
    if (!_wathcNumberInputView) {
        _wathcNumberInputView = [[MINInputView alloc]init];
        [self.view addSubview:_wathcNumberInputView];
        [_wathcNumberInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15*frameSizeRate);
            make.right.mas_equalTo(-15*frameSizeRate);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(15);
        }];
    }
    return _wathcNumberInputView;
}
- (MINInputView *)watchNickNameInputView {
    if (!_watchNickNameInputView) {
        _watchNickNameInputView = [[MINInputView alloc]init];
        [self.view addSubview:_watchNickNameInputView];
        [_watchNickNameInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15*frameSizeRate);
            make.right.mas_equalTo(-15*frameSizeRate);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(self.wathcNumberInputView.mas_bottom).offset(15);
        }];
    }
    return _watchNickNameInputView;
}
- (MINInputView *)contactInputView {
    if (!_contactInputView) {
        _contactInputView = [[MINInputView alloc]init];
        [self.view addSubview:_contactInputView];
        if (self.hasAdmin) {
            [_contactInputView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15*frameSizeRate);
                make.right.mas_equalTo(-15*frameSizeRate);
                make.height.mas_equalTo(40);
                make.top.mas_equalTo(15);
            }];
        } else {
            [_contactInputView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15*frameSizeRate);
                make.right.mas_equalTo(-15*frameSizeRate);
                make.height.mas_equalTo(40);
                make.top.mas_equalTo(self.watchNickNameInputView.mas_bottom).offset(15);
            }];
        };
    }
    return _contactInputView;
}
- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [CBWtMINUtils createNoBorderBtnWithTitle:Localized(@"保存") titleColor: [UIColor whiteColor] fontSize:15 backgroundColor: KWtBlueColor];
        [_saveBtn addTarget:self action: @selector(saveBtnClick) forControlEvents: UIControlEventTouchUpInside];
        [self.view addSubview:_saveBtn];
        _saveBtn.layer.cornerRadius = 10;
        [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contactInputView.mas_bottom).with.offset(15);
            make.height.mas_equalTo(40 );
            make.left.equalTo(self.view).with.offset(12.5 * KFitWidthRate);
            make.right.equalTo(self.view).with.offset(-12.5 * KFitWidthRate);
        }];
    }
    return _saveBtn;
}
#pragma mark -- 绑定手表
- (void)saveBtnClick {
    if (!self.hasAdmin) {
        if (kStringIsEmpty(self.wathcNumberInputView.textField.text) || kStringIsEmpty(self.watchNickNameInputView.textField.text)) {
            [CBWtMINUtils showProgressHudToView: self.view withText:Localized(@"任何一项不能为空")];
            return;
        }
    }
     
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:self.sno?:@"" forKey:@"sno"];
    if (!self.hasAdmin) {
        [paramters setObject:self.wathcNumberInputView.textField.text?:@"" forKey:@"watchPhone"]; // hasAdmin决定当手表未绑定过时需要此字段
        [paramters setObject:self.watchNickNameInputView.textField.text?:@"" forKey:@"watchName"];  //hasAdmin决定当手表未绑定过时需要此字段
    }
    [paramters setObject:[NSNumber numberWithInt:self.model.type] forKey:@"type"];
    [paramters setObject:self.model.name?:@"" forKey:@"relation"];
    
    NSLog(@"输入的参数:%@",paramters);
    
    [[CBWtNetworkRequestManager sharedInstance] bindWatchParamters:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        switch (baseModel.status) {
            case CBWtNetworkingStatus0:
            {
                [CBWtMINUtils showProgressHudToView:self.view withText:baseModel.resmsg];
                [self performSelector:@selector(popToViewController) withObject:nil afterDelay:1.5];
            }
                break;
            default:
            {
                //[CBWtMINUtils showProgressHudToView: self.view withText:baseModel.resmsg];
            }
                break;
        }
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)popToViewController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
