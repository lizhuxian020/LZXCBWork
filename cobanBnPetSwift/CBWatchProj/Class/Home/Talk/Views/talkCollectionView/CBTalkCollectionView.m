//
//  CBTalkCollectionView.m
//  Watch
//
//  Created by coban on 2019/9/6.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBTalkCollectionView.h"
#import "CBTalkCollectionViewCell.h"

static NSString *talkCell = @"CBTalkCollectionCell";

@interface CBTalkCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) NSMutableArray *arrayData;
//@property (nonatomic,strong) UIButton *btnClearChatLog;
@end
@implementation CBTalkCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    //self.backgroundColor = [UIColor whiteColor];
    //self.scrollEnabled = NO;
    self.dataSource = self;
    self.delegate = self;
    
    // 设置此属性为yes 不满一屏幕 也能滚动
    //collectionView.alwaysBounceHorizontal = YES;
    //self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    //collectionView.pagingEnabled = YES;
    //self.collectionView.scrollEnabled = YES;
    //注册可重用的单元所使用的类
    [self registerClass:[CBTalkCollectionViewCell class] forCellWithReuseIdentifier:talkCell];
    //注册可重用的段头所使用的类
    [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    //注册可重用的段尾所使用的类
    [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
}
//- (UIButton *)btnClearChatLog {
//    if (!_btnClearChatLog) {
//        CGFloat width = [NSString getWidthWithText:Localized(@"清除聊天记录") font:[UIFont fontWithName:CBPingFangSC_Regular size:14] height:50];
//        _btnClearChatLog = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - width - 80)/2, 0, width + 80, 44)];
//        [_btnClearChatLog setTitle:Localized(@"清除聊天记录") forState:UIControlStateNormal];
//        [_btnClearChatLog setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _btnClearChatLog.titleLabel.font = [UIFont fontWithName:CBPingFangSC_Regular size:14];
//        _btnClearChatLog.backgroundColor = KWtAppMainColor;
//        _btnClearChatLog.layer.masksToBounds = YES;
//        _btnClearChatLog.layer.cornerRadius = 22;
//        //[self.view addSubview:_btnClearChatLog];
////        [_btnClearChatLog mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.top.mas_equalTo(self.collectionView.mas_bottom).offset(30);
////            make.centerX.mas_equalTo(self.view.mas_centerX);
////            make.height.mas_equalTo(44);
////            make.width.mas_equalTo(width + 80);
////        }];
//        [_btnClearChatLog addTarget:self action:@selector(clearChatLogAction) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _btnClearChatLog;
//}
- (void)updateTalkMemberDataArray:(NSMutableArray *)array {
    self.arrayData = array;
    [self reloadData];
}
#pragma mark - UICollectionViewDataSource
// 设置分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CBTalkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:talkCell forIndexPath:indexPath];
    if (self.arrayData.count > indexPath.row) {
        CBTalkMemberModel *model = self.arrayData[indexPath.row];
        cell.talkModel = model;
    }
    return cell;
    return UICollectionViewCell.new;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.arrayData.count > indexPath.row) {
        CBTalkMemberModel *model = self.arrayData[indexPath.row];
        if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(collectionClick:clickModel:)]) {
            [self.clickDelegate collectionClick:indexPath.row clickModel:model];
        }
    }
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    return CGSizeMake(SCREEN_WIDTH, 44);//304
//}
//- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    if (kind == UICollectionElementKindSectionHeader) {
//        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
//        return header;
//    } else if (kind == UICollectionElementKindSectionFooter) {
//        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:indexPath];
//        footer.backgroundColor = KWtBackColor;//[UIColor clearColor];//[UIColor darkGrayColor];
//        [footer addSubview:self.btnClearChatLog];
//        return footer;
//    } else {
//        return nil;
//    }
//}
@end
