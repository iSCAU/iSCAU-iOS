//
//  CourseComment.m
//  iSCAU
//
//  Created by Alvin on 3/15/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "CourseComment.h"

@implementation CourseComment

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ @"_id": @"Id",
              @"userName" : @"UserName",
              @"courseId" : @"CourseId",
              @"hasHomework" : @"hasHomework",
              @"isCheck" : @"isCheck",
              @"examType" : @"Exam",
              @"comment" : @"Comment",
              @"timeString" : @"time"};
}

- (NSString *)timeStamp
{
    return [Tool timeStampParseWithDateString:self.timeString 
                          andOriginDateFormat:@"yyyy/MM/dd HH:mm:ss"];
}

@end
