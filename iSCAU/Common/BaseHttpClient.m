//
//  BaseHttpClient.m
//  iSCAU
//
//  Created by Alvin on 3/12/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "BaseHttpClient.h"

/**
 * 200:
 * 404: null_error
 * 405: username_error(edu)
 * 406: password_error(edu)
 * 407: username_password_error(lib)
 * 408: maxrenew_limit(lib)    // 超过最大续借额
 * 409: username_password_error(card)
 * 500: server_error
 */
NSInteger const RequestSuccess = 200;
NSInteger const NullError = 404;
NSInteger const EduUsernameError = 405;
NSInteger const EduPasswordError = 406;
NSInteger const LibUsernamePasswordError = 407;
NSInteger const MaxRenewLimit = 408;
NSInteger const CardUsernamePasswordError = 409;
NSInteger const ServerError = 500;

@implementation BaseHttpClient

+ (instancetype)shareInstance 
{
    return nil;
}

- (void)cancleRequest
{
    if (self.request && self.request.isExecuting) {
        [self.request cancel];
    }
}

@end
