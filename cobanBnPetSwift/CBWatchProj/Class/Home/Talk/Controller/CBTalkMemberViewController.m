//
//  CBTalkMemberViewController.m
//  Watch
//
//  Created by coban on 2019/9/6.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBTalkMemberViewController.h"
#import "CBTalkCollectionView.h"
#import "CBTalkModel.h"
#import "CBChatFMDBManager.h"
#import "CBInviteFamilyViewController.h"

// 标题
#define KTitleHeight ([NSString getHeightText:Localized(@"绑定手表的家庭成员,会自动添加到语聊") font:[UIFont fontWithName:CBPingFangSC_Regular size:14] width:SCREEN_WIDTH] + 15)
// 单元格宽
#define KItemWidth ((SCREEN_WIDTH - 5*frameSizeRate*3 - 10*frameSizeRate*2)/4)
// 集合视图最大宽度
#define KCollectionMaxHeight (SCREEN_HEIGHT - PPNavigationBarHeight)
// 清除聊天记录与集合视图，底部的间距和本身高
#define KClearBtnHeight (30 + 44 + 20)

@interface CBTalkMemberViewController ()<CBTalkCollectionViewDelegate>
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) CBTalkCollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,strong) UIButton *btnClearChatLog;
/** 添加按钮模型 */
@property (nonatomic,strong) CBTalkMemberModel *addModel;
@end

@implementation CBTalkMemberViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}
- (void)setupView {
    self.view.backgroundColor = KWtBackColor;
    [self initBarWithTitle:Localized(@"成员") isBack: YES];
    
    [self titleLb];
    [self collectionView];
    [self btnClearChatLog];
    
    [self getTalkMemberRequest];
}
#pragma mark -- setting && getting
- (UILabel *)titleLb {
    if (!_titleLb) {
        CGFloat height = [NSString getHeightText:Localized(@"绑定手表的家庭成员,会自动添加到语聊") font:[UIFont fontWithName:CBPingFangSC_Regular size:14] width:SCREEN_WIDTH];
        
        UIView *bgmView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15 + height + 0)];
        bgmView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bgmView];
        
        _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(15*frameSizeRate, 0, SCREEN_WIDTH - 30*frameSizeRate, 15 + height + 0)];
        _titleLb.numberOfLines = 0;
        _titleLb.font = [UIFont fontWithName:CBPingFangSC_Regular size:14];
        _titleLb.text = Localized(@"绑定手表的家庭成员,会自动添加到语聊");
        _titleLb.textColor = [UIColor colorWithHexString:@"#282828"];
        _titleLb.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_titleLb];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 15 + height + 0, SCREEN_WIDTH, 1)];
        line.backgroundColor = KWtBackColor;
        [self.view addSubview:line];
    }
    return _titleLb;
}
- (CBTalkCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;//UICollectionViewScrollDirectionHorizontal;
        //设置每个段与周围区域（即段于段之间、段与集合视图的边界之间）的距离
        //UIEdgeInsetsMake(顶部，左边，下边，右边）
        //实际距离可能比配置的值大
        layout.sectionInset = UIEdgeInsetsMake(15.0*frameSizeRate, 10.0f*frameSizeRate, 15.0f*frameSizeRate, 10.0f*frameSizeRate);
        //最小行间距(默认为10)
        //水平间隔
        layout.minimumInteritemSpacing = 5*frameSizeRate;
        //垂直行间距
        layout.minimumLineSpacing = 15*frameSizeRate;
        //每个单元的大小，也可以通过collectionView:layout:sizeForItemAtIndexPath:协议方法动态指定
        //每个单元大小 屏幕宽 - 设置的行间距*列数 - 左边距 - 右边距
        //(SCREEN_WIDTH - 5*frameSizeRate*3 - 10*frameSizeRate*2)/4;
        CGFloat itemHeight = KItemWidth;
        CGFloat collectionViewHeight = (15*frameSizeRate + KItemWidth)*[self getColloctionRows];
        layout.itemSize = CGSizeMake(KItemWidth, itemHeight);
        _collectionView = [[CBTalkCollectionView alloc]initWithFrame:CGRectMake(0*frameSizeRate, CGRectGetMaxY(self.titleLb.frame)+1, SCREEN_WIDTH, collectionViewHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_collectionView];
        _collectionView.clickDelegate = self;
    }
    return _collectionView;
}
- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = [NSMutableArray array];
    }
    return _arrayData;
}
- (UIButton *)btnClearChatLog {
    if (!_btnClearChatLog) {
        CGFloat width = [NSString getWidthWithText:Localized(@"清除聊天记录") font:[UIFont fontWithName:CBPingFangSC_Regular size:14] height:50];
        _btnClearChatLog = [UIButton new];
        [_btnClearChatLog setTitle:Localized(@"清除聊天记录") forState:UIControlStateNormal];
        [_btnClearChatLog setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnClearChatLog.titleLabel.font = [UIFont fontWithName:CBPingFangSC_Regular size:14];
        _btnClearChatLog.backgroundColor = KWtAppMainColor;
        _btnClearChatLog.layer.masksToBounds = YES;
        _btnClearChatLog.layer.cornerRadius = 22;
        [self.view addSubview:_btnClearChatLog];
        [_btnClearChatLog mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.collectionView.mas_bottom).offset(30);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(width + 80);
        }];
        [_btnClearChatLog addTarget:self action:@selector(clearChatLogAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnClearChatLog;
}
- (CBTalkMemberModel *)addModel {
    if (!_addModel) {
        _addModel = [[CBTalkMemberModel alloc]init];
        _addModel.name = Localized(@"添加");
        _addModel.isAddBtn = YES;
    }
    return _addModel;
}
#pragma mark -- 获取语聊成员
- (void)getTalkMemberRequest {
    [self.arrayData removeAllObjects];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:[HomeModel CBDevice].tbWatchMain.sno?:@"" forKey:@"sno"];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetworkRequestManager sharedInstance] getTalkMemberParamters:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *array = baseModel.data;
        for (NSDictionary *dic in array) {
            CBTalkMemberModel *model = [CBTalkMemberModel mj_objectWithKeyValues:dic];
            [self.arrayData addObject:model];
        }
        [self.arrayData addObject:self.addModel];
        
        CGFloat collectionViewHeight = (15*frameSizeRate + KItemWidth)*[self getColloctionRows] + (self.arrayData.count == 0?0:15*frameSizeRate);
        if (collectionViewHeight >= (KCollectionMaxHeight - KTitleHeight - KClearBtnHeight)) {
            collectionViewHeight = (KCollectionMaxHeight - KTitleHeight - KClearBtnHeight);
        }
        _collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.titleLb.frame)+1, SCREEN_WIDTH, collectionViewHeight);
        [self.collectionView updateTalkMemberDataArray:self.arrayData];
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
// 得到适配集合视图的行数
- (int)getColloctionRows {
    int menuTotalCount = (int)self.arrayData.count;
    int unit = menuTotalCount%4;
    int rows = 0;
    rows = unit == 0?menuTotalCount/4:menuTotalCount/4 + 1;
    return rows;
}
#pragma mark -- 清除聊天记录
- (void)clearChatLogAction {
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:Localized(@"清空聊天记录") message:Localized(@"确定清空记录?") preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self clearChatLogRequest];
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alertControl animated:YES completion:nil];
}
- (void)clearChatLogRequest {
    [CBWtMINUtils showProgressHudToView:self.view withText:Localized(@"清理完成")];
    BOOL result = [[CBChatFMDBManager sharedFMDataBase] deleteGroupChat:@""];
    if (result) {
        NSLog(@"清理完成");
    } else {
        NSLog(@"清理失败");
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (self.clearBlock) {
        self.clearBlock();
    }
//    return;
//    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
//    [paramters setObject:[HomeModel CBDevice].tbWatchMain.sno?:@"" forKey:@"sno"];
//    [MBProgressHUD showHUDIcon:self.view animated:YES];
//    kWeakSelf(self);
//    [[CBWtNetworkRequestManager sharedInstance] clearChatLogParamters:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
//        kStrongSelf(self);
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        switch (baseModel.status) {
//            case CBWtNetworkingStatus0:
//            {
//                [CBWtMINUtils showProgressHudToView:self.view withText:Localized(@"清理完成")];
//                BOOL result = [[CBChatFMDBManager sharedFMDataBase] deleteGroupChat:@""];
//                if (result) {
//                    NSLog(@"清理完成");
//                } else {
//                    NSLog(@"清理失败");
//                }
//                if (self.clearBlock) {
//                    self.clearBlock();
//                }
//            }
//                break;
//            default:
//            {
//                [CBWtMINUtils showProgressHudToView:self.view withText:baseModel.resmsg];
//            }
//                break;
//        }
//    } failure:^(NSError * _Nonnull error) {
//        kStrongSelf(self);
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }];
}
#pragma mark -- 集合视图点击代理
- (void)collectionClick:(NSInteger)index clickModel:(CBTalkMemberModel *)model {
    if (model.isAddBtn) {
        CBInviteFamilyViewController *vc = [CBInviteFamilyViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
