//
//  FormDateChooseTableViewCell.m
//  Telematics
//
//  Created by lym on 2017/11/17.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "FormDateChooseTableViewCell.h"
#import <GoogleMaps/GoogleMaps.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "cobanBnPetSwift-Swift.h"

@interface FormDateChooseTableViewCell ()<BMKGeoCodeSearchDelegate>

@end
@implementation FormDateChooseTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier: reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kBackColor;
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = kCellBackColor;
        [self addSubview: _backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).with.offset(12.5 * KFitHeightRate);
            make.right.equalTo(self).with.offset(-12.5 * KFitHeightRate);
        }];
        _leftLabel = [MINUtils createLabelWithText: @"1." size: 15 * KFitWidthRate alignment: NSTextAlignmentCenter textColor: k137Color];
        //_leftLabel.backgroundColor = [UIColor greenColor];
        [_backView addSubview: _leftLabel];
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backView);
            make.top.bottom.equalTo(_backView);
            make.width.mas_equalTo(70 * KFitWidthRate);
        }];
        _middleLabel = [MINUtils createLabelWithText:@"2017-09-21 12:23:22" size: 15 * KFitWidthRate alignment: NSTextAlignmentLeft textColor: k137Color];
        [_backView addSubview: _middleLabel];
        [_middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_leftLabel.mas_right).with.offset(35 * KFitWidthRate);
            make.top.bottom.equalTo(_backView);
            make.width.mas_equalTo(160*KFitWidthRate);
            //make.width.mas_equalTo(width);
        }];
        
        UIImage *rightImage = [UIImage imageNamed:@"右边"];
        UIImageView *rightBtnImageView  = [[UIImageView alloc] initWithImage: rightImage];
        [_backView addSubview: rightBtnImageView];
        [rightBtnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backView);
            make.right.equalTo(_backView).with.offset(-10 * KFitWidthRate);
            make.height.mas_equalTo(rightImage.size.height * KFitHeightRate);
            make.width.mas_equalTo(rightImage.size.width * KFitHeightRate);
        }];
        
        _rightLabel = [MINUtils createLabelWithText: @"168" size: 15 * KFitWidthRate alignment: NSTextAlignmentCenter textColor: k137Color];
        _rightLabel.numberOfLines = 0;
        _rightLabel.textAlignment = NSTextAlignmentRight;
        [_backView addSubview: _rightLabel];
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_middleLabel.mas_right).with.offset(10 * KFitWidthRate);
            make.right.mas_equalTo(rightBtnImageView.mas_left).offset(-5);
            make.top.bottom.equalTo(_backView);
        }];
    }
    return self;
}

- (void)addBottomLineView
{
    UIView *lineView = [MINUtils createLineView];
    [_backView addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_backView).with.offset(-0.5);
        make.height.mas_equalTo(0.5);
        make.left.equalTo(_backView).with.offset(12.5 * KFitWidthRate);
        make.right.equalTo(_backView).with.offset(-12.5 * KFitWidthRate);
    }];
}
- (void)setFormModel:(FormInfoModel *)formModel {
    _formModel = formModel;
    if (formModel) {
        self.leftLabel.text = [NSString stringWithFormat: @"%@.",formModel.ids?:@"0"];
        if ([AppDelegate shareInstance].IsShowGoogleMap == YES) {
            // 谷歌地图反向地理编码
            GMSGeocoder *geocoder = [[GMSGeocoder alloc]init];
            [geocoder reverseGeocodeCoordinate:CLLocationCoordinate2DMake(formModel.lat.doubleValue,formModel.lng.doubleValue) completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
                if (response.results.count > 0) {
                    GMSAddress *address = response.results[0];
                    NSString *addressStr = [NSString stringWithFormat:@"%@%@%@%@%@",address.country,address.administrativeArea,address.locality,address.subLocality,address.thoroughfare];
                    NSLog(@"位置::::%@",addressStr);
                    self.formModel.address = addressStr;
                }
            }];
        } else {
            // 谷歌反向地理编码的不准确,故用百度地图解析
            CLLocationCoordinate2D realCoor = CLLocationCoordinate2DMake(formModel.lat.doubleValue, formModel.lng.doubleValue);
            BMKReverseGeoCodeSearchOption *reverseGeoCodeOpetion = [[BMKReverseGeoCodeSearchOption alloc]init];
            reverseGeoCodeOpetion.location = realCoor;//coorData;
            BMKGeoCodeSearch *searcher = [[BMKGeoCodeSearch alloc] init];
            searcher.delegate = self;
            BOOL flag = [searcher reverseGeoCode: reverseGeoCodeOpetion];
            if(flag) {
                NSLog(@"反geo检索发送成功");
            }else {
                NSLog(@"反geo检索发送失败");
            }
        }
        switch (formModel.formType) {
            case FormTypeIdling:
            {
                //怠速报表
                self.middleLabel.text = formModel.startTime?:@"";
                self.rightLabel.text = [self getTimeStr:formModel.time];
            }
                break;
            case FormTypeStay:
                //停留统计
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"shanghai"]];
                NSInteger startTimeInterval = [CBCommonTools timeStrConvertTimeInteral:formModel.startTime formatter:formatter].integerValue;
                
                NSString *startTimeStr = [Utils convertTimeWithTimeIntervalString:[NSString stringWithFormat:@"%@",@(startTimeInterval*1000)] timeZoneObj:NSTimeZone.localTimeZone];
                self.middleLabel.text = startTimeStr?:@"";
                
                self.rightLabel.text = [self getTimeStr:formModel.time];
            }
                break;
            case FormTypeFire:
                //点火报表
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"shanghai"]];
                NSInteger startTimeInterval = [CBCommonTools timeStrConvertTimeInteral:formModel.startTime formatter:formatter].integerValue;
                NSString *startTimeStr = [Utils convertTimeWithTimeIntervalString:[NSString stringWithFormat:@"%@",@(startTimeInterval*1000)] timeZoneObj:NSTimeZone.localTimeZone];
                self.middleLabel.text = startTimeStr?:@"";
                if (formModel.status == 0) {
                    self.rightLabel.text = Localized(@"关");
                } else {
                    self.rightLabel.text = Localized(@"开");
                }
            }
                break;
            case FormTypePourOil:
                //加油报表
            {
                NSString *startTimeStr = [Utils convertTimeWithTimeIntervalString:formModel.createTime?:@"0" timeZoneObj:NSTimeZone.localTimeZone];
                self.middleLabel.text = startTimeStr;
                self.rightLabel.text = [NSString stringWithFormat:@"%@",formModel.oilCount];
            }
                break;
            case FormTypeOilLeak:
                //漏油报表
            {
                NSString *startTimeStr = [Utils convertTimeWithTimeIntervalString:formModel.createTime?:@"0" timeZoneObj:NSTimeZone.localTimeZone];
                self.middleLabel.text = startTimeStr;
                self.rightLabel.text = [NSString stringWithFormat:@"%@",formModel.oilCount];
            }
                break;
            case FormTypeAllAlarm:
                //所有报警
                {
                    NSString *startTimeStr = [Utils convertTimeWithTimeIntervalString:formModel.createTime?:@"0" timeZoneObj:NSTimeZone.localTimeZone];
                    self.middleLabel.text = startTimeStr?:@"";
                    NSArray *arrayType = [formModel.type componentsSeparatedByString:@","];
                    NSMutableArray *arrayTypeStr = [NSMutableArray array];
                    for (NSString *str in arrayType) {
                        if (!kStringIsEmpty(str)) {
                            [arrayTypeStr addObject:[self convertWarmType:str]];
                        }
                    }
                    self.rightLabel.text = [NSString stringWithFormat:@"%@",[arrayTypeStr componentsJoinedByString:@","]];
                }
                break;
            case FormTypeSOSAlarm:
                //SOS报警
            {
                NSString *startTimeStr = [Utils convertTimeWithTimeIntervalString:formModel.createTime?:@"0" timeZoneObj:NSTimeZone.localTimeZone];
                self.middleLabel.text = startTimeStr;
                self.rightLabel.text = [NSString stringWithFormat:@"SOS"];
            }
                break;
            case FormTypeOverspeedAlarm:
                //超速报警
            {
                NSString *startTimeStr = [Utils convertTimeWithTimeIntervalString:formModel.createTime?:@"0" timeZoneObj:NSTimeZone.localTimeZone];
                self.middleLabel.text = startTimeStr;
                self.rightLabel.text = [NSString stringWithFormat:@"%@", formModel.speed];
            }
                break;
            case FormTypeTiredAlarm:
                //疲劳驾驶统计
            {
                NSString *startTimeStr = [Utils convertTimeWithTimeIntervalString:formModel.createTime?:@"0" timeZoneObj:NSTimeZone.localTimeZone];
                self.middleLabel.text = startTimeStr;
                self.rightLabel.text = [NSString stringWithFormat:@"%@", formModel.speed];
            }
                break;
            case FormTypeUnderpackingAlarm:
                //欠压统计
            {
                NSString *startTimeStr = [Utils convertTimeWithTimeIntervalString:formModel.createTime?:@"0" timeZoneObj:NSTimeZone.localTimeZone];
                self.middleLabel.text = startTimeStr;
                self.rightLabel.text = [NSString stringWithFormat:@"%@%@",formModel.battery,@"%"];
            }
                break;
            case FormTypePowerDownAlarm:
                //掉电报警统计报表
            {
                NSString *startTimeStr = [Utils convertTimeWithTimeIntervalString:formModel.createTime?:@"0" timeZoneObj:NSTimeZone.localTimeZone];
                self.middleLabel.text = startTimeStr;
                self.rightLabel.text = [NSString stringWithFormat:@"%@",Localized(@"掉电")];
            }
                break;
            case FormTypeShakeAlarm:
                //振动报警统计报表
            {
                NSString *startTimeStr = [Utils convertTimeWithTimeIntervalString:formModel.createTime?:@"0" timeZoneObj:NSTimeZone.localTimeZone];
                self.middleLabel.text = startTimeStr;
                self.rightLabel.text = [NSString stringWithFormat:@"%@",Localized(@"振动")];
            }
                break;
            case FormTypeOpenDoorAlarm:
                //开门报警统计报表
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"shanghai"]];
                NSInteger startTimeInterval = [CBCommonTools timeStrConvertTimeInteral:formModel.startTime formatter:formatter].integerValue;
                
                NSString *startTimeStr = [Utils convertTimeWithTimeIntervalString:[NSString stringWithFormat:@"%@",@(startTimeInterval*1000)] timeZoneObj:NSTimeZone.localTimeZone];
                self.middleLabel.text = startTimeStr?:@"";
                if (formModel.status == 0) {
                    self.rightLabel.text = Localized(@"开门");
                } else {
                    self.rightLabel.text = Localized(@"行驶");
                }
            }
                break;
            case FormTypeFireAlarm:
                //点火报警统计报表
            {
                NSString *startTimeStr = [Utils convertTimeWithTimeIntervalString:formModel.createTime?:@"0" timeZoneObj:NSTimeZone.localTimeZone];
                self.middleLabel.text = startTimeStr;
                self.rightLabel.text = [NSString stringWithFormat:@"%@",Localized(@"点火")];
            }
                break;
            case FormTypeMoveAlarm:
                //位移报警统计报表
            {
                NSString *startTimeStr = [Utils convertTimeWithTimeIntervalString:formModel.createTime?:@"0" timeZoneObj:NSTimeZone.localTimeZone];
                self.middleLabel.text = startTimeStr;
                self.rightLabel.text = [NSString stringWithFormat:@"%@",Localized(@"位移")];
            }
                break;
            case FormTypeGasolineTheftAlarm:
                //偷油漏油报警统计报表
            {
                NSString *startTimeStr = [Utils convertTimeWithTimeIntervalString:formModel.createTime?:@"0" timeZoneObj:NSTimeZone.localTimeZone];
                self.middleLabel.text = startTimeStr;
                self.rightLabel.text = [NSString stringWithFormat: @"%@",formModel.oil];
            }
                break;
            case FormTypeCollisionAlarm:
                //碰撞报警报表
            {
                NSString *startTimeStr = [Utils convertTimeWithTimeIntervalString:formModel.createTime?:@"0" timeZoneObj:NSTimeZone.localTimeZone];
                self.middleLabel.text = startTimeStr;
                self.rightLabel.text = [NSString stringWithFormat:@"%@", formModel.speed];
            }
                break;
            case FormTypeOBD:
                //OBD报表
            {
                NSString *startTimeStr = [Utils convertTimeWithTimeIntervalString:formModel.createTime?:@"0" timeZoneObj:NSTimeZone.localTimeZone];
                self.middleLabel.text = startTimeStr;
                self.rightLabel.text = [NSString stringWithFormat: @"%@",formModel.errCode];
            }
                break;
            case FormTypeInFencing:
                //入围栏报警报表
            {
                NSString *startTimeStr = [Utils convertTimeWithTimeIntervalString:formModel.createTime?:@"0" timeZoneObj:NSTimeZone.localTimeZone];
                self.middleLabel.text = startTimeStr;
                self.rightLabel.text = [NSString stringWithFormat: @"%@",formModel.fName?:@""];
            }
                break;
            case FormTypeOutFencing:
                //出围栏报警报表
            {
                NSString *startTimeStr = [Utils convertTimeWithTimeIntervalString:formModel.createTime?:@"0" timeZoneObj:NSTimeZone.localTimeZone];
                self.middleLabel.text = startTimeStr;
                self.rightLabel.text = [NSString stringWithFormat: @"%@",formModel.fName?:@""];
            }
                break;
            case FormTypeInOutFencing:
                //出入围栏报警报表
            {
                NSString *startTimeStr = [Utils convertTimeWithTimeIntervalString:formModel.createTime?:@"0" timeZoneObj:NSTimeZone.localTimeZone];
                self.middleLabel.text = startTimeStr;
                self.rightLabel.text = [NSString stringWithFormat: @"%@",formModel.fName?:@""];
            }
                break;
            default:
                self.middleLabel.text = @"";
                self.rightLabel.text = @"";
                break;
        }
    }
}
- (NSString *)getTimeStr:(NSString *)time {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSInteger startTimeInterval = [CBCommonTools timeStrConvertTimeInteral:self.formModel.startTime formatter:formatter].integerValue;
    NSInteger endTimeInterval = [CBCommonTools timeStrConvertTimeInteral:self.formModel.endTime formatter:formatter].integerValue;
    NSArray *timeArray = [CBCommonTools getDetailTimeWithTimestamp:(endTimeInterval - startTimeInterval)];
    
    NSNumber *dayStr = timeArray[0];
    NSNumber *hourStr = timeArray[1];
    NSNumber *minuteStr = timeArray[2];
    NSNumber *secondStr = timeArray[3];
    
    NSString *timeStr = @"";
    timeStr = [NSString stringWithFormat:@"%@ %@ %@ %@",dayStr.integerValue == 0?@"":[NSString stringWithFormat:@"%@%@",dayStr,Localized(@"天")],hourStr.integerValue == 0?@"":[NSString stringWithFormat:@"%@%@",hourStr,Localized(@"时")],minuteStr.integerValue == 0?@"":[NSString stringWithFormat:@"%@%@",minuteStr,Localized(@"分")],secondStr.integerValue == 0?@"":[NSString stringWithFormat:@"%@%@",secondStr,Localized(@"秒")]];
    return timeStr;
}
- (NSString *)convertWarmType:(NSString *)str {
    switch (str.integerValue) {
        case 0:
            return Localized(@"sos");
            break;
        case 1:
            return Localized(@"超速");
            break;
        case 2:
            return Localized(@"疲劳");
            break;
        case 3:
            return [NSString stringWithFormat:@"%@%@",self.formModel.battery,@"%"];//Localized(@"欠压");
            break;
        case 7:
            return Localized(@"低电");
            break;
        case 8:
            return Localized(@"掉电");
            break;
        case 12:
            return Localized(@"振动");
            break;
        case 15:
            return Localized(@"位移");
            break;
        case 16:
            return Localized(@"点火");
            break;
        case 17:
            return Localized(@"开门");
            break;
        case 20:
            return Localized(@"进出区域");
            break;
        case 25:
            return Localized(@"偷油漏油");
            break;
        case 27:
            return Localized(@"碰撞");
            break;
        case 32:
            return Localized(@"出围栏");
            break;
        case 33:
            return Localized(@"进围栏");
        default:
            return Localized(@"未知");
            break;
    }
}
#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        self.formModel.address = result.address;
    } else {
        NSLog(@"未找到结果");
        self.formModel.address = @"";
    }
}
@end
