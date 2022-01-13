//
//  CBTalkListTableView.m
//  cobanBnWatch
//
//  Created by coban on 2019/12/4.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBTalkListTableView.h"

@implementation CBTalkListTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = [UIColor colorWithHexString:@"#F6F8FA"];
    self.bounces = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
