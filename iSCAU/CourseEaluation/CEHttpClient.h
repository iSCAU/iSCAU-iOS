//
//  CEHttpClient.h
//  iSCAU
//
//  Created by Alvin on 3/14/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "BaseHttpClient.h"

extern NSString * const CourseInfoCourseKey;
extern NSString * const CourseInfoStatusKey;
extern NSString * const CourseInfoCommentsKey;
extern NSString * const CourseInfoCountKey;
extern NSString * const CourseInfoSumPageKey;
extern NSString * const CourseInofResultKey;
extern NSString * const CourseInfoResultError;
extern NSString * const CourseInfoResultSuccess;
extern NSString * const CourseInfoStatusInvalid;

@interface CEHttpClient : BaseHttpClient

- (void)searchCoursesWithKeyword:(NSString *)keyword 
                         success:(SuccessedBlock)success
                         failure:(ErrorBlock)failure;

- (void)getCommentsWithCourseId:(NSString *)courseId 
                           page:(NSInteger)page
                        success:(SuccessedBlock)success
                        failure:(ErrorBlock)failure;

- (void)addCommentWithCourseId:(NSString *)courseId 
                      userName:(NSString *)username 
                       isCheck:(BOOL)isCheck 
                   hasHomework:(BOOL)hasHomework 
                      examType:(NSString *)examType 
                       comment:(NSString *)comment 
                       success:(SuccessedBlock)success
                       failure:(ErrorBlock)failure;

- (void)likedTheCourseWithCourseId:(NSString *)courseId 
                          userName:(NSString *)username 
                           success:(SuccessedBlock)success
                           failure:(ErrorBlock)failure;

- (void)dislikedTheCourseWithCourseId:(NSString *)courseId 
                             userName:(NSString *)username 
                              success:(SuccessedBlock)success
                              failure:(ErrorBlock)failure;

@end
