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

@interface MyDeviceDetailViewController () <UITableViewDelegate, UITableViewDataSource, MINPickerViewDelegate,CBControlInputPopViewDelegate>
@property (nonatomic, weak) UITextField *textField; // 警告框的输入框
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, assign) BOOL isEdit;
/** 设置电话号码、设置车牌号码、设置设备名称，输入值弹窗 */
@property (nonatomic,strong) CBControlInputPopView *inputPopView;
@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation MyDeviceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self addGesture];
    self.deviceInfoTitleArr = @[@"设备IMEI号",@"设备电话号码",@"车牌颜色",@"车辆VIN",@"设备名称",@"车牌号码",@"定位图标",@"所属分组",@"设备协议类型",@"设备版本号",@"经销商ID",@"注册日期",@"有效期"];
    self.carColorArr = @[Localized(@"蓝色"), Localized(@"黄色"), Localized(@"黑色"), Localized(@"白色"), Localized(@"其他")];
    self.purposeArr = @[Localized(@"定位图"), Localized(@"人物"), Localized(@"宠物"), Localized(@"单车"), Localized(@"摩托车"), Localized(@"小车"), Localized(@"货车"), Localized(@"行李箱")];
    
    // 扫码添加设备，可编辑
    if (self.isAddDevice) {
        self.isEdit = YES;
    }
    NSArray *array_title = @[Localized( @"设备IMEI号"),Localized(@"设备电话号码"),Localized(@"车辆颜色"),Localized(@"车辆VIN"),Localized(@"车牌号码"),Localized(@"设备名称"),Localized(@"定位图标"),Localized(@"所属分组"),Localized(@"设备协议类型"),Localized(@"设备版本号"),Localized(@"经销商ID"),Localized(@"注册日期"),Localized(@"有效期")];
    for (int i = 0 ; i < array_title.count ; i ++ ) {
        MyDeviceModel *deviceModel = [[MyDeviceModel alloc]init];
        deviceModel.leftTitle = array_title[i];
        switch (i) {
            case 0:
                deviceModel.dno = self.model.dno;
                break;
            case 1:
                deviceModel.devPhone = self.model.devPhone;
                break;
            case 2:
                // 车辆颜色
                deviceModel.color = self.model.color;
                break;
            case 3:
                deviceModel.vin = self.model.vin;
                break;
            case 4:
                deviceModel.carNum = self.model.carNum;
                break;
            case 5:
                deviceModel.name = self.model.name;
                break;
            case 6:
                // 定位图标
                deviceModel.icon = self.model.icon;
                break;
            case 7:
                // 所属分组
                deviceModel.groupNameStr = self.groupName;
                break;
            case 8:
                deviceModel.protocol = self.model.protocol;
                break;
            case 9:
                deviceModel.version = self.model.version;
                break;
            case 10:
                deviceModel.uid = self.model.uid;
                break;
            case 11:
                deviceModel.registerTime = self.model.registerTime;
                break;
            case 12:
                deviceModel.expireTime = self.model.expireTime;
                break;
            default:
                break;
        }
        [self.arrayData addObject:deviceModel];
    }
    [self.tableView reloadData];
}
- (CBControlInputPopView *)inputPopView {
    if (!_inputPopView) {
        _inputPopView = [[CBControlInputPopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _inputPopView.delegate = self;
    }
    return _inputPopView;
}
- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = [NSMutableArray array];
    }
    return _arrayData;
}
#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle: Localized(@"我的设备") isBack: YES];
    if (self.isAddDevice == NO) {
        [self initBarRighBtnTitle: Localized(@"编辑") target: self action: @selector(rightBtnClick:)];
    }else {
        [self initBarRighBtnTitle: Localized(@"完成") target: self action: @selector(rightBtnClick:)];
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
#pragma mark -- 输入弹窗代理
- (void)updateTextFieldValue:(NSString *)inputStr returnTitle:(NSString *)title {
    if ([title isEqualToString:Localized(@"设置电话号码")]) {
        if (kStringIsEmpty(inputStr)) {
            [HUD showHUDWithText:Localized(@"请输入电话号码") withDelay:3.0];
            return;
        }
        MyDeviceModel *deviceModel = self.arrayData[1];
        deviceModel.devPhone = inputStr;
    } else if ([title isEqualToString:Localized(@"车牌号码")]) {
        if (kStringIsEmpty(inputStr)) {
            [HUD showHUDWithText:Localized(@"请输入组名") withDelay:3.0];
            return;
        }
        MyDeviceModel *deviceModel = self.arrayData[4];
        deviceModel.carNum = inputStr;
    } else if ([title isEqualToString:Localized(@"设备名称")]) {
        if (kStringIsEmpty(inputStr)) {
            [HUD showHUDWithText:Localized(@"输入设备名称") withDelay:3.0];
            return;
        }
        MyDeviceModel *deviceModel = self.arrayData[5];
        deviceModel.name = inputStr;
    }
    [self.tableView reloadData];
}
#pragma mark - tableView delegate & datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.5 * KFitHeightRate;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;//self.deviceInfoTitleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"DeviceDetailCellIndentify";
    DeviceDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIndentify];
    if (cell == nil) {
        cell = [[DeviceDetailTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIndentify];
    }
    if (self.arrayData.count > indexPath.row) {
        MyDeviceModel *deviceModel = self.arrayData[indexPath.row];
        cell.editDeviceModel = deviceModel;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEdit == YES) {
        //DeviceDetailTableViewCell *cell = (DeviceDetailTableViewCell *)[tableView cellForRowAtIndexPath: indexPath];
        if (indexPath.row == 2 || indexPath.row == 6 || indexPath.row == 7) {
            MINPickerView *pickerView = [[MINPickerView alloc] init];
            if (self.arrayData.count > indexPath.row) {
                MyDeviceModel *deviceModel = self.arrayData[indexPath.row];
                pickerView.titleLabel.text = deviceModel.leftTitle;
                if (indexPath.row == 6) {
                    pickerView.isPicturePickerView = YES;
                }
                self.selectIndexPath = indexPath;
                if (indexPath.row == 2) {
                    pickerView.dataArr = @[self.carColorArr];
                } else if (indexPath.row == 6) {
                    pickerView.dataArr = @[self.purposeArr];
                } else if (indexPath.row == 7) {
                    pickerView.titleLabel.text = Localized(@"移至分组");
                    pickerView.dataArr = @[self.groupNameArray];
                }
                pickerView.delegate = self;
                [self.view addSubview: pickerView];
                [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.equalTo(self.view);
                    make.height.mas_equalTo(SCREEN_HEIGHT);
                }];
                [pickerView showView];
            }
        }else if (indexPath.row == 1) {
            [self.inputPopView updateTitle:Localized(@"设置电话号码") placehold:Localized(@"请输入电话号码") isDigital:YES];
            [self.inputPopView popView];
        } else if (indexPath.row == 4) {
            [self.inputPopView updateTitle:Localized(@"车牌号码") placehold:Localized(@"输入车牌号码") isDigital:NO];
            [self.inputPopView popView];
            self.inputPopView.inputTF.keyboardType = UIKeyboardTypeNamePhonePad;
        } else if (indexPath.row == 5) {
            [self.inputPopView updateTitle:Localized(@"设备名称") placehold:Localized(@"输入设备名称") isDigital:NO];
            [self.inputPopView popView];
        }
    }
}

// 添加设备的时候，修改数据
- (void)editWhenAddDeviceName:(NSString *)name phoneNum:(NSString *)phoneNum carColor:(int)carColor icon:(int)icon cell:(DeviceDetailTableViewCell*)cell
{
    // 修改model数据
    if (name != nil) {
        self.model.name = name;
    }else if (phoneNum != nil) {
        self.model.devPhone = phoneNum;
    }else if (carColor != -1) {
        self.model.color = carColor;
    }else if (icon != -1) {
        self.model.icon = icon;
    }
    // 修改UI数据
    if (name != nil) {
        [cell setEditLabelText: name];
    }else if (phoneNum != nil) {
        [cell setEditLabelText: phoneNum];
    }else if (carColor != -1) {
        [cell setSelectLabelText: self.carColorArr[carColor]];
    }else if (icon != -1) {
        [cell setSelectLabelText: self.purposeArr[icon]];
    }
}
#pragma mark -- 编辑设备信息
// 编辑设备的时候，修改数据
- (void)editDeviceRequest //Name:(NSString *)name phoneNum:(NSString *)phoneNum carColor:(NSInteger)carColor icon:(NSInteger)icon cell:(DeviceDetailTableViewCell*)cell
{
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    paramters[@"dno"] = self.model.dno; // self.model.dno
    MyDeviceModel *deviceModelDeviceName = self.arrayData[5];
    MyDeviceModel *deviceModelPhone = self.arrayData[1];
    MyDeviceModel *deviceModelCarNum = self.arrayData[4];
    MyDeviceModel *deviceModelColor = self.arrayData[2];
    MyDeviceModel *deviceModelIcon = self.arrayData[6];
    
    [paramters setObject:deviceModelDeviceName.name?:@"" forKey:@"dname"];
    [paramters setObject:deviceModelPhone.devPhone?:@"" forKey:@"devPhone"];
    [paramters setObject:deviceModelCarNum.carNum?:@"" forKey:@"carNum"];
    [paramters setObject:[NSNumber numberWithInteger:deviceModelColor.color] forKey:@"color"];
    [paramters setObject:[NSNumber numberWithInteger:deviceModelIcon.icon] forKey:@"icon"];
    
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[NetWorkingManager shared]postWithUrl:@"devControlController/editDev" params:paramters succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            self.isEdit = NO;
            [self.rightBtn setTitle: Localized(@"编辑") forState: UIControlStateNormal];
            [self.rightBtn setTitle: Localized(@"编辑") forState: UIControlStateHighlighted];
            [self.tableView reloadData];
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
            [rightBtn setTitle: Localized(@"完成") forState: UIControlStateNormal];
            [rightBtn setTitle: Localized(@"完成") forState: UIControlStateHighlighted];
        } else {
            self.rightBtn = sender;
            [self editDeviceRequest];
        }
    } else { // 添加设备的情况下
        __weak __typeof__(self) weakSelf = self;
        NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithCapacity:1];
        MyDeviceModel *deviceModelDeviceName = self.arrayData[5];
        MyDeviceModel *deviceModelPhone = self.arrayData[1];
        MyDeviceModel *deviceModelCarNum = self.arrayData[4];
        MyDeviceModel *deviceModelColor = self.arrayData[2];
        MyDeviceModel *deviceModelIcon = self.arrayData[6];
        
        [paramters setObject:self.model.dno?:@"" forKey:@"dno"];
        [paramters setObject:deviceModelDeviceName.name?:@"" forKey:@"dName"];
        [paramters setObject:deviceModelPhone.devPhone?:@"" forKey:@"devPhone"];
        [paramters setObject:deviceModelCarNum.carNum?:@"" forKey:@"carNum"];
        [paramters setObject:[NSNumber numberWithInteger:deviceModelColor.color] forKey:@"color"];
        [paramters setObject:[NSNumber numberWithInteger:deviceModelIcon.icon] forKey:@"icon"];
        
        [MBProgressHUD showHUDIcon:self.view animated:YES];
        kWeakSelf(self);
        [[NetWorkingManager shared]postWithUrl:@"personController/addDevice" params:paramters succeed:^(id response,BOOL isSucceed) {
            kStrongSelf(self);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (isSucceed) {
                if (weakSelf.isBind == true) {
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    [weakSelf popToControllerClass: [MyDeviceViewController class]];
                }
                //[hud hideAnimated:YES];
            } else {
                //[hud hideAnimated:YES];
            }
        } failed:^(NSError *error) {
            //[hud hideAnimated:YES];
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
    if (self.isAddDevice == NO) {
        if (self.selectIndexPath.row == 2) {
            MyDeviceModel *deviceModelColor = self.arrayData[2];
            deviceModelColor.color = [selectRow intValue];
            
        } else if (self.selectIndexPath.row == 6) {
            MyDeviceModel *deviceModelIcon = self.arrayData[6];
            deviceModelIcon.icon = [selectRow intValue];
        } else if (self.selectIndexPath.row == 7) {
            // 移至分组
            [self moveToGroupRequestGroupId:[selectRow integerValue]];
        }
    } else {
        if (self.selectIndexPath.row == 2) {
            MyDeviceModel *deviceModelColor = self.arrayData[2];
            deviceModelColor.color = [selectRow intValue];
        } else if (self.selectIndexPath.row == 6) {
            MyDeviceModel *deviceModelIcon = self.arrayData[6];
            deviceModelIcon.color = [selectRow intValue];
        } else if (self.selectIndexPath.row == 7) {
            // 移少分组
            [self moveToGroupRequestGroupId:[selectRow integerValue]];
        }
    }
    
    [self.tableView reloadData];
}
#pragma mark -- 设置分组
- (void)moveToGroupRequestGroupId:(NSInteger)index {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    NSString *goupIdStr = self.groupIdArray[index];
    paramters[@"gid"] = goupIdStr;
    paramters[@"dno"] = self.model.dno;
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    [[NetWorkingManager shared]postWithUrl:@"personController/moveDevGroup" params:paramters succeed:^(id response,BOOL isSucceed) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSucceed) {
            MyDeviceModel *deviceModelGroup = self.arrayData[7];
            deviceModelGroup.groupNameStr = self.groupNameArray[index];
            [self.tableView reloadData];
            [HUD showHUDWithText:Localized(@"修改成功") withDelay:3.0f];
        }else {
            //[hud hideAnimated:YES];
        }
    } failed:^(NSError *error) {
        //[hud hideAnimated:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
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
