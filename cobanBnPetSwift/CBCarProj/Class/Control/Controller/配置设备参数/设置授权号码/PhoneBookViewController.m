//
//  PhoneBookViewController.m
//  Telematics
//
//  Created by lym on 2017/11/30.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "PhoneBookViewController.h"
#import "PhoneBookTableViewCell.h"
#import "MINPickerView.h"
#import "PhoneBookModel.h"
#import "MINAlertView.h"
#import "CBAddAddressBKView.h"
#import "CBControlAlertPopView.h"
#import "CBPhoneBookHeaderView.h"

@interface PhoneBookViewController () <UITableViewDelegate, UITableViewDataSource, MINPickerViewDelegate, PhoneBookTableViewCellDelegate>
{
    BOOL keyboardIsShown;
}
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *editArr;
@property (nonatomic, strong) NSMutableArray *addArr;
@property (nonatomic, copy) NSArray *phoneTypeArr;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@property (nonatomic, strong) CBAddAddressBKView *addAddresBKView;
/** 警告弹窗 */
@property (nonatomic, strong) CBControlAlertPopView *alertPopView;
@property (nonatomic,strong) NSIndexPath *deleteIndexPath;
@end

@implementation PhoneBookViewController

-(void)viewWillAppear:(BOOL)animated{
    [IQKeyboardManager sharedManager].enable = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
    
    self.dataArr = [NSMutableArray array];
    self.editArr = [NSMutableArray array];
    self.addArr = [NSMutableArray array];
    self.phoneTypeArr = @[@[Localized(@"允许呼入"), Localized(@"允许呼出"), Localized(@"允许呼入/呼出"), Localized(@"第一授权号码"), Localized(@"授权号码"), Localized(@"平台短信中心号码"), Localized(@"复位设备号码"), Localized(@"恢复出厂设置号码")]];
    [self requestDataWithHud:nil];
}
- (CBControlAlertPopView *)alertPopView {
    if (!_alertPopView) {
        _alertPopView = [[CBControlAlertPopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        //_alertPopView.delegate = self;
    }
    return _alertPopView;
}
- (void)setupView {
    [self initBarWithTitle:Localized(@"设置电话本") isBack: YES];
    [self initBarRighWhiteBackBtnTitle:Localized(@"发送") target: self action: @selector(addNewPhoneBookRequest)];
    self.view.backgroundColor = kRGB(247, 247, 247);
    
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 100 * KFitHeightRate)];
    UIButton *addCellBtn = [MINUtils createNoBorderBtnWithTitle:[NSString stringWithFormat:@"+ %@",Localized(@"新增")] titleColor: kRGB(73, 73, 73) fontSize: 12 * KFitHeightRate backgroundColor:nil];
    addCellBtn.layer.cornerRadius = 5 * KFitWidthRate;
    addCellBtn.layer.borderColor = kRGB(210, 210, 210).CGColor;
    addCellBtn.layer.borderWidth = 0.5;
    [addCellBtn addTarget: self action: @selector(addCellBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [view addSubview: addCellBtn];
    [addCellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(100 * KFitWidthRate, 40 * KFitHeightRate));
    }];
    self.tableView.tableFooterView = view;
}
#pragma mark -- 根据设备号获取设备授权号码列表
- (void)requestDataWithHud:(MBProgressHUD *)hud {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]getWithUrl:@"devParamController/getDevParamAuthList" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSArray class]]) {
                [self.dataArr removeAllObjects];
                for (NSDictionary *dic in  response[@"data"]) {
                    PhoneBookModel *model = [PhoneBookModel yy_modelWithDictionary: dic];
                    [self.dataArr addObject: model];
                }
                [self.tableView reloadData];
                [self.addArr removeAllObjects];
                [self.editArr removeAllObjects];
            }
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 新增电话本request
- (void)addNewPhoneBookRequest {
    if (self.addArr.count == 0 && self.editArr.count == 0) {
        [MINUtils showProgressHudToView: self.view withText:Localized(@"请先添加")];//请先新增或编辑号码再进行发送
        return;
    }
    if (self.addArr.count > 0) {
        PhoneBookModel *modelFirst = self.addArr[0];
        if (modelFirst.name.length < 1) {
            [MINUtils showProgressHudToView: self.view withText:Localized(@"请输入姓名")];
            return;
        }
        if (modelFirst.phone.length < 1) {
            [MINUtils showProgressHudToView: self.view withText:Localized(@"请输入电话号码")];
            return;
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
        PhoneBookModel *model = nil;
        model = self.addArr[0];
        if (model.name.length < 1) {
            [MINUtils showProgressHudToView: self.view withText:Localized(@"请输入姓名")];
            return;
        }
        if (model.phone.length < 1) {
            [MINUtils showProgressHudToView: self.view withText:Localized(@"请输入电话号码")];
            return;
        }
        dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";//[CBCommonTools CBdeviceInfo].dno?:@"";
        dic[@"name"] = model.name;
        dic[@"phone"] = model.phone;
        dic[@"type"] = [NSString stringWithFormat: @"%d", model.type];
        [MBProgressHUD showHUDIcon:self.view animated:YES];
        kWeakSelf(self);
        [[NetWorkingManager shared]postWithUrl:@"devParamController/sendDevParamAuth" params: dic succeed:^(id response,BOOL isSucceed) {
            kStrongSelf(self);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (isSucceed) {
                [self requestDataWithHud:nil];
                [self.addArr removeAllObjects];
                [self.editArr removeAllObjects];
            }
        } failed:^(NSError *error) {
            kStrongSelf(self);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}
#pragma mark -- 编辑电话本request
- (void)editPhoneReqeust {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    PhoneBookModel *model = self.editArr[0];
    if (model.name.length < 1) {
        [MINUtils showProgressHudToView: self.view withText:Localized(@"请输入姓名")];
        return;
    }
    if (model.phone.length < 1) {
        [MINUtils showProgressHudToView: self.view withText:Localized(@"请输入电话号码")];
        return;
    }
    dic[@"aid"] = model.phoneId;
    dic[@"name"] = model.name;
    dic[@"phone"] = model.phone;
    dic[@"type"] = [NSString stringWithFormat: @"%d", model.type];
    dic[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]postWithUrl:@"devParamController/editDevParamAuth" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self requestDataWithHud:nil];
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self requestDataWithHud:nil];
    }];
}
#pragma mark -- 编辑或新增弹框
- (void)phoneBookPopView:(PhoneBookModel *)model {
    [self.addArr removeAllObjects];
    [self.editArr removeAllObjects];
    
    __weak __typeof__(self) weakSelf = self;
    MINAlertView *alertView = [[MINAlertView alloc] init];
    __weak MINAlertView *weakAlertView = alertView;
    if (model) {
        alertView.titleLabel.text = Localized(@"编辑");
    } else {
        alertView.titleLabel.text = Localized(@"添加");
    }
    [weakSelf.view addSubview: alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    // 重置高度
    [alertView setContentViewHeight:160];
    
    CBAddAddressBKView *newView = [[CBAddAddressBKView alloc] init];
    self.addAddresBKView = newView;
    newView.alramTypeBtnClickBlock = ^{
        MINPickerView *pickerView = [[MINPickerView alloc] init];
        pickerView.titleLabel.text = @"";
        pickerView.dataArr = weakSelf.phoneTypeArr;
        pickerView.delegate = weakSelf;
        [weakSelf.view addSubview: pickerView];
        [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(weakSelf.view);
            make.height.mas_equalTo(SCREEN_HEIGHT);
        }];
        [pickerView showView];
    };
    [weakAlertView.contentView addSubview: newView];
    [newView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakAlertView.contentView);
    }];
    newView.nameTextField.text = model.name?:@"";
    newView.mobileTextField.text = model.phone?:@"";
    [newView.alramTypeBtn setTitle:self.phoneTypeArr[0][model.type] forState:UIControlStateNormal];
    [newView.alramTypeBtn setTitle:self.phoneTypeArr[0][model.type] forState:UIControlStateHighlighted];
    if (model) {
        newView.mobileTextField.enabled = NO;
    } else {
        newView.mobileTextField.enabled = YES;
    }
    alertView.rightBtnClick = ^{
        [weakAlertView hideView];
        if (model) {
            // 编辑
            [weakSelf addAddressBKModel_edit:model];
        } else {
            // 新增
            //[weakSelf addAddressBKModel_new];
            [weakSelf checkPhoneRequestPhoneStr:weakSelf.addAddresBKView.mobileTextField.text];
        }
    };
    alertView.leftBtnClick = ^{
        [weakAlertView hideView];
    };
}
#pragma mark -- 验证授权号码
- (void)checkPhoneRequestPhoneStr:(NSString *)phone {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    paramters[@"phone"] = phone;
    paramters[@"dno"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    //[MBProgressHUD showHUDIcon:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]postWithUrl:@"devParamController/isExistAuthPhone" params:paramters succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *statusStr = [NSString stringWithFormat:@"%@",response[@"status"]];
        if ([statusStr isEqualToString:@"1"]) {
            // 已存在，不允许添加
            [HUD showHUDWithText:[Utils getSafeString:Localized(@"号码已存在")] withDelay:2.0];
        } else {
            [self addAddressBKModel_new];
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 新增
- (void)addCellBtnClick {
    if (self.dataArr.count >= 5) {
        [MINUtils showProgressHudToView: self.view withText:Localized(@"授权号码已满")];
        return;
    }
    [self phoneBookPopView:nil];
}
- (void)addAddressBKModel_new {
    PhoneBookModel *model_new = [[PhoneBookModel alloc]init];//self.dataArr[self.currentIndexPath.row];
    model_new.name = self.addAddresBKView.nameTextField.text;
    model_new.phone = self.addAddresBKView.mobileTextField.text;
    NSArray *arr = self.phoneTypeArr[0];
    for (int i = 0; i < arr.count;  i++) {
        if ([arr[i] isEqualToString:self.addAddresBKView.alramTypeBtn.titleLabel.text]) {
            model_new.type = i;
        }
    }
    [self.addArr addObject:model_new];
}
#pragma mark -- 编辑
- (void)addAddressBKModel_edit:(PhoneBookModel *)model {
    if (self.addAddresBKView.nameTextField.text.length < 1) {
        [MINUtils showProgressHudToView: self.view withText:Localized(@"请输入姓名")];
        return ;
    }
    if (self.addAddresBKView.mobileTextField.text.length < 1) {
        [MINUtils showProgressHudToView: self.view withText:Localized(@"请输入电话号码")];
        return ;
    }
    PhoneBookModel *modelSelect = self.dataArr[self.currentIndexPath.row];
    modelSelect.name = self.addAddresBKView.nameTextField.text;
    modelSelect.phone = self.addAddresBKView.mobileTextField.text;
    NSArray *arr = self.phoneTypeArr[0];
    for (int i = 0; i < arr.count;  i++) {
        if ([arr[i] isEqualToString:self.addAddresBKView.alramTypeBtn.titleLabel.text]) {
            modelSelect.type = i;
        }
    }
    [self.editArr addObject:modelSelect];
    [self editPhoneReqeust];
}
#pragma mark - tableView delegate & dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45 * KFitHeightRate;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CBPhoneBookHeaderView *headView = [[CBPhoneBookHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 45 * KFitHeightRate)];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.5 * KFitHeightRate;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"PhoneBookCellIndentify";
    PhoneBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIndentify];
    if (cell == nil) {
        cell = [[PhoneBookTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIndentify];
    }
    [cell addLeftSwipeGesture];
    [cell hideDeleteBtn];
    __weak typeof(self) weakSelf = self;
    [cell setDeleteBtnClick:^(NSIndexPath *indexPath) {
        
    }];
    [cell setEditBtnClick:^(NSIndexPath *indexPath) {
    }];
    cell.cellDelegate = self;
    cell.indexPath = indexPath;
    if (indexPath.row < self.dataArr.count) {
        PhoneBookModel *model = self.dataArr[indexPath.row];
        cell.nameTextFeild.text = model.name;
        cell.phoneTextFeild.text = model.phone;
        cell.phoneTypeTitleLabel.text = [NSString stringWithFormat:@"%@",weakSelf.phoneTypeArr[0][model.type]];
        model.indexPath = indexPath;
    }
    cell.deleteBtnClickBlock = ^(NSIndexPath *indexPath) {
        [weakSelf deleteAlertPopClick:indexPath];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataArr.count) {
        PhoneBookModel *model = self.dataArr[indexPath.row];
        self.currentIndexPath = indexPath;
        [self phoneBookPopView:model];
    }
}
#pragma mark -- 删除
- (void)deleteAlertPopClick:(NSIndexPath *)indexPath {
    self.deleteIndexPath = indexPath;
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:Localized(@"确定删除?") message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self deletePhoneBookReqeust];
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alertControl animated:YES completion:nil];
}
#pragma mark -- 删除电话本request
- (void)deletePhoneBookReqeust {
    if (self.editArr.count > 0) {
        [MINUtils showProgressHudToView: self.view withText: @"请先发送当前编辑的电话号码"];
        return ;
    }
    __weak __typeof__(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    PhoneBookModel *model = self.dataArr[self.deleteIndexPath.row];//self.dataArr[indexPath.row];
    dic[@"aid"] = model.phoneId;
    dic[@"imei"] = [CBCommonTools CBdeviceInfo].dno?:@"";
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]postWithUrl:@"devParamController/delDevParamAuth" params: dic succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            [weakSelf requestDataWithHud:nil];
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark - PhoneBookDelegate
- (BOOL)shouldEditCellWithIndexPath:(NSIndexPath *)indexPath {   
    return YES;
}

#pragma mark - PickerViewDelegate
- (void)minPickerView:(MINPickerView *)pickerView didSelectWithDic:(NSDictionary *)dic {
    NSNumber *number = dic[@"0"];
    [self.addAddresBKView.alramTypeBtn setTitle:self.phoneTypeArr[0][[number integerValue]] forState:UIControlStateNormal];
}

#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
