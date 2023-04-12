//
//  _CBCarAlertMsgModel.h
//  cobanBnPetSwift
//
//  Created by lee on 2022/11/25.
//  Copyright © 2022 coban. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface _CBCarAlertMsgModel : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *warnTime;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *iid;
@property (nonatomic, copy) NSString *timeZone ; /** <##> **/
@property (nonatomic, copy) NSString *imei ; /** <##> **/
@property (nonatomic, copy) NSString *image_paths ; /** <##> **/
//        "fenceName": null,
//        "lng": 113.90869863430072,
//        "warnTime": 1669253686000,
//        "name": "403A",
//        "isRead": 0,
//        "timeZone": "8.0",
//        "imei": "863584040008426",
//        "id": "1595591725143363589",
//        "type": "12",
//        "fenceId": null,
//        "lat": 22.551350599641665,
//        "speed": 0.9
//    },

@end

NS_ASSUME_NONNULL_END
