//
//  NSString+LBExtension.h
//  Yiyingjia
//
//  Created by liu bin on 16/10/27.
//  Copyright © 2016年 liu bin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LBExtension)

//获取无空格字符
+ (NSString *)getNoSpacingText:(NSString *)aStr;
+ (NSString *)getSafeString:(id)aObj;
+ (NSInteger)getSafeIntValue:(id)aObj;
+ (CGFloat)getSafeFloatValue:(id)aObj;
+ (double)getSafeDoubleValue:(id)aObj;
+ (NSString *)getSafeTrimString:(id)aObj;
- (NSString *)deleteLastString:(NSString *)delStr;
- (BOOL)stateIsOk;

+ (CGSize)attributeText:(NSAttributedString *)aText sizeWithMaxSize:(CGSize)maxSize;
- (CGSize)sizeFroTextWithMaxSize:(CGSize)maxSize
                            font:(UIFont *)aFont;
- (CGSize)sizeFroTextWithMaxSize:(CGSize)maxSize
                            font:(UIFont *)aFont
                     lineSpacing:(CGFloat)lineSpacing
                       alignment:(NSTextAlignment)alignment;
- (CGSize)sizeFroTextWithMaxSize:(CGSize)maxSize
                            font:(UIFont *)aFont
                     lineSpacing:(CGFloat)lineSpacing
                        lineCout:(NSInteger)lineCount
                       alignment:(NSTextAlignment)alignment;

//判断手机号或邮箱是否合法
- (BOOL)isEmailOrPhoneNumber;
- (NSString *)md5Text;
//创建随机字符串
+ (NSString *)createRandomString:(NSInteger)len;

//URL编、解码
- (NSString *)encodeToPercentEscapeString;
- (NSString *)decodeFromPercentEscapeString;

//判断字符串是否是整型
- (BOOL)isPureInt;
//判断是否为浮点形：
- (BOOL)isPureFloat;
//判断是否为浮点形：
- (BOOL)isPureLong;
//是否全部为中文
- (BOOL)isChineseText;

//替换url中的参数
- (NSString *)replaceParamsWithValue:(NSString *)valueText
                              forKey:(NSString *)aKey;
//获取URL中的参数
- (NSDictionary *)getParamsFromUrl;

//在某个范围内用*替换
- (NSString *)replaceSeceretStarInRange:(NSRange)aRange;
- (NSString *)insertBlankWithSpace:(NSInteger)space;

- (NSString *)hasStringInPrefix:(NSString *)prefix;

@end
