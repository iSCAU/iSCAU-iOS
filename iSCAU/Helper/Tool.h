//
//  Tool.h
//  iSCAU
//
//  Created by Alvin on 13-9-10.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tool : NSObject

// Config helpers
+ (NSInteger)OSVersion;
+ (CGSize)calculateSizeWithString:(NSString *)string
                             font:(UIFont *)font
                   constrainWidth:(CGFloat)width;

+ (NSString *)encodeGB2312Str:(NSString *)encodeStr;
+ (NSString *)safeBase64Encode:(NSString *)string;

+ (NSArray *)schoolYear;
+ (void)setSchoolYear:(NSArray *)schoolYear;

+ (NSArray *)semester;
+ (void)setSemester:(NSArray *)semester;

+ (NSDictionary *)emptyClassroomParams;
+ (void)setEmptyClassroomParams:(NSDictionary *)params;

+ (UIColor *)indicatorColorAtIndex:(NSInteger)index;
+ (CGFloat)heightForNewsTitle:(NSString *)title;
+ (CGFloat)heightForNewsTitle:(NSString *)title fontSize:(CGFloat)fontSize;


// User settings
+ (void)setStuNum:(NSString *)stuNum
        andStuPwd:(NSString *)stuPwd
        andLibPwd:(NSString *)libPwd
       andCardPwd:(NSString *)cardPwd;

+ (void)setStuNum:(NSString *)stuNum
      andPassword:(NSString *)pwd
       andStuName:(NSString *)stuName
        andServer:(NSString *)server;

+ (NSString *)stuNum;
+ (NSString *)stuPwd;
+ (NSString *)libPwd;
+ (NSString *)cardPwd;
+ (NSString *)server;
+ (void)setServer:(NSString *)server;
+ (void)setSemesterStartDate:(NSString *)startDate;
+ (NSString *)semesterStartDate;


// View helper
+ (UITableViewCell *)loadMoreCellWithIdentifier:(NSString *)identifier;

// Time helper
+ (NSString *)timeStampParseWithDateString:(NSString *)dateString 
                       andOriginDateFormat:(NSString *)originDateFormat;

// UIBarButton helper
+ (UIBarButtonItem *)barButtonItemWithName:(NSString *)buttonName target:(id)target selector:(SEL)selector;

@end
