//
//  EduSysHttpClient.m
//  iSCAU
//
//  Created by Alvin on 13-9-10.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "EduSysHttpClient.h"

@implementation EduSysHttpClient

/** edusystem module */
// password need to base64urlsafeencode;
/*
 array('edusys/login/:username/:password/:server\d', 'Edusys/login', '', 'get', 'json,'),
 array('edusys/classtable/:username/:password/:server\d', 'Edusys/getClassTable', '', 'get', 'json,'),
 array('edusys/exam/:username/:password/:server\d', 'Edusys/getExam', '', 'get', 'json,'),
 array('edusys/goal/:username/:password/:server\d/:year/:team', 'Edusys/getGoal', '', 'get', 'json,'),
 array('edusys/pickclassinfo/:username/:password/:server\d', 'Edusys/getPickClassInfo', '', 'get', 'json,'),
 'Edusys/getEmptyClassRoom', '', 'get', 'json,'),
 array('edusys/params/emptyclassroom/:username/:password/:server\d',
 'Edusys/getEmptyClassRoomParameter', '', 'get', 'json,'),
 array('edusys/params/goal/:username/:password/:server\d',
 'Edusys/getGoalParameter', '', 'get', 'json,'),
  array('edusys/emptyclassroom/:username/:password/:server\d/:xq/:jslb/:ddlKsz/:ddlJsz/:xqj/:dsz/:sjd',
 */

+ (void)startRequestWithUrl:(NSString *)urlString
                    success:(SuccessedBlock)success
                    failure:(ErrorBlock)failure {
    NSString *encodedURL = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, nil, nil, kCFStringEncodingUTF8));
    NSLog(@"url %@", encodedURL);
    NSURL *url = [NSURL URLWithString:encodedURL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:60];
    __weak ASIHTTPRequest *weekRequest = request;
    [request setCompletionBlock:^{
        NSInteger httpCode = [weekRequest responseStatusCode];
        if (httpCode == EduUsernameError || httpCode == EduPasswordError) {
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_NOTICE_NOTIFICATION object:nil userInfo:@{ kNotice : @"账号或密码错误哦", kHideNoticeIntervel : @(kDefaultHideNoticeIntervel) }];
        } else if (httpCode == ServerError) {
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_NOTICE_NOTIFICATION object:nil userInfo:@{ kNotice : @"服务器挂了..换个接入点试试吧", kHideNoticeIntervel : @(kDefaultHideNoticeIntervel) }];
        } else if (httpCode == NullError) {
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_NOTICE_NOTIFICATION object:nil userInfo:@{ kNotice : @"没找到相关信息哦", kHideNoticeIntervel : @(kDefaultHideNoticeIntervel) }];
        }
        if (success != nil) {
            success([weekRequest responseData], [weekRequest responseStatusCode]);
        }
    }];
    [request setFailedBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_NOTICE_NOTIFICATION object:nil userInfo:@{ kNotice : kDefaultErrorNotice, kHideNoticeIntervel : @(kDefaultHideNoticeIntervel) }];
        if (failure != nil) {
            failure([weekRequest responseData], [weekRequest responseStatusCode]);
        }
    }];
    [request startAsynchronous];
}

+ (void)eduSysLoginWithStuNum:(NSString *)stuNum
                          pwd:(NSString *)pwd
                       server:(NSString *)server
                      success:(SuccessedBlock)success
                      failure:(ErrorBlock)failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/edusys/login/%@/%@/%@", HOST_NAME, stuNum, [Tool safeBase64Encode:pwd], server];
    [self startRequestWithUrl:urlString success:success failure:failure];
}

+ (void)eduSysGetClassTableSuccess:(SuccessedBlock)success failure:(ErrorBlock)failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/edusys/classtable/%@/%@/%@", HOST_NAME, [Tool stuNum], [Tool safeBase64Encode:[Tool stuPwd]], [Tool server]];
    [self startRequestWithUrl:urlString success:success failure:failure];
}

+ (void)eduSysGetExamSuccess:(SuccessedBlock)success
                     failure:(ErrorBlock)failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/edusys/exam/%@/%@/%@", HOST_NAME, [Tool stuNum], [Tool safeBase64Encode:[Tool stuPwd]], [Tool server]];
    [self startRequestWithUrl:urlString success:success failure:failure];
}

+ (void)eduSysGetMarksInfoSuccess:(SuccessedBlock)success
                          failure:(ErrorBlock)failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/edusys/params/goal/%@/%@/%@", HOST_NAME, [Tool stuNum], [Tool safeBase64Encode:[Tool stuPwd]], [Tool server]];
    [self startRequestWithUrl:urlString success:success failure:failure];
}

+ (void)eduSysGetMarksWithYear:(NSString *)year
                         tearm:(NSString *)term
                       success:(SuccessedBlock)success
                       failure:(ErrorBlock)failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/edusys/goal/%@/%@/%@/%@/%@", HOST_NAME, [Tool stuNum], [Tool safeBase64Encode:[Tool stuPwd]], [Tool server], year, term];
    [self startRequestWithUrl:urlString success:success failure:failure];
}

+ (void)eduSysGetPickClassInfoSuccess:(SuccessedBlock)success failure:(ErrorBlock)failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/edusys/pickclassinfo/%@/%@/%@", HOST_NAME, [Tool stuNum], [Tool safeBase64Encode:[Tool stuPwd]], [Tool server]];
    [self startRequestWithUrl:urlString success:success failure:failure];
}

+ (void)eduSysGetEmptyClassroomInfoSuccessWithXQ:(NSString *)xq 
                                            jslb:(NSString *)jslb 
                                          ddlKsz:(NSString *)ddlKsz 
                                          ddlJsz:(NSString *)ddlJsz
                                             xqj:(NSString *)xqj 
                                             dsz:(NSString *)dsz 
                                             sjd:(NSString *)sjd  
                                         success:(SuccessedBlock)success 
                                         failure:(ErrorBlock)failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/edusys/emptyclassroom/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@", HOST_NAME, [Tool stuNum], [Tool safeBase64Encode:[Tool stuPwd]], [Tool server], xq, jslb, ddlKsz, ddlJsz, xqj, dsz, sjd];
    [self startRequestWithUrl:urlString success:success failure:failure];
}

+ (void)eduSysGetEmptyClassroomParamsSuccess:(SuccessedBlock)success failure:(ErrorBlock)failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/edusys/params/emptyclassroom/%@/%@/%@", HOST_NAME, [Tool stuNum], [Tool safeBase64Encode:[Tool stuPwd]], [Tool server]];
    [self startRequestWithUrl:urlString success:success failure:failure];
}

@end
