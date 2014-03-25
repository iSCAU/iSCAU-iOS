//
//  CetMark.m
//  iSCAU
//
//  Created by Alvin on 3/19/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "CetMark.h"

@implementation CetMark

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ @"name" : @"name",
              @"school" : @"school",
              @"type" : @"type",
              @"cetNum" : @"cet_num",
              @"examTime" : @"exam_time",
              @"totalMark" : @"total_mark",
              @"listening" : @"listening",
              @"reading" : @"reading",
              @"writing" : @"writing"};
}

@end
