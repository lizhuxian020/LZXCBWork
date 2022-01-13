//
//  CBBindMemberViewController.m
//  cobanBnWatch
//
//  Created by coban on 2019/12/6.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBBindMemberViewController.h"
#import "CBBindMemberCollectionView.h"
#import "AddressBookModel.h"
#import "CBInviteFamilyViewController.h"

// 标题
#define KTitleHeight ([NSString getHeightText:Localized(@"绑定手表的家庭成员,会自动添加到语聊") font:[UIFont fontWithName:CBPingFangSC_Regular size:14] width:SCREEN_WIDTH] + 15)
// 单元格宽
#define KItemWidth ((SCREEN_WIDTH - 20*frameSizeRate - 10*frameSizeRate*2)/2)
// 集合视图最大宽度
#define KCollectionMaxHeight (SCREEN_HEIGHT - PPNavigationBarHeight)
// 清除聊天记录与集合视图，底部的间距和本身高
#define KClearBtnHeight (30 + 44 + 20)

@interface CBBindMemberViewController ()<CBBindMemberCollectionViewDelegate>
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) CBBindMemberCollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,strong) AddressBookModel *addAddressModel;
@end

@implementation CBBindMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
    [self getFamilyDataReuqest];
}
- (void)setupView {
    self.view.backgroundColor = KWtBackColor;
    [self initBarWithTitle:Localized(@"绑定成员") isBack: YES];
    
    [self titleLb];
    [self collectionView];
}
#pragma mark -- setting && getting
- (UILabel *)titleLb {
    if (!_titleLb) {
        CGFloat height = [NSString getHeightText:Localized(@"需下载APP绑定手表才可以跟宝贝微聊和电话") font:[UIFont fontWithName:CBPingFangSC_Regular size:14] width:SCREEN_WIDTH];
        
        UIView *bgmView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15 + height + 0)];
        bgmView.backgroundColor = KWtBackColor;//[UIColor whiteColor];
        [self.view addSubview:bgmView];
        
        _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(15*frameSizeRate, 0, SCREEN_WIDTH - 30*frameSizeRate, 15 + height + 0)];
        _titleLb.numberOfLines = 0;
        _titleLb.font = [UIFont fontWithName:CBPingFangSC_Regular size:14];
        _titleLb.text = Localized(@"需下载APP绑定手表才可以跟宝贝微聊和电话");
        _titleLb.textColor = [UIColor colorWithHexString:@"#282828"];
        _titleLb.backgroundColor = KWtBackColor;//[UIColor whiteColor];
        [self.view addSubview:_titleLb];
    }
    return _titleLb;
}
- (CBBindMemberCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;//UICollectionViewScrollDirectionHorizontal;
        //设置每个段与周围区域（即段于段之间、段与集合视图的边界之间）的距离
        //UIEdgeInsetsMake(顶部，左边，下边，右边）
        //实际距离可能比配置的值大
        layout.sectionInset = UIEdgeInsetsMake(15.0*frameSizeRate, 10.0f*frameSizeRate, 15.0f*frameSizeRate, 10.0f*frameSizeRate);
        //最小行间距(默认为10)
        //水平间隔
        layout.minimumInteritemSpacing = 20*frameSizeRate;
        //垂直行间距
        layout.minimumLineSpacing = 15*frameSizeRate;
        //每个单元的大小，也可以通过collectionView:layout:sizeForItemAtIndexPath:协议方法动态指定
        //每个单元大小 屏幕宽 - 设置的行间距*列数 - 左边距 - 右边距
        //(SCREEN_WIDTH - 5*frameSizeRate - 10*frameSizeRate*2)/2;
        CGFloat itemHeight = 100*frameSizeRate + 5 + 25*frameSizeRate;//KItemWidth;
        layout.itemSize = CGSizeMake(KItemWidth, itemHeight);
        _collectionView = [[CBBindMemberCollectionView alloc]initWithFrame:CGRectMake(0*frameSizeRate, CGRectGetMaxY(self.titleLb.frame)+1, SCREEN_WIDTH, KCollectionMaxHeight - KTitleHeight) collectionViewLayout:layout];
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
- (AddressBookModel *)addAddressModel {
    if (!_addAddressModel) {
        _addAddressModel = [[AddressBookModel alloc]init];
        _addAddressModel.isBindAction = YES;
    }
    return _addAddressModel;
}
#pragma mark -- 获取通讯录列表-筛选family = 1 的用户
- (void)getFamilyDataReuqest {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    paramters[@"sno"] = [HomeModel CBDevice].tbWatchMain.sno;
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] getWithUrl: @"watch/watch/getConnectList" params:paramters succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            NSLog(@"通讯录列表:%@",response);
            if (response && [response[@"data"] isKindOfClass: [NSArray class]]) {
                for (NSDictionary *dic in response[@"data"]) {
                    AddressBookModel *model = [AddressBookModel yy_modelWithDictionary:dic];
                    if ([model.family isEqualToString:@"1"]) {
                        [self.arrayData addObject:model];
                    }
                }
                [self.arrayData addObject:self.addAddressModel];
                [self.collectionView updaterDataArray:self.arrayData];
            }
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 集合视图点击代理
- (void)collectionClick:(NSInteger)index clickModel:(AddressBookModel *)model {
    if (model.isBindAction) {
        CBInviteFamilyViewController *vc = [CBInviteFamilyViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
