//
//  CBTerminalSwitchModel.h
//  cobanBnPetSwift
//
//  Created by zzer on 2023/1/16.
//  Copyright © 2023 coban. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBTerminalSwitchModel : NSObject

@property (nonatomic, assign) BOOL horn_switch ; /** //设置喇叭开关： 1:打开 , 0:关闭 **/
@property (nonatomic, assign) BOOL pz_switch ; /** //碰撞开关 0:关,1:开， **/
@property (nonatomic, copy) NSString *pz_speed ; /** <##> **/
@property (nonatomic, copy) NSString *pz_time ; /** <##> **/

@property (nonatomic, assign) BOOL jzw_switch ; /** <##> **/
@property (nonatomic, copy) NSString *jzw_angle ; /** <##> **/
@property (nonatomic, copy) NSString *jzw_speed ; /** BOO **/

@property (nonatomic, assign) BOOL jjs_switch ; /** <##> **/
@property (nonatomic, copy) NSString *jjs_time ; /** <##> **/
@property (nonatomic, copy) NSString *jjs_speed ; /** <##> **/

@property (nonatomic, assign) BOOL jsc_switch ; /** <##> **/
@property (nonatomic, copy) NSString *jsc_speed ; /** <##> **/
@property (nonatomic, copy) NSString *jsc_time ; /** <##> **/
//"pz_switch" ：1,//碰撞开关 0:关,1:开，
//"pz_speed":10,//碰撞加速度（g）
//"pz_time":50,//碰撞时长（ms）
//"horn_switch"：1,//设置喇叭开关： 1:打开 , 0:关闭
//"jzw_switch"：1,//急转弯警告：1打开 0：关闭
//"jzw_speed"：90,//急转弯时速：（单位km/h）
//"jzw_angle"：30,//急转弯角度：（单位度）
//"jjs_switch":1,//急加速警告：1打开 0：关闭
//"jjs_time":5,//急加速时长：（单位秒）
//"jjs_speed"100：,//急加速,增速变化量： （单位km/h）
//"jsc_switch":1,//刹车警告：1打开 0：关闭
//"jsc_time"：5,//急减速时长：（单位秒)
//"jsc_speed"50：,//降速变化量： （单位km/h）
@end

NS_ASSUME_NONNULL_END
