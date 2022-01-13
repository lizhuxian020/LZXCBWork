//
//  CBSingTalkViewController.m
//  cobanBnWatch
//
//  Created by coban on 2019/12/5.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBSingTalkViewController.h"
#import "CBHomeTalkTableView.h"
#import "CBTalkFootView.h"
#import "CBTalkMineTableViewCell.h"
#import "CBTalkOthersTableViewCell.h"
#import "CBVoicePopView.h"
#import "CBTalkPlayVoiceManager.h"
#import "CBChatFMDBManager.h"
/* oc 调用 swift*/
#import "cobanBnPetSwift-Swift.h"

@interface CBSingTalkViewController ()<UITableViewDelegate,UITableViewDataSource,CBTalkFootViewDelegate>

@property (nonatomic,strong) CBHomeTalkTableView *talkTableView;
@property (nonatomic,strong) CBTalkFootView *footView;
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,strong) CBVoicePopView *recordingView;
@property (nonatomic,copy) NSString *qnyToken;

@end

@implementation CBSingTalkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 创建获取语聊数据库
    [[CBChatFMDBManager sharedFMDataBase] createTabSingleChat];
    
    [self setupView];
    [self getQNYFileTokenReqeust];
    [self getChatLogDataRequest:NO];
    
    kPlayTalkVoiceManager.isEnd = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSingleData) name:KCBWtSingleChatNotification object:nil];
    
    //shanchu
    [self initBarRightImageName:@"shanchu" target: self action: @selector(clearChatRecordClick)];
    
    [CBWtCommonTools checkMicrophonePermission];
}
#pragma mark -- 收到推送刷新聊天列表
- (void)updateSingleData {
    [self.arrayData removeAllObjects];
    [self getChatLogDataRequest:YES];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KCBWtSingleChatNotification object:nil];
}
- (void)setupView {
    self.view.backgroundColor = UIColor.whiteColor;//KWtBackColor;
    [self initBarWithTitle:[HomeModel CBDevice].tbWatchMain.name?:@"" isBack:YES];
    
    [self tableView];
    [self footView];
    [self recordingView];
}
#pragma mark -- setting && getting
- (CBHomeTalkTableView *)tableView {
    if (!_talkTableView) {
        _talkTableView = [[CBHomeTalkTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - PPNavigationBarHeight - TabPaddingBARHEIGHT - 66*frameSizeRate) style:UITableViewStylePlain];
        [self.view addSubview:_talkTableView];
        _talkTableView.delegate = self;
        _talkTableView.dataSource = self;
        _talkTableView.backgroundColor = [UIColor whiteColor];
        kWeakSelf(self);
        _talkTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            kStrongSelf(self);
            [self.arrayData removeAllObjects];
            [self getChatLogDataRequest:YES];
        }];
    }
    return _talkTableView;
}
- (CBTalkFootView *)footView {
    if (!_footView) {
        _footView = [[CBTalkFootView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - PPNavigationBarHeight - 66*frameSizeRate - TabPaddingBARHEIGHT, SCREEN_WIDTH, 66*frameSizeRate)];
        _footView.delegate = self;
        _footView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_footView];
        kWeakSelf(self);
        _footView.returnBlock = ^(id  _Nonnull objc) {
            kStrongSelf(self);
            self.recordingView.timeLb.text = objc?:@"";
        };
        _footView.recordingDoneBlock = ^(id  _Nonnull objc) {
            kStrongSelf(self);
            // 录音完成
            [self uploadVoiceRequestToQiniu:objc];
        };
    }
    return _footView;
}
- (CBVoicePopView *)recordingView {
    if (!_recordingView) {
        _recordingView = [CBVoicePopView new];
        _recordingView.backgroundColor = [UIColor grayColor];
        _recordingView.layer.masksToBounds = YES;
        _recordingView.layer.cornerRadius = 6.0f;
        _recordingView.hidden = YES;
        _recordingView.alpha = 0.0;
        [self.view addSubview:_recordingView];
        [_recordingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.centerY.mas_equalTo(self.view.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(180*frameSizeRate, 95 + 20));
        }];
    }
    return _recordingView;
}
- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = [NSMutableArray array];
    }
    return _arrayData;
}
- (void)scrollToBottom {
    NSInteger s = [self.tableView numberOfSections];  //有多少组
    if (s < 1) return;                                //无数据时不执行 要不会crash
    NSInteger r = [self.tableView numberOfRowsInSection:s-1];           //最后一组有多少行
    if (r < 1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  //取最后一行数据
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO]; //滚动到最后一行
}
#pragma mark -- 获取本地聊天全部数据
- (void)getLocalChatRecord {
    NSArray *arr = [[CBChatFMDBManager sharedFMDataBase] querySingleChat:@""];
    [self.arrayData removeAllObjects];
    [self.arrayData addObjectsFromArray:arr];
}
#pragma mark -- 获取七牛云token
- (void)getQNYFileTokenReqeust {
    [[CBWtNetworkRequestManager sharedInstance] getQNFileTokenSuccess:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        switch (baseModel.status) {
            case CBWtNetworkingStatus0:
            {
                self.qnyToken = baseModel.data;
            }
                break;
            default:
            {
                [CBWtMINUtils showProgressHudToView:self.view withText:baseModel.resmsg];
            }
                break;
        }
    } failure:^(NSError * _Nonnull error) {
    }];
}
#pragma mark -- 获取单聊聊天记录
- (void)getChatLogDataRequest:(BOOL)isPull {
    [self getLocalChatRecord];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:[HomeModel CBDevice].tbWatchMain.sno?:@"" forKey:@"sno"];
    if (!isPull) {
        [MBProgressHUD showHUDIcon:self.view animated:YES];
    }
    kWeakSelf(self);
    [[CBWtNetworkRequestManager sharedInstance] getSingleChatLogListParamters:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_footer endRefreshing];
        NSArray *array = baseModel.data;
        NSLog(@"+++++单聊聊天记录++++++++:%@",array);
        if (array.count > 0) {
            for (NSDictionary *dic in array) {
                CBTalkModel *model = [CBTalkModel mj_objectWithKeyValues:dic];
                model.isPlay = YES;
                // 查询本地，若本地有则不添加
                NSArray *arr = [[CBChatFMDBManager sharedFMDataBase] querySingleChat:[NSString stringWithFormat:@"select * from t_SINGLECHAT_TABLE%@%@ WHERE ids = '%@'",[CBPetLoginModelTool getUser].uid,[HomeModel CBDevice].tbWatchMain.sno?:@"",model.ids]];
                if (arr.count <= 0) {
                    [self.arrayData addObject:model];
                    //数据插入
                    BOOL isInsert = [[CBChatFMDBManager sharedFMDataBase] addSingleChat:model];
                    if (isInsert) {
                        NSLog(@"插入成功");
                    } else {
                        NSLog(@"插入失败");
                    }
                }
            }
        }
        
        [self.tableView reloadData];
        [self scrollToBottom];
        self.noDataView.hidden = self.arrayData.count == 0?NO:YES;
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark -- 上传语音文件到七牛云
- (void)uploadVoiceRequestToQiniu:(NSString *)filePath {
    if (!filePath) {
        [CBWtMINUtils showProgressHudToView:self.view withText:@"录音未完成"];
        return;
    }
    NSData *voiceData = [NSData dataWithContentsOfFile:filePath];
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    [[CBWtNetworkRequestManager sharedInstance] uploadVoiceToQNFileData:voiceData token:self.qnyToken?:@"" success:^(id  _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *voiceKey = [NSString stringWithFormat:@"%@",baseModel[@"key"]];
        NSString *voiceUrlStr = [NSString stringWithFormat:@"%@%@",@"http://cdn.clw.gpstrackerxy.com/",voiceKey];
        
        NSLog(@"--------语音路径--------%@",voiceUrlStr);
        [self sendVoiceRequestUrl:voiceUrlStr];
        
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 发送语音
- (void)sendVoiceRequestUrl:(NSString *)url {
    [MBProgressHUD showHUDIcon:self.view animated:YES];
    kWeakSelf(self);
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:[HomeModel CBDevice].tbWatchMain.sno?:@"" forKey:@"sno"];
    [paramters setObject:url?:@"" forKey:@"voice"];
    [paramters setObject:@"1" forKey:@"chatType"];
    [[CBWtNetworkRequestManager sharedInstance] sendVoiceReqeustParamters:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        [self getChatLogDataRequest:YES];
        
    } failure:^(NSError * _Nonnull error) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -- 播放语音
- (void)playVoiceAction:(CBTalkModel *)model {
    if (kPlayTalkVoiceManager.isEnd == NO) {
        return;
    }
    [kPlayTalkVoiceManager playVoiceUrl:model];
    kWeakSelf(self);
    kPlayTalkVoiceManager.playTalkVoiceEndBlock = ^(id  _Nonnull objc) {
        kStrongSelf(self);
        // 播放语音结束，设置已读
        CBTalkModel *model = (CBTalkModel *)objc;
        if (![model.read isEqualToString:@"1"] && ![model.phone isEqualToString:[CBPetLoginModelTool getUser].phone]) {
            [self updateChatStatusRequest:model];
        }
    };
}
#pragma mark -- 更新聊天记录状态 标记为已读
- (void)updateChatStatusRequest:(CBTalkModel *)model {
    // 修改
    //update XX set key = ?,key = ?
    BOOL update = [[CBChatFMDBManager sharedFMDataBase] updateSingleChat:[NSString stringWithFormat:@"update t_SINGLECHAT_TABLE%d%@ set read = '1' where ids = '%@'",[CBPetLoginModelTool getUser].uid,[HomeModel CBDevice].tbWatchMain.sno?:@"",model.ids]];
    if (update) {
        NSLog(@"修改成功");
    } else {
        NSLog(@"修改失败");
    }
    [self getLocalChatRecord];
    [self.tableView reloadData];
    return;
    // 更新语音状态，只在本地处理
//    //[MBProgressHUD showHUDIcon:self.view animated:YES];
//    kWeakSelf(self);
//    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
//    [paramters setObject:@"1" forKey:@"read"];
//    [paramters setObject:model.ids?:@"" forKey:@"id"];
//    [[CBWtNetworkRequestManager sharedInstance] updateChatStatusReqeustParamters:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
//        kStrongSelf(self);
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//        //[self getChatLogDataRequest:NO];
//        // 修改
//        //update XX set key = ?,key = ?
//        BOOL update = [[CBChatFMDBManager sharedFMDataBase] updateSingleChat:[NSString stringWithFormat:@"update t_SINGLECHAT_TABLE%@ set read = '1' where ids = '%@'",[CBWtUserLoginModel CBaccount].phone,model.ids]];
//        if (update) {
//            NSLog(@"修改成功");
//        } else {
//            NSLog(@"修改失败");
//        }
//        [self getLocalChatRecord];
//        [self.tableView reloadData];
//        
//    } failure:^(NSError * _Nonnull error) {
//        kStrongSelf(self);
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }];
}
#pragma mark -- CBTalkFootViewDelegate
- (void)recordingActionResponseEvent:(UIGestureRecognizerState)gestureState {
    if (gestureState == UIGestureRecognizerStateBegan) {
        //NSLog(@"长按中开始");
        self.recordingView.hidden = NO;
        // 开始录音
        [UIView animateWithDuration:0.1 animations:^{
            self.recordingView.alpha = 0.4;
        }];
    } else if(gestureState == UIGestureRecognizerStateEnded) {
        //NSLog(@"长按结束");
        self.recordingView.hidden = YES;
        // 停止录音
        [UIView animateWithDuration:0.1 animations:^{
            self.recordingView.alpha = 0.0;
        }];
        
    } else if(gestureState == UIGestureRecognizerStateChanged) {
        //NSLog(@"长按中");
        
    } else if (gestureState == UIGestureRecognizerStateFailed) {
        //NSLog(@"失败");
        
    } else if (gestureState == UIGestureRecognizerStateCancelled) {
        //SLog(@"取消");
        
    }
}
#pragma mark - tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.arrayData.count > 0) {
        CBTalkModel *model = self.arrayData[indexPath.row];
        NSLog(@"%@ =====%@",model.name,[HomeModel CBDevice].tbWatchMain.name);
        //[model.name isEqualToString:[HomeModel CBDevice].tbWatchMain.name]
        if (!kStringIsEmpty(model.to_sno)) {
            // 自己
            CBTalkMineTableViewCell *cell;
            cell = [CBTalkMineTableViewCell cellCopyTableView:tableView];
            cell.talkModel = model;
            kWeakSelf(self);
            cell.playBlock = ^(id  _Nonnull objc) {
                kStrongSelf(self);
                CBTalkModel *modelTemp = (CBTalkModel *)objc;
                [self playVoiceAction:modelTemp];
            };
            return cell;
        } else {
            CBTalkOthersTableViewCell *cell;
            cell = [CBTalkOthersTableViewCell cellCopyTableView:tableView];
            cell.talkModel = model;
            kWeakSelf(self);
            cell.playBlock = ^(id  _Nonnull objc) {
                kStrongSelf(self);
                CBTalkModel *modelTemp = (CBTalkModel *)objc;
                [self playVoiceAction:modelTemp];
            };
            return cell;
        }
    }
    return UITableViewCell.new;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //cell.backgroundColor = [UIColor clearColor];
}
#pragma mark - tableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
#pragma mark -- 清除聊天记录
- (void)clearChatRecordClick {
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:Localized(@"清空聊天记录") message:Localized(@"确定清空记录?") preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self clearSingleChatRecord];
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alertControl animated:YES completion:nil];
}
- (void)clearSingleChatRecord {
    [CBWtMINUtils showProgressHudToView:self.view withText:Localized(@"清理完成")];
    BOOL result = [[CBChatFMDBManager sharedFMDataBase] deleteSingleChat:@""];
    if (result) {
        NSLog(@"清理完成");
        // 清空聊天记录
        [self.arrayData removeAllObjects];
        [self.tableView reloadData];
        self.noDataView.hidden = NO;
    } else {
        NSLog(@"清理失败");
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
