//
//  BabyInfoViewController.m
//  Watch
//
//  Created by lym on 2018/2/8.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "BabyInfoViewController.h"
#import "MINClickCellView.h"
#import "CBWtMINAlertView.h"
#import "HomeModel.h"
/* oc 调用 swift*/
#import "cobanBnPetSwift-Swift.h"

@interface BabyInfoViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,strong) MINClickCellView *headImageView;
@property (nonatomic,strong) MINClickCellView *nameView;
@property (nonatomic, weak) UITextField *textField;
/** 七牛云上传token */
@property (nonatomic,strong) CBBaseQNYFileInfoModel *qnyFileModelPrivate;
@property (nonatomic,copy) NSString *qnyToken;
@end

@implementation BabyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
    [self getQNYFileTokenReqeust];
    [self initWatchModelData];

}
- (void)setupView {
    [self initBarWithTitle:@"" isBack: YES];//宝贝资料"
    self.view.backgroundColor = KWtBackColor;
    
    [self headImageView];
    [self nameView];
    
    [self initWatchModelData];
}
- (void)initWatchModelData {
    HomeModel *model = [HomeModel CBDevice];
    [self.headImageView setLeftImageUrlString: model.tbWatchMain.head rightLabelText:Localized(@"更换头像")];
    self.headImageView.leftImageView.contentMode = UIViewContentModeScaleToFill;
    [self.nameView setLeftLabelText:Localized(@"昵称") rightLabelText: model.tbWatchMain.name];
}
- (MINClickCellView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[MINClickCellView alloc]init];
        [self.view addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(12.5 * KFitWidthRate);
            } else {
                // Fallback on earlier versions
                make.top.equalTo(self.view.mas_topMargin).with.offset(12.5 * KFitWidthRate + kNavAndStatusHeight);
            }
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(75 * KFitWidthRate);
        }];
        [_headImageView addBottomLine];
        [_headImageView setLeftImageUrlString:@"" rightLabelText:Localized(@"更换头像")];
        kWeakSelf(self);
        _headImageView.clickBtnClickBlock = ^{
            kStrongSelf(self);
            [self modifyAvatar];
        };
    }
    return _headImageView;
}
- (MINClickCellView *)nameView {
    if (!_nameView) {
        _nameView = [[MINClickCellView alloc]init];
        [self.view addSubview:_nameView];
        [_nameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headImageView.mas_bottom).with.offset(12.5 * KFitWidthRate);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(50 * KFitWidthRate);
        }];
        [_nameView setLeftLabelText:Localized(@"关系") rightLabelText: @"哥哥"];
        kWeakSelf(self);
        _nameView.clickBtnClickBlock = ^{
            kStrongSelf(self);
            [self modifyNickName];
        };
    }
    return _nameView;
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
#pragma mark -- 更改头像
- (void)modifyAvatar {
    /**
     *  弹出提示框
     */
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:Localized(@"从相册选择") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //初始化UIImagePickerController
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:Localized(@"拍照") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        /**
         其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
         */
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark -- 更改昵称
- (void)modifyNickName {
    CBWtMINAlertView *alertView = [[CBWtMINAlertView alloc] init];
    alertView.titleLabel.text = Localized(@"请输入名称");
    [alertView showRightCloseBtn];
    [self.view addSubview: alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    [alertView setContentViewHeight:80];
    __weak __typeof__(CBWtMINAlertView *) weakAlertView = alertView;
    self.textField = [CBWtMINUtils createTextFieldWithHoldText:Localized(@"请输入名称") fontSize: 15 * KFitWidthRate];
    self.textField.leftView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 25 * KFitWidthRate,  40 * KFitWidthRate)];
    self.textField.layer.cornerRadius = 20 * KFitWidthRate;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.backgroundColor = KWtRGB(240, 240, 240);
    [alertView.contentView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertView.contentView);
        make.centerY.equalTo(alertView.contentView).with.offset(-5 * KFitHeightRate);
        make.height.mas_equalTo(40 * KFitWidthRate);
        make.width.mas_equalTo(250 * KFitWidthRate);
    }];

    kWeakSelf(self);
    alertView.leftBtnClick = ^{
        kStrongSelf(self);
        [MBProgressHUD showHUDIcon:self.view animated:YES];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
        dic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";//[AppDelegate shareInstance].currentSno;
        dic[@"name"] = self.textField.text;
        kWeakSelf(self);
        [[CBWtNetWorkingManager shared] postWithUrl:@"watch/persion/updWatchInfo" params: dic succeed:^(id response, BOOL isSucceed) {
            kStrongSelf(self);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (isSucceed) {
                self.nameView.rightLabel.text = self.textField.text;
                //[AppDelegate shareInstance].currentWatchModel.tbWatchMain.name = self.textField.text;
                
                HomeModel *model = [HomeModel CBDevice];
                model.tbWatchMain.name = self.textField.text;
                [HomeModel saveCBDevice:model];
                
                [weakAlertView hideView];
            }
        } failed:^(NSError *error) {
            kStrongSelf(self);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    };
}
#pragma mark - UINavigationControllerDelegate, UIImagePickerControllerDelegate
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    // 压缩需要上传的图片
    UIImage *uploadImage = [self imageWithImageSimple:newPhoto scaledToSize:CGSizeMake(83, 83)];
    
    [self uploadHeader: uploadImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -- 上传图片
- (void)uploadHeader:(UIImage*)image {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetworkRequestManager sharedInstance] uploadImageToQNFilePath:image token:self.qnyToken?:@"" success:^(id  _Nonnull baseModel) {
        kStrongSelf(self);
        
        NSString *imageUrl = [NSString stringWithFormat:@"%@",baseModel[@"key"]];
        NSString *headImageUrlStr = [NSString stringWithFormat:@"%@%@",@"http://cdn.clw.gpstrackerxy.com/",imageUrl];
        
        NSLog(@"--------头像路径--------%@",headImageUrlStr);
        [self requestUploadImageWithFileUrl:headImageUrlStr hud:nil];
        
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)requestUploadImageWithFileUrl:(NSString *)fileUrl hud:(MBProgressHUD *)hud {
    kWeakSelf(self);
    NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithCapacity:2];
    paramters[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno;
    paramters[@"head"] = fileUrl;
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/persion/updWatchInfo" params:paramters succeed:^(id response, BOOL isSucceed) {
        if (isSucceed) {
            kStrongSelf(self);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            HomeModel *model = [HomeModel CBDevice];
            model.tbWatchMain.head = fileUrl;
            [HomeModel saveCBDevice:model];
            //[AppDelegate shareInstance].currentWatchModel.tbWatchMain.head = fileUrl;
            
            [self.headImageView.leftImageView setImage: [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: fileUrl]]]];
        }
        [hud hideAnimated: YES];
    } failed:^(NSError *error) {
        [hud hideAnimated: YES];
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize {
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
