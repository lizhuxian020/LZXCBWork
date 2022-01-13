//
//  FormDetailInfoViewController.h
//  Telematics
//
//  Created by lym on 2017/12/26.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "MINBaseViewController.h"

@interface FormDetailInfoViewController : MINBaseViewController
@property (nonatomic, copy) NSArray *dataArr;
@property (nonatomic, assign) int isShowDownloadBtn;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) int type; // 多媒体类型；0-图像，1-音频，2-视频
@end
