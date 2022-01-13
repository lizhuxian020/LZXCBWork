//
//  GuardInSchoolTableViewCell.h
//  Watch
//
//  Created by lym on 2018/2/9.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuardInSchoolTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
- (void)setBottomLabelText:(NSString *)text;
@end
