//
//  CBNewFencePickPointView.m
//  Telematics
//
//  Created by coban on 2020/1/9.
//  Copyright © 2020 coban. All rights reserved.
//

#import "CBNewFencePickPointView.h"

@interface CBNewFencePickPointView ()

@property (nonatomic, strong) UIImageView *imageView;

@end
@implementation CBNewFencePickPointView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBounds:CGRectMake(0.f, 0.f, 10*KFitWidthRate, 10*KFitWidthRate)];
        _pointView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10*KFitWidthRate, 10*KFitWidthRate)];
        _pointView.backgroundColor = kBlueColor;
        _pointView.layer.masksToBounds = YES;
        _pointView.layer.cornerRadius = 5*KFitWidthRate;
        [self addSubview:_pointView];
        
        _pointView_realTime = [[CBTrackPointView alloc]initWithFrame:CGRectMake(0, 0, 10*KFitWidthRate, 10*KFitWidthRate)];
        [self addSubview:_pointView_realTime];
        _pointView_realTime.hidden = YES;
    }
    return self;
}
@end
