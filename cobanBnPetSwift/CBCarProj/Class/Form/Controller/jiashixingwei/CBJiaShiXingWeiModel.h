//
//  CBJiaShiXingWeiModel.h
//  cobanBnPetSwift
//
//  Created by zzer on 2023/1/16.
//  Copyright © 2023 coban. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBJiaShiXingWeiModel : NSObject

//"direct": "201.57",//方向
//"lat": 22.551377777,//纬度
//"lng": 113.908899346,//经度
//"speed": 60,//速度
//"ts": 1673316586294,//时间
//"vehicle_status": "19,20"//驾驶行为类型
@property (nonatomic, copy) NSString *ids; //
@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *direct ; /** <##> **/
@property (nonatomic, copy) NSString *lat ; /** <##> **/
@property (nonatomic, copy) NSString *lng ; /** <##> **/
@property (nonatomic, copy) NSString *speed ; /** <##> **/
@property (nonatomic, copy) NSString *ts ; /** <##> **/
@property (nonatomic, copy) NSString *vehicle_status ; /** <##> **/

- (NSString *)descVehicleStatus;
@end

NS_ASSUME_NONNULL_END
