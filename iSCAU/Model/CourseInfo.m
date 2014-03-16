//
//  CourseInfo.m
//  iSCAU
//
//  Created by Alvin on 3/14/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "CourseInfo.h"

@implementation CourseInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"courseId"    : @"CourseId",
             @"courseName"  : @"CourseName",
             @"teacher"     : @"Teacher",
             @"property"    : @"Property",
             @"score"       : @"Score",
             @"liked"       : @"Liked",
//             @"commentCount": @"count",
             @"disliked"    : @"Disliked"
             };
}

@end
