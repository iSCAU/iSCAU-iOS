//
//  Notice.m
//  iSCAU
//
//  Created by Alvin on 3/18/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "Notice.h"

@implementation Notice

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ @"time" : @"time",
              @"title" : @"title",
              @"url" : @"url"};
}

@end
