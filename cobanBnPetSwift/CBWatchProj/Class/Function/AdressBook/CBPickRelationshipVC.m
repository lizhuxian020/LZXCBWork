//
//  CBPickRelationshipVC.m
//  cobanBnWatch
//
//  Created by coban on 2019/12/11.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBPickRelationshipVC.h"
#import "RelatioshipCollectionViewCell.h"
#import "AddFamilyViewController.h"
#import "AddressBookModel.h"
#import "CBWtMINAlertView.h"
#import "CBBindWatchNextViewController.h"

@interface CBPickRelationshipVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, weak) UITextField *textField;
@property (nonatomic,strong) AddressBookEditModel *modelSelect;

@end

@implementation CBPickRelationshipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}
- (void)setupView {
    [self initBarWithTitle:Localized(@"编辑关系") isBack: YES];
    if (self.isModifyRelation) {
        // 修改关系，完成
        [self initBarRighBtnTitle:Localized(@"完成") target: self action: @selector(confirmBtnClick)];
    } else {
        [self initBarRighBtnTitle:Localized(@"下一步") target: self action: @selector(nextstepBtnClick)];
    }
    [self collectionView];
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = (SCREEN_WIDTH - 80 * KFitWidthRate * 3) / 4;
        flowLayout.minimumLineSpacing = 0 * KFitWidthRate;
        flowLayout.itemSize = CGSizeMake(80 * KFitWidthRate, 125 * KFitWidthRate);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout: flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass: [RelatioshipCollectionViewCell class] forCellWithReuseIdentifier: @"RelatioshipCollectionViewCellIndentify"];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.view);
        }];
    }
    return _collectionView;
}
- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        NSArray *imageArr = @[@"爸爸", @"妈妈", @"姐姐", @"爷爷", @"奶奶", @"哥哥", @"外公", @"外婆", @"老师", @"自定义", @"校讯通"];
        NSArray *titleArr = @[Localized(@"爸爸"), Localized(@"妈妈"), Localized(@"姐姐"), Localized(@"爷爷"), Localized(@"奶奶"), Localized(@"哥哥"), Localized(@"外公"), Localized(@"外婆"), Localized(@"老师"), Localized(@"自定义"), Localized(@"校讯通")];
        //NSArray *typeArr = @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9, @10];
        _arrayData = [NSMutableArray array];
        for (int i = 0 ; i < imageArr.count ; i ++ ) {
            AddressBookEditModel *model = [[AddressBookEditModel alloc]init];
            model.title = titleArr[i];
            model.imgName = imageArr[i];
            model.name = titleArr[i];
            model.type = i;
            if ([model.title isEqualToString:Localized(@"校讯通")]) {
                model.type = 9;
            } else if ([model.title isEqualToString:Localized(@"自定义")]) {
                model.type = 10;
            }
            model.famlily = 0;
            [self.arrayData addObject:model];
        }
    }
    return _arrayData;
}
#pragma mark -- 下一步 click
- (void)nextstepBtnClick {
    if (self.modelSelect == nil) {
        [CBWtMINUtils showProgressHudToView:self.view withText:Localized(@"请选择关系")];
        return;
    }
    if (self.isAddContact) {
        // 添加联系人
        AddFamilyViewController *addFamilyVC = [[AddFamilyViewController alloc] init];
        addFamilyVC.model = self.modelSelect;
        [self.navigationController pushViewController: addFamilyVC animated: YES];
    } else {
        // 绑定手表
        CBBindWatchNextViewController *vc = [[CBBindWatchNextViewController alloc]init];
        vc.sno = self.sno;
        vc.hasAdmin = self.hasAdmin;
        vc.model = self.modelSelect;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark -- 完成修改联系人关系
- (void)confirmBtnClick {
    if (self.modelSelect == nil) {
        [CBWtMINUtils showProgressHudToView:self.view withText:Localized(@"请选择关系")];
        return;
    }
    [self requestEditInfoWithName: nil];
}
#pragma mark -- 修改联系人关系
- (void)requestEditInfoWithName:(NSString *)name {
    NSMutableDictionary *parmaters = [NSMutableDictionary dictionary];
    parmaters[@"relationId"] = self.model.relationId;
    parmaters[@"type"] = [NSNumber numberWithInt:self.modelSelect.type];
    if (name == nil) {
        parmaters[@"relation"] = self.modelSelect.title;
    } else {
        parmaters[@"relation"] = name;
    }
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetWorkingManager shared] postWithUrl: @"watch/watch/updConnectInfo" params:parmaters succeed:^(id response, BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [self.navigationController popViewControllerAnimated: YES];
            self.model.type = self.modelSelect.type;
            if (name == nil) {
                self.model.relation = self.modelSelect.title;
            }else {
                self.model.relation = name;
            }
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark - UICollectionViewDelegate UICollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AddressBookEditModel *modelCurrent = self.arrayData[indexPath.item];
    for (AddressBookEditModel *model in self.arrayData) {
        if ([model isEqual:modelCurrent]) {
            model.isSelect = YES;
            self.modelSelect = model;
        } else {
            model.isSelect = NO;
        }
    }
    [self.collectionView reloadData];
    if ([modelCurrent.title isEqualToString:Localized(@"自定义")]) { // 自定义 && self.isAddRelationship == NO
        __weak __typeof__(self) weakSelf = self;
        CBWtMINAlertView *alertView = [[CBWtMINAlertView alloc] init];
        alertView.titleLabel.text = Localized(@"提示");
        [alertView showRightCloseBtn];
        [self.view addSubview: alertView];
        [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(weakSelf.view);
            make.height.mas_equalTo(SCREEN_HEIGHT);
        }];
        // 重置高度
        [alertView setContentViewHeight:80];
        __weak __typeof__(CBWtMINAlertView *) weakAlertView = alertView;
        self.textField = [CBWtMINUtils createTextFieldWithHoldText:Localized(@"请输入关系，长度不超过8个字") fontSize: 15 * KFitWidthRate];
        self.textField.leftView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 25 * KFitWidthRate,  40 * KFitWidthRate)];
        self.textField.layer.cornerRadius = 20 * KFitWidthRate;
        self.textField.leftViewMode = UITextFieldViewModeAlways;
        self.textField.backgroundColor = KWtRGB(240, 240, 240);
        [self.textField limitTextFieldTextLength:8];
        [alertView.contentView addSubview: self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(alertView.contentView);
            make.centerY.equalTo(alertView.contentView).with.offset(-5 * KFitHeightRate);
            make.height.mas_equalTo(40 * KFitWidthRate);
            make.width.mas_equalTo(250 * KFitWidthRate);
        }];
        alertView.leftBtnClick = ^{
            self.modelSelect.name = weakSelf.textField.text;
            [weakAlertView hideView];
        };
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indentify = @"RelatioshipCollectionViewCellIndentify";
    RelatioshipCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: indentify forIndexPath: indexPath];
    if (self.arrayData.count > indexPath.item) {
        AddressBookEditModel *model = self.arrayData[indexPath.item];
        cell.model = model;
    }
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, (SCREEN_WIDTH - 80 * KFitWidthRate * 3) / 4, 0, (SCREEN_WIDTH - 80 * KFitWidthRate * 3) / 4);
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
