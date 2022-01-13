//
//  CBChartView.h
//  Telematics
//
//  Created by coban on 2019/8/6.
//  Copyright © 2019 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LYChartView;
typedef NS_ENUM(NSInteger,LYChartViewType) {
    LYChartViewTypeLine,       // 折线
    LYChartViewTypeHistogram   // 柱状
};

@interface CBChartView : UIView
/*
 * 功能:重写初始化方法
 * 参数:frame,column,type,title,unit
 * 返回:图表对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                       column:(NSInteger)column
                          row:(NSInteger)row
                         type:(LYChartViewType)type
                        title:(NSString *)title
                         unit:(NSString *)unit;
/*
 * 功能:设置是否动画
 * 参数animation:是否动画
 */
- (void)customAnimation:(BOOL)animation;
/*
 * 功能:更新下标字体大小
 * 参数font:字体大小
 */
- (void)customIndexFont:(CGFloat)font;
/*
 * 功能:更新标题字体大小
 * 参数font:字体大小
 */
- (void)customTitleFont:(CGFloat)font;
/*
 * 功能:更新填充样式
 * 参数color:返回颜色回调
 */
- (void)customColor:(UIColor *(^)(NSInteger index,LYChartViewType type))color;
/*
 * 功能:更改类型
 * 参数type:要更改的类型
 */
- (void)customType:(LYChartViewType)type;
/*
 * 功能:更新frame
 * 参数frame:更改的frame
 */
- (void)customFrame:(CGRect)frame;
/*
 * 功能:设置标题的位置
 * 参数alignment:标题的位置
 */
- (void)customTitleAlignment:(NSTextAlignment)alignment;
/*
 * 功能:设置内边距
 * 参数edgeInsets:内边距
 */
- (void)customEdgeInsets:(UIEdgeInsets)edgeInsets;
/*
 * 功能:设置下标
 * 参数data:下标数组
 */
- (void)customColumnIndexData:(NSArray *)data;
/*
 * 功能:设置数据
 * 参数data:数值数组
 */
- (void)customValueData:(NSArray *)data;
/*
 * 功能:柱状图点击事件回调
 * 参数action:柱状图点击时间回调
 */
- (void)histogramSelectAction:(void(^)(NSInteger index))action;
/*
 * 功能:设置右上角图片视图
 * 参数action:图表右上角视图
 */
- (void)customRightTopView:(void(^)(UIView *view))action;
/*
 * 功能:刷新数据(以上所有调整,要想展示在图表上,就必须调用这个刷新方法,否则不起效)
 */
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
