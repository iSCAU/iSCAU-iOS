//
//  LibBaseViewController.m
//  iSCAU
//
//  Created by Alvin on 2/19/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "LibBaseViewController.h"

@interface LibBaseViewController ()

@end

@implementation LibBaseViewController

- (BOOL)LibAccountValidate {
    if ([Tool stuNum].length < 1 || [Tool libPwd].length < 1) {
        NSDictionary *dict = @{ kNotice: @"请先填写对应账号密码哦"};
        
        double delayInSeconds = 500;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_MSEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            POST_NOTIFICATION(SUGGEST_LOGIN_AGAIN_NOTIFICATION, dict);
        });
        return NO;
    }
    return NO;
}

@end
