//
//  CBHomeLeftMenuView.m
//  Telematics
//
//  Created by coban on 2019/7/17.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBHomeLeftMenuView.h"
#import "CBHomeLeftMenuModel.h"
#import "CBHomeLeftMenuTableView.h"

@interface CBHomeLeftMenuView ()<UIScrollViewDelegate>
{
    // 子视图宽度
    CGFloat KLeftMenuWidth;
}
/** bgmView  */
@property (nonatomic, strong) UIView *bgmView;
/** 搜索View  */
@property (nonatomic, strong) UIView *textFieldView;
/** 搜索textFieldView  */
@property (nonatomic, strong) UITextField *searchTextFeild;
/** 顶部scrollView  */
@property (nonatomic, strong) UIScrollView *topScrollView;
/** 滑线view  */
@property (nonatomic, strong) UIView *slideLineView;
/** 数据源数组  */
@property (nonatomic, strong) NSMutableArray *sliderArray;
/** btn数组  */
@property (nonatomic, strong) NSMutableArray *buttonsArray;
/** 选中btn  */
@property (nonatomic, strong) UIButton *selectBtn;
/** 下方scrollView  */
@property (nonatomic, strong) UIScrollView *mainScrollView;
/** 当前选中页  */
@property (nonatomic, assign) NSInteger currentPage;
/** tableView数组  */
@property (nonatomic, strong) NSMutableArray *tableViewArray;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,strong) CBHomeLeftMenuDeviceGroupModel *deviceGoupModelPrivate;
/** 防止点击表格视图段的时候，二次请求数据  */
@property (nonatomic,assign) BOOL isLoad;

@end
@implementation CBHomeLeftMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame withSlideArray:(NSMutableArray *)slideArray index:(NSInteger)index {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        KLeftMenuWidth = self.width - 21.5*KFitWidthRate - 16*KFitHeightRate;
        [self bgmView];
        
        self.index = index;
        self.sliderArray = slideArray;
        self.tableViewArray = [NSMutableArray array];
        
        [self initTopBtns];
        
        [self initSlideView];
        
        // 搜索view
        [self textFieldView];
        
        [self initScrollView];
        
        [self initDownTableViews];
    }
    return self;
}
- (UIView *)bgmView {
    if (!_bgmView) {
        UIImage *image = [UIImage imageNamed: @"列表框"];
        UIImageView *backImageView = [[UIImageView alloc] initWithImage: image];
        backImageView.alpha = 0.5;//
        [self addSubview: backImageView];
        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
        
        _bgmView = [UIView new];
        _bgmView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        [self addSubview:_bgmView];
        [_bgmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(16 * KFitHeightRate);
            make.left.equalTo(self).with.offset(9 * KFitWidthRate);
            make.right.equalTo(self).with.offset(-12.5 * KFitWidthRate);
            make.bottom.equalTo(self).with.offset(-15 * KFitWidthRate);
        }];
    }
    return _bgmView;
}
#pragma mark -- 实例化顶部菜单
- (void)initTopBtns {
    CGFloat width = KLeftMenuWidth/self.sliderArray.count;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(9*KFitWidthRate, 16*KFitHeightRate, KLeftMenuWidth, 40*KFitHeightRate)];
    scrollView.backgroundColor = kRGB(26, 151, 251);//[UIColor colorWithHexString:@"#898989"];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(width*self.sliderArray.count, 0);
    [self.bgmView addSubview:scrollView];
    _topScrollView = scrollView;

    self.buttonsArray = [NSMutableArray array];
    for (int i = 0; i < self.sliderArray.count; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(width*i, 0, width, 40*KFitHeightRate)];
        button.tag = 100+i;
        if (i == 0)
            _selectBtn = button;
        button.titleLabel.font = i==0?[UIFont systemFontOfSize: 14*KFitHeightRate]:[UIFont systemFontOfSize: 14*KFitHeightRate];
        [button setTitleColor:i==0?[UIColor whiteColor]:[UIColor blackColor] forState:UIControlStateNormal];
        CBHomeLeftMenuSliderModel *model = self.sliderArray[i];
        [button setTitle:model.title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tabButton:) forControlEvents:UIControlEventTouchUpInside];
        [_topScrollView addSubview:button];
        [self.buttonsArray addObject:button];
    }
}
#pragma mark -- 初始化滑动的指示View
- (void)initSlideView {
    CGFloat width = KLeftMenuWidth/self.sliderArray.count;
    CGFloat siderWidth = width;//20;
    _slideLineView = [[UIView alloc] initWithFrame:CGRectMake((width-siderWidth)/2.0, 40*KFitHeightRate - 2, siderWidth, 2)];
    [_slideLineView setBackgroundColor:[UIColor whiteColor]];
    [_topScrollView addSubview:_slideLineView];
}
- (UIView *)textFieldView {
    if (!_textFieldView) {
        _textFieldView = [[UIView alloc] init];
        _textFieldView.backgroundColor = [UIColor whiteColor];//kRGB(243, 244, 245);
        [self.bgmView addSubview: _textFieldView];
        [_textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bgmView.mas_left).offset(9*KFitWidthRate);
            make.width.mas_equalTo(KLeftMenuWidth);
            make.top.equalTo(self.topScrollView.mas_bottom).with.offset(12.5 * KFitHeightRate);
            make.height.mas_equalTo(40 * KFitHeightRate);
        }];
        
        _searchTextFeild = [MINUtils createTextFieldWithHoldText:Localized(@"输入车牌号码") fontSize: 13 * KFitHeightRate];
        UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(12.5 * KFitWidthRate,0, 60 * KFitWidthRate,30 * KFitHeightRate)];
        UIImage *image = [UIImage imageNamed: @"搜索"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
        [leftView addSubview: imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(leftView);
            make.size.mas_equalTo(CGSizeMake(image.size.width * KFitWidthRate, image.size.height * KFitWidthRate));
        }];
        leftView.backgroundColor = [UIColor clearColor];
        _searchTextFeild.leftView = leftView;
        _searchTextFeild.leftViewMode = UITextFieldViewModeAlways;
        [_textFieldView addSubview: _searchTextFeild];
        [_searchTextFeild mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_textFieldView);
            make.centerY.equalTo(_textFieldView);
            make.height.mas_equalTo(30 * KFitHeightRate);
            make.right.equalTo(_textFieldView).with.offset(12.5 * KFitWidthRate);
        }];
        
        [_searchTextFeild addTarget:self action:@selector(responseToTextfeildValueChange:) forControlEvents:UIControlEventEditingChanged];
        [_searchTextFeild addTarget:self action:@selector(responseToTextfeildBegainEdit:) forControlEvents:UIControlEventEditingDidBegin];
        [_searchTextFeild addTarget:self action:@selector(responseToTextfeildDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
        [_searchTextFeild limitTextFieldTextLength:10];
    }
    return _textFieldView;
}
#pragma mark -- 实例化ScrollView
- (void)initScrollView {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(9 * KFitWidthRate, CGRectGetMaxY(self.topScrollView.frame) + 12.5*KFitHeightRate + 40*KFitHeightRate, KLeftMenuWidth, self.height - (CGRectGetMaxY(self.topScrollView.frame) + 12.5*KFitHeightRate + 40*KFitHeightRate) - 16*KFitHeightRate - 15*KFitHeightRate)];
    _mainScrollView.contentSize = CGSizeMake(KLeftMenuWidth*self.sliderArray.count, 0);
    _mainScrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    //_mainScrollView.scrollEnabled = NO;
    [self.bgmView addSubview:_mainScrollView];
}
#pragma mark --初始化下方的TableViews
- (void)initDownTableViews {
    for (int i = 0; i < 2; i ++) {
        CBHomeLeftMenuTableView *tableView = [[CBHomeLeftMenuTableView alloc] initWithFrame:CGRectMake(i*KLeftMenuWidth, 0, KLeftMenuWidth, _mainScrollView.frame.size.height - TabPaddingBARHEIGHT) style:UITableViewStyleGrouped];
        tableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        tableView.tag = i;
        [_tableViewArray addObject:tableView];
        [_mainScrollView addSubview:tableView];
        if (i == 0) {
            if (_sliderArray.count > 0) {
                _currentPage = 0;
            }
        }
        kWeakSelf(self);
        tableView.returnBlock = ^(id  _Nonnull objc) {
            kStrongSelf(self);
            self.isLoad = YES;
            if ([objc isKindOfClass:[CBHomeLeftMenuDeviceGroupModel class]]) {
                // 更新顶部菜单
                self.deviceGoupModelPrivate = objc;
                [self updateMenuTitle];
            } else if ([objc isKindOfClass:[CBHomeLeftMenuDeviceInfoModel class]]) {
                // cell 点击，更新地图坐标
                if (self.leftMenuBlock) {
                    self.leftMenuBlock(objc);
                }
            }
        };
    }
}
- (void)requestData {
    UIButton *btn = self.buttonsArray[self.index];
    [self tabButton:btn];
    
     int tabviewTag = self.index % 2;
    CBHomeLeftMenuTableView *reuseTableView = _tableViewArray[tabviewTag];
    CBHomeLeftMenuSliderModel *model = _sliderArray[self.index];
    [reuseTableView reloadDataWithModel:model];
}
- (void)updateMenuTitle {
    UIButton *btnFirst = self.buttonsArray[0];
    UIButton *btnSecond = self.buttonsArray[1];
    UIButton *btnThird = self.buttonsArray[2];
    switch (self.index) {
        case 0:
        {
            [btnFirst setTitle:[NSString stringWithFormat:@"%@(%ld)",Localized(@"全部"),self.deviceGoupModelPrivate.offline.integerValue + self.deviceGoupModelPrivate.online.integerValue] forState:UIControlStateNormal];
            [btnSecond setTitle:[NSString stringWithFormat:@"%@(%ld)",Localized(@"在线"),self.deviceGoupModelPrivate.online.integerValue] forState:UIControlStateNormal];
            [btnThird setTitle:[NSString stringWithFormat:@"%@(%ld)",Localized(@"离线"),self.deviceGoupModelPrivate.offline.integerValue] forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            [btnSecond setTitle:[NSString stringWithFormat:@"%@(%ld)",Localized(@"在线"),self.deviceGoupModelPrivate.online.integerValue] forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [btnThird setTitle:[NSString stringWithFormat:@"%@(%ld)",Localized(@"离线"),self.deviceGoupModelPrivate.offline.integerValue] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}
#pragma mark -- scrollView的代理方法
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_mainScrollView]) {
        _currentPage = [NSString stringWithFormat:@"%.2f",_mainScrollView.contentOffset.x/KLeftMenuWidth].floatValue;
        [self updateTableWithPageNumber:_currentPage];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([_mainScrollView isEqual:scrollView]) {
        CGFloat slideX= scrollView.contentOffset.x/self.sliderArray.count+(KLeftMenuWidth/self.sliderArray.count-_slideLineView.width)/2.0;
        _slideLineView.left = slideX ;
    }
    if ([scrollView isEqual:self.topScrollView]) {
        CGPoint point = scrollView.contentOffset;
        // 限制y轴不动
        point.y = 0.0f;
        scrollView.contentOffset = point;
    }
}
#pragma mark --根据scrollView的滚动位置复用tableView，减少内存开支
- (void)updateTableWithPageNumber:(NSUInteger)pageNumber {
    self.index = pageNumber;
    [self changeBackColorWithPage:100+pageNumber];
    int tabviewTag = pageNumber % 2;
    CGRect tableNewFrame = CGRectMake(pageNumber*KLeftMenuWidth, 0, KLeftMenuWidth, _mainScrollView.frame.size.height);

    CBHomeLeftMenuTableView *reuseTableView = _tableViewArray[tabviewTag];
    CBHomeLeftMenuSliderModel *model = self.sliderArray[pageNumber];

    reuseTableView.frame = tableNewFrame;
    if (!self.isLoad) {
        
        [reuseTableView reloadDataWithModel:model];
    }
}
#pragma mark -- 点击顶部的按钮所触发的方法
- (void)tabButton:(id)sender {
    UIButton *button = sender;
    // 记录选择的菜单
    self.index = button.tag - 100;
    [self changeBackColorWithPage:button.tag];
    self.isLoad = NO;
    [_mainScrollView setContentOffset:CGPointMake((button.tag-100) * KLeftMenuWidth, 0) animated:YES];
}
#pragma mark -- 改变按钮颜色
- (void)changeBackColorWithPage:(NSInteger)currentPage {
    UIButton *currentBtn = [_topScrollView viewWithTag:currentPage];
    if (![currentBtn isEqual:_selectBtn]) {
        [_selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [currentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    _selectBtn = currentBtn;
}
#pragma mark - TouchDelegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self endEditing:YES];
}
#pragma mark - UITextfeild的输入内容
- (void)responseToTextfeildValueChange:(UITextField *)sender {
    //self.currentTF = sender;
    NSLog(@" %s", __FUNCTION__);
    UIButton *btn = self.buttonsArray[self.index];
    [self tabButton:btn];
    
    int tabviewTag = self.index % 2;
    CBHomeLeftMenuTableView *reuseTableView = _tableViewArray[tabviewTag];
    CBHomeLeftMenuSliderModel *model = _sliderArray[self.index];
    model.KeyWord = sender.text?:@"";
    [reuseTableView reloadDataWithModel:model];
}
- (void)responseToTextfeildBegainEdit:(UITextField *)sender {
    NSLog(@" %s", __FUNCTION__);
}
- (void)responseToTextfeildDidEnd:(UITextField *)sender {
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
