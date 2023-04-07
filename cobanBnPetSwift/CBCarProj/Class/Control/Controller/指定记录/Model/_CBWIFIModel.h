//
//  _CBWIFIModel.h
//  cobanBnPetSwift
//
//  Created by zzer on 2023/4/3.
//  Copyright © 2023 coban. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface _CBWIFIModel_WIFI : NSObject

@property (nonatomic, copy) NSString *wifiSwitch ; /** <##> **/
@property (nonatomic, copy) NSString *wifiName ; /** <##> **/
@property (nonatomic, copy) NSString *wifiPassword ; /** <##> **/

@end

@interface _CBWIFIModel_ROW : NSObject

@property (nonatomic, copy) NSString *channelId ; /** <##> **/
@property (nonatomic, copy) NSString *channelName ; /** <##> **/
@property (nonatomic, copy) NSString *createTime ; /** <##><##> **/
@property (nonatomic, copy) NSString *dno ; /** <##> **/
@property (nonatomic, copy) NSString *idd ; /** <##> **/

@end

@interface _CBWIFIModel : NSObject

@property (nonatomic, strong) _CBWIFIModel_WIFI *wifi;
@property (nonatomic, strong) NSArray<_CBWIFIModel_ROW *> *row;

@end

/*
 {
     "chart": null,
     "data": {
         "wifi": {
             "wifiSwitch": 1,
             "wifiName": "dddw",
             "wifiPassword": "a123456"
         },
         "row": [{
             "channelId": 3,
             "channelName": "客厅摄像2",
             "createTime": null,
             "dno": "863584040008426",
             "id": 3
         }, {
             "channelId": 4,
             "channelName": "客厅1",
             "createTime": null,
             "dno": "863584040008426",
             "id": 5
         }, {
             "channelId": 5,
             "channelName": "客厅2",
             "createTime": null,
             "dno": "863584040008426",
             "id": 6
         }]
     },
     "length": null,
     "page": null,
     "resmsg": "success",
     "status": 0,
     "tips": null,
     "totalrow": 1
 }
 */

NS_ASSUME_NONNULL_END
