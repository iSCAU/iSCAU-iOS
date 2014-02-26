//
//  PathHelper.m
//  iSCAU
//
//  Created by Alvin on 13-10-7.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "PathHelper.h"

@implementation PathHelper

+ (NSString *)userDocumentPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)classTableFileName {
    return [[PathHelper userDocumentPath] stringByAppendingPathComponent:@"classTable"];
}

+ (NSString *)borrowedBooksFileName {
    return [[PathHelper userDocumentPath] stringByAppendingPathComponent:@"borrowedBooks"];
}

+ (NSString *)borrowingBooksFileName {
    return [[PathHelper userDocumentPath] stringByAppendingPathComponent:@"borrowingBooks"];
}

+ (NSString *)pickClassFileName {
    return [[PathHelper userDocumentPath] stringByAppendingPathComponent:@"pickClass"];
}

+ (NSString *)marksCacheFileName {
    return [[PathHelper userDocumentPath] stringByAppendingPathComponent:@"marksCache"];
}

+ (NSString *)emptyClassroomParamsFileName {
    return [[PathHelper userDocumentPath] stringByAppendingPathComponent:@"emptyClassroomParams"];
}

@end
