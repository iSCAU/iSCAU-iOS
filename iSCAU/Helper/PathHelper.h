//
//  PathHelper.h
//  iSCAU
//
//  Created by Alvin on 13-10-7.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PathHelper : NSObject

+ (NSString *)userDocumentPath;
+ (NSString *)classTableFileName;
+ (NSString *)marksCacheFileName;
+ (NSString *)borrowedBooksFileName;
+ (NSString *)borrowingBooksFileName;
+ (NSString *)pickClassFileName;
+ (NSString *)emptyClassroomParamsFileName;
+ (NSString *)likedCoursesFileName;
+ (NSString *)dislikedCoursesFileName;
@end
