//
//  MINImageTextBtn.h
//  Watch
//
//  Created by lym on 2018/2/6.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MINImageTextBtn : UIButton
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *lbNumberUnRead;
- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;
+ (instancetype)buttonWithImage:(UIImage *)image title:(NSString *)title;
@end
