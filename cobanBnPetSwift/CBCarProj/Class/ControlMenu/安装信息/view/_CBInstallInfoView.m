//
//  _CBInstallInfoView.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/12/3.
//  Copyright © 2022 coban. All rights reserved.
//

#import "_CBInstallInfoView.h"
#import "MINDatePickerView.h"

@interface _CBInstallInfoView ()<MINDatePickerViewDelegare,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UILabel *installerLbl;
@property (nonatomic, strong) UILabel *companyLbl;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UILabel *placeLbl;
@property (nonatomic, strong) UILabel *driverLbl;
@property (nonatomic, strong) UILabel *phoneLbl;
@property (nonatomic, strong) UILabel *vinLbl;
@property (nonatomic, strong) UILabel *engineLbl;
@property (nonatomic, strong) UILabel *brandLbl;
@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) MINDatePickerView *pickerView;
@end

@implementation _CBInstallInfoView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    UIView *lbl = nil;
    UIView *v0 = [self viewWithTitle:Localized(@"安装人") :&lbl];
    self.installerLbl = lbl;
    UIView *v1 = [self viewWithTitle:Localized(@"安装公司") :&lbl];
    self.companyLbl = lbl;
    UIView *v2 = [self viewWithTitle:Localized(@"安装时间") :&lbl :NO :YES];
    self.timeLbl = lbl;
    UIView *v3 = [self viewWithTitle:Localized(@"安装地点") :&lbl];
    self.placeLbl = lbl;
    UIView *v4 = [self viewWithTitle:Localized(@"司机名称") :&lbl];
    self.driverLbl = lbl;
    UIView *v5 = [self viewWithTitle:Localized(@"手机号码") :&lbl];
    self.phoneLbl = lbl;
    UIView *v6 = [self viewWithTitle:Localized(@"VIN码") :&lbl];
    self.vinLbl = lbl;
    UIView *v7 = [self viewWithTitle:Localized(@"发动机编号") :&lbl];
    self.engineLbl = lbl;
    UIView *v8 = [self viewWithTitle:Localized(@"车辆品牌") :&lbl];
    self.brandLbl = lbl;
    UIView *v9 = [self viewWithTitle:Localized(@"安装图片") :&lbl :YES :NO];
    self.imgView = lbl;
    
    NSArray *vArr = @[v0,v1,v2,v3,v4,v5,v6,v7,v8,v9];
    UIView *lastView = nil;
    for (UIView *v in vArr) {
        [self addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom);
            } else {
                make.top.equalTo(@0);
            }
            make.right.left.equalTo(@0);
        }];
        lastView = v;
    }
    [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
    }];
    
    kWeakSelf(self);
    [v0 bk_whenTapped:^{
        [weakself showInput:NO :Localized(@"请输入安装人") :weakself.installerLbl ];
    }];
    [v1 bk_whenTapped:^{
        [weakself showInput:NO :Localized(@"请输入安装公司") :weakself.companyLbl ];
    }];
    [v2 bk_whenTapped:^{
        [weakself showDatePick];
    }];
    [v3 bk_whenTapped:^{
        [weakself showInput:NO :Localized(@"请输入安装地点") :weakself.placeLbl ];
    }];
    [v4 bk_whenTapped:^{
        [weakself showInput:NO :Localized(@"请输入司机名称") :weakself.driverLbl ];
    }];
    [v5 bk_whenTapped:^{
        [weakself showInput:YES :Localized(@"请输入手机号码") :weakself.phoneLbl ];
    }];
    [v6 bk_whenTapped:^{
        [weakself showInput:NO :Localized(@"请输入VIN码") :weakself.vinLbl ];
    }];
    [v7 bk_whenTapped:^{
        [weakself showInput:NO :Localized(@"请输入发动机编号") :weakself.engineLbl ];
    }];
    [v8 bk_whenTapped:^{
        [weakself showInput:NO :Localized(@"请输入车辆品牌") :weakself.brandLbl];
    }];
    [v9 bk_whenTapped:^{
        [weakself showImgAlert];
    }];
    
    self.model = nil;
    
}

- (UIView *)viewWithTitle:(NSString *)title :(UILabel **)lbl {
    return [self viewWithTitle:title :lbl :NO :NO];
}
- (UIView *)viewWithTitle:(NSString *)title :(UIView **)lbl :(BOOL)isImg :(BOOL)isTime{
    UIView *v = [UIView new];
    
    UILabel *_lbl = [MINUtils createLabelWithText:title size:16 alignment:NSTextAlignmentLeft textColor:kCellTextColor];
    [v addSubview:_lbl];
    [_lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.greaterThanOrEqualTo(@15);
        make.bottom.lessThanOrEqualTo(@-15);
        make.centerY.equalTo(@0);
    }];
    
    UIView *line = UIView.new;
    line.backgroundColor = KCarLineColor;
    [v addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.bottom.equalTo(@0);
    }];
    
    UIImageView *arrow = [UIImageView new];
    arrow.image = [UIImage imageNamed:@"查看"];
    [v addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(@-10);
    }];
    
    if (!isImg) {
        UIImageView *imgV = nil;
        if (isTime) {
            UIImageView *time = [UIImageView new];
            time.image = [UIImage imageNamed:@"时间-可点击"];
            [v addSubview:time];
            [time mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@15);
                make.centerY.equalTo(@0);
                make.right.equalTo(arrow.mas_left).mas_offset(-10);
            }];
            imgV = time;
        }
        
        UILabel *contentLbl = [MINUtils createLabelWithText:@"" size:16 alignment:NSTextAlignmentLeft textColor:kCellTextColor];
        [v addSubview:contentLbl];
        [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            if (imgV) {
                make.right.equalTo(imgV.mas_left).mas_offset(-10);
            } else {
                make.right.equalTo(arrow.mas_left).mas_offset(-10);
            }
        }];
        *lbl = contentLbl;
    } else {
        UIImageView *img = [UIImageView new];
        img.image = [UIImage imageNamed:@"右边"];
        [v addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(arrow.mas_left).mas_offset(-10);
            make.width.height.equalTo(@60);
            make.top.equalTo(@15);
            make.bottom.equalTo(@-15);
        }];
        img.layer.cornerRadius = 4;
        img.layer.masksToBounds = YES;
        *lbl = img;
    }
    
    return v;
}

- (void)setModel:(_CBInstallInfo *)model {
    _model = model;
    
    
    [self setLbl:self.installerLbl text:_model.installer placeHolder:Localized(@"请输入")];
    [self setLbl:self.companyLbl text:_model.installCompany placeHolder:Localized(@"请输入")];
    NSString *installTime = kStringIsEmpty(_model.installTime) ? @"" : [CBWtMINUtils getTimeFromTimestamp:_model.installTime formatter: @"yyyy-MM-dd HH:mm:ss"];
    [self setLbl:self.timeLbl text:installTime placeHolder:Localized(@"请设置时间")];
    [self setLbl:self.placeLbl text:_model.installLocation placeHolder:Localized(@"请输入")];
    [self setLbl:self.driverLbl text:_model.driverName placeHolder:Localized(@"请输入")];
    [self setLbl:self.phoneLbl text:_model.installMobile placeHolder:Localized(@"请输入")];
    [self setLbl:self.vinLbl text:_model.vinCode placeHolder:Localized(@"请输入")];
    [self setLbl:self.engineLbl text:_model.engineNumber placeHolder:Localized(@"请输入")];
    [self setLbl:self.brandLbl text:_model.vehicleBrand placeHolder:Localized(@"请输入")];
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.installPicture] placeholderImage:[UIImage imageNamed:@"添加图片"]];
}

- (void)setLbl:(UILabel *)lbl text:(NSString *)text placeHolder:(NSString *)placeHolder{
    lbl.text = kStringIsEmpty(text) ? placeHolder : text;
    lbl.textColor = kStringIsEmpty(text) ? kTextFieldColor : kCellTextColor;
}

- (void)showInput:(BOOL)isNum :(NSString *)placeHolder :(UILabel *)lbl {
    __weak UILabel *wLbl = lbl;
    kWeakSelf(self);
    [[CBCarAlertView viewWithMultiInput:@[placeHolder] title:Localized(@"安装信息") isDigital:isNum maxLength:13 confirmCanDismiss:^BOOL(NSArray<NSString *> * _Nonnull contentStr) {
        return YES;
    } confrim:^(NSArray<NSString *> * _Nonnull contentStr) {
        [weakself setLbl:wLbl text:contentStr.firstObject placeHolder:Localized(@"请输入")];
    }] pop];
}
#pragma mark - MINDatePickerViewDelegare
- (void)datePicker:(MINDatePickerView *)pickerView didSelectordate:(NSString *)dateString date:(NSDate *)date {
    NSLog(@"%@", dateString);
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *string = [formatter stringFromDate:date];
    
    [self setLbl:self.timeLbl text:string placeHolder:Localized(@"请设置时间")];
//    self.dateString = dateString;
//    NSDictionary *dicTime = [CBCommonTools getSomeDayPeriod:date];
//    self.dateStringStart = [NSString stringWithFormat:@"%@",dicTime[@"startTime"]];
//    self.dateStringEnd = [NSString stringWithFormat:@"%@",dicTime[@"endTime"]];
}
- (void)showDatePick {
    [self.pickerView showView];
}
- (MINDatePickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[MINDatePickerView alloc] initWithLimitDate:NO];
        if (@available(iOS 13.4, *)) {
            _pickerView.datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        } else {
            // Fallback on earlier versions
        }
        [UIApplication.sharedApplication.keyWindow addSubview: _pickerView];
        [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(@0);
        }];
        _pickerView.delegate = self;
        kWeakSelf(self);
        _pickerView.didHide = ^{
            [weakself didHidePickView];
        };
    }
    return _pickerView;
}

- (void)didHidePickView {
    [_pickerView removeFromSuperview];
    _pickerView = nil;
}

- (void)showImgAlert {
    kWeakSelf(self);
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
        PickerImage.delegate = weakself;
        //页面跳转
        [weakself.getVC presentViewController:PickerImage animated:YES completion:nil];
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
        PickerImage.delegate = weakself;
        [weakself.getVC presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleCancel handler:nil]];
    [weakself.getVC presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate, UIImagePickerControllerDelegate
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    // 压缩需要上传的图片
    UIImage *uploadImage = [self imageWithImageSimple:newPhoto scaledToSize:CGSizeMake(83, 83)];
    
    
    self.imgView.image = uploadImage;
    
    kWeakSelf(self);
    [picker dismissViewControllerAnimated:YES completion:^{
        if (uploadImage && weakself.didChooseImg) {
            weakself.didChooseImg(uploadImage);
        }
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

- (UIViewController *)getVC {
    return UIApplication.sharedApplication.keyWindow.rootViewController;
}

- (NSMutableDictionary *)getSaveInfo {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [self addParam:param key:@"installer" label:self.installerLbl];
    [self addParam:param key:@"installCompany" label:self.companyLbl];
    [self addParam:param key:@"installTime" label:self.timeLbl];
    [self addParam:param key:@"installLocation" label:self.placeLbl];
    [self addParam:param key:@"driverName" label:self.driverLbl];
    [self addParam:param key:@"installerMobile" label:self.phoneLbl];
    [self addParam:param key:@"vinCode" label:self.vinLbl];
    [self addParam:param key:@"engineNumber" label:self.engineLbl];
    [self addParam:param key:@"vehicleBrand" label:self.brandLbl];
    NSString *dno = [CBCommonTools CBdeviceInfo].dno?:@"";
    param[@"dno"] = dno;
    return param;
}

- (void)addParam:(NSMutableDictionary *)param key:(NSString *)key label:(UILabel *)lbl {
    if (!kStringIsEmpty(lbl.text) && ![lbl.text isEqualToString:Localized(@"请设置时间")] && ![lbl.text isEqualToString:Localized(@"请输入")]) {
        param[key] = lbl.text;
    }
}
@end
