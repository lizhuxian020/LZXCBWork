//
//  SubAccountTableViewCell.h
//  Telematics
//
//  Created by lym on 2017/11/10.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubAccountTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *accountLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *passLabel;
@property (nonatomic, strong) UILabel *permissionLab;
@property (nonatomic, strong) UIImageView *permissionImage;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL isEdit; // 删除按钮是否显示
@property (nonatomic, strong) NSMutableArray<UISwipeGestureRecognizer *> *swipeGestures;
@property (nonatomic, copy) void (^deleteBtnClick)(NSIndexPath *indexPath);
@property (nonatomic, copy) void (^editBtnClick)(NSIndexPath *indexPath);
- (void)setAccountName:(NSString *)account name:(NSString *)name pass:(NSString *)pass;
- (void)addLeftSwipeGesture;
- (void)hideDeleteBtn;
@end
