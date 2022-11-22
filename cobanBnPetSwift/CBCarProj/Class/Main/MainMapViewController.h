//
//  MainMapViewController.h
//  Telematics
//
//  Created by lym on 2017/12/6.
//  Copyright © 2017年 lym. All rights reserved.
//
//- (void)fff {
//    NSURL *url = [NSURL URLWithString: [NSString stringWithUTF8String: "http://139.196.21.59:9199"]];
//    kWeakSelf(self);
//    if (self.client == nil) {
//        self.client = [[SocketIOClient alloc] initWithSocketURL: url config: @{@"log": @YES, @"forcePolling": @YES}];
//        [self.client on: @"connect" callback:^(NSArray * _Nonnull arr, SocketAckEmitter * _Nonnull ack) {
//            kStrongSelf(self);
//            [self.client emit: @"auth" with: @[@{@"uid":[NSNumber numberWithInt:[UserLoginModelManager shareManager].userInfoModel.uid ],@"token": @"",@"imei": @""}]];
//        }];;
//        [self.client on: @"gps" callback:^(NSArray * arr, SocketAckEmitter * ack) {
//            NSLog( @"%@", arr);
//            if (arr.count > 0) {
//                //[weakSelf traceDeviceWithModel: model dicData: arr[0]];
//            }
//        }];
//        [self.client on: @"auth_result" callback:^(NSArray * arr, SocketAckEmitter * ack) {
//            NSLog( @"%@", arr);
//        }];
//        [self.client connect];
//    } else {
//        [self.client disconnect];
//        self.client = nil;
//        self.client = [[SocketIOClient alloc] initWithSocketURL: url config: @{@"log": @YES, @"forcePolling": @YES}];
//        [self.client on: @"connect" callback:^(NSArray * _Nonnull arr, SocketAckEmitter * _Nonnull ack) {
//            kStrongSelf(self);
//            [self.client emit: @"auth" with: @[@{@"uid":[NSNumber numberWithInt:[UserLoginModelManager shareManager].userInfoModel.uid ],@"token": @"",@"imei": @""}]];
//        }];;
//        [self.client on: @"gps" callback:^(NSArray * arr, SocketAckEmitter * ack) {
//            NSLog( @"%@", arr);
//            if (arr.count > 0) {
//                //                weakSelf.lastTraceLaction = CLLocationCoordinate2DMake(model.lat, model.lng);
//                //                [weakSelf traceDeviceWithModel: model dicData: arr[0]];
//            }
//        }];
//        [self.client on: @"auth_result" callback:^(NSArray * arr, SocketAckEmitter * ack) {
//            NSLog( @"%@", arr);
//        }];
//        [self.client connect];
//    }
//}

#import "MINBaseViewController.h"

@interface MainMapViewController : MINBaseViewController

/** 选中的设备  */
@property (nonatomic, strong) CBHomeLeftMenuDeviceInfoModel *deviceInfoModelSelect;

@end
