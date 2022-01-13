//
//  CBManagerAccountPopView.m
//  Telematics
//
//  Created by coban on 2019/12/25.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBManagerAccountPopView.h"
#import "CBAccountPopTableViewCell.h"
#import "CBAccountPopHeadView.h"
#import "CBAccountPopTableViewCell.h"

static NSString *AccountPopViewHeadViewIndentifer = @"AccountPopViewHeadViewIndentifer";

@interface CBManagerAccountPopView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIView *bgmView;
@property (nonatomic,strong) UILabel *titleTopLb;
@property (nonatomic,strong) UILabel *titlePickDeviceLb;
@property (nonatomic,strong) UITableView *deviceTableView;
@property (nonatomic,strong) UILabel *titlePickedDeviceLb;
@property (nonatomic,strong) UILabel *deviceLb;
@property (nonatomic,strong) UIButton *certainBtn;
@property (nonatomic,strong) UIButton *lookatBtn;
@property (nonatomic,strong) UIButton *controlBtn;

@property (nonatomic,strong) CBAccountPopHeadView *headView;
@property (nonatomic,strong) NSMutableArray *arrayDataSection;
@property (nonatomic,strong) CBNoDataView *noDataView;

@end

@implementation CBManagerAccountPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taphandle:)];
    [self addGestureRecognizer:tap];
    tap.delegate = self;
    
    [self bgmView];
    [self titleTopLb];
    [self titlePickDeviceLb];

    [self certainBtn];
    [self lookatBtn];
    [self controlBtn];
    [self deviceLb];
    [self titlePickedDeviceLb];
    
    [self deviceTableView];
}
- (UIView *)bgmView {
    if (!_bgmView) {
        _bgmView = [UIView new];
        _bgmView.backgroundColor = [UIColor whiteColor];
        _bgmView.layer.masksToBounds = YES;
        _bgmView.layer.cornerRadius = 6*frameSizeRate;
        [self addSubview:_bgmView];
        [_bgmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30*frameSizeRate);
            make.right.mas_equalTo(-30*frameSizeRate);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(400);
        }];
    }
    return _bgmView;
}
- (UILabel *)titleTopLb {
    if (!_titleTopLb) {
        _titleTopLb = [MINUtils createLabelWithText:Localized(@"权限设置")size:18 alignment: NSTextAlignmentCenter textColor:kRGB(51, 51, 51)];
        _titleTopLb.numberOfLines = 0;
        _titleTopLb.textColor = UIColor.blackColor;
        _titleTopLb.font = [UIFont systemFontOfSize:18];
        [self.bgmView addSubview:_titleTopLb];
        [_titleTopLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgmView.mas_top).offset(15*KFitHeightRate);
            make.centerX.equalTo(self.bgmView);
        }];
    }
    return _titleTopLb;
}
- (UILabel *)titlePickDeviceLb {
    if (!_titlePickDeviceLb) {
        _titlePickDeviceLb = [MINUtils createLabelWithText:Localized(@"设备选择")size: 16 alignment: NSTextAlignmentCenter textColor:kRGB(51, 51, 51)];
        _titlePickDeviceLb.numberOfLines = 0;
        _titlePickDeviceLb.textColor = UIColor.blackColor;
        _titlePickDeviceLb.font = [UIFont systemFontOfSize:16];
        [self.bgmView addSubview:_titlePickDeviceLb];
        [_titlePickDeviceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleTopLb.mas_bottom).offset(20*KFitHeightRate);
            make.left.mas_equalTo(self.bgmView.mas_left).offset(15*KFitWidthRate);
        }];
    }
    return _titlePickDeviceLb;
}
- (UIButton *)certainBtn {
    if (!_certainBtn) {
        _certainBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"确定") titleColor: [UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: kBlueColor];
        _certainBtn.layer.masksToBounds = YES;
        _certainBtn.layer.cornerRadius = 4;
        _certainBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_certainBtn addTarget:self action:@selector(certain) forControlEvents:UIControlEventTouchUpInside];
        [self.bgmView addSubview:_certainBtn];
        [_certainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgmView.mas_left).offset(10);
            make.right.equalTo(self.bgmView.mas_right).offset(-10);
            make.bottom.mas_equalTo(self.bgmView.mas_bottom).offset(-10);
            make.height.mas_equalTo(45);
        }];
    }
    return _certainBtn;
}
- (UIButton *)lookatBtn {
    if (!_lookatBtn) {
        _lookatBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"确定") titleColor: [UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: UIColor.whiteColor];
        _lookatBtn.selected = YES;
        [_lookatBtn setImage: [UIImage imageNamed:@"单选-选中"] forState: UIControlStateSelected];
        [_lookatBtn setImage: [UIImage imageNamed:@"单选-没选中"] forState: UIControlStateNormal];
//        [_lookatBtn setImageEdgeInsets: UIEdgeInsetsMake(0, 0, 0, 10 * KFitWidthRate)];
//        [_lookatBtn setTitleEdgeInsets: UIEdgeInsetsMake(0, 10 * KFitWidthRate, 0, 0)];
        [_lookatBtn horizontalCenterImageAndTitle:10];
        [_lookatBtn setTitle: Localized(@"查看") forState: UIControlStateNormal];
        [_lookatBtn setTitle: Localized(@"查看") forState: UIControlStateSelected];
        [_lookatBtn setTitleColor:kRGB(137, 137, 137) forState: UIControlStateNormal];
        [_lookatBtn setTitleColor:kRGB(137, 137, 137) forState: UIControlStateSelected];
        _lookatBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _lookatBtn.adjustsImageWhenHighlighted = NO;
        _lookatBtn.adjustsImageWhenDisabled = NO;
        [_lookatBtn addTarget:self action:@selector(selectAuthBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgmView addSubview:_lookatBtn];
        [_lookatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.bgmView.mas_centerX).offset(-15*KFitWidthRate);
            make.bottom.mas_equalTo(self.certainBtn.mas_top).offset(-10);
            make.height.mas_equalTo(40);
            //make.size.mas_equalTo(CGSizeMake(75*KFitWidthRate, 40));
        }];
    }
    return _lookatBtn;
}
- (UIButton *)controlBtn {
    if (!_controlBtn) {
        _controlBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"确定") titleColor: [UIColor whiteColor] fontSize: 15 * KFitWidthRate backgroundColor: UIColor.whiteColor];
        [_controlBtn setImage: [UIImage imageNamed:@"单选-选中"] forState: UIControlStateSelected];
        [_controlBtn setImage: [UIImage imageNamed:@"单选-没选中"] forState: UIControlStateNormal];
        [_controlBtn setTitle: Localized(@"控制") forState: UIControlStateNormal];
        [_controlBtn setTitle: Localized(@"控制") forState: UIControlStateSelected];
//        [_controlBtn setImageEdgeInsets: UIEdgeInsetsMake(0, 0, 0, 10 * KFitWidthRate)];
//        [_controlBtn setTitleEdgeInsets: UIEdgeInsetsMake(0, 10 * KFitWidthRate, 0, 0)];
        [_controlBtn horizontalCenterImageAndTitle:10];
        [_controlBtn setTitleColor:kRGB(137, 137, 137) forState: UIControlStateNormal];
        [_controlBtn setTitleColor:kRGB(137, 137, 137) forState: UIControlStateSelected];
        _controlBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _controlBtn.adjustsImageWhenHighlighted = NO;
        _controlBtn.adjustsImageWhenDisabled = NO;
        [_controlBtn addTarget:self action:@selector(selectAuthBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgmView addSubview:_controlBtn];
        [_controlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bgmView.mas_centerX).offset(15*KFitWidthRate);
            make.bottom.mas_equalTo(self.certainBtn.mas_top).offset(-10);
            make.height.mas_equalTo(40);
            //make.size.mas_equalTo(CGSizeMake(75*KFitWidthRate, 40));
        }];
    }
    return _controlBtn;
}
- (UILabel *)deviceLb {
    if (!_deviceLb) {
        _deviceLb = [MINUtils createLabelWithText:Localized(@"灯火阑珊")size: 18 * KFitWidthRate alignment: NSTextAlignmentCenter textColor:kRGB(51, 51, 51)];
        _deviceLb.numberOfLines = 0;
        _deviceLb.textColor = kRGB(137, 137, 137);
        _deviceLb.font = [UIFont systemFontOfSize:15];
        [self.bgmView addSubview:_deviceLb];
        [_deviceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.lookatBtn.mas_top).offset(-5*KFitHeightRate);
            make.left.equalTo(self.bgmView.mas_left).offset(15*KFitWidthRate);
        }];
    }
    return _deviceLb;
}
- (UILabel *)titlePickedDeviceLb {
    if (!_titlePickedDeviceLb) {
        _titlePickedDeviceLb = [MINUtils createLabelWithText:[NSString stringWithFormat:@"%@[0]",Localized(@"已选设备")] size: 18 * KFitWidthRate alignment: NSTextAlignmentCenter textColor:kRGB(51, 51, 51)];
        _titlePickedDeviceLb.textColor = UIColor.blackColor;
        _titlePickedDeviceLb.numberOfLines = 0;
        _titlePickedDeviceLb.font = [UIFont systemFontOfSize:15];
        [self.bgmView addSubview:_titlePickedDeviceLb];
        [_titlePickedDeviceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.deviceLb.mas_top).offset(-5*KFitHeightRate);
            make.left.equalTo(self.titlePickDeviceLb.mas_left);
        }];
    }
    return _titlePickedDeviceLb;
}
- (UITableView *)deviceTableView {
    if (!_deviceTableView) {
        _deviceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _deviceTableView.delegate = self;
        _deviceTableView.backgroundColor = UIColor.whiteColor;
        _deviceTableView.dataSource = self;
        _deviceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 设为0，防止tableView刷新后位置变化
        _deviceTableView.estimatedRowHeight = 0;
        _deviceTableView.estimatedSectionFooterHeight = 0;
        _deviceTableView.estimatedSectionHeaderHeight = 0;
        [self.bgmView addSubview:_deviceTableView];
        [_deviceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titlePickDeviceLb.mas_bottom).offset(5*KFitHeightRate);
            make.left.mas_equalTo(self.bgmView.mas_left).offset(15*KFitWidthRate);
            make.right.equalTo(self.bgmView.mas_right).offset(-15*KFitWidthRate);
            make.bottom.mas_equalTo(self.titlePickedDeviceLb.mas_top).offset(-5*KFitHeightRate);
        }];
    }
    return _deviceTableView;
}
- (CBNoDataView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[CBNoDataView alloc] initWithGrail];
        [self.deviceTableView addSubview:_noDataView];
        _noDataView.center = self.deviceTableView.center;
        _noDataView.hidden = YES;
        kWeakSelf(self);
        [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf(self);
            make.size.mas_equalTo(CGSizeMake(200, 200));
            make.centerX.equalTo(self.deviceTableView.mas_centerX);
            make.centerY.equalTo(self.deviceTableView.mas_centerY).offset(-20);
        }];
    }
    return _noDataView;
}
- (NSMutableArray *)arrayDataSection {
    if (!_arrayDataSection) {
        _arrayDataSection = [NSMutableArray array];
    }
    return _arrayDataSection;
}
- (void)popView:(SubAccountModel *)subDeviceModel {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self getDeviceListRequest:subDeviceModel];
}
- (void)dismiss {
    [self removeFromSuperview];
}
- (void)certain {
    if (self.popViewBlock) {
        self.popViewBlock(self.arrayDataSection);
    }
    [self removeFromSuperview];
}
#pragma mark -------------- 手势代理方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (CGRectContainsPoint(self.bgmView.frame, [gestureRecognizer locationInView:self]) ) {
        return NO;
    } else {
        return YES;
    }
}
- (void)taphandle:(UITapGestureRecognizer*)sender {
    [self dismiss];
}
- (void)selectAuthBtnClick:(UIButton *)sender {
    if (sender == self.lookatBtn) {
        self.lookatBtn.selected = YES;
        self.controlBtn.selected = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(accountPopViewClickType:)]) {
            [self.delegate accountPopViewClickType:0];
        }
    } else {
        self.lookatBtn.selected = NO;
        self.controlBtn.selected = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(accountPopViewClickType:)]) {
            [self.delegate accountPopViewClickType:1];
        }
    }
}
#pragma mark -- 获取设备列表
- (void)getDeviceListRequest:(SubAccountModel *)subDeviceModel {
    [MBProgressHUD showHUDIcon:self animated:YES];
    kWeakSelf(self);
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [[NetWorkingManager shared]getWithUrl:@"personController/getMyDeviceList" params:paramters succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self animated:YES];
        NSLog(@"====设备列表==%@====",response);
        if (isSucceed) {
            NSMutableArray *arrayAll = [NSMutableArray array];
            CBBaseNetworkModel *baseModel = [CBBaseNetworkModel mj_objectWithKeyValues:response];
            for (NSDictionary *dic in baseModel.data) {
                CBHomeLeftMenuDeviceGroupModel *model = [CBHomeLeftMenuDeviceGroupModel mj_objectWithKeyValues:dic];
                [arrayAll addObject:model];
                self.arrayDataSection = arrayAll;
            }
            [self.deviceTableView reloadData];
            self.noDataView.hidden = self.arrayDataSection.count == 0?NO:YES;
            [self updatePopView:subDeviceModel];
        }
    } failed:^(NSError *error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self animated:YES];
    }];
}
- (void)updatePopView:(SubAccountModel *)subDeviceModel {
    if (subDeviceModel.subDevice.count > 0) {
        for (SubAccountSubDeviceModel *modelSubDevice in subDeviceModel.subDevice) {
            for (CBHomeLeftMenuDeviceGroupModel *deviceGoupModel in self.arrayDataSection) {
                if (deviceGoupModel.noGroup) {
                    deviceGoupModel.isCheck = YES;
                    for (CBHomeLeftMenuDeviceInfoModel *model in deviceGoupModel.noGroup) {
                        NSLog(@"设备列表设备ID%@  子账号设备ID%@",model.ids,modelSubDevice.deviceId);
                        if ([model.ids isEqualToString:modelSubDevice.deviceId]) {
                            model.isCheck = YES;
                        }
                        if (!model.isCheck) {
                            deviceGoupModel.isCheck = NO;
                        }
                    };
                    // 分组下设备书为0，状态为不选中
                    if (deviceGoupModel.noGroup.count == 0) {
                        deviceGoupModel.isCheck = NO;
                    }
                } else {
                    deviceGoupModel.isCheck = YES;
                    for (CBHomeLeftMenuDeviceInfoModel *model in deviceGoupModel.device) {
                        NSLog(@"设备列表设备ID%@  子账号设备ID%@",model.ids,modelSubDevice.deviceId);
                        if ([model.ids isEqualToString:modelSubDevice.deviceId]) {
                            model.isCheck = YES;
                        }
                        if (!model.isCheck) {
                            deviceGoupModel.isCheck = NO;
                        }
                    };
                    // 分组下设备书为0，状态为不选中
                    if (deviceGoupModel.device.count == 0) {
                        deviceGoupModel.isCheck = NO;
                    }
                }
            }
        }
    }
    [self.deviceTableView reloadData];
}
- (void)updateDeviceName {
    NSMutableArray *arraySelectDeviece = [NSMutableArray array];
    for (CBHomeLeftMenuDeviceGroupModel *deviceGoupModel in self.arrayDataSection) {
        if (deviceGoupModel.noGroup) {
            for (CBHomeLeftMenuDeviceInfoModel *model in deviceGoupModel.noGroup) {
                if (model.isCheck) {
                    [arraySelectDeviece addObject:model.name];
                }
            };
            
        } else {
            for (CBHomeLeftMenuDeviceInfoModel *model in deviceGoupModel.device) {
                if (model.isCheck) {
                    [arraySelectDeviece addObject:model.name];
                }
            };
        }
    }
    self.titlePickedDeviceLb.text = [NSString stringWithFormat:@"%@[%@]",Localized(@"已选设备"),@(arraySelectDeviece.count)];
    self.deviceLb.text = [NSString stringWithFormat:@"%@",[arraySelectDeviece componentsJoinedByString:@","]];
}
#pragma mark -- UITableView delegate
#pragma mark -- UITableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrayDataSection.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.arrayDataSection.count > section) {
        CBHomeLeftMenuDeviceGroupModel *deviceGoupModel = self.arrayDataSection[section];
        if (deviceGoupModel.isShow) {
            if (deviceGoupModel.noGroup) {
                return deviceGoupModel.noGroup.count;
            } else {
                return deviceGoupModel.device.count;
            }
        } else {
            return 0;
        }
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CBAccountPopTableViewCell *cell;
    cell = [CBAccountPopTableViewCell cellCopyTableView:tableView];
    if (self.arrayDataSection.count > indexPath.section) {
        CBHomeLeftMenuDeviceGroupModel *deveiceGroup = self.arrayDataSection[indexPath.section];
        //__weak typeof(CBHomeLeftMenuDeviceGroupModel *) weakModel = deveiceGroup;
        __block typeof(CBHomeLeftMenuDeviceGroupModel *) weakModel = deveiceGroup;
        kWeakSelf(self);
        cell.cellClickBlock = ^(id  _Nonnull objc) {
            weakModel.isCheck = YES;
            kStrongSelf(self);
            if (deveiceGroup.noGroup) {
                for (CBHomeLeftMenuDeviceInfoModel *model in deveiceGroup.noGroup) {
                    if (!model.isCheck) {
                        weakModel.isCheck = NO;
                    }
                };
            } else {
                for (CBHomeLeftMenuDeviceInfoModel *model in deveiceGroup.device) {
                    if (!model.isCheck) {
                        weakModel.isCheck = NO;
                    }
                };
            }
            [self.deviceTableView reloadData];
            [self updateDeviceName];
        };
        if (deveiceGroup.noGroup) {
            CBHomeLeftMenuDeviceInfoModel *deviceInfoModel = deveiceGroup.noGroup[indexPath.row];
            cell.deviceInfoModel = deviceInfoModel;
            return cell;
        } else {
            CBHomeLeftMenuDeviceInfoModel *deviceInfoModel = deveiceGroup.device[indexPath.row];
            cell.deviceInfoModel = deviceInfoModel;
            return cell;
        }
    }
    return UITableViewCell.new;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50 * KFitHeightRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 63 * KFitHeightRate;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CBAccountPopHeadView *homeSectionHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:AccountPopViewHeadViewIndentifer];
    if (!homeSectionHeadView) {
        homeSectionHeadView = [[CBAccountPopHeadView alloc]initWithReuseIdentifier:AccountPopViewHeadViewIndentifer];
    }
    if (self.arrayDataSection.count > section) {
        kWeakSelf(self);
        CBHomeLeftMenuDeviceGroupModel *deviceGoupModel = self.arrayDataSection[section];
        homeSectionHeadView.deviceGoupModel = deviceGoupModel;
        homeSectionHeadView.headClickBlock = ^(id  _Nonnull objc) {
            kStrongSelf(self);
            if (deviceGoupModel.noGroup) {
                if (deviceGoupModel.noGroup.count > 0) {
                    for (CBHomeLeftMenuDeviceInfoModel *model in deviceGoupModel.noGroup) {
                        model.isCheck = deviceGoupModel.isCheck;
                    };
                };
            } else {
                if (deviceGoupModel.device.count > 0) {
                    for (CBHomeLeftMenuDeviceInfoModel *model in deviceGoupModel.device) {
                        model.isCheck = deviceGoupModel.isCheck;
                    };
                };
            }
            [self.deviceTableView reloadData];
        };
        [self updateDeviceName];
    }
    return homeSectionHeadView;
}
@end
