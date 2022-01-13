//
//  CBChartView.m
//  Telematics
//
//  Created by coban on 2019/8/6.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBChartView.h"

@implementation CBChartView
{
    CGRect _frame;
    NSInteger _column;
    NSInteger _row;
    CGFloat _columnSpace;
    CGFloat _rowSpace;
    LYChartViewType _type;
    CGPoint _zeroPoint;
    CGFloat _width;
    CGFloat _height;
    UIEdgeInsets _edgeInsets;
    NSInteger _valueNum;
    NSArray *_valueDataAry;
    NSArray *_columnIndexAry;
    NSArray *_rowIndexAry;
    NSString *_title;
    NSString *_unit;
    void(^_distogramSelectAction)(NSInteger index);
    UIView *_view;
    NSTextAlignment _alignment;
    CGFloat _indexFont;
    CGFloat _titleFont;
    UIColor *(^_histogramColor)(NSInteger index,LYChartViewType type);
    UIColor *_fillColor;
    
    NSMutableArray *_histogramLayerAry;
    NSMutableArray *_histogramLayerHeightAry;
    NSMutableArray *_histogramLayerCurrentHeightAry;
    NSMutableArray *_histogramLayerIndexValueAry;
    CADisplayLink *_displayLink;
    
    
    CAShapeLayer *_lineLayer;
    CAShapeLayer *_chartOverstriking;
    NSMutableArray *_linePointAry;
    NSMutableArray *_lineCurrentPointAry;
    
    CGFloat _scale;
    
    BOOL _animation;
}
// 初始化创建方法
- (instancetype)initWithFrame:(CGRect)frame column:(NSInteger)column row:(NSInteger)row type:(LYChartViewType)type title:(NSString *)title unit:(NSString *)unit
{
    self = [super initWithFrame:frame];
    if (self) {
        _animation = YES;
        if (title) {
            _edgeInsets = UIEdgeInsetsMake(35, 35, 30, 25);
            _titleFont = 12;
        }else {
            _edgeInsets = UIEdgeInsetsMake(20, 35, 30, 25);
        }
        _indexFont = 8;
        _fillColor = [[UIColor colorWithRed:24 / 255.0 green:171 / 255.0 blue:255 / 255.0 alpha:1.0] colorWithAlphaComponent:0.5];
        [self refreshArgument:frame valueNum:column row:row type:type title:title unit:unit alignment:NSTextAlignmentCenter];
    }
    return self;
}
// 更新下标字体大小
- (void)customIndexFont:(CGFloat)font{
    _indexFont = font;
}
// 更新标题字体大小
- (void)customTitleFont:(CGFloat)font{
    if (_title) {
        _edgeInsets = UIEdgeInsetsMake(_edgeInsets.top + (font - _titleFont), _edgeInsets.left, _edgeInsets.bottom, _edgeInsets.right);
        [self refreshArgument:_frame valueNum:_valueNum row:_row type:_type title:_title unit:_unit alignment:_alignment];
        _titleFont = font;
    }
}
// 更新参数
- (void)refreshArgument:(CGRect)frame valueNum:(NSInteger)valueNum row:(NSInteger)row type:(LYChartViewType)type title:(NSString *)title unit:(NSString *)unit alignment:(NSTextAlignment)alignment{
    _frame = frame;
    _row = row;
    _title = title;
    _unit = unit;
    _type = type;
    _valueNum = valueNum;
    _alignment = alignment;
    
    if (_type == LYChartViewTypeLine) {_column = _valueNum - 1;}
    if (_type == LYChartViewTypeHistogram) {_column = _valueNum;}
    _width = CGRectGetWidth(_frame) - _edgeInsets.left - _edgeInsets.right;
    _height = CGRectGetHeight(_frame) - _edgeInsets.top - _edgeInsets.bottom;
    _zeroPoint = CGPointMake(_edgeInsets.left,CGRectGetHeight(_frame) - _edgeInsets.bottom);
    _columnSpace = _width / _column;
    _rowSpace = _height / _row;
    
}
// 更改类型
- (void)customType:(LYChartViewType)type{
    [self refreshArgument:_frame valueNum:_valueNum row:_row type:type title:_title unit:_unit alignment:_alignment];
}
// 更新frame
- (void)customFrame:(CGRect)frame{
    [self refreshArgument:frame valueNum:_valueNum row:_row type:_type title:_title unit:_unit alignment:_alignment];
    self.frame = frame;
}
// 设置标题的位置
- (void)customTitleAlignment:(NSTextAlignment)alignment{
    [self refreshArgument:_frame valueNum:_valueNum row:_row type:_type title:_title unit:_unit alignment:alignment];
}
// 设置右上角图片视图
- (void)customRightTopView:(void(^)(UIView *view))action{
    if (action) {
        if (!_view) {
            _view = [[UIView alloc] initWithFrame:CGRectMake(2, 2, _frame.size.width - 4, 20)];
            _view.backgroundColor = [UIColor clearColor];
            [self addSubview:_view];
        }
        action(_view);
    }
}
// 设置列下标
- (void)customColumnIndexData:(NSArray *)data{
    if (data) {
        NSMutableArray *tempAry = [NSMutableArray array];
        for (id obj in data) {
            [tempAry addObject:[NSString stringWithFormat:@"%@",obj]];
        }
        _columnIndexAry = [NSArray arrayWithArray:tempAry];
    }
}
// 设置数据和行下标
- (void)customValueData:(NSArray *)data{
    if (data) {
        NSMutableArray *tempAry = [NSMutableArray array];
        for (id obj in data) {
            [tempAry addObject:[NSString stringWithFormat:@"%@",obj]];
        }
        _valueDataAry = [NSArray arrayWithArray:tempAry];
        CGFloat space_Value = [self spaceValue];
        NSMutableArray *rowIndexAry = [NSMutableArray array];
        for (int i = 0; i <= _row; i++) {
            NSInteger index = i * space_Value;
            [rowIndexAry addObject:[NSString stringWithFormat:@"%ld",index]];
        }
        _rowIndexAry = [NSArray arrayWithArray:rowIndexAry];
    }
}
// 设置内边距
- (void)customEdgeInsets:(UIEdgeInsets)edgeInsets{
    _edgeInsets = edgeInsets;
    [self refreshArgument:_frame valueNum:_valueNum row:_row type:_type title:_title unit:_unit alignment:_alignment];
}
// 更新柱状图填充颜色
- (void)customColor:(UIColor *(^)(NSInteger index,LYChartViewType type))color{
    if (color) {
        _histogramColor = color;
    }
}
// 刷新数据
- (void)reloadData{
    [self customSubViews];
}
// 开始布局
- (void)customSubViews{
    // 移除所有layer
    NSArray *tempAry = [NSArray arrayWithArray:self.layer.sublayers];
    for (CALayer *layer in tempAry) {
        [layer removeFromSuperlayer];
    }
    // 设置坐标轴
    [self customAxis];
    
    // 设置列和行线,以及遮盖
    [self customColumn_Row_CoverView];
    
    // 设置单位
    [self customUNITAndTitle];
    
    // 添加折线或者柱状图
    [self addChartOrHistogram:_animation];
    
    if (_view) {  // 防止上面的移除,会清楚掉这个view
        [self addSubview:_view];
    }
}
- (void)customAnimation:(BOOL)animation{
    _animation = animation;
}
// 添加折线或者柱状图
- (void)addChartOrHistogram:(BOOL)animation{
    CGFloat space_Value = [self spaceValue];
    _scale = space_Value / _rowSpace;  // 比例
    if (_type == LYChartViewTypeLine) {
        if (animation) {
            if (_displayLink) {
                [_displayLink invalidate];
                _displayLink = nil;
            }
            _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animationDisPlayLine)];
            [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:(NSDefaultRunLoopMode)];
            
        }
        NSMutableArray *pointAry = [NSMutableArray array];
        for (int i = 0; i < [_valueDataAry count]; i++) {
            CGPoint point  = CGPointMake(_zeroPoint.x + (i * _columnSpace),_zeroPoint.y - ([[_valueDataAry objectAtIndex:i] floatValue] / _scale));
            [pointAry addObject:[NSValue valueWithCGPoint:point]];
        }
        // 绘制折线
        if (_histogramColor) {
            _fillColor = _histogramColor(0,_type);
        }
        _lineLayer = nil;
        _linePointAry = [NSMutableArray arrayWithArray:pointAry];
        _lineCurrentPointAry = [NSMutableArray array];
        for (NSValue *value in pointAry) {
            CGPoint point = [value CGPointValue];
            point.y = _zeroPoint.y;
            [_lineCurrentPointAry addObject:[NSValue valueWithCGPoint:point]];
        }
        _lineLayer = [CAShapeLayer layer];
        _lineLayer.fillColor = _fillColor.CGColor;
        UIBezierPath *layerPath = [self createChartLayer:pointAry];
        _lineLayer.path = layerPath.CGPath;
        
        [self.layer addSublayer:_lineLayer];
        _chartOverstriking = [CAShapeLayer layer];
        _chartOverstriking.strokeColor = _fillColor.CGColor;
        _chartOverstriking.path = [self createChartOverstrikingLine:pointAry].CGPath;
        [self.layer addSublayer:_chartOverstriking];
        // 绘制圆点
        for (NSValue *pointValue in pointAry) {
            CAShapeLayer *dot = [self createDot:[pointValue CGPointValue] color:[UIColor colorWithRed:24 / 255.0 green:171 / 255.0 blue:255 / 255.0 alpha:1.0]];
            [self.layer addSublayer:dot];
        }
        // 绘制标记值
        BOOL adjust = NO;
        for (int i = 0;i < pointAry.count;i++) {
            if ((i == [_valueDataAry count] - 1) && ([[NSString stringWithFormat:@"%@",_valueDataAry[i]] length] > 5)) {
                adjust = YES;
            }
            CATextLayer *text = [self createValueLineTextLayer:[pointAry[i] CGPointValue] text:_valueDataAry[i] adjust:adjust];
            [self.layer addSublayer:text];
        }
    }
    if (_type == LYChartViewTypeHistogram) {
        if (animation) {
            if (_displayLink) {
                [_displayLink invalidate];
                _displayLink = nil;
            }
            _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animationDisPlayHistogram)];
            [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:(NSDefaultRunLoopMode)];
        }
        CGFloat width = _columnSpace - 2;
        _histogramLayerAry = [NSMutableArray array];
        _histogramLayerHeightAry = [NSMutableArray array];
        _histogramLayerCurrentHeightAry = [NSMutableArray array];
        _histogramLayerIndexValueAry = [NSMutableArray array];
        // 绘制柱状图
        for (int i = 0; i < [_valueDataAry count]; i++) {
            CGPoint point  = CGPointMake(_zeroPoint.x + (i * _columnSpace) + 1,_zeroPoint.y);
            UIColor *fillColor = nil;
            if (_histogramColor) {
                fillColor = _histogramColor(i,_type);
            }else {
                fillColor = _fillColor;
            }
            CAShapeLayer *layer = [CAShapeLayer layer];
            [_histogramLayerAry addObject:layer];
            [_histogramLayerHeightAry addObject:[NSNumber numberWithFloat:[[_valueDataAry objectAtIndex:i] floatValue] / _scale]];
            [_histogramLayerCurrentHeightAry addObject:@(0)];
            layer.fillColor = fillColor.CGColor;
            UIBezierPath *path = [self createHistogram:point width:width height:[[_valueDataAry objectAtIndex:i] floatValue] / _scale];
            layer.path = path.CGPath;
            [self.layer addSublayer:layer];
            
            CATextLayer *text = [self createValueHistogramLayer:CGPointMake(point.x + (width / 2.0), point.y - [[_valueDataAry objectAtIndex:i] floatValue] / _scale) text:_valueDataAry[i]];
            [_histogramLayerIndexValueAry addObject:text];
            if (animation) {
                text.opacity = 0;
            }else {
                text.opacity = 1;
            }
            [self.layer addSublayer:text];
        }
    }
}
// 动态更改折线路径
- (void)animationDisPlayLine{
    
    for (int i = 0; i < [_linePointAry count]; i++) {
        CGFloat last_y = [[_linePointAry objectAtIndex:i] CGPointValue].y;
        CGFloat current_y = [[_lineCurrentPointAry objectAtIndex:i] CGPointValue].y;
        CGFloat speed = (last_y - current_y) / 10;
        _lineCurrentPointAry[i] = [NSValue valueWithCGPoint:CGPointMake([_lineCurrentPointAry[i] CGPointValue].x, current_y + speed)];
    }
    UIBezierPath *linePath = [self createChartLayer:_lineCurrentPointAry];
    _lineLayer.path = linePath.CGPath;
    _chartOverstriking.path = [self createChartOverstrikingLine:_lineCurrentPointAry].CGPath;
    BOOL success = YES;
    for (int i = 0; i < [_lineCurrentPointAry count]; i++) {
        NSString *currentStr = [NSString stringWithFormat:@"%.2f",[[_lineCurrentPointAry objectAtIndex:i] CGPointValue].y];
        CGFloat current = [currentStr floatValue];
        NSString *lastStr = [NSString stringWithFormat:@"%.2f",[[_linePointAry objectAtIndex:i] CGPointValue].y];
        CGFloat last = [lastStr floatValue];
        if (current > last) {
            success = NO;
        }
    }
    if (success) {
        [_displayLink invalidate];
        _displayLink = nil;
        _linePointAry = nil;
        _lineCurrentPointAry = nil;
    }
    
}
// 动态更改路径
- (void)animationDisPlayHistogram{
    CGFloat width = _columnSpace - 2;
    for (int i = 0; i < [_histogramLayerCurrentHeightAry count]; i++) {
        CGFloat currentHeight = [_histogramLayerCurrentHeightAry[i] floatValue];
        CGFloat lastHeight = [_histogramLayerHeightAry[i] floatValue];
        CGFloat speed = ceilf((lastHeight - currentHeight) / 10);
        _histogramLayerCurrentHeightAry[i] = [NSNumber numberWithFloat:currentHeight + speed];
    }
    for (int i = 0; i < [_histogramLayerAry count]; i++) {
        CGPoint point  = CGPointMake(_zeroPoint.x + (i * _columnSpace) + 1,_zeroPoint.y);
        UIBezierPath *path = [self createHistogram:point width:width height:[_histogramLayerCurrentHeightAry[i] floatValue]];
        [[_histogramLayerAry objectAtIndex:i] setPath:path.CGPath];
    }
    BOOL success = YES;
    for (int i = 0; i < [_histogramLayerHeightAry count]; i++) {
        if ([[_histogramLayerCurrentHeightAry objectAtIndex:i] floatValue] < [[_histogramLayerHeightAry objectAtIndex:i] floatValue]) {
            success = NO;
        }
    }
    if (success) {
        [_displayLink invalidate];
        _displayLink = nil;
        for (CATextLayer *text in _histogramLayerIndexValueAry) {
            text.opacity = 1;
        }
        
        _histogramLayerAry = nil;
        _histogramLayerHeightAry = nil;
        _histogramLayerCurrentHeightAry = nil;
        _histogramLayerIndexValueAry = nil;
    }
    
}
// 获取数据最大值,并计算每一行间隔值
- (CGFloat)spaceValue{
    if ([_unit isEqualToString:@"%"]) {
        return 20;
    }
    CGFloat minValue = MAXFLOAT;
    CGFloat maxValue = -MAXFLOAT;
    for (int i = 0; i < [_valueDataAry count]; i++) {
        if ([_valueDataAry[i] floatValue] > maxValue) {
            maxValue = [_valueDataAry[i] floatValue];
        }
        if ([_valueDataAry[i] floatValue] < minValue) {
            minValue = [_valueDataAry[i] floatValue];
        }
    }
    int max = (int)[self getNumber:maxValue];
    CGFloat space_Value = 0;
    if (max >= 10) {
        NSInteger tenValue = 1;
        while (max / 10) {
            max = max / 10;
            tenValue *= 10;
        }
        space_Value = ceil((CGFloat)((max + 1) * tenValue) / _row);  // y轴间隔数值(真实数值)
    }
    else if (max >= 1 && max < 10) {
        space_Value = 2;
    }
    else if (max >= 0 && max < 1) {
        space_Value = 1;
    }
    if (space_Value == 0) {space_Value = 1;}
    return space_Value;
}
// 只取小数点之前的数字
- (CGFloat)getNumber:(CGFloat)value{
    NSString *string = [NSString stringWithFormat:@"%f",value];
    if (![[NSMutableString stringWithString:string] containsString:@"."]) {
        return value;
    }
    return [[[string componentsSeparatedByString:@"."] firstObject] floatValue];
}
// 设置单位和标题
- (void)customUNITAndTitle{
    if (_unit) {
        CATextLayer *textLayer = [self createTextUNITLayer:CGPointMake(_edgeInsets.left / 2.0, _zeroPoint.y - _height - 2) text:[NSString stringWithFormat:@"单位:%@",_unit]];
        [self.layer addSublayer:textLayer];
    }
    if (_title) {
        CATextLayer *textLayer = nil;
        if (_alignment == NSTextAlignmentCenter) {
            textLayer = [self createTitleLayer:CGPointMake(CGRectGetWidth(_frame) / 2.0, 2) text:_title];
        }
        if (_alignment == NSTextAlignmentLeft) {
            textLayer = [self createTitleLayer:CGPointMake(2, 2) text:_title];
        }
        if (_alignment == NSTextAlignmentRight) {
            textLayer = [self createTitleLayer:CGPointMake(CGRectGetWidth(_frame) - 2, 2) text:_title];
        }
        [self.layer addSublayer:textLayer];
    }
}
// 设置列和行线,以及遮盖
- (void)customColumn_Row_CoverView{
    // 设置列线
    for (int i = 1; i <= _column; i++) {
        CAShapeLayer *axisVertical = [self createVerticalLine:CGPointMake(_zeroPoint.x + (_columnSpace * i), _zeroPoint.y) height:_height color:[[UIColor lightGrayColor] colorWithAlphaComponent:0.1] lineWidth:0.5];
        [self.layer addSublayer:axisVertical];
    }
    // 设置下标数值
    for (int i = 0; i < [_columnIndexAry count]; i++) {
        if (_type == LYChartViewTypeLine) {
            CGPoint point = CGPointMake(_zeroPoint.x + (_columnSpace * i), _zeroPoint.y);
            CATextLayer *text = [self createTextLayer:point text:_columnIndexAry[i]];
            [self.layer addSublayer:text];
        }
        if (_type == LYChartViewTypeHistogram) {
            CGPoint point = CGPointMake(_zeroPoint.x + (_columnSpace * i) + _columnSpace / 2.0, _zeroPoint.y);
            CATextLayer *text = [self createTextLayer:point text:_columnIndexAry[i]];
            [self.layer addSublayer:text];
        }
    }
    // 设置水平线
    for (int i = 1; i <= _row; i++) {
        CAShapeLayer *axisHorizontal = [self createHorizontalLine:CGPointMake(_zeroPoint.x, _zeroPoint.y - (_rowSpace * i)) width:_width color:[[UIColor lightGrayColor] colorWithAlphaComponent:0.1] lineHeight:0.5];
        [self.layer addSublayer:axisHorizontal];
    }
    // 设置水平下标值
    for (int i = 1; i < [_rowIndexAry count]; i++) {
        CGPoint point = CGPointMake(_zeroPoint.x, _zeroPoint.y - (i * _rowSpace));
        NSString *text = [NSString stringWithFormat:@"%@",_rowIndexAry[i]];
        CATextLayer *textLayer = [self createHorizontalTextLayer:point text:text];
        [self.layer addSublayer:textLayer];
    }
    // 设置遮盖
    for (int i = 1; i <= _row; i++) {
        if (i % 2 != 0) {
            CAShapeLayer *coverLayer = [self createCoverViewPosition:CGPointMake(_zeroPoint.x, _zeroPoint.y - (_rowSpace * i)) width:_width height:_rowSpace color:[[UIColor lightGrayColor] colorWithAlphaComponent:0.05]];
            [self.layer addSublayer:coverLayer];
        }
    }
}
// 设置坐标轴
- (void)customAxis{
    UIColor *color = [UIColor lightGrayColor];
    CGFloat lineWidth = 1;
    // 创建X轴
    CAShapeLayer *axis_X = [self createHorizontalLine:_zeroPoint width:_width color:color lineHeight:lineWidth];
    [self.layer addSublayer:axis_X];
    
    // 创建Y轴
    CAShapeLayer *axis_Y = [self createVerticalLine:_zeroPoint height:_height color:color lineWidth:lineWidth];
    [self.layer addSublayer:axis_Y];
}
// 创建竖线
- (CAShapeLayer *)createVerticalLine:(CGPoint)bottomPoint height:(CGFloat)height color:(UIColor *)color lineWidth:(CGFloat)lineWidth{
    CAShapeLayer *line = [CAShapeLayer layer];
    line.bounds = CGRectMake(0, 0, lineWidth, height);
    line.position = CGPointMake(bottomPoint.x, bottomPoint.y - (height / 2.0));
    line.backgroundColor = color.CGColor;
    return line;
}
// 创建水平线
- (CAShapeLayer *)createHorizontalLine:(CGPoint)leftPoint width:(CGFloat)width color:(UIColor *)color lineHeight:(CGFloat)lineHeight{
    CAShapeLayer *line = [CAShapeLayer layer];
    line.bounds = CGRectMake(0, 0, width, lineHeight);
    line.position = CGPointMake(leftPoint.x + (width / 2.0), leftPoint.y);
    line.backgroundColor = color.CGColor;
    return line;
}
// 创建遮盖
- (CAShapeLayer *)createCoverViewPosition:(CGPoint)positionPoint width:(CGFloat)width height:(CGFloat)height color:(UIColor *)color{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.bounds = CGRectMake(0, 0, width, height);
    layer.position = CGPointMake(positionPoint.x + (width / 2.0), positionPoint.y + (height / 2.0));
    layer.backgroundColor = color.CGColor;
    return layer;
}
// 创建折线
- (UIBezierPath *)createChartLayer:(NSArray<NSValue *> *)points{
    if (points && [points count]) {
        UIBezierPath *layerPath = [UIBezierPath bezierPath];
        [layerPath moveToPoint:[[points firstObject] CGPointValue]];
        for (int i = 1; i < points.count; i++) {
            [layerPath addLineToPoint:[points[i] CGPointValue]];
        }
        [layerPath addLineToPoint:CGPointMake([[points lastObject] CGPointValue].x, _zeroPoint.y)];
        [layerPath addLineToPoint:_zeroPoint];
        return layerPath;
    }
    return nil;
}
// 创建折线加粗线
- (UIBezierPath *)createChartOverstrikingLine:(NSArray<NSValue *> *)points{
    UIBezierPath *layerPath = [UIBezierPath bezierPath];
    [layerPath moveToPoint:[[points firstObject] CGPointValue]];
    for (int i = 1; i < points.count; i++) {
        [layerPath addLineToPoint:[points[i] CGPointValue]];
    }
    for (int i = (int)(points.count - 1); i > 0; i--) {
        [layerPath addLineToPoint:[points[i] CGPointValue]];
    }
    return layerPath;
}
// 创建圆点
- (CAShapeLayer *)createDot:(CGPoint)center color:(UIColor *)color{
    CAShapeLayer *dot = [CAShapeLayer layer];
    dot.bounds = CGRectMake(0, 0, 5, 5);
    dot.cornerRadius = 2.5;
    dot.position = center;
    dot.backgroundColor = color.CGColor;
    return dot;
}
// 创建柱状图
- (UIBezierPath *)createHistogram:(CGPoint)positionPoint width:(CGFloat)width height:(CGFloat)height{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(positionPoint.x , _zeroPoint.y)];
    [path addLineToPoint:CGPointMake(positionPoint.x + width, _zeroPoint.y)];
    [path addLineToPoint:CGPointMake(positionPoint.x + width, _zeroPoint.y - height)];
    [path addLineToPoint:CGPointMake(positionPoint.x, _zeroPoint.y - height)];
    return path;
}
// 创建下标标题
- (CATextLayer *)createTextLayer:(CGPoint)positionPoint text:(NSString *)text{
    CATextLayer *textLayer = [CATextLayer layer];
    CGRect rect = [self ly_rectWithSize:CGSizeMake(100, 100) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_indexFont]} forStr:text];
    textLayer.string = text;
    textLayer.foregroundColor = [UIColor lightGrayColor].CGColor;
    textLayer.position = CGPointMake(positionPoint.x, positionPoint.y + hypot(rect.size.width, rect.size.height) / 2.0 + 5);
    textLayer.fontSize = _indexFont;
    textLayer.bounds = CGRectMake(0, 0, rect.size.width, rect.size.height);
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    textLayer.transform = CATransform3DRotate(textLayer.transform, 1, 0, 0,(3.14159265359 * -20)/ 180);
    return textLayer;
}
// 获取字符串在指定区域的rect
- (CGRect)ly_rectWithSize:(CGSize)size attributes:(NSDictionary<NSString *,id> *)attributes forStr:(NSString *)string{
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [string boundingRectWithSize:size options:options attributes:attributes context:nil];
    return rect;
}
// 创建横坐标标题
- (CATextLayer *)createHorizontalTextLayer:(CGPoint)positionPoint text:(NSString *)text{
    CATextLayer *textLayer = [CATextLayer layer];
    CGRect rect = [self ly_rectWithSize:CGSizeMake(100, 100) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_indexFont]} forStr:text];
    textLayer.string = text;
    textLayer.foregroundColor = [UIColor lightGrayColor].CGColor;
    textLayer.position = CGPointMake(positionPoint.x - (rect.size.width / 2.0) - 2, positionPoint.y + 5);
    textLayer.fontSize = _indexFont;
    textLayer.bounds = CGRectMake(0, 0, rect.size.width, rect.size.height);
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    return textLayer;
}
// 创建折线标记值
- (CATextLayer *)createValueLineTextLayer:(CGPoint)positionPoint text:(NSString *)text adjust:(BOOL)adjust{
    CATextLayer *textLayer = [CATextLayer layer];
    CGRect rect = [self ly_rectWithSize:CGSizeMake(100, 100) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_indexFont]} forStr:text];
    textLayer.string = text;
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    if (adjust) {
        textLayer.position = CGPointMake(positionPoint.x, positionPoint.y + (rect.size.height));
    }else {
        textLayer.position = CGPointMake(positionPoint.x + (rect.size.width / 4.5), positionPoint.y - (rect.size.height));
    }
    textLayer.fontSize = _indexFont;
    textLayer.bounds = CGRectMake(0, 0, rect.size.width, rect.size.height);
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    return textLayer;
}
// 绘制柱状图标记值
- (CATextLayer *)createValueHistogramLayer:(CGPoint)positionPoint text:(NSString *)text{
    CATextLayer *textLayer = [CATextLayer layer];
    CGRect rect = [self ly_rectWithSize:CGSizeMake(100, 100) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_indexFont]} forStr:text];
    textLayer.string = text;
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.position = CGPointMake(positionPoint.x, positionPoint.y - (rect.size.height));
    textLayer.fontSize = _indexFont;
    textLayer.bounds = CGRectMake(0, 0, rect.size.width, rect.size.height);
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    return textLayer;
}
// 创建单位
- (CATextLayer *)createTextUNITLayer:(CGPoint)leftBottomPoint text:(NSString *)text{
    CATextLayer *textLayer = [CATextLayer layer];
    CGRect rect = [self ly_rectWithSize:CGSizeMake(100, 100) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_indexFont]} forStr:text];
    textLayer.string = text;
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.position = CGPointMake(leftBottomPoint.x, leftBottomPoint.y - (rect.size.height / 2.0));
    textLayer.fontSize = _indexFont;
    textLayer.bounds = CGRectMake(0, 0, rect.size.width, rect.size.height);
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    return textLayer;
}
// 创建标题
- (CATextLayer *)createTitleLayer:(CGPoint)positionPoint text:(NSString *)text{
    CATextLayer *textLayer = [CATextLayer layer];
    CGRect rect = [self ly_rectWithSize:CGSizeMake(100, 100) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_titleFont]} forStr:text];
    textLayer.string = text;
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    if (_alignment == NSTextAlignmentCenter) {
        textLayer.position = CGPointMake(positionPoint.x, positionPoint.y + rect.size.height / 2.0);
    }
    if (_alignment == NSTextAlignmentLeft) {
        textLayer.position = CGPointMake(positionPoint.x + rect.size.width / 2.0, positionPoint.y + rect.size.height / 2.0);
    }
    if (_alignment == NSTextAlignmentRight) {
        textLayer.position = CGPointMake(positionPoint.x - rect.size.width / 2.0, positionPoint.y + rect.size.height / 2.0);
    }
    textLayer.fontSize = _titleFont;
    textLayer.bounds = CGRectMake(0, 0, rect.size.width, rect.size.height);
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    return textLayer;
}
- (void)histogramSelectAction:(void(^)(NSInteger index))action{
    if (action) {
        _distogramSelectAction = action;
    }
}
#pragma mark - 处理柱状图点击事件 -
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (_type == LYChartViewTypeHistogram) {
        CGPoint point = [touch preciseLocationInView:self];
        if ((point.x >= _zeroPoint.x) && (point.x <= (_zeroPoint.x + _width))) {
            if ((point.y <= _zeroPoint.y) && (point.y >= _edgeInsets.top)) {
                NSInteger index = (point.x - _zeroPoint.x) / _columnSpace;
                
                if (index < [_valueDataAry count]) {
                    if (_distogramSelectAction) {
                        _distogramSelectAction(index);
                    }
                }
                
            }
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
