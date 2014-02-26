//
//  LibHttpClient.m
//  iSCAU
//
//  Created by Alvin on 13-9-11.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "LibHttpClient.h"

@implementation LibHttpClient

/** library module
 // password need to base64urlsafeencode;
 array('lib/login/:username/:password', 'Lib/login', '', 'get', 'json,'),
 // title need to base64urlsafeencode;
 array('lib/search/:title/:page\d', 'Lib/search', '', 'get', 'json,'),
 // url need to base64urlsafeencode;
 array('lib/book/:address', 'Lib/getBookDetail', '', 'get', 'json,'),
 array('lib/list/now/:username/:password', 'Lib/getBookList', 'target=now', 'get', 'json,'),
 array('lib/list/history/:username/:password', 'Lib/getBookList', 'target=history', 'get', 'json,'),
 array('lib/renew/:username/:password/:barcode_number/:check_code', 'Lib/reNewBook', '', 'get', 'json,'),
 */

+ (void)startRequestWithUrl:(NSString *)urlString success:(SuccessedBlock)success failure:(ErrorBlock)failure {
    NSLog(@"url %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];    
    __weak ASIHTTPRequest *weekRequest = request;         // 以防循环引用
    [request setCompletionBlock:^{
        NSInteger httpCode = [weekRequest responseStatusCode];
        if (httpCode == LibUsernamePasswordError) {
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_NOTICE_NOTIFICATION object:nil userInfo:@{ kNotice : @"账号或密码错误哦", kHideNoticeIntervel : @(kDefaultHideNoticeIntervel) }];
        } else if (httpCode == ServerError) {
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_NOTICE_NOTIFICATION object:nil userInfo:@{ kNotice : @"啊..服务器挂了..", kHideNoticeIntervel : @(kDefaultHideNoticeIntervel) }];
        } else if (httpCode == NullError) {
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_NOTICE_NOTIFICATION object:nil userInfo:@{ kNotice : @"没找到相关信息哦", kHideNoticeIntervel : @(kDefaultHideNoticeIntervel) }];
        } else if (httpCode == MaxRenewLimit) {
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_NOTICE_NOTIFICATION object:nil userInfo:@{ kNotice : @"超过最大续借次数呢", kHideNoticeIntervel : @(kDefaultHideNoticeIntervel) }];
            return;
        }
        if (success) {
            success([weekRequest responseData], [weekRequest responseStatusCode]);
        }
    }];
    [request setFailedBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_NOTICE_NOTIFICATION object:nil userInfo:@{ kNotice : kDefaultErrorNotice, kHideNoticeIntervel : @(kDefaultHideNoticeIntervel) }];
        NSLog(@"failed %@", [[NSString alloc] initWithData:[weekRequest responseData] encoding:NSUTF8StringEncoding]);
        if (failure != nil) {
            failure([weekRequest responseData], [weekRequest responseStatusCode]);
        }
    }];
    [request startAsynchronous];
}

+ (void)libLoginSuccess:(SuccessedBlock)success
                failure:(ErrorBlock)failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/lib/login/%@/%@", HOST_NAME, [Tool stuNum], [Tool safeBase64Encode:[Tool libPwd]]];
    [self startRequestWithUrl:urlString success:success failure:failure];
}

+ (void)libSearchBooksWithTitle:(NSString *)title
                           page:(NSInteger)page
                        success:(SuccessedBlock)success
                        failure:(ErrorBlock)failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/lib/search/%@/%d", HOST_NAME, [Tool safeBase64Encode:title], page];
    NSLog(@"%@", urlString);
    [self startRequestWithUrl:urlString success:success failure:failure];
}

+ (void)libGetBookDetailWithAddress:(NSString *)address
                            success:(SuccessedBlock)success
                            failure:(ErrorBlock)failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/lib/book/%@", HOST_NAME, [Tool safeBase64Encode:address]];
    [self startRequestWithUrl:urlString success:success failure:failure];
}

+ (void)libListNowSuccess:(SuccessedBlock)success
                  failure:(ErrorBlock)failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/lib/list/now/%@/%@", HOST_NAME, [Tool stuNum], [Tool safeBase64Encode:[Tool libPwd]]];
    [self startRequestWithUrl:urlString success:success failure:failure];
}

+ (void)libListHistorySuccess:(SuccessedBlock)success
                      failure:(ErrorBlock)failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/lib/list/history/%@/%@", HOST_NAME, [Tool stuNum], [Tool safeBase64Encode:[Tool libPwd]]];
    [self startRequestWithUrl:urlString success:success failure:failure];
}

+ (void)libRenewWithBarcode:(NSString *)barcode
                  checkCode:(NSString *)checkCode
                    Success:(SuccessedBlock)success
                    failure:(ErrorBlock)failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/lib/renew/%@/%@/%@/%@", HOST_NAME, [Tool stuNum], [Tool safeBase64Encode:[Tool libPwd]], barcode, checkCode];
    [self startRequestWithUrl:urlString success:success failure:failure];
}

@end
