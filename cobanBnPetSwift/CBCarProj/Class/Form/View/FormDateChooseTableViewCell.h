//
//  FormDateChooseTableViewCell.h
//  Telematics
//
//  Created by lym on 2017/11/17.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormInfoModel.h"

@interface FormDateChooseTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *middleLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, assign) BOOL isCreate;

@property (nonatomic,strong) FormInfoModel *formModel;

- (void)addBottomLineView;
@end
