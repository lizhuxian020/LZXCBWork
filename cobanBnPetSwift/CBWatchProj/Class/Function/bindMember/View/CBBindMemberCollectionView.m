//
//  CBBindMemberCollectionView.m
//  cobanBnWatch
//
//  Created by coban on 2019/12/6.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBBindMemberCollectionView.h"
#import "CBBindMembCollectionViewCell.h"

static NSString *bindMembCell = @"CBBindMembCollectionViewCell";

@interface CBBindMemberCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) NSMutableArray *arrayData;
@end
@implementation CBBindMemberCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.dataSource = self;
    self.delegate = self;
    //self.showsVerticalScrollIndicator = NO;
    //注册可重用的单元所使用的类
    [self registerClass:[CBBindMembCollectionViewCell class] forCellWithReuseIdentifier:bindMembCell];
    //注册可重用的段头所使用的类
    [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    //注册可重用的段尾所使用的类
    [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
}
- (void)updaterDataArray:(NSMutableArray *)array {
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
    CBBindMembCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bindMembCell forIndexPath:indexPath];
    if (self.arrayData.count > indexPath.row) {
        AddressBookModel *model = self.arrayData[indexPath.row];
        cell.addressModel = model;
    }
    return cell;
    return UICollectionViewCell.new;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.arrayData.count > indexPath.row) {
        AddressBookModel *model = self.arrayData[indexPath.row];
        if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(collectionClick:clickModel:)]) {
            [self.clickDelegate collectionClick:indexPath.row clickModel:model];
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
