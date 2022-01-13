//
//  AutoHeightSwitchTableViewCell.h
//  Watch
//
//  Created by lym on 2018/2/8.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoHeightSwitchTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
- (void)setTopLabelText:(NSString *)text;
@end
