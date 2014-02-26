//
//  AppDelegate.h
//  iSCAU
//
//  Created by Alvin on 13-8-20.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const UM_CODE;

extern NSInteger const NullError;
extern NSInteger const EduUsernameError;
extern NSInteger const EduPasswordError;
extern NSInteger const LibUsernamePasswordError;
extern NSInteger const MaxRenewLimit;
extern NSInteger const CardUsernamePasswordError;
extern NSInteger const ServerError;

// ----- Lib
extern NSString *BARCODE_NUMBER;
extern NSString *BORROW_DATE;
extern NSString *RETURN_DATE;
extern NSString *CHECK_CODE;
extern NSString *COLLECTION_PLACE;
extern NSString *RENEW_TIME;
extern NSString *SHOULD_RETURN_DATE;
extern NSString *TITLE;
extern NSString *BOOK_STATUS;
extern NSString *AUTHOR;
extern NSString *DOCUMENT_TYPE;
extern NSString *PRESS;
extern NSString *SERIAL_NUMBER;
extern NSString *URL;
extern NSString *YEAR_TITLE;
// -----

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *rootViewController;
@property (strong, nonatomic) UIColor *tintColor;

@end
