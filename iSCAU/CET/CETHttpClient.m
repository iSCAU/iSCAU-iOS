//
//  CETHttpClient.m
//  iSCAU
//
//  Created by Alvin on 3/18/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "CETHttpClient.h"

@implementation CETHttpClient

+ (instancetype)shareInstance 
{
    static CETHttpClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[CETHttpClient alloc] init];
    });
    return sharedClient;
}

- (void)startRequestWithUrl:(NSString *)urlString
                    success:(SuccessedBlock)success
                    failure:(ErrorBlock)failure 
{
    [self cancleRequest];
    NSLog(@"url %@", urlString);
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

- (void)queryMarksWithCetNum:(NSString *)cetNum 
                    username:(NSString *)username 
                     success:(SuccessedBlock)success 
                     failure:(ErrorBlock)failure
{
    NSString *urlString = [NSString stringWithFormat:@"%@/cet/querymarks?cetnum=%@&username=%@", @"http://192.168.199.147:8890", cetNum, username];
    [self startRequestWithUrl:urlString success:success failure:failure];
}

@end
