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

/** 七牛云上传token */
@property (nonatomic,strong) CBBaseQNYFileInfoModel *qnyFileModelPrivate;
@property (nonatomic,copy) NSString *qnyToken;
@property (nonatomic, copy) NSString *picUrl ; /** <##> **/
@end

@implementation CBInstallInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self requestData];
    [self getQNYFileTokenReqeust];
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
    kWeakSelf(self);
    [self.infoView setDidChooseImg:^(UIImage * _Nonnull image) {
        [weakself uploadHeader:image];
    }];
    [self.scrollView addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@0);
        make.width.equalTo(self.view);
        make.bottom.equalTo(@0);
    }];
}

- (void)requestData {
    NSString *dno = _deviceInfoModelSelect.dno?:@"";
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
    NSMutableDictionary *dic = [self.infoView getSaveInfo];
    if (self.picUrl) {
        dic[@"installPicture"] = self.picUrl;
    }
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
#pragma mark -- 获取七牛云token
- (void)getQNYFileTokenReqeust {
    [[CBWtNetworkRequestManager sharedInstance] getQNFileTokenSuccess:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        switch (baseModel.status) {
                
            case CBWtNetworkingStatus0:
            {
                self.qnyFileModelPrivate = [CBBaseQNYFileInfoModel mj_objectWithKeyValues:baseModel.data];
                self.qnyToken = baseModel.data;
            }
                break;
            default:
            {
                [CBWtMINUtils showProgressHudToView:self.view withText:baseModel.resmsg];
            }
                break;
        }
    } failure:^(NSError * _Nonnull error) {
        //[MBProgressHUD showMessage:@"请求超时" withDelay:3.0f];
    }];
}

#pragma mark -- 上传图片
- (void)uploadHeader:(UIImage*)image {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetworkRequestManager sharedInstance] uploadImageToQNFilePath:image token:self.qnyToken?:@"" success:^(id  _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *imageUrl = [NSString stringWithFormat:@"%@",baseModel[@"key"]];
        NSString *headImageUrlStr = [NSString stringWithFormat:@"%@%@",@"http://cdn.clw.gpstrackerxy.com/",imageUrl];
        
        NSLog(@"--------头像路径--------%@",headImageUrlStr);
        self.picUrl = headImageUrlStr;
        
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

@end
