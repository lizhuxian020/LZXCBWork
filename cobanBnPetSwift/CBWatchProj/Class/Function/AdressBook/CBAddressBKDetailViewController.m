//
//  CBAddressBKDetailViewController.m
//  cobanBnWatch
//
//  Created by coban on 2019/12/10.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBAddressBKDetailViewController.h"
#import "MINClickCellView.h"
#import "CBPickRelationshipVC.h"
#import "AddressBookModel.h"
/* oc 调用 swift*/
#import "cobanBnPetSwift-Swift.h"

@interface CBAddressBKDetailViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,strong) MINClickCellView *headImageView;
@property (nonatomic,strong) MINClickCellView *nameView;
@property (nonatomic,strong) MINClickCellView *relationView;
@property (nonatomic, strong) UIButton *deleBtn;
/** 七牛云上传token */
@property (nonatomic,strong) CBBaseQNYFileInfoModel *qnyFileModelPrivate;
@property (nonatomic,copy) NSString *qnyToken;
@property (nonatomic,strong) NSMutableArray *imageArr;

@end

@implementation CBAddressBKDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self initWatchModelData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
    [self getQNYFileTokenReqeust];
}
- (void)setupView {
    [self initBarWithTitle:Localized(@"详细资料") isBack: YES];
    self.view.backgroundColor = KWtBackColor;
    
    [self headImageView];
    [self nameView];
    [self relationView];
    [self deleBtn];
}
- (void)initWatchModelData {
    [self.headImageView setLeftImageUrlString: self.model.head rightLabelText:Localized(@"更换头像")];
    [self.nameView setLeftLabelText:Localized(@"关系") rightLabelText:Localized(self.model.relation)];
    self.relationView.rightImageView.image = [UIImage imageNamed:@"家人-图标"];
    
    if ([self.model.family isEqualToString:@"1"]) {
        // 家庭成员
        if (self.model.type < 11) {
            [self.headImageView.leftImageView sd_setImageWithURL: [NSURL URLWithString:self.model.head] placeholderImage:[UIImage imageNamed:self.imageArr[self.model.type]]];
        } else {
            [self.headImageView.leftImageView sd_setImageWithURL: [NSURL URLWithString:self.model.head] placeholderImage:[UIImage imageNamed: @"默认宝贝头像"]];
        }
        [self.relationView setLeftLabelText:Localized(@"类型") rightLabelText:Localized(@"家庭成员")];
        [self.relationView.rightImageView setImage: [UIImage imageNamed: @"家人-图标"]];
    } else if ([self.model.family isEqualToString:@"2"]) {
        // 好友
        [self.headImageView setLeftImageUrlString: self.model.head rightLabelText:Localized(@"头像")];
        [self.headImageView.rightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.relationView);
            make.right.equalTo(self.relationView).with.offset(-12.5 * KFitWidthRate);
            make.size.mas_equalTo(CGSizeMake(0 * KFitWidthRate, 0 * KFitWidthRate));
        }];
        [self.nameView.rightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.relationView);
            make.right.equalTo(self.relationView).with.offset(-12.5 * KFitWidthRate);
            make.size.mas_equalTo(CGSizeMake(0 * KFitWidthRate, 0 * KFitWidthRate));
        }];
        
        [self.relationView setLeftLabelText:Localized(@"类型") rightLabelText:Localized(@"好友")];
        [self.relationView.rightImageView setImage: [UIImage imageNamed:@""]];
        [self.relationView.rightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.relationView);
            make.right.equalTo(self.relationView).with.offset(-12.5 * KFitWidthRate);
            make.size.mas_equalTo(CGSizeMake(0 * KFitWidthRate, 0 * KFitWidthRate));
        }];
    } else {
        if (self.model.type < 11) {
            [self.headImageView.leftImageView sd_setImageWithURL: [NSURL URLWithString:self.model.head] placeholderImage:[UIImage imageNamed:self.imageArr[self.model.type]]];
        } else {
            [self.headImageView.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.model.head] placeholderImage:[UIImage imageNamed: @"默认宝贝头像"]];
        }
        [self.relationView setLeftLabelText:Localized(@"类型") rightLabelText:Localized(@"联系人")];
        [self.relationView.rightImageView setImage: [UIImage imageNamed:@"校讯通-图标"]];
    }
}
- (NSMutableArray *)imageArr {
    if (!_imageArr) {
        _imageArr = [NSMutableArray arrayWithObjects:@"爸爸", @"妈妈", @"姐姐", @"爷爷", @"奶奶", @"哥哥", @"外公", @"外婆", @"老师", @"自定义", @"校讯通", nil];
    }
    return _imageArr;
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
            [self modifyRelation];
        };
    }
    return _nameView;
}
- (MINClickCellView *)relationView {
    if (!_relationView) {
        _relationView = [[MINClickCellView alloc]init];
        [self.view addSubview:_relationView];
        [_relationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameView.mas_bottom).with.offset(0 * KFitWidthRate);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(50 * KFitWidthRate);
        }];
        [_relationView setLeftLabelText:Localized(@"类型") rightLabelText: @"家庭成员"];
        [_relationView addBottomLine];
        _relationView.rightImageView.image = [UIImage imageNamed: @"家人-图标"];
    }
    return _relationView;
}
- (UIButton *)deleBtn {
    if (!_deleBtn) {
        _deleBtn = [CBWtMINUtils createNoBorderBtnWithTitle:Localized(@"删除") titleColor: [UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: KWtBlueColor];
        [self.view addSubview:_deleBtn];
        _deleBtn.layer.cornerRadius = 20 * KFitWidthRate;
        [_deleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(150 * KFitWidthRate, 40 * KFitWidthRate));
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(-25 * KFitWidthRate);
            } else {
                // Fallback on earlier versions
                make.bottom.equalTo(self.view.mas_bottomMargin).with.offset(-25 * KFitWidthRate);
            }
        }];
        [_deleBtn addTarget: self action: @selector(deleBtnClick) forControlEvents: UIControlEventTouchUpInside];
    }
    return _deleBtn;
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
    if ([self.model.family isEqualToString:@"2"]) {
        return;
    }
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
#pragma mark -- 更改关系
- (void)modifyRelation {
    if ([self.model.family isEqualToString:@"2"]) {
        return;
    }
    CBPickRelationshipVC *editRelationShipVC = [[CBPickRelationshipVC alloc] init];
    editRelationShipVC.model = self.model;
    editRelationShipVC.isModifyRelation = YES;
    [self.navigationController pushViewController: editRelationShipVC animated: YES];
}
#pragma 删除
- (void)deleBtnClick {
    if (self.model.flag == YES) { // 表示是管理员
        [CBWtMINUtils showProgressHudToView:self.view withText:Localized(@"不能删除管理员")];
        return;
    }
    if ([self.model.phone isEqualToString:[CBPetLoginModelTool getUser].phone]) {
        [CBWtMINUtils showProgressHudToView:self.view withText:Localized(@"不能删除自己")];
        return;
    }
    __weak __typeof__(self) weakSelf = self;
    //MBProgressHUD *hud = [CBWtMINUtils hudToView: self.view withText: Localized(@"MINHud_Request")];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
    dic[@"id"] = self.model.relationId;
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/watch/delConnector" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [weakSelf.navigationController popViewControllerAnimated: YES];
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showMessage:Localized(@"修改失败") withDelay:1.5];
    }];
}
#pragma mark - UINavigationControllerDelegate, UIImagePickerControllerDelegate
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    // 压缩需要上传的图片
    UIImage *uploadImage = [self imageWithImageSimple:newPhoto scaledToSize:CGSizeMake(83, 83)];
    
    [self uploadHeader:uploadImage];
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
    paramters[@"relationId"] = self.model.relationId;
    paramters[@"head"] = fileUrl;
    [[CBWtNetWorkingManager shared] postWithUrl:@"watch/watch/updConnectInfo" params:paramters succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [self.headImageView.leftImageView setImage: [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: fileUrl]]]];
        }
    } failed:^(NSError *error) {
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
