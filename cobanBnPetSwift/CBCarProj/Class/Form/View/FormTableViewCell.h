//
//  FormTableViewCell.h
//  Telematics
//
//  Created by lym on 2017/11/15.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, assign) BOOL isCreate;
//- (void)addTopLineView;
- (void)addBottomLineView;
- (void)hideRightImage;
@end
