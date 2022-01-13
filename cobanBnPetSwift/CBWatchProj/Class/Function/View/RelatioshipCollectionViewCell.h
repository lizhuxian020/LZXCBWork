//
//  RelatioshipCollectionViewCell.h
//  Watch
//
//  Created by lym on 2018/2/8.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBookModel.h"

@interface RelatioshipCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UILabel *textLabel;
- (void)setSelectStatus:(BOOL)isSelect;

@property (nonatomic, strong) AddressBookEditModel *model;

@end
