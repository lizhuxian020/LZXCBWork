//
//  DownloadPicViewController.m
//  Telematics
//
//  Created by lym on 2017/11/20.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "DownloadPicViewController.h"
#import "PictureCollectionViewCell.h"
#import "PictureClickView.h"
#import "MINFileObject.h"

@interface DownloadPicViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *dataArr;
@end

@implementation DownloadPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self loadData];
}

- (void)loadData
{
//    NSString *picPath = [[MINFileManager sharedInstance] getPicFolderPath];
//    self.dataArr = [[MINFileManager sharedInstance] getFilesWithPath: picPath];
//    [self.collectionView reloadData];
}

#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"已下载图片") isBack: YES];
    [self showBackGround];
    [self createCollectionView];
}

- (void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(80 * KFitWidthRate, 110 * KFitWidthRate);
    flowLayout.minimumInteritemSpacing = 13 * KFitWidthRate;
    flowLayout.minimumLineSpacing = 13 * KFitWidthRate;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(13 * KFitWidthRate, 13 * KFitWidthRate, 0, 13 * KFitWidthRate);
    self.collectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_HEIGHT) collectionViewLayout: flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = kBackColor;
    [self.collectionView registerClass: [PictureCollectionViewCell class] forCellWithReuseIdentifier: @"PictureCellIndentify"];
    [self.view addSubview: self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(self.view);
    }];
}

#pragma mark - collection delegate & dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"PictureCellIndentify";
    PictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: cellIndentify forIndexPath: indexPath];
    if (cell == nil) {
        cell = [[PictureCollectionViewCell alloc] init];
    }
    MINFileObject *obj = self.dataArr[indexPath.row];
    cell.imageView.image = [UIImage imageWithData: [NSData dataWithContentsOfFile: obj.filePath]];
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate转NSString
    NSString *nameText = [dateFormatter stringFromDate:obj.fileCreateTime];
    cell.nameLabel.text = nameText;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureClickView *clickView = [[PictureClickView alloc] init];
    MINFileObject *obj = self.dataArr[indexPath.row];
    clickView.imageView.image = [UIImage imageWithData: [NSData dataWithContentsOfFile: obj.filePath]];
    [self.view addSubview: clickView];
    [clickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
