//
//  AZNewsHttpClient.m
//  iSCAU
//
//  Created by Alvin on 2/17/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "AZNewsHttpClient.h"
#import <Base64/MF_Base64Additions.h>

@implementation AZNewsHttpClient

/*
 notice module 
 // url need to base64urlsafeencode;
 array('notice/getlist/:page\d', 'Notice/getNoticeList', '', 'get', 'json,'),
 array('notice/getcontent/:url', 'Notice/getNoticeContent', '', 'get', 'json,'),
 */

+ (instancetype)shareInstance 
{
    static AZNewsHttpClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[AZNewsHttpClient alloc] init];
    });
    return sharedClient;
}

- (void)startRequestWithUrl:(NSString *)urlString
                    success:(SuccessedBlock)success
                    failure:(ErrorBlock)failure 
{
    NSLog(@"url %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    __weak ASIHTTPRequest *weekRequest = request;
    [request setCompletionBlock:^{
        success([weekRequest responseData], [weekRequest responseStatusCode]);
    }];
    [request setFailedBlock:^{
        if (failure != nil) {
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_NOTICE_NOTIFICATION object:nil userInfo:@{ kNotice : kDefaultErrorNotice, kHideNoticeIntervel : @(kDefaultHideNoticeIntervel) }];
            failure([weekRequest responseData], [weekRequest responseStatusCode]);
        }
    }];
    [request startAsynchronous];
}

- (void)newsGetListWithPage:(NSInteger)page 
                    success:(SuccessedBlock)success
                    failure:(ErrorBlock)failure 
{
    NSString *urlString = [NSString stringWithFormat:@"%@/notice/getlist/%@", HOST_NAME, @(page)];
    [self startRequestWithUrl:urlString success:success failure:failure];
}

- (void)newsGetContentWithURL:(NSString *)url 
                      success:(SuccessedBlock)success
                      failure:(ErrorBlock)failure 
{
    NSString *urlString = [NSString stringWithFormat:@"%@/notice/getcontent/%@", HOST_NAME, [url base64String]];
    [self startRequestWithUrl:urlString success:success failure:failure];
}

@end
