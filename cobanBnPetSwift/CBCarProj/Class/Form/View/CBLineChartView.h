//
//  CBLineChartView.h
//  Telematics
//
//  Created by coban on 2019/8/21.
//  Copyright © 2019 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBLineChartView : UIView


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


/** 折线x value */
@property (nonatomic,strong) NSMutableArray *valueDataArr_y;
/** 折线y value */
@property (nonatomic,strong) NSMutableArray *valueDateArr_x;
@property (nonatomic,strong) NSMutableArray *valueDataArr_y_second;
@property (nonatomic,strong) NSMutableArray *valueDateArr_x_second;
@property (nonatomic,strong) NSMutableArray *valueDataArr_y_third;
@property (nonatomic,strong) NSMutableArray *valueDateArr_x_third;


/** 第一条折线圆点颜色和折线颜色 */
@property (nonatomic,strong) UIColor *linePointColor_first;
/** 第w二条折线圆点颜色和折线颜色 */
@property (nonatomic,strong) UIColor *linePointColor_second;
/** 第三条折线圆点颜色和折线颜色 */
@property (nonatomic,strong) UIColor *linePointColor_third;

/** 画图 */
- (void)refreshLineChart;

@end

NS_ASSUME_NONNULL_END
