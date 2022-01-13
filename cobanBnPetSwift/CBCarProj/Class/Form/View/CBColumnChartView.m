//
//  CBColumnChartView.m
//  Telematics
//
//  Created by coban on 2019/8/22.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBColumnChartView.h"

@interface CBColumnChartView ()
{
    CALayer *_columnChartLayer_first;// 折线图层第一
    CALayer *_columnChartLayer_second;// 折线图层第二
    CAShapeLayer *_verticalLineLayer;// 网格竖线图层
    CAShapeLayer *_horizonLineLayer;// 网格横线图层
}
/** 绘制 (横线竖线) 左侧起点 */
@property (nonatomic,assign) CGFloat startPoint_x_left;
/** 绘制 (横线竖线) 右侧终点 */
@property (nonatomic,assign) CGFloat endPoint_x_right;
/** 溢出高度 */
@property (nonatomic,assign) CGFloat outHeight;
@end
@implementation CBColumnChartView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
- (void)refreshColumnChart {
    
    // 左侧起点 距离左侧屏幕
    CGFloat width = [NSString getWidthWithText:self.maxData_left font:[UIFont systemFontOfSize:10] height:16];
    width = width < 35?(35 + 10):(width + 10);
    self.startPoint_x_left = width;
    
    // 右侧终点 距离右侧屏幕
    CGFloat width_right = [NSString getWidthWithText:self.maxData_right font:[UIFont systemFontOfSize:10] height:16];
    width_right = width_right < 15?15:(width + 10);
    self.endPoint_x_right = width_right;
    
    // 溢出高度
    //CGFloat space = (self.frame.size.height - 30)/(_dateArr_y.count - 1);//横线之间的间距
    self.outHeight = 0;//space/2;
    
    //移除竖线layer
    [_verticalLineLayer removeFromSuperlayer];
    //移除横线layer
    [_horizonLineLayer removeFromSuperlayer];
    //移除柱状图layer
    [_columnChartLayer_first removeFromSuperlayer];
    [_columnChartLayer_second removeFromSuperlayer];
    //移除lab
    for (UILabel *lab in self.subviews) {
        [lab removeFromSuperview];
    }
    
    CGFloat height = self.frame.size.height - 30;//表格的总高度
    [self drawVerticalLine:height];
    
    [self drawHorizontalOfTemperature:height];
    
    [self drawColmnChartView_first];
    
    if (self.isDouble) {
        [self drawColmnChartView_second];
    }
}
//绘制竖线
#pragma mark -- 绘制竖线
- (void)drawVerticalLine:(CGFloat)height{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat width = (self.bounds.size.width-self.startPoint_x_left-self.endPoint_x_right)/(5 - 1);
    CGFloat start_y = 8;
    for (int i = 0; i < 5; i ++) {
        [path moveToPoint:CGPointMake(self.startPoint_x_left + width*i, start_y)];
        [path addLineToPoint:CGPointMake(self.startPoint_x_left + width*i, height+start_y + self.outHeight)];
    }
    
    _verticalLineLayer = [[CAShapeLayer alloc] init];
    _verticalLineLayer.path = path.CGPath;
    _verticalLineLayer.strokeColor = [UIColor blackColor].CGColor;
    _verticalLineLayer.lineWidth = 0.5;
    [self.layer addSublayer:_verticalLineLayer];
    
    start_y = start_y + height + 3;
    
    for (int i = 0; i < 5; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.startPoint_x_left + width*i - 30/2, start_y, 30, 16)];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = 1;
        label.backgroundColor = [UIColor clearColor];
        label.text = _dateArr_x[i];
        label.textColor = [UIColor blackColor];
        [self addSubview:label];
    }
}

//绘制室温的横线
#pragma mark -- 绘制e横线
- (void)drawHorizontalOfTemperature:(CGFloat)height{
    
    CGFloat space = height/(_dateArr_y.count - 1);//横线之间的间距
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i < _dateArr_y.count; i ++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, height - space*i + self.outHeight, self.startPoint_x_left, 16)];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.text = _dateArr_y[i];//[NSString stringWithFormat:@"%d",temperature-10*i];
        label.textColor = [UIColor lightGrayColor];
        [self addSubview:label];
        
        if (self.isDouble) {
            UILabel *label_right = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - self.endPoint_x_right, height - space*i + self.outHeight, self.startPoint_x_left, 16)];
            label_right.font = [UIFont systemFontOfSize:10];
            label_right.textAlignment = 1;
            label_right.textAlignment = NSTextAlignmentCenter;
            label_right.backgroundColor = [UIColor clearColor];
            label_right.text = _dateArr_y_right[i];//[NSString stringWithFormat:@"%d",temperature-10*i];
            label_right.textColor = [UIColor lightGrayColor];
            [self addSubview:label_right];
        }
        
        [path moveToPoint:CGPointMake(self.startPoint_x_left, 8+space*i + self.outHeight)];
        [path addLineToPoint:CGPointMake(self.bounds.size.width-self.endPoint_x_right, 8+space*i + self.outHeight)];
    }
    
    _horizonLineLayer = [[CAShapeLayer alloc] init];
    _horizonLineLayer.path = path.CGPath;
    _horizonLineLayer.strokeColor = [UIColor blackColor].CGColor;
    _horizonLineLayer.lineWidth = 0.5;
    [self.layer addSublayer:_horizonLineLayer];
    
    //[self addExplain:@"卧室" originX:36 color:[UIColor redColor]];
}
#pragma mark -- 画柱状图
- (void)drawColmnChartView_first {
    
    UIColor *columnColor = self.columnChartColor_first?:[UIColor blueColor];
    _columnChartLayer_first = [CALayer layer];
    _columnChartLayer_first.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    _columnChartLayer_first.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    _columnChartLayer_first.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:_columnChartLayer_first];
    
    CGFloat width = (self.bounds.size.width-self.startPoint_x_left-self.endPoint_x_right)/(5 - 1);
    CGFloat height = self.bounds.size.height-30+8+self.outHeight;
    CGFloat column_width = width/2;
    CGFloat column_x = self.startPoint_x_left + width*2;
    CGFloat column_height = self.value_mileage;
    CGFloat column_y = (self.frame.size.height - 30) + 8 + self.outHeight - column_height;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(column_x, height)];
    [bezierPath addLineToPoint:CGPointMake(column_x, column_y)];
    [bezierPath stroke];
    
    CAShapeLayer *columnChartShape = [[CAShapeLayer alloc]init];
    columnChartShape.strokeColor = columnColor.CGColor;//[UIColor clearColor].CGColor;
    columnChartShape.fillColor = [UIColor clearColor].CGColor;//columnColor.CGColor;
    columnChartShape.lineWidth = column_width;//2.0f;
    [_columnChartLayer_first addSublayer:columnChartShape];
    columnChartShape.path = bezierPath.CGPath;
    
    //z柱状图的绘制动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    animation.duration = 1.5;//4.0;
    [columnChartShape addAnimation:animation forKey:nil];
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];//添加动画样式
    animation.removedOnCompletion = NO;
    
    [self performSelector:@selector(drawLabFirst) withObject:nil afterDelay:1.5];
}
- (void)drawLabFirst {
    
    CGFloat width = (self.bounds.size.width-self.startPoint_x_left-self.endPoint_x_right)/(5 - 1);
    CGFloat column_x = self.startPoint_x_left + width*2;
    CGFloat column_height = self.value_mileage;
    CGFloat column_y = (self.frame.size.height - 30) + 8 + self.outHeight - column_height;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(column_x, column_y + 0, 100, 18)];
    label.center = CGPointMake(column_x, column_y - 10);
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.text = self.value_mileage_str;
    label.textColor = [UIColor lightGrayColor];
    [self addSubview:label];
}
- (void)drawColmnChartView_second {
    UIColor *columnColor = self.columnChartColor_second?:[UIColor blueColor];
    _columnChartLayer_second = [CALayer layer];
    _columnChartLayer_second.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    _columnChartLayer_second.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    _columnChartLayer_second.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:_columnChartLayer_second];
    
    CGFloat width = (self.bounds.size.width-self.startPoint_x_left-self.endPoint_x_right)/(5 - 1);
    CGFloat height = self.bounds.size.height-30+8+self.outHeight;
    CGFloat column_width = width/2;
    CGFloat column_x = self.startPoint_x_left + width*3;
    CGFloat column_height = self.value_oil;
    CGFloat column_y = (self.frame.size.height - 30) + 8 + self.outHeight - column_height;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(column_x, height)];
    [bezierPath addLineToPoint:CGPointMake(column_x, column_y)];
    [bezierPath stroke];
    
    CAShapeLayer *columnChartShape = [[CAShapeLayer alloc]init];
    columnChartShape.strokeColor = columnColor.CGColor;
    columnChartShape.fillColor = [UIColor clearColor].CGColor;
    columnChartShape.lineWidth = column_width;//2.0f;
    [_columnChartLayer_second addSublayer:columnChartShape];
    columnChartShape.path = bezierPath.CGPath;
    
    //z柱状图的绘制动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    animation.duration = 1.5;//4.0;
    [columnChartShape addAnimation:animation forKey:nil];
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];//添加动画样式
    animation.removedOnCompletion = NO;
    
    [self performSelector:@selector(drawLabSecond) withObject:nil afterDelay:1.5];
}
- (void)drawLabSecond {
    
    CGFloat width = (self.bounds.size.width-self.startPoint_x_left-self.endPoint_x_right)/(5 - 1);
    CGFloat column_x = self.startPoint_x_left + width*3;
    CGFloat column_height = self.value_oil;
    CGFloat column_y = (self.frame.size.height - 30) + 8 + self.outHeight - column_height;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(column_x, column_y + 0, 100, 18)];
    label.center = CGPointMake(column_x, column_y - 10);
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.text = self.value_oil_str;
    label.textColor = [UIColor lightGrayColor];
    [self addSubview:label];
}
@end
////开始添加动画
//[CATransaction begin];
////创建一个strokeEnd路径的动画
//CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
////动画时间
//pathAnimation.duration = 2.0;
////添加动画样式
//pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
////动画起点
//pathAnimation.fromValue = @0.0f;
////动画停止位置
//pathAnimation.toValue   = @1.0f;
////把动画添加到CAShapeLayer
//[shapeLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
////动画终点
//shapeLine.strokeEnd = 1.0;
////结束动画
//[CATransaction commit];
