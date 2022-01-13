//
//  CBTimeZoneViewController.m
//  Telematics
//
//  Created by coban on 2019/11/26.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBTimeZoneViewController.h"
#import "MINControlListDataModel.h"

@interface CBTimeZoneViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) MINControlListDataModel *paramtersModel;
@property (nonatomic,strong) UIView *bgmView;
@property (nonatomic,strong) UIButton *pickerBtn;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UITableView *pickerTableView;
@property (nonatomic,strong) NSMutableArray *arrayData;
@end

@implementation CBTimeZoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
    [self getTimeZoneRequest];
    
    //NSLog(@"时区数字:%@",self.arrayData);
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.bgmView.layer.cornerRadius = 5;
    self.bgmView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.bgmView.layer.shadowRadius = 5;
    self.bgmView.layer.shadowOpacity = 0.3;//0.3;
    self.bgmView.layer.shadowOffset  = CGSizeMake(0, 5);// 阴影的范围
    
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.contentView.layer.shadowRadius = 10;
    self.contentView.layer.shadowOpacity = 1;//0.3;
    self.contentView.layer.shadowOffset  = CGSizeMake(0, 10);//CGSizeMake(0, 5);// 阴影的范围
}
- (void)setupView {
    [self initBarWithTitle:Localized(@"时区设置") isBack: YES];
    self.view.backgroundColor = kRGB(247, 247, 247);
    [self initBarRighBtnTitle:Localized(@"确定") target:self action:@selector(comfirmBtnClick)];
    
    self.bgmView = [UIView new];
    self.bgmView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.bgmView];
    [self.bgmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(PPNavigationBarHeight + 15);
        make.left.mas_equalTo(15*frameSizeRate);
        make.right.mas_equalTo(-15*frameSizeRate);
        make.height.mas_equalTo(160);
    }];
    
    UILabel *titleLB = [MINUtils createLabelWithText:Localized(@"请选择时区:") size:14];
    [self.bgmView addSubview:titleLB];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.mas_equalTo(15);
    }];
    UIView *lineView = [MINUtils createLineView];
    [self.bgmView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgmView.mas_left).offset(10);
        make.top.mas_equalTo(titleLB.mas_bottom).offset(10);
        make.right.mas_equalTo(self.bgmView.mas_right).offset(-10);
        make.height.mas_equalTo(0.5);
    }];
    
    [self pickerBtn];
}
- (UIButton *)pickerBtn {
    if (!_pickerBtn) {
        _pickerBtn = [MINUtils createNoBorderBtnWithTitle:Localized(@"") titleColor: kRGB(96, 96, 96) fontSize: 15 * KFitWidthRate backgroundColor:UIColor.whiteColor];
        _pickerBtn.layer.masksToBounds = YES;
        _pickerBtn.layer.borderColor = kTextFieldColor.CGColor;
        _pickerBtn.layer.borderWidth = 1.0f;
        [_pickerBtn addTarget:self action:@selector(pickTimezoneClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bgmView addSubview:_pickerBtn];
        [_pickerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.bgmView.mas_bottom).offset(-20);
            make.centerX.mas_equalTo(self.bgmView.mas_centerX);
            make.height.mas_equalTo(35*KFitHeightRate);
            make.width.mas_equalTo(80);
        }];
        
        UIImage *img = [UIImage imageNamed:@"下拉三角"];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
        [_pickerBtn addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_pickerBtn.mas_centerY);
            make.right.mas_equalTo(_pickerBtn.mas_right).offset(-5);
        }];
    }
    return _pickerBtn;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80);
            make.centerX.mas_equalTo(self.bgmView.mas_centerX);
            make.top.mas_equalTo(self.pickerBtn.mas_top).offset(0);
            make.height.mas_equalTo(0*KFitHeightRate);
        }];
    }
    return _contentView;
}
- (UITableView *)pickerTableView {
    if (!_pickerTableView) {
        _pickerTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 100, 100) style:UITableViewStylePlain];
        _pickerTableView.delegate = self;
        _pickerTableView.dataSource = self;
        _pickerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentView addSubview:_pickerTableView];
        [_pickerTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 5, 0, 5));
        }];
    }
    return _pickerTableView;
}
- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        float kk = 12;
        _arrayData = [NSMutableArray array];
        for (int i = 0 ; i <= 48 ; i ++ ) {
            if (kk > 0.0) {
                [_arrayData addObject:[NSString stringWithFormat:@"+%@",@(kk)]];
            } else if (kk == 0.0) {
                [_arrayData addObject:[NSString stringWithFormat:@"%.0f",kk]];
            } else {
                [_arrayData addObject:[NSString stringWithFormat:@"%@",@(kk)]];
            }
            kk = kk - 0.5;
        }
    }
    return _arrayData;
}
#pragma mark -- 获取开关类设备控制参数
- (void)getTimeZoneRequest {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:[CBCommonTools CBdeviceInfo].dno?:@"" forKey:@"dno"];
    kWeakSelf(self);
    [[NetWorkingManager shared] getWithUrl:@"devControlController/getParamListApp" params:paramters succeed:^(id response,BOOL isSucceed) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"---------结果：%@",response);
        if (isSucceed) {
            if (response && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                self.paramtersModel = [MINControlListDataModel yy_modelWithJSON:response[@"data"]];
                [self.pickerBtn setTitle:self.paramtersModel.timeZone forState:UIControlStateNormal];
            }
        }
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)comfirmBtnClick {
    if (kStringIsEmpty(self.pickerBtn.titleLabel.text)) {
        [HUD showHUDWithText:Localized(@"请选择时区") withDelay:3.0];
        return;
    }
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:[CBCommonTools CBdeviceInfo].dno?:@"" forKey:@"dno"];
    [paramters setObject:self.pickerBtn.titleLabel.text?:@"" forKey:@"timeZone"];
    [self timeZoneEditControlNewRequest:paramters];
}
- (void)pickTimezoneClick {
    [self.pickerTableView reloadData];
    //告知需要更改约束
    //[self setNeedsUpdateConstraints];
    [self.contentView.superview layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80);
            make.centerX.mas_equalTo(self.bgmView.mas_centerX);
            make.top.mas_equalTo(self.pickerBtn.mas_top).offset(0);
            make.bottom.mas_equalTo(-60);
        }];
        [self.contentView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}
#pragma mark -- UITableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45*frameSizeRate;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"popViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.text = self.arrayData[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 收起tableView
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.centerX.mas_equalTo(self.bgmView.mas_centerX);
        make.top.mas_equalTo(self.pickerBtn.mas_top).offset(0);
        make.height.mas_equalTo(0*frameSizeRate);
    }];
    [self.pickerBtn setTitle:self.arrayData[indexPath.row] forState:UIControlStateNormal];
}
#pragma mark -- 终端设备参数设置 -- 新增
- (void)timeZoneEditControlNewRequest:(NSMutableDictionary *)paramters {
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBNetworkRequestManager sharedInstance] terminalSettingParamters:paramters success:^(CBBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        switch (baseModel.status) {
            case CBNetworkingStatus0:
            {
                [HUD showHUDWithText:Localized(@"设置成功") withDelay:3.0];
                [self getTimeZoneRequest];
            }
                break;
            default:
                break;
        }
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
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
