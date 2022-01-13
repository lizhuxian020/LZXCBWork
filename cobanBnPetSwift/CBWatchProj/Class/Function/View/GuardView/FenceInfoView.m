//
//  FenceInfoView.m
//  Watch
//
//  Created by lym on 2018/4/19.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "FenceInfoView.h"

@implementation FenceInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        self.layer.cornerRadius = frame.size.height / 2;
        self.backgroundColor = KWtBlueColor;
        self.titleLabel = [CBWtMINUtils createLabelWithText: @"守护范围200米" size: 15 * KFitWidthRate alignment: NSTextAlignmentCenter textColor: [UIColor whiteColor]];
        self.titleLabel.frame = CGRectMake(15 * KFitWidthRate, 0, frame.size.width - 30 * KFitWidthRate, 30 * KFitWidthRate);
        [self addSubview: self.titleLabel];
    }
    return self;
}

@end
