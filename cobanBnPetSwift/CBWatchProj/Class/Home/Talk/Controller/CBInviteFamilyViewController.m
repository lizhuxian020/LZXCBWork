//
//  CBInviteFamilyViewController.m
//  cobanBnWatch
//
//  Created by coban on 2019/12/5.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBInviteFamilyViewController.h"

@interface CBInviteFamilyViewController ()
@property (nonatomic,strong) UIView *noteCardView;
@property (nonatomic,strong) UIView *imgCardView;
@end

@implementation CBInviteFamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}
- (void)setupView {
    self.view.backgroundColor = KWtBackColor;
    [self initBarWithTitle:Localized(@"邀请家庭成员") isBack: YES];
    
    [self noteCardView];
    [self imgCardView];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.noteCardView.layer.cornerRadius = 4;
    self.noteCardView.layer.shadowColor = [UIColor grayColor].CGColor;  //阴影颜色
    self.noteCardView.layer.shadowRadius = 4;                           //阴影半径
    self.noteCardView.layer.shadowOpacity = 0.3;                        //阴影透明度
    self.noteCardView.layer.shadowOffset  = CGSizeMake(0, 3);           // 阴影偏移量
    
    self.imgCardView.layer.cornerRadius = 8;
    self.imgCardView.layer.shadowColor = [UIColor grayColor].CGColor;  //阴影颜色
    self.imgCardView.layer.shadowRadius = 4;                           //阴影半径
    self.imgCardView.layer.shadowOpacity = 0.3;                        //阴影透明度
    self.imgCardView.layer.shadowOffset  = CGSizeMake(0, 3);           // 阴影偏移量
}
#pragma mark -- setting && getting
- (UIView *)noteCardView {
    if (!_noteCardView) {
        _noteCardView = [UIView new];
        _noteCardView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_noteCardView];
        [_noteCardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(15*frameSizeRate);
            make.right.mas_equalTo(-15*frameSizeRate);
            make.height.mas_equalTo(15 + 20 + 15 + (10+10)*3 + 10);
        }];
        
        UILabel *titleLb = [UILabel new];
        [_noteCardView addSubview:titleLb];
        titleLb.text = Localized(@"操作流程");
        titleLb.textColor = [UIColor colorWithHexString:@"#282828"];
        titleLb.font = [UIFont fontWithName:CBPingFang_SC_Bold size:18];
        titleLb.textAlignment = NSTextAlignmentCenter;
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_noteCardView.mas_top).offset(15);
            make.left.mas_equalTo(_noteCardView.mas_left).offset(15*frameSizeRate);
            make.height.mas_equalTo(20);
        }];
        
        UILabel *noteLbTemp = nil;
        NSArray *arrayTitle = @[Localized(@"对方手机首先需要安装APP"),Localized(@"用APP扫描二维码,绑定该手表"),Localized(@"管理员同意后,就可以加入家庭群")];
        for (int i = 0 ; i < arrayTitle.count ; i ++ ) {
            UIView *cornerView = [UILabel new];
            cornerView.layer.masksToBounds = YES;
            cornerView.layer.cornerRadius = 3;
            cornerView.backgroundColor = UIColor.orangeColor;
            [_noteCardView addSubview:cornerView];
            
            UILabel *noteLab = [UILabel new];
            noteLab.font = [UIFont fontWithName:CBPingFangSC_Regular size:14];
            noteLab.text = arrayTitle[i];
            [_noteCardView addSubview:noteLab];
    
            [noteLab mas_makeConstraints:^(MASConstraintMaker *make) {
                if (noteLbTemp) {
                    make.top.mas_equalTo(noteLbTemp.mas_bottom).offset(10);
                } else {
                    make.top.mas_equalTo(titleLb.mas_bottom).offset(15);
                }
                make.left.mas_equalTo(cornerView.mas_right).offset(10);
                make.height.mas_equalTo(10);
            }];
            [cornerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(noteLab.mas_centerY);
                make.left.mas_equalTo(_noteCardView.mas_left).offset(15*frameSizeRate);
                make.size.mas_equalTo(CGSizeMake(6, 6));
            }];
            noteLbTemp = noteLab;
        }
    }
    return _noteCardView;
}
- (UIView *)imgCardView {
    if (!_imgCardView) {
        _imgCardView = [UIView new];
        _imgCardView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_imgCardView];
        [_imgCardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.noteCardView.mas_bottom).offset(30);
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
        
        UILabel *snoLab = [UILabel new];
        [self.view addSubview:snoLab];
        snoLab.text = [NSString stringWithFormat:@"%@:%@",Localized(@"绑定号"),[HomeModel CBDevice].tbWatchMain.sno];
        snoLab.textColor = UIColor.grayColor;
        snoLab.font = [UIFont fontWithName:CBPingFang_SC size:18];
        snoLab.textAlignment = NSTextAlignmentCenter;
        [snoLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLb.mas_bottom).offset(30);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        [CBWtCommonTools labelColorWithKeywords:[HomeModel CBDevice].tbWatchMain.sno label:snoLab color:UIColor.blackColor];
    }
    return _imgCardView;
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
