//
//  CBHomeTalkTableView.m
//  Watch
//
//  Created by coban on 2019/8/16.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBHomeTalkTableView.h"

@implementation CBHomeTalkTableView

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

@end
