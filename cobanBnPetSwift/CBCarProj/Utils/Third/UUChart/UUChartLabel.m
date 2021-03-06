//
//  PNChartLabel.m
//  PNChart
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//
//横纵坐标的标记即横纵坐标的label
#import "UUChartLabel.h"
#import "UUColor.h"

@implementation UUChartLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setLineBreakMode:NSLineBreakByWordWrapping];
        [self setMinimumScaleFactor:5.0f];
        [self setNumberOfLines:0];
        [self setLineBreakMode:NSLineBreakByCharWrapping];
        [self setFont:[UIFont boldSystemFontOfSize:9.0f]];
        [self setTextColor: UUDeepGrey];
        self.backgroundColor = [UIColor clearColor];
        [self setTextAlignment:NSTextAlignmentCenter];
        self.userInteractionEnabled = YES;
    }
    return self;
}


@end
