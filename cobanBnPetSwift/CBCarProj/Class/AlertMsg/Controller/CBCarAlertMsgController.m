//
//  CBCarAlertMsgController.m
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/24.
//  Copyright © 2022 coban. All rights reserved.
//

#import "CBCarAlertMsgController.h"
#import "_CBCarAlertMsgCell.h"
#import "_CBCarAlertMsgModel.h"
#import "_CBAlertMsgMenuPopView.h"
#import "CBCarAlertMsgDelegate.h"
#import "CBCarMsgCenterDelegate.h"

#define __MsgUI_TitleHeight 50
#define __MsgUI_SelectColor kAppMainColor
#define __MsgUI_NormalColor UIColor.grayColor

@interface CBCarAlertMsgController ()<UITableViewDelegate, UITableViewDataSource>

//@property (nonatomic, strong) NSArray<_CBCarAlertMsgModel *> *alertMsgdataArr;
@property (nonatomic, strong) CBCarAlertMsgDelegate *alertMsgDelegate;

@property (nonatomic, strong) CBCarMsgCenterDelegate *msgCenterDelegate;

@property (nonatomic, strong) _CBAlertMsgMenuPopView *popView;

/** 顶部scrollView  */
@property (nonatomic, strong) UIScrollView *topScrollView;
/** 下方scrollView  */
@property (nonatomic, strong) UIScrollView *mainScrollView;
/** 当前选中页  */
@property (nonatomic, assign) NSInteger currentPage;
/** tableView数组  */
@property (nonatomic, strong) NSMutableArray *tableViewArray;
/** 滑线view  */
@property (nonatomic, strong) UIView *slideLineView;
/** 数据源数组  */
@property (nonatomic, strong) NSMutableArray *sliderArray;
@property (nonatomic, strong) NSMutableArray *buttonsArray;

//@property (nonatomic,assign) NSInteger index;
/** 选中btn  */
@property (nonatomic, strong) UIButton *selectBtn;
@end

@implementation CBCarAlertMsgController

- (void)viewDidLoad {
    [super viewDidLoad];
    kWeakSelf(self);
    
    [self initBarWithTitle:Localized(@"消息中心") isBack:YES];
    [self initBarRightImageName:@"更多" target:self action:@selector(showPopView)];
    self.popView = [_CBAlertMsgMenuPopView new];
    [self.popView setDidClick:^{
        [weakself requestAllRead];
    }];
    [self.popView setDidClickCheck:^{
        [weakself switchTabBarThird];
    }];

    self.alertMsgDelegate = [CBCarAlertMsgDelegate new];
    self.alertMsgDelegate.navigationController = self.navigationController;
    self.msgCenterDelegate = [CBCarMsgCenterDelegate new];
    self.msgCenterDelegate.navigationController = self.navigationController;
    
    self.sliderArray = [NSMutableArray arrayWithArray:@[Localized(@"报警消息"), Localized(@"消息通知")]];
    [self initTopBtns];
    
    [self initSlideView];

    [self initScrollView];

    [self initDownTableViews];
    
    [self.alertMsgDelegate reload];
    [self.msgCenterDelegate reload];
}

#pragma mark -- 实例化顶部菜单
- (void)initTopBtns {
    CGFloat width = self.view.width/self.sliderArray.count;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
//    scrollView.backgroundColor = kRGB(26, 151, 251);//[UIColor colorWithHexString:@"#898989"];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(self.view.width, 0);
    [self.view addSubview:scrollView];
    _topScrollView = scrollView;
    [_topScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@64);
        make.left.right.equalTo(@0);
        make.height.equalTo(@(__MsgUI_TitleHeight));
    }];

    self.buttonsArray = [NSMutableArray array];
    for (int i = 0; i < self.sliderArray.count; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(width*i, 0, width, __MsgUI_TitleHeight)];
//        button.tag = HomeLetfMenu_TitleBtnBaseTag+i;
        if (i == 0)
            _selectBtn = button;
        button.titleLabel.font = [UIFont systemFontOfSize: 20];
        [button setTitleColor:i==0?__MsgUI_SelectColor:__MsgUI_NormalColor forState:UIControlStateNormal];
        NSString *title = self.sliderArray[i];
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tabButton:) forControlEvents:UIControlEventTouchUpInside];
        [_topScrollView addSubview:button];
        [self.buttonsArray addObject:button];
    }
}
#pragma mark -- 点击顶部的按钮所触发的方法
- (void)tabButton:(id)sender {
//    UIButton *button = sender;
    // 记录选择的菜单
    self.currentPage = [self.buttonsArray indexOfObject:sender];
    [self changeBackColorWithPage:self.currentPage];
    [_mainScrollView setContentOffset:CGPointMake((self.currentPage) * self.view.width, 0) animated:YES];
    
//    CBHomeLeftMenuTableView *reuseTableView = _tableViewArray[self.index];
//    CBHomeLeftMenuSliderModel *model = _sliderArray[self.index];
//    [reuseTableView reloadDataWithModel:model];
}
#pragma mark -- 改变按钮颜色
- (void)changeBackColorWithPage:(NSInteger)currentPage {
    UIButton *currentBtn = self.buttonsArray[currentPage];
    if (![currentBtn isEqual:_selectBtn]) {
        [_selectBtn setTitleColor:__MsgUI_NormalColor forState:UIControlStateNormal];

        [currentBtn setTitleColor:__MsgUI_SelectColor forState:UIControlStateNormal];
    }
    _selectBtn = currentBtn;
}
#pragma mark -- 初始化滑动的指示View
- (void)initSlideView {
    CGFloat width = self.view.width/self.sliderArray.count;
    CGFloat siderWidth = width;//20;
    _slideLineView = [[UIView alloc] initWithFrame:CGRectMake((width-siderWidth)/2.0, __MsgUI_TitleHeight - 1, siderWidth, 1)];
    [_slideLineView setBackgroundColor:kAppMainColor];
    [_topScrollView addSubview:_slideLineView];
}
#pragma mark -- 实例化ScrollView
- (void)initScrollView {
    _mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.contentSize = CGSizeMake(self.view.width*self.sliderArray.count, 0);
//    _mainScrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    //_mainScrollView.scrollEnabled = NO;
    [self.view addSubview:_mainScrollView];
    [_mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topScrollView.mas_bottom);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
}

- (void)initDownTableViews {
    UIView *last = nil;
    for (int i = 0; i < self.sliderArray.count; i ++) {
        UIView *contentView = [UIView new];
        contentView.backgroundColor = RandomColor;
        [_mainScrollView addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            if (last) {
                make.left.equalTo(last.mas_right);
            } else {
                make.left.equalTo(@0);
            }
            make.width.height.equalTo(_mainScrollView);
            
        }];
        last = contentView;
        if (i == 0) {
            [contentView addSubview:self.alertMsgDelegate.tableView];
            [self.alertMsgDelegate.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(@0);
            }];
        } else {
            [contentView addSubview:self.msgCenterDelegate.tableView];
            [self.msgCenterDelegate.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(@0);
            }];
        }
        
    }
}

- (void)requestAllRead {
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared] getWithUrl:@"/alarmDealController/updateAlarmDeal" params:nil succeed:^(id response, BOOL isSucceed) {
        
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [HUD showHUDWithText:Localized(@"操作成功")];
        }
        } failed:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
}

- (void)switchTabBarThird {
    UITabBarController *tabVC = UIApplication.sharedApplication.keyWindow.rootViewController;
    if (!tabVC || ![tabVC isKindOfClass:UITabBarController.class]) {
        return;;
    }
    [self.navigationController popToRootViewControllerAnimated:NO];
    tabVC.selectedIndex = 2;
}

- (void)showPopView {
    [self.popView pop];
}

#pragma mark -- scrollView的代理方法
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_mainScrollView]) {
        _currentPage = [NSString stringWithFormat:@"%.2f",_mainScrollView.contentOffset.x/self.view.width].floatValue;
        [self updateTableWithPageNumber:_currentPage];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([_mainScrollView isEqual:scrollView]) {
        CGFloat slideX= scrollView.contentOffset.x/self.sliderArray.count+(self.view.width/self.sliderArray.count-_slideLineView.width)/2.0;
        _slideLineView.left = slideX ;
    }
    if ([scrollView isEqual:self.topScrollView]) {
        CGPoint point = scrollView.contentOffset;
        // 限制y轴不动
        point.y = 0.0f;
        scrollView.contentOffset = point;
    }
}
//#pragma mark --根据scrollView的滚动位置复用tableView，减少内存开支
- (void)updateTableWithPageNumber:(NSUInteger)pageNumber {
    self.currentPage = pageNumber;
    [self changeBackColorWithPage:pageNumber];
//    int tabviewTag = pageNumber % 2;
//    CGRect tableNewFrame = CGRectMake(pageNumber*KLeftMenuWidth, 0, KLeftMenuWidth, _mainScrollView.frame.size.height);

//    CBHomeLeftMenuTableView *reuseTableView = _tableViewArray[pageNumber];
//    CBHomeLeftMenuSliderModel *model = self.sliderArray[pageNumber];

//    reuseTableView.frame = tableNewFrame;
//    if (!self.isLoad) {

//    [reuseTableView reloadDataWithModel:model];
//    }
}
@end
