//
//  MINImageTextBtn.m
//  Watch
//
//  Created by lym on 2018/2/6.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "MINImageTextBtn.h"

@interface MINImageTextBtn()

@end

@implementation MINImageTextBtn

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title
{
    if (self = [super init]) {
        
        [self setImage: image forState: UIControlStateNormal];
        [self setImageEdgeInsets: UIEdgeInsetsMake(10 * KFitWidthRate, 0, 30 * KFitWidthRate, 0)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.text = title;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont systemFontOfSize: 15 * KFitWidthRate];
        self.textLabel.textColor = KWtRGB(73, 73, 73);
        [self addSubview: self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.mas_equalTo(30 * KFitWidthRate);
        }];
        
        self.lbNumberUnRead = [[UILabel alloc] init];
        self.lbNumberUnRead.text = @"";
        self.lbNumberUnRead.textAlignment = NSTextAlignmentCenter;
        self.lbNumberUnRead.font = [UIFont fontWithName:CBPingFang_SC_Bold size:10];
        self.lbNumberUnRead.textColor = [UIColor redColor];
        [self addSubview: self.lbNumberUnRead];
        [self.lbNumberUnRead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(self.mas_right).offset(-2);
            make.height.mas_equalTo(10);
        }];
        
//        self.backgroundColor = [UIColor redColor];
//        self.textLabel.backgroundColor = [UIColor greenColor];
//        self.lbNumberUnRead.backgroundColor = [UIColor blueColor];
    }
    return self;
}

+ (instancetype)buttonWithImage:(UIImage *)image title:(NSString *)title
{
    return [[self alloc] initWithImage: image title: title];
}

- (instancetype)init
{
    return [self initWithImage: [UIImage imageNamed: @"首页-定位"] title: @"title"];
}

@end
