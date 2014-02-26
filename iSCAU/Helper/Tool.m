//
//  Tool.m
//  iSCAU
//
//  Created by Alvin on 13-9-10.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "Tool.h"
#import <CoreText/CoreText.h>
#import <NSData+Base64/NSData+Base64.h>

#define SCHOOL_YEAR             @"SCHOOL_YEAR"
#define SEMESTER                @"SEMESTER"
#define kEmptyClassroomParams   @"EmptyClassroomParams"

@implementation Tool

#pragma mark - 

+ (NSInteger)OSVersion
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

+ (CGSize)calculateSizeWithString:(NSString *)string
                             font:(UIFont *)font
                   constrainWidth:(CGFloat)width {
    CGSize expectSize = CGSizeZero;
    if ([Tool OSVersion] >= 7) {
        expectSize = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{UITextAttributeFont : font} context:nil].size;
    } else {
        expectSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    }
    return expectSize;
}

#pragma mark Encode Chinese to GB2312 in URL
+ (NSString *)encodeGB2312Str:(NSString *)encodeStr {
    CFStringRef nonAlphaNumValidChars = CFSTR("![        DISCUZ_CODE_1        ]’()*+,-./:;=?@_~");
    NSString *preprocessedString = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)encodeStr, CFSTR(""), kCFStringEncodingGB_18030_2000));
    NSString *newStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingGB_18030_2000));
    return newStr;
}

+ (NSString *)safeBase64Encode:(NSString *)string {
    if (string == nil) return nil;
    
    NSString *unsafeStr = [[string dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
//    return unsafeStr;
    unsafeStr = [unsafeStr stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    unsafeStr = [unsafeStr stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return unsafeStr;
}

+ (NSArray *)schoolYear {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:SCHOOL_YEAR];
}

+ (void)setSchoolYear:(NSArray *)schoolYear {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:schoolYear forKey:SCHOOL_YEAR];
    [def synchronize];
}

+ (NSArray *)semester {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:SEMESTER];
}

+ (void)setSemester:(NSArray *)semester {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:semester forKey:SEMESTER];
    [def synchronize];
}

+ (UIColor *)indicatorColorAtIndex:(NSInteger)index {
    NSInteger colorIndex = index % 4;
    switch (colorIndex) {
        case 0:
            return [UIColor colorFromHexRGB:@"0x0140ca" alpha:1];
        case 1:
            return [UIColor colorFromHexRGB:@"0x16a61e" alpha:1];
        case 2:
            return [UIColor colorFromHexRGB:@"0xdd1812" alpha:1];
        case 3:
            return [UIColor colorFromHexRGB:@"0xfcca03" alpha:1];
        default:
            return [UIColor colorFromHexRGB:@"0x0140ca" alpha:1];
    }
}

+ (CGFloat)heightForNewsTitle:(NSString *)title {
    CGFloat fontSize = 15;
    CGSize titleLabelMaxSize = CGSizeMake(290, CGFLOAT_MAX);
    if (SystemVersion_floatValue >= 7.0) {
        CGFloat heightIndent = 3.0f;
        NSDictionary *attributes = @{ (NSString *)kCTFontAttributeName : [UIFont boldSystemFontOfSize:fontSize] };
        CGRect frame = [title boundingRectWithSize:titleLabelMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        frame.size.height += heightIndent;
        return frame.size.height;
    }
    CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:fontSize] constrainedToSize:titleLabelMaxSize lineBreakMode:NSLineBreakByWordWrapping];
    return size.height;
}

+ (CGFloat)heightForNewsTitle:(NSString *)title fontSize:(CGFloat)fontSize {
    CGSize titleLabelMaxSize = CGSizeMake(290, CGFLOAT_MAX);
    if (SystemVersion_floatValue >= 7.0) {
        CGFloat heightIndent = 3.0f;
        NSDictionary *attributes = @{ (NSString *)kCTFontAttributeName : [UIFont boldSystemFontOfSize:fontSize] };
        CGRect frame = [title boundingRectWithSize:titleLabelMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        frame.size.height += heightIndent;
        return frame.size.height;
    }
    CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:fontSize] constrainedToSize:titleLabelMaxSize lineBreakMode:NSLineBreakByWordWrapping];
    return size.height;
}

+ (NSDictionary *)emptyClassroomParams {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:kEmptyClassroomParams];
}

+ (void)setEmptyClassroomParams:(NSDictionary *)params {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:params forKey:kEmptyClassroomParams];
    [def synchronize];
}

#pragma mark - User settings

+ (void)setStuNum:(NSString *)stuNum andStuPwd:(NSString *)stuPwd andLibPwd:(NSString *)libPwd andCardPwd:(NSString *)cardPwd {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:stuNum forKey:EDU_SYS_stuNum];
    [def setObject:stuPwd forKey:EDU_SYS_password];
    [def setObject:libPwd forKey:Library_password];
    [def setObject:cardPwd forKey:CampusCard_password];
    [def synchronize];
}

+ (void)setStuNum:(NSString *)stuNum
      andPassword:(NSString *)pwd
       andStuName:(NSString *)stuName
        andServer:(NSString *)server {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:EDU_SYS_stuNum];
    [def removeObjectForKey:EDU_SYS_password];
    [def removeObjectForKey:EDU_SYS_stuName];
    [def removeObjectForKey:EDU_SYS_server];
    
    [def setObject:stuNum forKey:EDU_SYS_stuNum];
    [def setObject:pwd forKey:EDU_SYS_password];
    [def setObject:stuName forKey:EDU_SYS_stuName];
    [def setObject:server forKey:EDU_SYS_server];
    [def synchronize];
}

+ (NSString *)stuNum {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:EDU_SYS_stuNum];
}

+ (NSString *)stuPwd {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:EDU_SYS_password];
}

+ (NSString *)libPwd {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:Library_password];
}

+ (NSString *)cardPwd {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:CampusCard_password];
}

+ (void)setServer:(NSString *)server {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:server forKey:EDU_SYS_server];
    [def synchronize];
}

+ (NSString *)server {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *server = [def objectForKey:EDU_SYS_server];
    if (server) {
        return server;
    } else {
        return @"1";
    }
}

+ (void)setSemesterStartDate:(NSString *)startDate {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:startDate forKey:SEMESTER_START_DATE];
    [def synchronize];
}

+ (NSString *)semesterStartDate {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    id date = [def objectForKey:SEMESTER_START_DATE];
    return date ? date : nil;
}



@end
