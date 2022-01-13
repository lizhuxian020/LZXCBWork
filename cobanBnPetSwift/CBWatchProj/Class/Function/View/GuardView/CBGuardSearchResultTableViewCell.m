//
//  CBGuardSearchResultTableViewCell.m
//  Watch
//
//  Created by coban on 2019/8/31.
//  Copyright © 2019 Coban. All rights reserved.
//

#import "CBGuardSearchResultTableViewCell.h"

@interface CBGuardSearchResultTableViewCell ()
@property (nonatomic,strong) UIView *lineView;
@end
@implementation CBGuardSearchResultTableViewCell

+ (instancetype)cellCopyTableView:(UITableView *)tableView {
    static NSString *cellID = @"CBGuardSearchResultTableViewCell";
    id cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    
    [self lineView];
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        _lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:_lineView];
    }
    return _lineView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
