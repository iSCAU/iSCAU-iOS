//
//  CEHttpClient.m
//  iSCAU
//
//  Created by Alvin on 3/14/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "CEHttpClient.h"
#import <ASIHTTPRequest/ASIFormDataRequest.h>

NSString * const CourseInfoCourseKey = @"courses";
NSString * const CourseInfoStatusKey = @"status";
NSString * const CourseInfoCommentsKey = @"comments";
NSString * const CourseInfoCountKey = @"count";
NSString * const CourseInfoSumPageKey = @"sumPage";
NSString * const CourseInofResultKey = @"result";
NSString * const CourseInfoResultError = @"error";
NSString * const CourseInfoResultSuccess = @"success";
NSString * const CourseInfoStatusInvalid = @"invalid request";

@interface CEHttpClient ()

@property (nonatomic, strong) ASIFormDataRequest *formDataRequest;

@end

@implementation CEHttpClient

+ (instancetype)shareInstance 
{
    static CEHttpClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[CEHttpClient alloc] init];
    });
    return sharedClient;
}

- (void)startRequestWithUrl:(NSString *)urlString
                    success:(SuccessedBlock)success
                    failure:(ErrorBlock)failure 
{
    [self cancleRequest];
    NSLog(@"%@", urlString);
    
    NSString *encodedURL = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, nil, nil, kCFStringEncodingUTF8));
    
    self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:encodedURL]];
    [self.request setTimeOutSeconds:60];
    
    __weak ASIHTTPRequest *weekRequest = self.request;
    
    [self.request setCompletionBlock:^{
        NSInteger httpCode = [weekRequest responseStatusCode];
        
        if (httpCode == EduUsernameError || httpCode == EduPasswordError) {
            NSDictionary *dict = @{ kNotice : @"账号或密码错误哦，要重新登录吗？" };
            POST_NOTIFICATION(SUGGEST_LOGIN_AGAIN_NOTIFICATION, dict);
            POST_NOTIFICATION(HIDE_NOTICE_NOTIFICATION, nil);
            
        } else if (httpCode == ServerError) {
            NSDictionary *dict = @{ kNotice : @"服务器挂了..换个接入点试试吧" };
            POST_NOTIFICATION(SUGGEST_LOGIN_AGAIN_NOTIFICATION, dict);
            POST_NOTIFICATION(HIDE_NOTICE_NOTIFICATION, nil);
            
        } else if (httpCode == NullError) {
            NSDictionary *dict = @{ kNotice : @"没找到相关信息哦", kHideNoticeIntervel : @(kDefaultHideNoticeIntervel) };
            POST_NOTIFICATION(SHOW_NOTICE_NOTIFICATION, dict);
        }
        if (success != nil) {
            success([weekRequest responseData], [weekRequest responseStatusCode]);
        }
    }];
    [self.request setFailedBlock:^{        
        NSDictionary *dict = @{ kNotice : kDefaultErrorNotice, kHideNoticeIntervel : @(kDefaultHideNoticeIntervel) };
        POST_NOTIFICATION(SHOW_NOTICE_NOTIFICATION, dict);
        
        if (failure != nil) {
            failure([weekRequest responseData], [weekRequest responseStatusCode]);
        }
    }];
    [self.request startAsynchronous];
}

- (void)postRequestWithUrl:(NSString *)urlString 
                    params:(NSDictionary *)params 
                   success:(SuccessedBlock)success
                   failure:(ErrorBlock)failure
{
    [self cancleRequest];
    NSLog(@"%@", urlString);
    
    NSString *encodedURL = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, nil, nil, kCFStringEncodingUTF8));
    
    self.formDataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:encodedURL]];
    [self.formDataRequest setTimeOutSeconds:60];
    
    for (NSString *key in [params allKeys]) {
        [self.formDataRequest setPostValue:params[key] forKey:key];
    }
    
    __weak ASIFormDataRequest *weekFormDataRequest = self.formDataRequest;
    
    [self.request setCompletionBlock:^{
        NSInteger httpCode = [weekFormDataRequest responseStatusCode];
        
        if (httpCode == EduUsernameError || httpCode == EduPasswordError) {
            NSDictionary *dict = @{ kNotice : @"账号或密码错误哦，要重新登录吗？" };
            POST_NOTIFICATION(SUGGEST_LOGIN_AGAIN_NOTIFICATION, dict);
            POST_NOTIFICATION(HIDE_NOTICE_NOTIFICATION, nil);
            
        } else if (httpCode == ServerError) {
            NSDictionary *dict = @{ kNotice : @"服务器挂了..换个接入点试试吧" };
            POST_NOTIFICATION(SUGGEST_LOGIN_AGAIN_NOTIFICATION, dict);
            POST_NOTIFICATION(HIDE_NOTICE_NOTIFICATION, nil);
            
        } else if (httpCode == NullError) {
            NSDictionary *dict = @{ kNotice : @"没找到相关信息哦", kHideNoticeIntervel : @(kDefaultHideNoticeIntervel) };
            POST_NOTIFICATION(SHOW_NOTICE_NOTIFICATION, dict);
        }
        if (success != nil) {
            success([weekFormDataRequest responseData], [weekFormDataRequest responseStatusCode]);
        }
    }];
    [self.request setFailedBlock:^{        
        NSDictionary *dict = @{ kNotice : kDefaultErrorNotice, kHideNoticeIntervel : @(kDefaultHideNoticeIntervel) };
        POST_NOTIFICATION(SHOW_NOTICE_NOTIFICATION, dict);
        
        if (failure != nil) {
            failure([weekFormDataRequest responseData], [weekFormDataRequest responseStatusCode]);
        }
    }];
    [self.request startAsynchronous];
}

- (void)searchCoursesWithKeyword:(NSString *)keyword 
                         success:(SuccessedBlock)success 
                         failure:(ErrorBlock)failure
{
    NSString *urlString = [NSString stringWithFormat:@"%@/search/keyword/%@", COURSE_EVALUATION, keyword];
    [self startRequestWithUrl:urlString success:success failure:failure];
}

- (void)getCommentsWithCourseId:(NSString *)courseId 
                           page:(NSInteger)page
                        success:(SuccessedBlock)success 
                        failure:(ErrorBlock)failure
{
    NSString *urlString = [NSString stringWithFormat:@"%@/comment/courseId/%@/page/%d", COURSE_EVALUATION, courseId, page];
    [self startRequestWithUrl:urlString success:success failure:failure];
}

- (void)addCommentWithCourseId:(NSString *)courseId 
                      userName:(NSString *)username 
                       isCheck:(BOOL)isCheck 
                   hasHomework:(BOOL)hasHomework 
                      examType:(NSString *)examType 
                       comment:(NSString *)comment 
                       success:(SuccessedBlock)success 
                       failure:(ErrorBlock)failure
{
    NSString *isCheckParam = isCheck ? @"1" : @"0";
    NSString *hasHomeworkParam = hasHomework ? @"1" : @"0";
    NSDictionary *params = @{ @"userName" : username,
                              @"courseId" : courseId,
                              @"isCheck" : isCheckParam,
                              @"hasHomework" : hasHomeworkParam, 
                              @"exam" : examType,
                              @"comment" : comment};
    
    NSString *urlString =  [NSString stringWithFormat:@"%@/addComment", COURSE_EVALUATION];
    [self postRequestWithUrl:urlString 
                      params:params 
                     success:success
                     failure:failure];
}

- (void)likedTheCourseWithCourseId:(NSString *)courseId 
                          userName:(NSString *)username 
                           success:(SuccessedBlock)success 
                           failure:(ErrorBlock)failure
{
    NSDictionary *params = @{ @"courseId" : courseId,
                              @"username" : username };
    
    NSString *urlString =  [NSString stringWithFormat:@"%@/likedCounrse", COURSE_EVALUATION];
    [self postRequestWithUrl:urlString 
                      params:params 
                     success:success
                     failure:failure];
}

- (void)dislikedTheCourseWithCourseId:(NSString *)courseId 
                             userName:(NSString *)username 
                              success:(SuccessedBlock)success 
                              failure:(ErrorBlock)failure
{
    NSDictionary *params = @{ @"courseId" : courseId,
                              @"username" : username };
    
    NSString *urlString =  [NSString stringWithFormat:@"%@/dislikedCounrse", COURSE_EVALUATION];
    [self postRequestWithUrl:urlString 
                      params:params 
                     success:success
                     failure:failure];
}

@end
