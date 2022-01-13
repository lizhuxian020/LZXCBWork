//
//  CBWtCBWtEditWtInfoViewController.m
//  Watch
//
//  Created by lym on 2018/2/28.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "CBWtEditWtInfoViewController.h"
#import "MINClickCellView.h"
#import "CBWtMINAlertView.h"
#import "HomeModel.h"

@interface CBWtCBWtEditWtInfoViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    MINClickCellView *headImageView;
    MINClickCellView *nameView;
}
@property (nonatomic, weak) UITextField *textField;
/** 七牛云上传token */
@property (nonatomic,strong) CBBaseQNYFileInfoModel *qnyFileModelPrivate;
@property (nonatomic,copy) NSString *qnyToken;
@end

@implementation CBWtCBWtEditWtInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self getQNYFileTokenReqeust];
}

#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle:@"" isBack: YES];//宝贝资料
    self.view.backgroundColor = KWtBackColor;
    [self createHeaderImageView];
    [self initWatchModelData];
}

- (void)initWatchModelData
{
    HomeModel *model = [HomeModel CBDevice];
    UIImage *headImage = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString:model.tbWatchMain.head]]];
    UIImage *thubImage = [UIImage imageByScalingAndCroppingForSourceImage:headImage targetSize:CGSizeMake(92, 92)];
    UIImage *headRadiusImage = headImage?[thubImage imageByRoundCornerRadius: thubImage.size.height borderWidth: 1.5 borderColor: [UIColor whiteColor]]:[UIImage imageNamed:@"默认宝贝头像"];
    headImageView.leftImageView.image = headRadiusImage;
    
    [nameView setLeftLabelText:Localized(@"昵称") rightLabelText: model.tbWatchMain.name];
}

- (void)createHeaderImageView
{
    __weak __typeof__(self) weakSelf = self;
    headImageView = [[MINClickCellView alloc] init];
    [headImageView setLeftImageUrlString: @"" rightLabelText:Localized(@"更换头像")];
    headImageView.leftImageView.layer.masksToBounds = YES;
    headImageView.leftImageView.layer.cornerRadius = 65*KFitWidthRate/2;
    [self.view addSubview: headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(12.5 * KFitWidthRate);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view.mas_topMargin).with.offset(12.5 * KFitWidthRate + kNavAndStatusHeight);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(75 * KFitWidthRate);
    }];
    headImageView.clickBtnClickBlock = ^{
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
            PickerImage.delegate = weakSelf;
            //页面跳转
            [weakSelf presentViewController:PickerImage animated:YES completion:nil];
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
            PickerImage.delegate = weakSelf;
            [weakSelf presentViewController:PickerImage animated:YES completion:nil];
        }]];
        //按钮：取消，类型：UIAlertActionStyleCancel
        [alert addAction:[UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleCancel handler:nil]];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    };
    nameView = [[MINClickCellView alloc] init];
    [nameView setLeftLabelText:Localized(@"昵称") rightLabelText: @"小璐璐"];
    [nameView addBottomLine];
    [self.view addSubview: nameView];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImageView.mas_bottom).with.offset(0 * KFitWidthRate);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50 * KFitWidthRate);
    }];
    __weak __typeof__(MINClickCellView *) weakNameView = nameView;
    
    kWeakSelf(self);
    nameView.clickBtnClickBlock = ^{
        CBWtMINAlertView *alertView = [[CBWtMINAlertView alloc] init];
        alertView.titleLabel.text = Localized(@"请输入名称");
        [alertView showRightCloseBtn];
        [weakSelf.view addSubview: alertView];
        [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(weakSelf.view);
            make.height.mas_equalTo(SCREEN_HEIGHT);
        }];
        [alertView setContentViewHeight:80];
        __weak __typeof__(CBWtMINAlertView *) weakAlertView = alertView;
        weakSelf.textField = [CBWtMINUtils createTextFieldWithHoldText:Localized(@"请输入名称") fontSize: 15 * KFitWidthRate];
        weakSelf.textField.leftView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 25 * KFitWidthRate,  40 * KFitWidthRate)];
        weakSelf.textField.layer.cornerRadius = 20 * KFitWidthRate;
        weakSelf.textField.leftViewMode = UITextFieldViewModeAlways;
        weakSelf.textField.backgroundColor = KWtRGB(240, 240, 240);
        [alertView.contentView addSubview: weakSelf.textField];
        [weakSelf.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(alertView.contentView);
            make.centerY.equalTo(alertView.contentView).with.offset(-5 * KFitHeightRate);
            make.height.mas_equalTo(40 * KFitWidthRate);
            make.width.mas_equalTo(250 * KFitWidthRate);
        }];
        kStrongSelf(self);
        kWeakSelf(self);
        alertView.leftBtnClick = ^{
            kStrongSelf(self);
            [self updateNickNameRequestAlertView:weakAlertView];
        };
    };
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
#pragma mark -- 更改头像request
- (void)requestUploadImageWithFileUrl:(NSString *)fileUrl hud:(MBProgressHUD *)hud
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
    dic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno;
    dic[@"head"] = fileUrl;
    //@"watch/watch/updUserInfo"
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/persion/updWatchInfo" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [hud hideAnimated: YES];
            //[AppDelegate shareInstance].currentWatchModel.head = fileUrl;
            HomeModel *model = [HomeModel CBDevice];
            model.tbWatchMain.head = fileUrl;
            [HomeModel saveCBDevice:model];
            [headImageView.leftImageView setImage: [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: fileUrl]]]];
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 更改昵称
- (void)updateNickNameRequestAlertView:(CBWtMINAlertView *)alertView {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
    dic[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno?:@"";//[AppDelegate shareInstance].currentSno;
    dic[@"name"] = self.textField.text;
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/persion/updWatchInfo" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            nameView.rightLabel.text = self.textField.text;
            HomeModel *model = [HomeModel CBDevice];
            model.tbWatchMain.name = self.textField.text;
            [HomeModel saveCBDevice:model];
            //[AppDelegate shareInstance].currentWatchModel.name = self.textField.text;
            [alertView hideView];
        }
    
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark - UINavigationControllerDelegate, UIImagePickerControllerDelegate
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    // 压缩需要上传的图片
    UIImage *uploadImage = [self imageWithImageSimple:newPhoto scaledToSize:CGSizeMake(83, 83)];
    
    kWeakSelf(self);
    [self dismissViewControllerAnimated:YES completion:^{
        kStrongSelf(self);
        [self uploadHeader:uploadImage];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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
