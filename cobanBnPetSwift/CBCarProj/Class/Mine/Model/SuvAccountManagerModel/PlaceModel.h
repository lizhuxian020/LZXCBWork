//
//  PlaceModel.h
//  Telematics
//
//  Created by lym on 2017/12/29.
//  Copyright © 2017年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceModel : NSObject
@property (nonatomic, strong) NSNumber *placeId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *parentId;
@end
