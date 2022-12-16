//
//  CBPersonInfoController.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/27.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBPersonInfoController.h"
#import "cobanBnPetSwift-Swift.h"
#import "CBCarAlertView.h"

@interface CBPersonInfoController ()

@property (nonatomic, strong) UIView *imgV;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UIView *accountV;
@property (nonatomic, strong) UIView *nameV;
@property (nonatomic, strong) UIView *phoneV;
@property (nonatomic, strong) UIView *emailV;
/** 七牛云上传token */
@property (nonatomic,copy) NSString *qnyToken;
@property (nonatomic, copy) NSString *headerUrl ; /** <##> **/
@end

@implementation CBPersonInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBarWithTitle:Localized(@"个人信息") isBack:YES];
    [self initBarRighBtnTitle:@"保存" target:self action:@selector(save)];
    
    CBPetLoginModel *userModel = [CBPetLoginModelTool getUser];
    
    self.imgV = [self viewWithTitle:Localized(@"头像") renderHead:YES content:nil placeHolder:nil canClick:YES blk:^{
        
    }];
    self.accountV = [self viewWithTitle:Localized(@"账号") renderHead:NO content:userModel.account placeHolder:nil canClick:NO blk:^{
        
    }];
    self.nameV = [self viewWithTitle:Localized(@"昵称") renderHead:NO content:userModel.name placeHolder:Localized(@"请输入昵称") canClick:YES blk:^{
        
    }];
    self.phoneV = [self viewWithTitle:Localized(@"手机号码") renderHead:NO content:userModel.phone placeHolder:Localized(@"请输入手机号码") canClick:YES isDigital:YES blk:^{
        
    }];
    self.emailV = [self viewWithTitle:Localized(@"邮箱") renderHead:NO content:userModel.email placeHolder:Localized(@"请输入邮箱") canClick:YES blk:^{
        
    }];
    [self.view addSubview:self.imgV];
    [self.view addSubview:self.accountV];
    [self.view addSubview:self.nameV];
    [self.view addSubview:self.phoneV];
    [self.view addSubview:self.emailV];
    
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(@(PPNavigationBarHeight));
    }];
    [self.accountV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.imgV.mas_bottom);
    }];
    [self.nameV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.accountV.mas_bottom);
    }];
    [self.phoneV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.nameV.mas_bottom);
    }];
    [self.emailV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.phoneV.mas_bottom);
    }];
    
    [self getQNYFileTokenReqeust];
}

- (UIView *)viewWithTitle:(NSString *)title
               renderHead:(BOOL)renderHead
                  content:(NSString *)content
              placeHolder:(NSString *)placeHolder
                 canClick:(BOOL)canClick
                      blk:(void(^)(void))blk {
    return [self viewWithTitle:title renderHead:renderHead content:content placeHolder:placeHolder canClick:canClick isDigital:NO blk:blk];
}

- (UIView *)viewWithTitle:(NSString *)title
               renderHead:(BOOL)renderHead
                  content:(NSString *)content
              placeHolder:(NSString *)placeHolder
                 canClick:(BOOL)canClick
                isDigital:(BOOL)isDigital
                      blk:(void(^)(void))blk
{
    UIView *v = [UIView new];
    
    UILabel *lbl = [MINUtils createLabelWithText:title size:14 alignment:NSTextAlignmentCenter textColor:UIColor.blackColor];
    [v addSubview:lbl];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@20);
        make.bottom.equalTo(@-20);
    }];
    
    UILabel *contentLbl = nil;
    
    if (renderHead) {
        CBPetLoginModel *userModel = [CBPetLoginModelTool getUser];
        UIImageView *img = [UIImageView new];
        self.headerView = img;
        [img sd_setImageWithURL:[NSURL URLWithString:userModel.photo] placeholderImage:[UIImage imageNamed:@"个人资料"]];
        [v addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.centerY.equalTo(@0);
            make.width.height.equalTo(@30);
        }];
        img.layer.cornerRadius = 15;
        [img.layer setMasksToBounds:YES];
    } else {
        
        UIImageView *arrow = [UIImageView new];
        arrow.image = [UIImage imageNamed:@"detail"];
        [v addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@15);
            make.right.equalTo(@-10);
            make.centerY.equalTo(@0);
        }];
        
        if (content) {
            UILabel *cLbl = [MINUtils createLabelWithText:content size:15 alignment:NSTextAlignmentCenter textColor:UIColor.blackColor];
            cLbl.tag = 101;
            [v addSubview:cLbl];
            [cLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(@0);
                make.right.equalTo(arrow.mas_left).mas_offset(-10);
            }];
            contentLbl = cLbl;
        }
        arrow.hidden = !canClick;
    }
    
    
    
    UIView *line = [UIView new];
    [v addSubview:line];
    line.backgroundColor = KCarLineColor;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.right.equalTo(@0);
        make.height.equalTo(@1);
        make.bottom.equalTo(@0);
    }];
    
    
    __weak UILabel *wLbl = contentLbl;
    [v bk_whenTapped:^{
        
        if (renderHead) {
            [self modifyAvatar];
            return;
        }
        
        if (canClick) {
            [[CBCarAlertView viewWithMultiInput:@[placeHolder] title:title isDigital:isDigital confirmCanDismiss:nil confrim:^(NSArray<NSString *> * _Nonnull contentStr) {
                wLbl.text = contentStr.firstObject;
            }] pop];
        }
    }];
    return v;
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

#pragma mark - UINavigationControllerDelegate, UIImagePickerControllerDelegate
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    // 压缩需要上传的图片
    UIImage *uploadImage = [self imageWithImageSimple:newPhoto scaledToSize:CGSizeMake(83, 83)];
    
    self.headerView.image = uploadImage;
    [self uploadHeader: uploadImage];
    [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark -- 上传图片
#pragma mark -- 获取七牛云token
- (void)getQNYFileTokenReqeust {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared] getWithUrl:@"/systemController/getUploadToken" params:nil succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            if (response && response[@"data"]) {
                self.qnyToken = response[@"data"];
            }
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)uploadHeader:(UIImage*)image {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetworkRequestManager sharedInstance] uploadImageToQNFilePath:image token:self.qnyToken?:@"" success:^(id  _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *imageUrl = [NSString stringWithFormat:@"%@",baseModel[@"key"]];
        NSString *headImageUrlStr = [NSString stringWithFormat:@"%@%@",@"http://cdn.clw.gpstrackerxy.com/",imageUrl];
        
        NSLog(@"--------头像路径--------%@",headImageUrlStr);
        self.headerUrl = headImageUrlStr;
        
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (NSString *)getContent:(UIView *)view {
    for (UILabel *lbl in view.subviews) {
        if (lbl.tag == 101 && [lbl isKindOfClass:UILabel.class]) {
            return lbl.text;
        }
    }
    return nil;
}

- (void)save {
    NSString *name = [self getContent:self.nameV];
    NSString *phone = [self getContent:self.phoneV];
    NSString *email = [self getContent:self.emailV];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
        @"userName": name ?: @"",
        @"phone": phone ?: @"",
        @"email": email ?: @"",
    }];
    if (self.headerUrl) {
        param[@"photo"] = self.headerUrl;
    }
    
    
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared] postWithUrl:@"/userController/updateUserInfo" params:param succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [CBTopAlertView alertSuccess:Localized(@"操作成功")];
        }
        } failed:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
}

@end
