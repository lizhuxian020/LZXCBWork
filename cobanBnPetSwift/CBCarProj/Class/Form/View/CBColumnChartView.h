//
//  CBColumnChartView.h
//  Telematics
//
//  Created by coban on 2019/8/22.
//  Copyright © 2019 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBColumnChartView : UIView

/** 是否双向坐标 */
@property (nonatomic,assign) BOOL isDouble;

/** 左侧y轴最大值 */
@property (nonatomic,strong) NSString *maxData_left;
/** 右侧y轴最大值 */
@property (nonatomic,strong) NSString *maxData_right;

/** 左侧y轴分段值 */
@property (nonatomic,strong) NSMutableArray *dateArr_y;
/** 右侧y轴分段值 */
@property (nonatomic,strong) NSMutableArray *dateArr_y_right;
/** x轴分段值 */
@property (nonatomic,strong) NSMutableArray *dateArr_x;

/** 里程值 */
@property (nonatomic,assign) CGFloat value_mileage;
/** 油耗 */
@property (nonatomic,assign) CGFloat value_oil;
/** 里程值 */
@property (nonatomic,copy) NSString *value_mileage_str;
/** 油耗 */
@property (nonatomic,copy) NSString *value_oil_str;


/** 第一个条形图颜色 */
@property (nonatomic,strong) UIColor *columnChartColor_first;
/** 第二个条形图颜色 */
@property (nonatomic,strong) UIColor *columnChartColor_second;


/** 画图 */
- (void)refreshColumnChart;


@end

NS_ASSUME_NONNULL_END
