//
//  FunctionViewController.m
//  Watch
//
//  Created by lym on 2018/2/7.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "FunctionViewController.h"
#import "FunctionCollectionViewCell.h"
#import "FunctionHeaderCollectionReusableView.h"
#import "AddressBookViewController.h"
#import "SwitchViewController.h"
#import "GuardInSchoolViewController.h"
#import "ForbiddenInClassViewController.h"
#import "WatchCallChargeViewController.h"
#import "CollectionMessageViewController.h"
#import "TimingSwitchViewController.h"
#import "AutoReceiveViewController.h"
#import "VoicePromptViewController.h"
#import "WatchSettingViewController.h"
#import "FuctionSwitchModel.h"
#import "HomeModel.h"
#import "CBFriendViewController.h"
#import "CBBindMemberViewController.h"

@interface FunctionViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *imageArr;
@property (nonatomic, copy) NSArray *titleArr;
@property (nonatomic, strong) FuctionSwitchModel *model;
@end

@implementation FunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    
//    self.imageArr = @[@[@"通讯录", @"上学守护-1", @"上课禁用-1", @"佩戴检测"],
//                      @[@"手表话费", @"代收短信", @"通话位置", @"计步", @"定时开关机", @"自动接通", @"预留电量", @"语音提示"],
//                      @[@"手表设置", @"拒接陌生人", @"体感接听-1", @"手表挂失"]];
//    self.titleArr = @[@[@"通讯录", @"上学守护", @"上课禁用", @"佩戴检测"],
//                      @[@"手表话费", @"代收短信", @"通话位置", @"计步", @"定时开关机", @"自动接通", @"预留电量", @"语音提示"],
//                      @[@"手表设置", @"拒接陌生人", @"体感接听", @"手表挂失"]];
    
    // 定时开关机暂未开放，先隐藏
    self.imageArr = @[@[@"通讯录", @"上学守护-1", @"上课禁用-1", @"function_bind_member"], //function_bind_member  function_friend_icon
                      @[@"手表话费", @"代收短信", @"通话位置", @"计步", @"体感接听-1", @"自动接通", @"预留电量", @"语音提示"],
                      @[@"手表设置", @"拒接陌生人", @"手表挂失"]];
    self.titleArr = @[@[Localized(@"通讯录-功能列表"), Localized(@"上学守护-功能列表"), Localized(@"上课禁用-功能列表"), Localized(@"绑定成员")],//Localized(@"好友-功能列表")],
                      @[Localized(@"手表话费-功能列表"), Localized(@"代收短信-功能列表"), Localized(@"通话位置-功能列表"), Localized(@"计步-功能列表"), Localized(@"体感接听-功能列表"), Localized(@"自动接通-功能列表"), Localized(@"预留电量-功能列表"), Localized(@"语音提示-功能列表")],
                      @[Localized(@"手表设置-功能列表"), Localized(@"拒接陌生人-功能列表"), Localized(@"手表挂失-功能列表")]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self getSwitchStatusData];
}
#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"功能") isBack: YES];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //flowLayout.minimumInteritemSpacing = (SCREEN_WIDTH - 90 * KFitWidthRate * 4) / 5;
    flowLayout.minimumInteritemSpacing = 0*frameSizeRate;
    flowLayout.minimumLineSpacing = 0*KFitWidthRate;
    //flowLayout.itemSize = CGSizeMake(90 * KFitWidthRate, 90 * KFitWidthRate);
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-10)/4, 90 * KFitWidthRate);
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout: flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    //    self.collectionView.backgroundColor = KWtRGB(237, 237, 237);
    [self.collectionView registerClass: [FunctionCollectionViewCell class] forCellWithReuseIdentifier: @"FunctionCollectionViewCellIndentify"];
    [self.collectionView registerClass:[FunctionHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FunctionHeaderCollectionReusableViewIndentify"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableViewIndentify"];
    [self.view addSubview: self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}
#pragma mark -- 获取手表开关状态 (手表的基本开关)
- (void)getSwitchStatusData {
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"sno"] = self.homeInfoModel.tbWatchMain.sno?:@"";//[AppDelegate shareInstance].currentSno;
    //MBProgressHUD *hud = [CBWtMINUtils hudToView: self.view withText: Localized(@"MINHud_Loading")];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] getWithUrl: @"watch/watch/getSwitchStatus" params: dic succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed && response && [response[@"data"] isKindOfClass: [NSDictionary class]]) {
            weakSelf.model = [FuctionSwitchModel yy_modelWithDictionary: response[@"data"]];
        }
        //[hud hideAnimated: YES];
    } failed:^(NSError *error) {
        //[hud hideAnimated: YES];
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark - UICollectionViewDelegate UICollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 通讯录
            AddressBookViewController *addressBookVC = [[AddressBookViewController alloc] init];
            [self.navigationController pushViewController: addressBookVC animated: YES];
        } else if (indexPath.row == 1) {
            // 上学守护
            GuardInSchoolViewController *guardInSchoolVC = [[GuardInSchoolViewController alloc] init];
            [self.navigationController pushViewController: guardInSchoolVC animated: YES];
        } else if (indexPath.row == 2) {
            // 上课禁用
            ForbiddenInClassViewController *forbiddenInClassVC = [[ForbiddenInClassViewController alloc] init];
            [self.navigationController pushViewController: forbiddenInClassVC animated: YES];
        } else if (indexPath.row == 3) {
            // 佩戴检测
            //[self pushSwitchViewWithType: SwitchViewTypeWear];
            
            // 好友
//            CBFriendViewController *vc = [CBFriendViewController alloc].init;
//            vc.homeInfoModel = self.homeInfoModel;
//            [self.navigationController pushViewController:vc animated:YES];
            
            CBBindMemberViewController *vc = [[CBBindMemberViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 1) {
        // 常用功能
        if (indexPath.row == 0) {
            // 手表话费
            WatchCallChargeViewController *watchChargeVC = [[WatchCallChargeViewController alloc] init];
            [self.navigationController pushViewController: watchChargeVC animated: YES];
        }else if (indexPath.row == 1) {
            // 代收短信
            CollectionMessageViewController *collectionMessageVC = [[CollectionMessageViewController alloc] init];
            collectionMessageVC.model = self.model;
            [self.navigationController pushViewController: collectionMessageVC animated: YES];
        }else if (indexPath.row == 2) {
            // 通话位置
            [self pushSwitchViewWithType: SwitchViewTypeCommunicatePostion];
        }else if (indexPath.row == 3) {
            // 计步
            [self pushSwitchViewWithType: SwitchViewTypeStep];
        }else if (indexPath.row == 4) {
//            // 定时开关机
//            TimingSwitchViewController *timingSwitchVC = [[TimingSwitchViewController alloc] init];
//            timingSwitchVC.model = self.model;
//            [self.navigationController pushViewController: timingSwitchVC animated: YES];
            
            // 体感接听
            [self pushSwitchViewWithType: SwitchViewTypeSomatosensory];
            
        }else if (indexPath.row == 5) {
            // 自动接通
            AutoReceiveViewController *autoReceiveVC = [[AutoReceiveViewController alloc] init];
            autoReceiveVC.model = self.model;
            [self.navigationController pushViewController: autoReceiveVC animated: YES];
        }else if (indexPath.row == 6) {
            // 预留电量
            [self pushSwitchViewWithType: SwitchViewTypeResercationPower];
        }else if (indexPath.row == 7) {
            // 语音提示
            VoicePromptViewController *voicePromptVC = [[VoicePromptViewController alloc] init];
            voicePromptVC.model = self.model;
            [self.navigationController pushViewController: voicePromptVC animated: YES];
        }
    }else if (indexPath.section == 2) {
        // 更多功能
        if (indexPath.row == 0) {
            // 手表设置
            WatchSettingViewController *watchSettingVC = [[WatchSettingViewController alloc] init];
            watchSettingVC.model = self.model;
            [self.navigationController pushViewController: watchSettingVC animated: YES];
        }else if (indexPath.row == 1) {
            // 拒接陌生人
            [self pushSwitchViewWithType: SwitchViewTypeCalling];
        }else if (indexPath.row == 2) {
            // 体感接听
            //[self pushSwitchViewWithType: SwitchViewTypeSomatosensory];
            // 手表挂失
            [self pushSwitchViewWithType: SwitchViewTypeWatchReportLoss];
        }
//        else if (indexPath.row == 3) {
//            // 手表挂失
//            //[self pushSwitchViewWithType: SwitchViewTypeWatchReportLoss];
//        }
    }
}

- (void)pushSwitchViewWithType:(SwitchViewType)type
{
    SwitchViewController *switchVC = [[SwitchViewController alloc] init];
    switchVC.switchType = type;
    switchVC.model = self.model;
    [self.navigationController pushViewController: switchVC animated: YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section == 0) {
        return 4;
    }else if(section == 1){
        return 8;
    }
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentify = @"FunctionCollectionViewCellIndentify";
    FunctionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: indentify forIndexPath: indexPath];
    cell.textLabel.text = self.titleArr[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed: self.imageArr[indexPath.section][indexPath.row]];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
    //return UIEdgeInsetsMake(0, (SCREEN_WIDTH - 90 * KFitWidthRate * 4) / 5-1, 0, (SCREEN_WIDTH - 90 * KFitWidthRate * 4) / 5 - 1);
//    return UIEdgeInsetsMake(12.5 * KFitWidthRate, 12.5 * KFitWidthRate, 12.5 * KFitWidthRate, 7.5 * KFitWidthRate);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentify = @"FunctionHeaderCollectionReusableViewIndentify";
    if (kind == UICollectionElementKindSectionHeader && indexPath.section == 1) {
        FunctionHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier: indentify forIndexPath: indexPath];
        headerView.titleLabel.text = Localized(@"常用功能");
        return headerView;
    }else if (kind == UICollectionElementKindSectionHeader && indexPath.section == 2) {
        FunctionHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier: indentify forIndexPath: indexPath];
        headerView.titleLabel.text = Localized(@"更多功能");
        return headerView;
    }
    return [collectionView dequeueReusableSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier: @"UICollectionReusableViewIndentify" forIndexPath: indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 0 * KFitWidthRate);
    }
    return CGSizeMake(SCREEN_WIDTH, 52.5 * KFitWidthRate);
}


#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
