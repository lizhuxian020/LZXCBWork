//
//  CBTrackSelectTimeView.h
//  Telematics
//
//  Created by coban on 2019/8/1.
//  Copyright © 2019 coban. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBTrackSelectTimeView : UIView

@property (nonatomic,copy) NSString *dno;
@property (nonatomic,copy) NSString *dateStrStar;
@property (nonatomic,copy) NSString *dateStrEnd;

- (BOOL)readyToRequest;
@end

NS_ASSUME_NONNULL_END
