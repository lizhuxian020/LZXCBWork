//
//  _CBMsgCenterModel.h
//  cobanBnPetSwift
//
//  Created by zzer on 2023/1/16.
//  Copyright © 2023 coban. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface _CBMsgCenterModel : NSObject

//"fenceName": null,
//        "lng": 113.908899,
//        "warnTime": 1673514589294,
//        "vehicleIsRead": 0,
//        "name": "426999999999999",
//        "timeZone": null,
//        "imei": "863584040008426",
//        "id": "863584040008426:1673514589294:2",
//        "fenceId": null,
//        "lat": 22.551377,
//        "speed": null,
//        "vehicleStatus": "31"
@property(nonatomic, copy) NSString *iid;
@property (nonatomic, copy) NSString *name ;
@property (nonatomic, copy) NSString *warnTime ;
@property (nonatomic, copy) NSString *vehicleStatus ;
@property (nonatomic, copy) NSString *timeZone ; /** <##> **/
@property (nonatomic, copy) NSString *image_paths; //通知消息：vehicleStatus:：35的时候  显示图

- (NSString *)descVehicleStatus;

+ (NSString *)type:(NSString *)type;
@end

NS_ASSUME_NONNULL_END
