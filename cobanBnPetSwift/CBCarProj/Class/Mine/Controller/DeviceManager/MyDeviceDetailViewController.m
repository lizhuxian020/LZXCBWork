//
//  MyDeviceDetailViewController.m
//  Telematics
//
//  Created by lym on 2017/11/8.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MyDeviceDetailViewController.h"
#import "DeviceDetailTableViewCell.h"
#import "MINPickerView.h"
#import "MINAlertView.h"
#import "MyDeviceModel.h"
#import "MyDeviceViewController.h"
#import "CBControlInputPopView.h"
#import "_CBMyDeviceInfoView.h"

@interface MyDeviceDetailViewController () <UITableViewDelegate, UITableViewDataSource, MINPickerViewDelegate,CBControlInputPopViewDelegate>
@property (nonatomic, weak) UITextField *textField; // 警告框的输入框
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, assign) BOOL isEdit;
/** 设置电话号码、设置车牌号码、设置设备名称，输入值弹窗 */
@property (nonatomic,strong) CBControlInputPopView *inputPopView;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) _CBMyDeviceInfoView *infoView;
@end

@implementation MyDeviceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 扫码添加设备，可编辑
    if (self.isAddDevice) {
        self.isEdit = YES;
    }
    
    [self createUI];
    [self addGesture];
//    self.deviceInfoTitleArr = @[@"设备IMEI号",@"设备电话号码",@"车牌颜色",@"车辆VIN",@"设备名称",@"车牌号码",@"定位图标",@"所属分组",@"设备协议类型",@"设备版本号",@"经销商ID",@"注册日期",@"有效期"];
    self.carColorArr = @[Localized(@"蓝色"), Localized(@"黄色"), Localized(@"黑色"), Localized(@"白色"), Localized(@"其他")];
    self.purposeArr = @[Localized(@"定位图"), Localized(@"人物"), Localized(@"宠物"), Localized(@"单车"), Localized(@"摩托车"), Localized(@"小车"), Localized(@"货车"), Localized(@"行李箱")];
    self.devModelArray = CBDeviceTool.shareInstance.productSepcArr;
    self.devModelIdArray = CBDeviceTool.shareInstance.productSepcIdArr;
    [self reload];
}
- (void)reload {
    self.deviceInfoContentArr = @[
        self.model.dno ?: @"",
        self.model.name ?: @"",
        self.model.carNum ?: @"",
        self.model.devPhone ?: @"",
        self.model.color < self.carColorArr.count ? self.carColorArr[self.model.color] : @"",
        self.model.icon < self.purposeArr.count ? self.purposeArr[self.model.icon] : @"",
        self.devModel ?: @"",
        self.groupName ?: @"",
//        self.model.protocol ?: @"",
//        self.model.version ?: @"",
//        self.model.uid ?: @"",
//        self.model.registerTime ?: @"",
//        self.model.expireTime ?: @"",
    ];
    self.deviceInfoTitleArr = @[
        Localized(@"设备IMEI"),
        Localized(@"设备名称"),
        Localized(@"车牌号码"),
        Localized(@"电话号码"),
        Localized(@"车辆颜色"),
        Localized(@"图标"),
        Localized(@"产品类型"),
        Localized(@"所属分组"),
//        Localized(@"设备协议类型"),
//        Localized(@"设备版本号"),
//        Localized(@"经销商ID"),
//        Localized(@"注册日期"),
//        Localized(@"有效期")
    ];
   
    self.deviceInfoPlaceholderArr = @[
        Localized(@"请输入有效的IMEI(必填)"),
        Localized(@"输入设备名称(必填)"),
        Localized(@"输入车牌号码"),
        Localized(@"输入电话号码"),
        @"",
        @"",
        Localized(@"请选择"),
        Localized(@"默认分组")
    ];
    [self.tableView reloadData];
}
- (CBControlInputPopView *)inputPopView {
    if (!_inputPopView) {
        _inputPopView = [[CBControlInputPopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _inputPopView.delegate = self;
    }
    return _inputPopView;
}
#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle: self.model.name ?: Localized(@"我的设备") isBack: YES];
    if (self.isAddDevice == NO) {
        [self initBarRighBtnTitle: Localized(@"编辑") target: self action: @selector(rightBtnClick:)];
    }else {
        [self initBarRighBtnTitle: Localized(@"确定") target: self action: @selector(rightBtnClick:)];
    }
    [self createTableView];
}

- (void)createTableView;
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(self.view);
    }];
    
    self.infoView = [_CBMyDeviceInfoView new];
    self.infoView.model = self.model;
    [self.view addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(PPNavigationBarHeight));
        make.left.right.bottom.equalTo(@0);
    }];
    self.infoView.hidden = _isAddDevice;
}
#pragma mark - gesture
- (void)addGesture
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.textField resignFirstResponder];
}
//#pragma mark -- 输入弹窗代理
//- (void)updateTextFieldValue:(NSString *)inputStr returnTitle:(NSString *)title {
//    if ([title isEqualToString:Localized(@"设置电话号码")]) {
//        if (kStringIsEmpty(inputStr)) {
//            [HUD showHUDWithText:Localized(@"请输入电话号码") withDelay:3.0];
//            return;
//        }
//        MyDeviceModel *deviceModel = self.arrayData[1];
//        deviceModel.devPhone = inputStr;
//    } else if ([title isEqualToString:Localized(@"车牌号码")]) {
//        if (kStringIsEmpty(inputStr)) {
//            [HUD showHUDWithText:Localized(@"请输入组名") withDelay:3.0];
//            return;
//        }
//        MyDeviceModel *deviceModel = self.arrayData[4];
//        deviceModel.carNum = inputStr;
//    } else if ([title isEqualToString:Localized(@"设备名称")]) {
//        if (kStringIsEmpty(inputStr)) {
//            [HUD showHUDWithText:Localized(@"输入设备名称") withDelay:3.0];
//            return;
//        }
//        MyDeviceModel *deviceModel = self.arrayData[5];
//        deviceModel.name = inputStr;
//    }
//    [self.tableView reloadData];
//}
#pragma mark - tableView delegate & datasource
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([self.deviceInfoTitleArr[indexPath.row] isEqualToString:Localized(@"图标")]) {
//        return 80;
//    }
//    return 50;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deviceInfoTitleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"DeviceDetailCellIndentify";
    DeviceDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIndentify];
    if (cell == nil) {
        cell = [[DeviceDetailTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIndentify];
    }
    kWeakSelf(self);
    [cell setDidSelectedIconIndex:^(NSInteger iconIndex) {
        weakself.model.icon = (int)iconIndex;
    }];
    [cell showTextView];
    cell.nameLabel.text = self.deviceInfoTitleArr[indexPath.row];
    cell.textField.text = self.deviceInfoContentArr[indexPath.row];
    cell.textField.placeholder = self.deviceInfoPlaceholderArr[indexPath.row];
    if ([self.deviceInfoTitleArr[indexPath.row] isEqualToString:Localized(@"车辆颜色")]) {
        cell.selectLabel.text = self.deviceInfoContentArr[indexPath.row];
        [cell showSelectView];
    }
    if ([self.deviceInfoTitleArr[indexPath.row] isEqualToString:Localized(@"图标")]) {
        [cell showIcon:self.model.icon];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DeviceDetailTableViewCell *cell = (DeviceDetailTableViewCell *)[tableView cellForRowAtIndexPath: indexPath];
    self.selectIndexPath = indexPath;
    NSInteger row = indexPath.row;
    if (row < 4) {
        kWeakSelf(self);
        [[CBCarAlertView viewWithMultiInput:@[self.deviceInfoPlaceholderArr[row]] title:self.deviceInfoTitleArr[row] isDigital:row==0||row==3 maxLength:100 confirmCanDismiss:^BOOL(NSArray<NSString *> * _Nonnull contentStr) {
            return YES;
            } confrim:^(NSArray<NSString *> * _Nonnull contentStr) {
                if (row == 0) {
                    weakself.model.dno = contentStr.firstObject;
                }
                if (row == 1) {
                    weakself.model.name = contentStr.firstObject;
                }
                if (row == 2) {
                    weakself.model.carNum = contentStr.firstObject;
                }
                if (row == 3) {
                    weakself.model.devPhone = contentStr.firstObject;
                }
                [weakself reload];
            }] pop];
    }
    if (row == 4 || row == 6|| row == 7) {
        if (row == 7) {
            [[CBDeviceTool shareInstance] getGroupName:^(NSArray<NSString *> * _Nonnull groupNames) {
                self.groupNameArray = groupNames;
                MINPickerView *pickerView = [[MINPickerView alloc] init];
                pickerView.titleLabel.text = self.deviceInfoTitleArr[row];
                pickerView.dataArr = @[self.groupNameArray];
                pickerView.delegate = self;
                [self.view addSubview: pickerView];
                [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.equalTo(self.view);
                    make.height.mas_equalTo(SCREEN_HEIGHT);
                }];
                [pickerView showView];
            }];
            return;
        }
        MINPickerView *pickerView = [[MINPickerView alloc] init];
        pickerView.titleLabel.text = self.deviceInfoTitleArr[row];
        if (row == 4) {
            pickerView.dataArr = @[self.carColorArr];
        }
        if (row == 6) {
            pickerView.dataArr = @[self.devModelArray];
        }
//        if (row == 7) {
//            pickerView.dataArr = @[self.groupNameArray];
//        }
        pickerView.delegate = self;
        [self.view addSubview: pickerView];
        [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.height.mas_equalTo(SCREEN_HEIGHT);
        }];
        [pickerView showView];
    }
//    if (indexPath.row == 2 || indexPath.row == 6 || indexPath.row == 7) {
//        MINPickerView *pickerView = [[MINPickerView alloc] init];
//        if (self.arrayData.count > indexPath.row) {
//            MyDeviceModel *deviceModel = self.arrayData[indexPath.row];
//            pickerView.titleLabel.text = deviceModel.leftTitle;
//            if (indexPath.row == 6) {
//                pickerView.isPicturePickerView = YES;
//            }

//            if (indexPath.row == 2) {
//                pickerView.dataArr = @[self.carColorArr];
//            } else if (indexPath.row == 6) {
//                pickerView.dataArr = @[self.purposeArr];
//            } else if (indexPath.row == 7) {
//                pickerView.titleLabel.text = Localized(@"移至分组");
//                pickerView.dataArr = @[self.groupNameArray];
//            }
//            pickerView.delegate = self;
//            [self.view addSubview: pickerView];
//            [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.top.equalTo(self.view);
//                make.height.mas_equalTo(SCREEN_HEIGHT);
//            }];
//            [pickerView showView];
//        }
//    }else if (indexPath.row == 1) {
//        [self.inputPopView updateTitle:Localized(@"设置电话号码") placehold:Localized(@"请输入电话号码") isDigital:YES];
//        [self.inputPopView popView];
//    } else if (indexPath.row == 4) {
//        [self.inputPopView updateTitle:Localized(@"车牌号码") placehold:Localized(@"输入车牌号码") isDigital:NO];
//        [self.inputPopView popView];
//        self.inputPopView.inputTF.keyboardType = UIKeyboardTypeNamePhonePad;
//    } else if (indexPath.row == 5) {
//        [self.inputPopView updateTitle:Localized(@"设备名称") placehold:Localized(@"输入设备名称") isDigital:NO];
//        [self.inputPopView popView];
//    }
    
}

//// 添加设备的时候，修改数据
//- (void)editWhenAddDeviceName:(NSString *)name phoneNum:(NSString *)phoneNum carColor:(int)carColor icon:(int)icon cell:(DeviceDetailTableViewCell*)cell
//{
//    // 修改model数据
//    if (name != nil) {
//        self.model.name = name;
//    }else if (phoneNum != nil) {
//        self.model.devPhone = phoneNum;
//    }else if (carColor != -1) {
//        self.model.color = carColor;
//    }else if (icon != -1) {
//        self.model.icon = icon;
//    }
//    // 修改UI数据
//    if (name != nil) {
//        [cell setEditLabelText: name];
//    }else if (phoneNum != nil) {
//        [cell setEditLabelText: phoneNum];
//    }else if (carColor != -1) {
//        [cell setSelectLabelText: self.carColorArr[carColor]];
//    }else if (icon != -1) {
//        [cell setSelectLabelText: self.purposeArr[icon]];
//    }
//}
#pragma mark -- 编辑设备信息
// 编辑设备的时候，修改数据
- (void)editDeviceRequest //Name:(NSString *)name phoneNum:(NSString *)phoneNum carColor:(NSInteger)carColor icon:(NSInteger)icon cell:(DeviceDetailTableViewCell*)cell
{
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    paramters[@"dno"] = self.model.dno; // self.model.dno

    [paramters setObject:self.model.name?:@"" forKey:@"dname"];
    [paramters setObject:self.model.devPhone?:@"" forKey:@"devPhone"];
    [paramters setObject:self.model.carNum?:@"" forKey:@"carNum"];
    [paramters setObject:[NSNumber numberWithInteger:self.model.color] forKey:@"color"];
    [paramters setObject:[NSNumber numberWithInteger:self.model.icon] forKey:@"icon"];
    NSInteger produceSpecdIdx = [self.devModelArray indexOfObject:self.devModel];
    if (produceSpecdIdx != NSNotFound) {
        [paramters setObject:self.devModelIdArray[produceSpecdIdx] forKey:@"productSpecId"];
    }
    NSInteger groupIdx = [self.groupNameArray indexOfObject:self.groupName];
    if (groupIdx != NSNotFound) {
        if (self.groupIdArray && groupIdx < self.groupIdArray.count) {
            [paramters setObject:self.groupIdArray[groupIdx] forKey:@"groupId"];
        } else {
            [paramters setObject:@(groupIdx) forKey:@"groupId"];
        }
    }

    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]postWithUrl:@"devControlController/editDev" params:paramters succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            self.isEdit = NO;
            self.infoView.hidden = NO;
            [self.rightBtn setTitle: Localized(@"编辑") forState: UIControlStateNormal];
            [self.rightBtn setTitle: Localized(@"编辑") forState: UIControlStateHighlighted];
            self.infoView.model = self.model;
            [self reload];
            [HUD showHUDWithText:Localized(@"修改成功") withDelay:3.0f];
        } else {
            //[hud hideAnimated:YES];
        }
    } failed:^(NSError *error) {
        //[hud hideAnimated:YES];
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark -- 添加设备
- (void)rightBtnClick:(UIButton *)sender
{
    UIButton *rightBtn = sender;
    if (self.isAddDevice == NO) { // 编辑设备的情况下
        
        if (self.isEdit == NO) {
            self.isEdit = YES;
            self.infoView.hidden = YES;
            [self initBarRighBtnTitle: Localized(@"完成") target: self action: @selector(rightBtnClick:)];
        } else {
            self.rightBtn = sender;
            [self editDeviceRequest];
        }
    } else { // 添加设备的情况下
        __weak __typeof__(self) weakSelf = self;
        NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithCapacity:1];

        [paramters setObject:self.model.dno?:@"" forKey:@"dno"];
        [paramters setObject:self.model.name?:@"" forKey:@"dName"];
        [paramters setObject:self.model.devPhone?:@"" forKey:@"devPhone"];
        [paramters setObject:self.model.carNum?:@"" forKey:@"cardNum"];
        [paramters setObject:[NSNumber numberWithInteger:self.model.color] forKey:@"color"];
        [paramters setObject:[NSNumber numberWithInteger:self.model.icon] forKey:@"icon"];
        NSInteger produceSpecdIdx = [self.devModelArray indexOfObject:self.devModel];
        if (produceSpecdIdx != NSNotFound) {
            [paramters setObject:@(produceSpecdIdx+1) forKey:@"productSpecId"];
        }
        NSInteger groupIdx = [self.groupNameArray indexOfObject:self.groupName];
        if (groupIdx != NSNotFound) {
            [paramters setObject:@(groupIdx) forKey:@"groupId"];
        }

        [MBProgressHUD showHUDIcon:self.view animated:YES];
        kWeakSelf(self);
        [[NetWorkingManager shared]postWithUrl:@"personController/addDevice" params:paramters succeed:^(id response,BOOL isSucceed) {
            kStrongSelf(self);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (isSucceed) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            } else {
            }
        } failed:^(NSError *error) {
            kStrongSelf(self);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

#pragma mark - MINPickerViewDelegate
- (void)minPickerView:(MINPickerView *)pickerView didSelectWithDic:(NSDictionary *)dic
{
    //NSLog(@"%@", dic);
    // 取出选中的行，因为只有一列，所以直接暴力取出了
    NSNumber *selectRow = dic[@"0"];
    DeviceDetailTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.selectIndexPath];
    NSInteger row = self.selectIndexPath.row;
    if (row == 4) {
        self.model.color = [selectRow intValue];
    }
    if (row == 6) {
        self.devModel = self.devModelArray[[selectRow intValue]];
        self.model.devModel = self.devModel;
    }
    if (row == 7) {
        self.groupName = self.groupNameArray[[selectRow intValue]];
        self.model.groupNameStr = self.groupName;
    }
//        else if (self.selectIndexPath.row == 6) {
//            MyDeviceModel *deviceModelIcon = self.arrayData[6];
//            deviceModelIcon.icon = [selectRow intValue];
//        } else if (self.selectIndexPath.row == 7) {
//            // 移至分组
//            [self moveToGroupRequestGroupId:[selectRow integerValue]];
//        }
//    else {
//        if (self.selectIndexPath.row == 2) {
//            MyDeviceModel *deviceModelColor = self.arrayData[2];
//            deviceModelColor.color = [selectRow intValue];
//        } else if (self.selectIndexPath.row == 6) {
//            MyDeviceModel *deviceModelIcon = self.arrayData[6];
//            deviceModelIcon.color = [selectRow intValue];
//        } else if (self.selectIndexPath.row == 7) {
//            // 移少分组
//            [self moveToGroupRequestGroupId:[selectRow integerValue]];
//        }
//    }
    [self reload];
}
//#pragma mark -- 设置分组
//- (void)moveToGroupRequestGroupId:(NSInteger)index {
//    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
//    NSString *goupIdStr = self.groupIdArray[index];
//    paramters[@"gid"] = goupIdStr;
//    paramters[@"dno"] = self.model.dno;
//    [MBProgressHUD showHUDIcon:self.view animated:YES];
//    [[NetWorkingManager shared]postWithUrl:@"personController/moveDevGroup" params:paramters succeed:^(id response,BOOL isSucceed) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        if (isSucceed) {
//            MyDeviceModel *deviceModelGroup = self.arrayData[7];
//            deviceModelGroup.groupNameStr = self.groupNameArray[index];
//            [self.tableView reloadData];
//            [HUD showHUDWithText:Localized(@"修改成功") withDelay:3.0f];
//        }else {
//            //[hud hideAnimated:YES];
//        }
//    } failed:^(NSError *error) {
//        //[hud hideAnimated:YES];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }];
//}
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
