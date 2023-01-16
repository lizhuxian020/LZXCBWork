//
//  CBJiaShiXingWeiCell.m
//  cobanBnPetSwift
//
//  Created by zzer on 2023/1/16.
//  Copyright © 2023 coban. All rights reserved.
//

#import "CBJiaShiXingWeiCell.h"
#import <GoogleMaps/GoogleMaps.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "cobanBnPetSwift-Swift.h"

@implementation CBJiaShiXingWeiCell

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
            make.width.mas_equalTo(30 * KFitWidthRate);
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
            make.right.equalTo(_backView).with.offset(-5 * KFitWidthRate);
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

- (void)setModel:(CBJiaShiXingWeiModel *)model {
    _model = model;
    
    self.leftLabel.text = [NSString stringWithFormat: @"%@.",model.ids?:@"0"];
    
    if ([AppDelegate shareInstance].IsShowGoogleMap == YES) {
        // 谷歌地图反向地理编码
        GMSGeocoder *geocoder = [[GMSGeocoder alloc]init];
        [geocoder reverseGeocodeCoordinate:CLLocationCoordinate2DMake(model.lat.doubleValue,model.lng.doubleValue) completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
            if (response.results.count > 0) {
                GMSAddress *address = response.results[0];
                NSString *addressStr = [NSString stringWithFormat:@"%@%@%@%@%@",address.country,address.administrativeArea,address.locality,address.subLocality,address.thoroughfare];
                NSLog(@"位置::::%@",addressStr);
                self.model.address = addressStr;
            }
        }];
    } else {
        // 谷歌反向地理编码的不准确,故用百度地图解析
        CLLocationCoordinate2D realCoor = CLLocationCoordinate2DMake(model.lat.doubleValue, model.lng.doubleValue);
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
    
    self.middleLabel.text = [Utils convertTimeWithTimeIntervalString:model.ts timeZone:@""];
    self.rightLabel.text = [model descVehicleStatus];
}

#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        self.model.address = result.address;
    } else {
        NSLog(@"未找到结果");
        self.model.address = @"";
    }
}

@end
