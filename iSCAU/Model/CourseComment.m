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
	NSString *_timestamp;
    // Calculate distance time string
    //
    time_t now;
    time(&now);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:self.timeString];
    NSLog(@"%@ %@", date, self.timeString);
    double distance = - [date timeIntervalSinceNow];
     
    if (distance < 60) {
        _timestamp = [NSString stringWithFormat:@"%.0f%@", distance, (distance == 1) ? @"秒前" : @"秒前"];
    }
    else if (distance < 60 * 60) {  
        distance = distance / 60;
        _timestamp = [NSString stringWithFormat:@"%.0f%@", distance, (distance == 1) ? @"分钟前" : @"分钟前"];
    }  
    else if (distance < 60 * 60 * 24) {
        distance = distance / 60 / 60;
        _timestamp = [NSString stringWithFormat:@"%.0f%@", distance, (distance == 1) ? @"小时前" : @"小时前"];
    }
    else if (distance < 60 * 60 * 24 * 7) {
        distance = distance / 60 / 60 / 24;
        _timestamp = [NSString stringWithFormat:@"%.0f%@", distance, (distance == 1) ? @"天前" : @"天前"];
    }
    else if (distance < 60 * 60 * 24 * 7 * 4) {
        distance = distance / 60 / 60 / 24 / 7;
        _timestamp = [NSString stringWithFormat:@"%.0f%@", distance, (distance == 1) ? @"周前" : @"周前"];
    }
    else {
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        }
        
        _timestamp = [dateFormatter stringFromDate:date];
    }
    return _timestamp;
}

@end
