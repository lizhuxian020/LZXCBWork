//
//  UIButton+ImageAndTitle.m
//  KCBuinessKey
//
//  Created by KC on 16/1/5.
//  Copyright © 2016年 luhua. All rights reserved.
//

#import "UIButton+ImageAndTitle.h"

@implementation UIButton(ImageAndTitle)
- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType {
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    
    //CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:12.0]];
    
    //NSLog(@">>--- btn.width= %.2f, height = %.2f",self.width,self.height);
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
    CGSize titleSize = [title sizeWithAttributes:attribute];
//	[self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-20.0,
                                              0.0,
                                              0.0,
                                              -titleSize.width)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(45.0,
                                              -image.size.width,
                                              0.0,
                                              0.0)];
    [self setTitle:title forState:stateType];
}

- (void) setRightImage:(UIImage *)image withLeftTitle:(NSString *)title forState:(UIControlState)stateType {
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    
    //CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:12.0]];
    
    //NSLog(@">>--- btn.width= %.2f, height = %.2f",self.width,self.height);
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:self.titleLabel.font.pointSize]};
    CGSize titleSize = [title sizeWithAttributes:attribute];
    //    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0.0,
                                              titleSize.width,
                                              0.0,
                                              0)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
//    [self.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0,
                                              0,
                                              0.0,
                                              0)];
    [self setTitle:title forState:stateType];
}

- (void) setImage:(UIImage *)image withTitle:(NSString *)title titleTopInset:(CGFloat)titleTopInset imageTopInset:(CGFloat)imageTopInset forState:(UIControlState)stateType {
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    
    //CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:12.0]];
    
    //NSLog(@">>--- btn.width= %.2f, height = %.2f",self.width,self.height);
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
    CGSize titleSize = [title sizeWithAttributes:attribute];
    //	[self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-titleTopInset,
                                              0.0,
                                              0.0,
                                              -titleSize.width)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(imageTopInset,
                                              -image.size.width,
                                              0.0,
                                              0.0)];
    [self setTitle:title forState:stateType];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
