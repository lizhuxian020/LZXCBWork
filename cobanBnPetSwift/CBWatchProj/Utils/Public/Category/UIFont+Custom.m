//
//  UIFont+Custom.m
//  Singapore_powerbank
//
//  Created by 麦鱼科技 on 2017/8/19.
//  Copyright © 2017年 麦鱼科技. All rights reserved.
//

#import "UIFont+Custom.h"

@implementation UIFont (Custom)

+ (UIFont *)FiraSansBoldWithSize:(CGFloat)size{
    return [UIFont fontWithName:@"FiraSans-Bold" size:size];
}

+ (UIFont *)FiraSansMediumWithSize:(CGFloat)size{
    return [UIFont fontWithName:@"FiraSans-Medium" size:size];
}

+ (UIFont *)FiraSansRegularWithSize:(CGFloat)size{
    return [UIFont fontWithName:@"FiraSans-Regular" size:size];
}

+ (UIFont *)AdobeSongStdLight:(CGFloat)size{
    return [UIFont fontWithName:@"AdobeSongStd-Light" size:size];
}

@end
