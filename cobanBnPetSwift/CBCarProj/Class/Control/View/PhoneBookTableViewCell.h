//
//  PhoneBookTableViewCell.h
//  Telematics
//
//  Created by lym on 2017/11/30.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhoneBookTableViewCellDelegate <NSObject>
@optional
- (BOOL)shouldEditCellWithIndexPath:(NSIndexPath *)indexPath;
@end

@interface PhoneBookTableViewCell : UITableViewCell
@property (nonatomic, strong) UITextField *nameTextFeild;
@property (nonatomic, strong) UITextField *phoneTextFeild;
@property (nonatomic, strong) UILabel *phoneTypeTitleLabel;
@property (nonatomic, strong) UIButton *phoneTypeBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<PhoneBookTableViewCellDelegate> cellDelegate;
@property (nonatomic, copy) void (^phoneTypeBtnClickBlock)(NSIndexPath *indexPath);
@property (nonatomic, copy) void (^deleteBtnClickBlock)(NSIndexPath *indexPath);
@property (nonatomic, copy) void (^nameTextFieldEidtBlock)(NSIndexPath *indexPath, NSString *text);
@property (nonatomic, copy) void (^phoneTextFieldEidtBlock)(NSIndexPath *indexPath, NSString *text);
@end
