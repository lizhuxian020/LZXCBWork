//
//  _CBInstallInfo.h
//  cobanBnPetSwift
//
//  Created by lee on 2022/12/3.
//  Copyright © 2022 coban. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface _CBInstallInfo : NSObject

@property(nonatomic, copy) NSString *installer;//
@property(nonatomic, copy) NSString *installCompany;//
@property(nonatomic, copy) NSString *installTime;//
@property(nonatomic, copy) NSString *installLocation;//
@property(nonatomic, copy) NSString *driverName;//
@property(nonatomic, copy) NSString *installMobile;//
@property(nonatomic, copy) NSString *vinCode;//
@property(nonatomic, copy) NSString *engineNumber;//
@property(nonatomic, copy) NSString *vehicleBrand;//
@property(nonatomic, copy) NSString *installPicture;

@end

NS_ASSUME_NONNULL_END
