//
//  NSData+md5.m
//  cuiyuan
//
//  Created by 周浩 on 15/2/27.
//  Copyright (c) 2015年 zhubao. All rights reserved.
//

#import "NSData+md5.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSData (md5)
- (NSString *)md5String{
    const char *str = [self bytes];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)self.length, result);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    
    return [hash lowercaseString];
}
@end
