//
//  CBHomeTalkViewController.m
//  Watch
//
//  Created by coban on 2019/8/16.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBHomeTalkViewController.h"
#import "CBHomeTalkTableView.h"
#import "CBTalkFootView.h"
#import "HomeModel.h"
#import "CBTalkMineTableViewCell.h"
#import "CBTalkOthersTableViewCell.h"
#import "CBVoicePopView.h"
#import "CBTalkModel.h"
#import "CBTalkPlayVoiceManager.h"
#import "CBTalkMemberViewController.h"
#import "CBChatFMDBManager.h"
/* oc 调用 swift*/
#import "cobanBnPetSwift-Swift.h"

@interface CBHomeTalkViewController ()<UITableViewDelegate,UITableViewDataSource,CBTalkFootViewDelegate>

@property (nonatomic,strong) CBHomeTalkTableView *talkTableView;
@property (nonatomic,strong) CBTalkFootView *footView;
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,strong) CBVoicePopView *recordingView;
@property (nonatomic,copy) NSString *qnyToken;
@end
@implementation CBHomeTalkViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建获取语聊数据库
    [[CBChatFMDBManager sharedFMDataBase] createTabGruopChat];
    
    [self setupView];
    [self getQNYFileTokenReqeust];
    [self getChatLogDataRequest:NO];
    
    kPlayTalkVoiceManager.isEnd = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGroupData) name:KCBWtGroupChatNotification object:nil];
    
    [CBWtCommonTools checkMicrophonePermission];
}
#pragma mark -- 收到推送刷新聊天列表
- (void)updateGroupData {
    [self.arrayData removeAllObjects];
    [self getChatLogDataRequest:YES];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KCBWtGroupChatNotification object:nil];
}
- (void)setupView {
    self.view.backgroundColor = UIColor.whiteColor;//KWtBackColor;
    [self initBarWithTitle:Localized(@"家庭群聊") isBack: YES];
    [self initBarRightImageName:@"chat_mem" target:self action:@selector(chatMemberClick)];
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
//获取本地聊天全部数据
- (void)getLocalChatRecord {
    NSArray *arr = [[CBChatFMDBManager sharedFMDataBase] queryGroupChat:@""];
    [self.arrayData removeAllObjects];
    [self.arrayData addObjectsFromArray:arr];
}
#pragma mark -- 群聊成员
- (void)chatMemberClick {
    CBTalkMemberViewController *vc = [[CBTalkMemberViewController alloc]init];
    kWeakSelf(self);
    vc.clearBlock = ^{
        kStrongSelf(self);
        // 清空聊天记录
        [self.arrayData removeAllObjects];
        [self.tableView reloadData];
        self.noDataView.hidden = NO;
    };
    [self.navigationController pushViewController:vc animated:YES];
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
        //[MBProgressHUD showMessage:@"请求超时" withDelay:3.0f];
    }];
}
#pragma mark -- 获取家庭群聊聊天记录
- (void)getChatLogDataRequest:(BOOL)isPull {
    [self getLocalChatRecord];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:[HomeModel CBDevice].tbWatchMain.sno?:@"" forKey:@"sno"];
    if (!isPull) {
        [MBProgressHUD showHUDIcon:self.view animated:YES];
    }
    kWeakSelf(self);
    [[CBWtNetworkRequestManager sharedInstance] getChatLogListParamters:paramters success:^(CBWtBaseNetworkModel * _Nonnull baseModel) {
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_footer endRefreshing];
        NSArray *array = baseModel.data;
        NSLog(@"+++++聊天记录++++++++:%@",array);
        if (array.count > 0) {
            for (NSDictionary *dic in array) {
                CBTalkModel *model = [CBTalkModel mj_objectWithKeyValues:dic];
                model.isPlay = YES;
                // 查询本地，若本地有则不添加
                NSArray *arr = [[CBChatFMDBManager sharedFMDataBase]queryGroupChat:[NSString stringWithFormat:@"select * from t_GROUPCHAT_TABLE%@%@ WHERE ids = '%@'",[CBPetLoginModelTool getUser].uid,[HomeModel CBDevice].tbWatchMain.sno?:@"",model.ids]];
                if (arr.count <= 0) {
                    [self.arrayData addObject:model];
                    //数据插入
                    BOOL isInsert = [[CBChatFMDBManager sharedFMDataBase] addGroupChat:model];
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
    [paramters setObject:@"0" forKey:@"chatType"];
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
        //if ([model.phone isEqualToString:[CBWtUserLoginModel CBaccount].phone])
        if (![model.read isEqualToString:@"1"] && ![model.phone isEqualToString:[CBPetLoginModelTool getUser].phone]) {
            
            [self updateChatStatusRequest:model];
        }
    };
}
#pragma mark -- 更新聊天记录状态 标记为已读
- (void)updateChatStatusRequest:(CBTalkModel *)model {

    // 修改
    //update XX set key = ?,key = ?
    BOOL update = [[CBChatFMDBManager sharedFMDataBase] updateGroupChat:[NSString stringWithFormat:@"update t_GROUPCHAT_TABLE%@%@ set read = '1' where ids = '%@'",[CBPetLoginModelTool getUser].uid,[HomeModel CBDevice].tbWatchMain.sno?:@"",model.ids]];
    if (update) {
        NSLog(@"修改成功");
    } else {
        NSLog(@"修改失败");
    }
    [self getLocalChatRecord];
    [self.tableView reloadData];
    // 更新语音状态，只在本地处理
    return;
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
//        BOOL update = [[CBChatFMDBManager sharedFMDataBase] updateGroupChat:[NSString stringWithFormat:@"update t_GROUPCHAT_TABLE%@ set read = '1' where ids = '%@'",[CBWtUserLoginModel CBaccount].phone,model.ids]];
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
        if ([model.phone isEqualToString:[CBPetLoginModelTool getUser].phone]) {
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
@end
