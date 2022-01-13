//
//  NSString+LBExtension.m
//  Yiyingjia
//
//  Created by liu bin on 16/10/27.
//  Copyright © 2016年 liu bin. All rights reserved.
//

#import "NSString+LBExtension.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (LBExtension)

#pragma mark - 字符串空格处理
+ (NSString *)getNoSpacingText:(NSString *)aStr {
    NSString *aText = [[self class] getSafeString:aStr];
    return [aText stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+ (NSString *)getSafeString:(id)aObj {
    if (aObj == nil
        || [aObj isKindOfClass:[NSNull class]]) {
        return @"";
    }
    NSString *aText = [NSString stringWithFormat:@"%@",aObj];
    if ([aText.lowercaseString isEqualToString:@"<null>"]) {
        return @"";
    }
    return aText;
}

+ (NSInteger)getSafeIntValue:(id)aObj {
    NSString *aText = [NSString getSafeString:aObj];
    if ([aText isPureInt]) {
        return [aText integerValue];
    }
    return 0;
}

+ (CGFloat)getSafeFloatValue:(id)aObj {
    NSString *aText = [NSString getSafeString:aObj];
    if ([aText isPureFloat]) {
        return [aText floatValue];
    }
    return 0;
}

+ (double)getSafeDoubleValue:(id)aObj {
    NSString *aText = [NSString getSafeString:aObj];
    if ([aText isPureFloat]) {
        return [aText doubleValue];
    }
    return 0;
}

- (NSString *)deleteLastString:(NSString *)delStr {
    if ([self length] == 0 || [delStr length] == 0) {
        return self;
    }
    
    if ([self hasSuffix:delStr]) {
        return [self stringByReplacingCharactersInRange:NSMakeRange(self.length - delStr.length,delStr.length)
                                             withString:@""];
    }
    return self;
}

+ (NSString *)getSafeTrimString:(id)aObj {
    NSString *aStr = [[self class] getSafeString:aObj];
    aStr = [aStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return aStr;
}

- (BOOL)stateIsOk {
    return ([self isEqualToString:@"1"] || [self.lowercaseString isEqualToString:@"true"]);
}

#pragma mark - 计算文本高度
+ (UILabel *)calLab {
    return [[UILabel alloc] init];
}

+ (CGSize)attributeText:(NSAttributedString *)aText sizeWithMaxSize:(CGSize)maxSize {
    if (aText == nil || [aText length] == 0) {
        return CGSizeZero;
    }
    @autoreleasepool {
        UILabel *lab = [NSString calLab];
        lab.attributedText = aText;
        lab.numberOfLines = 0;
        lab.font = [UIFont systemFontOfSize:15];
        CGSize aSize = [lab sizeThatFits:maxSize];
        return CGSizeMake(MIN(ceilf(aSize.width),maxSize.width),MIN(ceilf(aSize.height),maxSize.height));
    }
}

- (CGFloat)getSpaceLabelHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    /** 行高 */
    paraStyle.lineSpacing = lineSpeace;
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    CGSize size = [self boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

- (CGSize)sizeFroTextWithMaxSize:(CGSize)maxSize
                            font:(UIFont *)aFont {
//    return [self boundingRectWithSize:maxSize
//                              options:NSStringDrawingUsesLineFragmentOrigin
//                           attributes:@{NSFontAttributeName:aFont}
//                              context:nil].size;
    return [self sizeFroTextWithMaxSize:maxSize
                                   font:aFont
                            lineSpacing:0
                              alignment:NSTextAlignmentLeft];
}

- (CGSize)sizeFroTextWithMaxSize:(CGSize)maxSize
                            font:(UIFont *)aFont
                     lineSpacing:(CGFloat)lineSpacing
                       alignment:(NSTextAlignment)alignment {
    return [self sizeFroTextWithMaxSize:maxSize
                                   font:aFont
                            lineSpacing:lineSpacing
                               lineCout:0
                              alignment:alignment];
}

- (CGSize)sizeFroTextWithMaxSize:(CGSize)maxSize
                            font:(UIFont *)aFont
                     lineSpacing:(CGFloat)lineSpacing
                        lineCout:(NSInteger)lineCount
                       alignment:(NSTextAlignment)alignment {
    if ([self length] == 0) {
        return CGSizeZero;
    }
    
    if (lineSpacing > 0) {
        NSMutableParagraphStyle *aStyle = [[NSMutableParagraphStyle alloc] init];
        aStyle.lineSpacing = lineSpacing;
        aStyle.alignment = alignment;
        aStyle.lineBreakMode = NSLineBreakByTruncatingTail;
//        return [self boundingRectWithSize:maxSize
//                                  options:NSStringDrawingUsesLineFragmentOrigin
//                               attributes:@{
//                                            NSFontAttributeName:aFont,
//                                            NSParagraphStyleAttributeName:aStyle
//                                            }
//                                  context:nil].size;
        
        @autoreleasepool {
            NSMutableAttributedString *attStr =
            [[NSMutableAttributedString alloc] initWithString:self
                                                   attributes:@{
                                                                NSFontAttributeName : aFont,
                                                                NSParagraphStyleAttributeName : aStyle
                                                                }];
            UILabel *lab = [NSString calLab];
            lab.font = aFont;
            lab.attributedText = attStr;
            lab.numberOfLines = lineCount;
            CGSize aSize = [lab sizeThatFits:maxSize];
            return CGSizeMake(MIN(ceilf(aSize.width),maxSize.width),MIN(ceilf(aSize.height),maxSize.height));
        }
    }else{
        @autoreleasepool {
            UILabel *lab = [NSString calLab];
            lab.font = aFont;
            lab.text = self;
            lab.numberOfLines = lineCount;
            CGSize aSize = [lab sizeThatFits:maxSize];
            return CGSizeMake(MIN(ceilf(aSize.width),maxSize.width),MIN(ceilf(aSize.height),maxSize.height));
        }
    }
}

#pragma mark - URL Encode Decode
//URL编码
- (NSString *)encodeToPercentEscapeString {
    if ([self length] == 0) {
        return self;
    }
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *outputStr = (NSString *)
//    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                              (CFStringRef)self,
//                                                              NULL,
//                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
//                                                              kCFStringEncodingUTF8));
//    return outputStr;
}

//URL解码
- (NSString *)decodeFromPercentEscapeString{
    if ([self length] == 0) {
        return @"";
    }
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *decodedString  =
//    (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,(__bridge CFStringRef)self,CFSTR(""),
//                                                                                          CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
//    return [NSString getSafeString:decodedString];
}

#pragma mark - 类型判断
//判断字符串是否是整型
- (BOOL)isPureInt {
    if (0 == [self length]){
        return NO;
    }
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)isPureFloat {
    if (0 == [self length]){
        return NO;
    }
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)isPureLong {
    if (0 == [self length]){
        return NO;
    }
    NSScanner* scan = [NSScanner scannerWithString:self];
    long long val;
    return[scan scanLongLong:&val] && [scan isAtEnd];
}

//是否全部为中文
- (BOOL)isChineseText {
    NSInteger len = [self length];
    if (len == 0) {
        return NO;
    }
    for (NSInteger i = 0; i < len;++i){
        unichar ch = [self characterAtIndex:i];
        if( ch <= 0x4e00 || ch >= 0x9fff){
            return NO;
        }
    }
    return YES;
}

#pragma mark - 字符串处理
//替换url中的参数
- (NSString *)replaceParamsWithValue:(NSString *)valueText
                              forKey:(NSString *)aKey {
    if ([self length] == 0) {
        return @"";
    }
    NSString *urlText = [NSString getSafeString:self];
    if ([aKey length] == 0) {
        return urlText;
    }
    NSString *matchStr = [NSString stringWithFormat:@"%@=",aKey];
    if ([urlText containsString:matchStr]) {
        NSMutableArray *aList = [NSMutableArray arrayWithCapacity:2];
        [aList addObjectsFromArray:[urlText componentsSeparatedByString:matchStr]];
        if ([aList count] == 1) {
            return [NSString stringWithFormat:@"%@%@%@",aList[0],matchStr,[NSString getSafeString:valueText]];
        }
        
        NSString *lastStr = aList[1];
        NSRange aRan = [lastStr rangeOfString:@"&"];
        if (aRan.location != NSNotFound && aRan.length > 0) {
            lastStr = [NSString stringWithFormat:@"%@%@",valueText,[lastStr substringFromIndex:aRan.location]];
        }else{
            lastStr = [NSString getSafeString:valueText];
        }
        [aList replaceObjectAtIndex:1 withObject:lastStr];
        
        NSString *resultText = @"";
        for (NSString *sText in aList) {
            resultText = [resultText stringByAppendingFormat:@"%@%@",sText,matchStr];
        }
        if ([resultText hasSuffix:matchStr]) {
            resultText = [resultText substringToIndex:([resultText length] - [matchStr length])];
        }
        return resultText;
    }else{
        if ([urlText containsString:@"?"]) {
            if (![urlText hasSuffix:@"?"]) {
                return [NSString stringWithFormat:@"%@&%@%@",urlText,matchStr,valueText];
            }else{
                return [NSString stringWithFormat:@"%@%@%@",urlText,matchStr,valueText];
            }
        }else{
            return [NSString stringWithFormat:@"%@?%@%@",urlText,matchStr,valueText];
        }
    }
}

//获取URL中的参数
- (NSDictionary *)getParamsFromUrl {
    NSString *urlText = [NSString getSafeString:self];
    if ([urlText length] == 0) {
        return nil;
    }
    NSArray *aList = [urlText componentsSeparatedByString:@"?"];
    if ([aList count] < 2) {
        return nil;
    }
    
    NSString *pText = [NSString getSafeString:aList[1]];
    if ([pText length] == 0) {
        return nil;
    }
    
    NSArray *pList = [pText componentsSeparatedByString:@"&"];
    NSMutableDictionary *pDict = [NSMutableDictionary dictionaryWithCapacity:2];
    for (NSString *paramText in pList) {
        NSArray *paramList = [paramText componentsSeparatedByString:@"="];
        if ([paramList count] == 2) {
            pDict[paramList[0]] = paramList[1];
        }else if ([paramList count] == 1) {
            pDict[paramList[0]] = @"";
        }
    }
    return pDict;
}

#pragma mark - 其他
//判断是否是Email格式或者手机号
- (BOOL)isEmailOrPhoneNumber{
    NSString *patternPhoneNumber = @"^((1[0-9])|(1[0-9])|(1[0-9]))\\d{9}$";
    NSString *patternEmail = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    NSError *error = NULL;
    //定义正则表达式
    NSRegularExpression *regexPhoneNumber = [NSRegularExpression regularExpressionWithPattern:patternPhoneNumber options:0 error:&error];
    NSRegularExpression *regexEmail = [NSRegularExpression regularExpressionWithPattern:patternEmail options:0 error:&error];
    //使用正则表达式匹配字符
    NSTextCheckingResult *isMatchPhoneNumber = [regexPhoneNumber firstMatchInString:self
                                                                            options:0
                                                                              range:NSMakeRange(0, [self length])];
    NSTextCheckingResult *isMatchEmail = [regexEmail firstMatchInString:self
                                                                options:0
                                                                  range:NSMakeRange(0, [self length])];
    
    if (isMatchPhoneNumber || isMatchEmail){
        return YES;
    }else{
        return NO;
    }
}

- (NSString *)md5Text {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)createRandomString:(NSInteger)len {
    time_t now;
    time(&now);
    NSString *time_stamp = [NSString stringWithFormat:@"%ld",(long)now];
    return time_stamp;
}

- (NSString *)replaceSeceretStarInRange:(NSRange)aRange {
    NSInteger len = [self length];
    if (aRange.location == NSNotFound
        || aRange.length == NSNotFound
        || aRange.length <= 0) {
        return self;
    }
    if (aRange.location >= len - aRange.length) {
        return self;
    }
    
    NSString *aStr = [self substringToIndex:aRange.location];
    for (NSInteger i = 0;i < aRange.length;++i) {
        if (i >= len - aRange.location) {
            break;
        }
        aStr = [aStr stringByAppendingString:@"*"];
    }
    if (aRange.location + aRange.length < len) {
        aStr = [aStr stringByAppendingString:[self substringFromIndex:aRange.location + aRange.length]];
    }
    
    return aStr;
}

- (NSString *)insertBlankWithSpace:(NSInteger)space {
    NSInteger len = [self length];
    if (len <= space) {
        return self;
    }
    NSInteger i = space;
    NSString *aStr = [self substringToIndex:i];
    while (i < len) {
        NSString *bStr = [self substringWithRange:NSMakeRange(i,MIN(space,len - i))];
        if (len - i < space) {
            aStr = [aStr stringByAppendingString:bStr];
        }else{
            aStr = [aStr stringByAppendingFormat:@" %@",bStr];
        }
        i += space;
    }
    return aStr;
}
- (NSString *)hasStringInPrefix:(NSString *)prefix {
    if ([self hasPrefix:prefix]) {
        return self;
    }
    return [prefix stringByAppendingString:self];
}
@end
