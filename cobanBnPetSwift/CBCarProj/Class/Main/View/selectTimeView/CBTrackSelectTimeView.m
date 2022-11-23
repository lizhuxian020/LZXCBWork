//
//  CBTrackSelectTimeView.m
//  Telematics
//
//  Created by coban on 2019/8/1.
//  Copyright © 2019 coban. All rights reserved.
//

#import "CBTrackSelectTimeView.h"
#import "_CBTSTChooseTimeView.h"

#define __TrackSelectTimeView_NormalColor UIColor.blackColor
#define __TrackSelectTimeView_SelectedColor kAppMainColor

@interface CBTrackSelectTimeView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *arrayTitle;
@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic, strong) _CBTSTChooseTimeView *startView;
@property (nonatomic, strong) _CBTSTChooseTimeView *endView;

@property (nonatomic, assign) int selectedIndex;

@end
@implementation CBTrackSelectTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    
    self.arrayTitle = @[
        Localized(@"今天"),
        Localized(@"昨天"),
        Localized(@"近三天"),
        Localized(@"近七天"),
        Localized(@"自定义"),
    ];
    
    UIView *lastBtn = nil;
    self.btnArr = [NSMutableArray new];
    for (int i = 0 ; i < self.arrayTitle.count ; i ++ ) {

        UIButton *btn = [UIButton new];
        [self.btnArr addObject:btn];
        btn.tag = 100 + i;
        [btn setTitle:self.arrayTitle[i] forState:UIControlStateNormal];
        [btn setTitleColor:__TrackSelectTimeView_NormalColor forState:UIControlStateNormal];
        [btn setTitleColor:__TrackSelectTimeView_SelectedColor forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setImage:[UIImage imageNamed:@"单选-没选中"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"单选-选中"] forState:UIControlStateSelected];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            if (lastBtn) {
                make.top.equalTo(lastBtn.mas_bottom).mas_offset(10);
            } else {
                make.top.equalTo(@15);
            }
        }];
        [btn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [btn setSelected:true];
        }
        lastBtn = btn;
    }
    
    self.startView = [[_CBTSTChooseTimeView alloc] initWithTitle:@"开始时间"];
    [self addSubview:self.startView];
    [self.startView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.top.equalTo(lastBtn.mas_bottom).mas_offset(15);
    }];
    
    self.endView = [[_CBTSTChooseTimeView alloc] initWithTitle:@"开始时间"];
    [self addSubview:self.endView];
    [self.endView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.top.equalTo(self.startView.mas_bottom).mas_offset(15);
        make.bottom.equalTo(@-35);
    }];
    
}

- (void)selectTime:(UIButton *)sender {
    int index = sender.tag - 100;
    [self.startView inactivate];
    [self.endView inactivate];
    if (index == self.selectedIndex) {
        return;
    }
    UIButton *lastBtn = self.btnArr[self.selectedIndex];
    [lastBtn setSelected:false];
    
    self.selectedIndex = index;
    [sender setSelected:true];

    if (self.selectedIndex == 4) {
        [self.startView activate];
        [self.endView activate];
    }
}

- (BOOL)readyToRequest {
    
    NSDate *nowDate = [NSDate date];
    NSDate *yesterdayDate = [nowDate dateByAddingTimeInterval:-24*60*60];
    NSDate *bfYesterdayDate = [nowDate dateByAddingTimeInterval:-24*60*60*2];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8*3600];
    [formatter setTimeZone:timeZone];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    

    switch (self.selectedIndex) {
        case 0:
        {
            NSDictionary *dicTodayTime = [CBCommonTools getSomeDayPeriod:[NSDate date]];
            self.dateStrStar = [NSString stringWithFormat:@"%@",dicTodayTime[@"startTime"]];
            self.dateStrEnd = [NSString stringWithFormat:@"%@",dicTodayTime[@"endTime"]];

        }
            break;
        case 1:
        {
//            NSDictionary *dicYesterdayTime = [CBCommonTools getSomeDayPeriod:yesterdayDate];
//            self.dateStrStar = [NSString stringWithFormat:@"%@",dicYesterdayTime[@"startTime"]];
//            self.dateStrEnd = [NSString stringWithFormat:@"%@",dicYesterdayTime[@"endTime"]];
            self.dateStrStar = [formatter stringFromDate:[nowDate dateByAddingTimeInterval:-24*60*60]];
            self.dateStrEnd = [formatter stringFromDate:nowDate];

        }
            break;
        case 2:
        {
//            NSDictionary *dicYesterdayTime = [CBCommonTools getSomeDayPeriod:yesterdayDate];
//            NSDictionary *dicBfYesterdayDateTime = [CBCommonTools getSomeDayPeriod:bfYesterdayDate];
//            self.dateStrStar = [NSString stringWithFormat:@"%@",dicBfYesterdayDateTime[@"startTime"]];
//            self.dateStrEnd = [NSString stringWithFormat:@"%@",dicYesterdayTime[@"endTime"]];
            self.dateStrStar = [formatter stringFromDate:[nowDate dateByAddingTimeInterval:-24*60*60*3]];
            self.dateStrEnd = [formatter stringFromDate:nowDate];

        }
            break;
        case 3:
        {
            self.dateStrStar = [formatter stringFromDate:[nowDate dateByAddingTimeInterval:-24*60*60*7]];
            self.dateStrEnd = [formatter stringFromDate:nowDate];
        }
            break;
        case 4: {
            self.dateStrStar = self.startView.timeStr;
            self.dateStrEnd = self.endView.timeStr;
        }
            break;
        default:
            break;
    }
    
    NSDate *startD = [formatter dateFromString:self.dateStrStar];
    NSDate *endD = [formatter dateFromString:self.dateStrEnd];
    if (startD.timeIntervalSince1970 > endD.timeIntervalSince1970) {
        [HUD showHUDWithText:Localized(@"开始时间不能大于结束时间") withDelay:1.2];
        return NO;
    }
    
    NSTimeInterval t = [endD timeIntervalSinceDate:startD];
    if ([endD timeIntervalSinceDate:startD] > 24*60*60*7) {
        [HUD showHUDWithText:Localized(@"时间跨度最大不能超过7天") withDelay:1.2];
        return NO;
    }
    return YES;
}

@end
