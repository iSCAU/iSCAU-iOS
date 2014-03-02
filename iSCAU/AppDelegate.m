//
//  AppDelegate.m
//  iSCAU
//
//  Created by Alvin on 13-8-20.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "AppDelegate.h"
#import "EduSysClassTableViewController.h"
#import "MobClick.h"
#import "EduSysClassTableViewController.h"
#import "RootViewController.h"

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
NSInteger const NullError = 404;
NSInteger const EduUsernameError = 405;
NSInteger const EduPasswordError = 406;
NSInteger const LibUsernamePasswordError = 407;
NSInteger const MaxRenewLimit = 408;
NSInteger const CardUsernamePasswordError = 409;
NSInteger const ServerError = 500;

// ----- lib
NSString *BARCODE_NUMBER = @"barcode_number";
NSString *BORROW_DATE = @"borrow_date";
NSString *RETURN_DATE = @"return_date";
NSString *CHECK_CODE = @"check_code";
NSString *COLLECTION_PLACE = @"collection_place";
NSString *RENEW_TIME = @"renew_time";
NSString *SHOULD_RETURN_DATE = @"should_return_date";
NSString *TITLE = @"title";
NSString *BOOK_STATUS = @"books_status";
NSString *AUTHOR = @"author";
NSString *DOCUMENT_TYPE = @"document_type";
NSString *PRESS = @"press";
NSString *SERIAL_NUMBER = @"serial_number";
NSString *URL = @"url";
NSString *YEAR_TITLE = @"year_title";

//正式版
NSString * const UM_CODE = @"50b853b85270156c2b000007";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.tintColor = [UIColor colorWithR:0 g:126 b:245 a:1];    
    [MobClick startWithAppkey:UM_CODE];
    [MobClick checkUpdate];
    [MobClick updateOnlineConfig];
    
    self.window.rootViewController = [[RootViewController alloc] init];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
