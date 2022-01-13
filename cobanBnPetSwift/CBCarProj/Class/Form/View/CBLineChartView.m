//
//  CBLineChartView.m
//  Telematics
//
//  Created by coban on 2019/8/21.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBLineChartView.h"

@interface CBLineChartView ()
{
    CALayer *_polyLineLayer_first;// 折线图层第一
    CALayer *_polyLineLayer_second;// 折线图层第二
    CALayer *_polyLineLayer_third;// 折线图层第三
    CAShapeLayer *_verticalLineLayer;// 网格竖线图层
    CAShapeLayer *_horizonLineLayer;// 网格横线图层
}
/** 绘制 (横线竖线) 左侧起点 */
@property (nonatomic,assign) CGFloat startPoint_x_left;
/** 绘制 (横线竖线) 右侧终点 */
@property (nonatomic,assign) CGFloat endPoint_x_right;
@end
@implementation CBLineChartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
- (void)refreshLineChart {
    // 左侧起点 距离左侧屏幕
    CGFloat width = [NSString getWidthWithText:self.maxData_left font:[UIFont systemFontOfSize:10] height:16];
    width = width < 35?(35 + 10):(width + 10);
    self.startPoint_x_left = width;
    
    // 右侧终点 距离右侧屏幕
    CGFloat width_right = [NSString getWidthWithText:self.maxData_right font:[UIFont systemFontOfSize:10] height:16];
    width_right = width_right < 15?15:(width + 10);
    self.endPoint_x_right = width_right;
    
    //移除竖线layer
    [_verticalLineLayer removeFromSuperlayer];
    //移除横线layer
    [_horizonLineLayer removeFromSuperlayer];
    //移除折线layer
    [_polyLineLayer_first removeFromSuperlayer];
    [_polyLineLayer_second removeFromSuperlayer];
    [_polyLineLayer_third removeFromSuperlayer];
    //移除lab
    for (UILabel *lab in self.subviews) {
        [lab removeFromSuperview];
    }
    
    CGFloat height = self.frame.size.height - 30;//表格的总高度
    [self drawVerticalLine:height];
    
    [self drawHorizontalOfTemperature:height];
    
    [self drawPolyLine_first];
    
    if (self.isDouble) {
        [self drawPolyLine_second];
        [self drawPolyLine_third];
    }
}
//绘制竖线
#pragma mark -- 绘制竖线
- (void)drawVerticalLine:(CGFloat)height{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat width = (self.bounds.size.width-self.startPoint_x_left-self.endPoint_x_right)/(_dateArr_x.count - 1);
    CGFloat start_y = 8;
    for (int i = 0; i < _dateArr_x.count; i ++) {
        [path moveToPoint:CGPointMake(self.startPoint_x_left + width*i, start_y)];
        [path addLineToPoint:CGPointMake(self.startPoint_x_left + width*i, height+start_y)];
    }
    
    _verticalLineLayer = [[CAShapeLayer alloc] init];
    _verticalLineLayer.path = path.CGPath;
    _verticalLineLayer.strokeColor = [UIColor blackColor].CGColor;
    _verticalLineLayer.lineWidth = 0.5;
    [self.layer addSublayer:_verticalLineLayer];
    
    start_y = start_y + height + 3;
    
    for (int i = 0; i < _dateArr_x.count; i ++) {
        if (i % 2 == 0) {
            //continue;
        }
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
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, height - space*i, self.startPoint_x_left, 16)];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.text = _dateArr_y[i];//[NSString stringWithFormat:@"%d",temperature-10*i];
        label.textColor = [UIColor lightGrayColor];
        [self addSubview:label];
        
        if (self.isDouble) {
            UILabel *label_right = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - self.endPoint_x_right, height - space*i, self.startPoint_x_left, 16)];
            label_right.font = [UIFont systemFontOfSize:10];
            label_right.textAlignment = 1;
            label_right.textAlignment = NSTextAlignmentCenter;
            label_right.backgroundColor = [UIColor clearColor];
            label_right.text = _dateArr_y_right[i];//[NSString stringWithFormat:@"%d",temperature-10*i];
            label_right.textColor = [UIColor lightGrayColor];
            [self addSubview:label_right];
        }
        
        [path moveToPoint:CGPointMake(self.startPoint_x_left, 8+space*i)];
        [path addLineToPoint:CGPointMake(self.bounds.size.width-self.endPoint_x_right, 8+space*i)];
    }
    
    _horizonLineLayer = [[CAShapeLayer alloc] init];
    _horizonLineLayer.path = path.CGPath;
    _horizonLineLayer.strokeColor = [UIColor blackColor].CGColor;
    _horizonLineLayer.lineWidth = 0.5;
    [self.layer addSublayer:_horizonLineLayer];
    
    //[self addExplain:@"卧室" originX:36 color:[UIColor redColor]];
}

- (void)addExplain:(NSString *)string originX:(CGFloat)originX color:(UIColor *)color{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(originX, self.bounds.size.height-30, 40, 18)];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = 2;
    label.backgroundColor = [UIColor clearColor];
    label.text = string;
    label.textColor = color;
    [self addSubview:label];
    
    CALayer *cirile = [CALayer layer];
    cirile.position = CGPointMake(originX+40+10, self.bounds.size.height-21);//30-9
    cirile.bounds = CGRectMake(0, 0, 6, 6);
    cirile.cornerRadius = 3;
    cirile.masksToBounds = YES;
    cirile.backgroundColor = color.CGColor;
    [self.layer addSublayer:cirile];
}
#pragma mark -- 画曲线
- (void)drawPolyLine_first {
    UIColor *roomColor = self.linePointColor_first?:[UIColor blueColor];
    _polyLineLayer_first = [CALayer layer];
    _polyLineLayer_first.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    _polyLineLayer_first.bounds = CGRectMake(0, 0,self.bounds.size.width, self.bounds.size.height);
    _polyLineLayer_first.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:_polyLineLayer_first];
    
    UIBezierPath *roomPath= [UIBezierPath bezierPath];
    CAShapeLayer *roomLine = [[CAShapeLayer alloc] init];
    roomLine.strokeColor = roomColor.CGColor;
    roomLine.fillColor = [UIColor clearColor].CGColor;
    roomLine.lineWidth = 2.0;
    [_polyLineLayer_first addSublayer:roomLine];
    
    BOOL firstOfRoom = YES;
    for (int i = 0; i < _valueDataArr_y.count; i ++) {
        int valueData_x = [_valueDateArr_x[i] intValue];
        int valueData_y = [_valueDataArr_y[i] intValue];
        CGPoint roomCenter = CGPointMake(valueData_x, valueData_y);
        [self drawCirile:roomCenter layer:_polyLineLayer_first color:roomColor];
        if (firstOfRoom) {
            [roomPath moveToPoint:roomCenter];
            firstOfRoom = NO;
        }else{
            [roomPath addLineToPoint:roomCenter];
        }
        
    }
    roomLine.path = roomPath.CGPath;
    
    //折线的绘制动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    animation.duration = 1.5;//4.0;
    [roomLine addAnimation:animation forKey:nil];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
}
- (void)drawPolyLine_second {
    UIColor *roomColor = self.linePointColor_second?:[UIColor blueColor];
    _polyLineLayer_second = [CALayer layer];
    _polyLineLayer_second.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    _polyLineLayer_second.bounds = CGRectMake(0, 0,self.bounds.size.width, self.bounds.size.height);
    _polyLineLayer_second.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:_polyLineLayer_second];
    
    UIBezierPath *roomPath= [UIBezierPath bezierPath];
    CAShapeLayer *roomLine = [[CAShapeLayer alloc] init];
    roomLine.strokeColor = roomColor.CGColor;
    roomLine.fillColor = [UIColor clearColor].CGColor;
    roomLine.lineWidth = 2.0;
    [_polyLineLayer_second addSublayer:roomLine];
    
    BOOL firstOfRoom = YES;
    for (int i = 0; i < _valueDataArr_y_second.count; i ++) {
        int valueData_x = [_valueDateArr_x_second[i] intValue];
        int valueData_y = [_valueDataArr_y_second[i] intValue];
        CGPoint roomCenter = CGPointMake(valueData_x, valueData_y);
        [self drawCirile:roomCenter layer:_polyLineLayer_second color:roomColor];
        if (firstOfRoom) {
            [roomPath moveToPoint:roomCenter];
            firstOfRoom = NO;
        }else{
            [roomPath addLineToPoint:roomCenter];
        }
    }
    roomLine.path = roomPath.CGPath;
    
    //折线的绘制动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    animation.duration = 1.5;//4.0;
    [roomLine addAnimation:animation forKey:nil];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
}
- (void)drawPolyLine_third {
    UIColor *roomColor = self.linePointColor_third?:[UIColor blueColor];
    _polyLineLayer_third = [CALayer layer];
    _polyLineLayer_third.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    _polyLineLayer_third.bounds = CGRectMake(0, 0,self.bounds.size.width, self.bounds.size.height);
    _polyLineLayer_third.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:_polyLineLayer_third];
    
    UIBezierPath *roomPath= [UIBezierPath bezierPath];
    CAShapeLayer *roomLine = [[CAShapeLayer alloc] init];
    roomLine.strokeColor = roomColor.CGColor;
    roomLine.fillColor = [UIColor clearColor].CGColor;
    roomLine.lineWidth = 2.0;
    [_polyLineLayer_third addSublayer:roomLine];
    
    BOOL firstOfRoom = YES;
    for (int i = 0; i < _valueDataArr_y_third.count; i ++) {
        int valueData_x = [_valueDateArr_x_third[i] intValue];
        int valueData_y = [_valueDataArr_y_third[i] intValue];
        CGPoint roomCenter = CGPointMake(valueData_x, valueData_y);
        [self drawCirile:roomCenter layer:_polyLineLayer_third color:roomColor];
        if (firstOfRoom) {
            [roomPath moveToPoint:roomCenter];
            firstOfRoom = NO;
        }else{
            [roomPath addLineToPoint:roomCenter];
        }
        
    }
    roomLine.path = roomPath.CGPath;
    
    //折线的绘制动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    animation.duration = 1.5;//4.0;
    [roomLine addAnimation:animation forKey:nil];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
}
- (void)drawCirile:(CGPoint)center layer:(CALayer *)layer color:(UIColor *)color{
    
    CALayer *roomCirile = [CALayer layer];
    roomCirile.position = center;
    roomCirile.bounds = CGRectMake(0, 0, 6, 6);
    roomCirile.cornerRadius = 3;
    roomCirile.masksToBounds = YES;
    roomCirile.backgroundColor = color.CGColor;
    [layer addSublayer:roomCirile];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
