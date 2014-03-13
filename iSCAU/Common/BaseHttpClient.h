//
//  BaseHttpClient.h
//  iSCAU
//
//  Created by Alvin on 3/12/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ASIHTTPRequest/ASIHTTPRequest.h>

extern NSInteger const RequestSuccess;
extern NSInteger const NullError;
extern NSInteger const EduUsernameError;
extern NSInteger const EduPasswordError;
extern NSInteger const LibUsernamePasswordError;
extern NSInteger const MaxRenewLimit;
extern NSInteger const CardUsernamePasswordError;
extern NSInteger const ServerError;

@interface BaseHttpClient : NSObject

@property (nonatomic, strong) ASIHTTPRequest *request;

+ (instancetype)shareInstance;

- (void)cancleRequest;

@end
