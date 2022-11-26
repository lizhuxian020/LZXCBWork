//
//  CBPersonInfoController.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/27.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBPersonInfoController.h"
#import "cobanBnPetSwift-Swift.h"

@interface CBPersonInfoController ()

@property (nonatomic, strong) UIView *imgV;
@property (nonatomic, strong) UIView *accountV;
@property (nonatomic, strong) UIView *nameV;
@property (nonatomic, strong) UIView *phoneV;
@property (nonatomic, strong) UIView *emailV;

@end

@implementation CBPersonInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBarWithTitle:Localized(@"个人信息") isBack:YES];
    [self initBarRighBtnTitle:@"保存" target:self action:@selector(save)];
    
    CBPetLoginModel *userModel = [CBPetLoginModelTool getUser];
    
    self.imgV = [self viewWithTitle:Localized(@"头像") renderHead:YES content:nil canClick:YES];
    self.accountV = [self viewWithTitle:Localized(@"账号") renderHead:NO content:userModel.account canClick:NO];
    self.nameV = [self viewWithTitle:Localized(@"昵称") renderHead:NO content:userModel.name canClick:YES];
    self.phoneV = [self viewWithTitle:Localized(@"手机号码") renderHead:NO content:userModel.phone canClick:YES];
    self.emailV = [self viewWithTitle:Localized(@"邮箱") renderHead:NO content:userModel.email canClick:YES];
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
}

- (UIView *)viewWithTitle:(NSString *)title renderHead:(BOOL)renderHead content:(NSString *)content canClick:(BOOL)canClick {
    UIView *v = [UIView new];
    
    UILabel *lbl = [MINUtils createLabelWithText:title size:14 alignment:NSTextAlignmentCenter textColor:UIColor.blackColor];
    [v addSubview:lbl];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@20);
        make.bottom.equalTo(@-20);
    }];
    
    if (renderHead) {
        CBPetLoginModel *userModel = [CBPetLoginModelTool getUser];
        UIImageView *img = [UIImageView new];
        [img sd_setImageWithURL:[NSURL URLWithString:userModel.photo] placeholderImage:[UIImage imageNamed:@""]];
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
            [v addSubview:cLbl];
            [cLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(@0);
                make.right.equalTo(arrow.mas_left).mas_offset(-10);
            }];
        }
        arrow.hidden = !canClick;
    }
    
    
    
    UIView *line = [UIView new];
    [v addSubview:line];
    line.backgroundColor = UIColor.grayColor;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.right.equalTo(@-30);
        make.height.equalTo(@1);
        make.bottom.equalTo(@0);
    }];
    return v;
}

- (void)save {
    NSLog(@"%s", __FUNCTION__);
}

@end
