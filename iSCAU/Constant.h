//
//  Constant.h
//  iSCAU
//
//  Created by Alvin on 13-8-20.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#ifndef iSCAU_Constant_h
#define iSCAU_Constant_h

typedef void(^SuccessedBlock)(NSData *responseData, int httpCode);
typedef void(^ErrorBlock)(NSData *responseData, int httpCode);

#define HOST_NAME @"http://115.28.144.49"
#define LIB_DETAIL_HOST @"http://202.116.174.108:8080/opac/"

#define SET_DEFAULT_BACKGROUND_COLOR(table) [(table) setBackgroundColor:[UIColor colorFromHexRGB:@"f2f0ed" alpha:1.0f]];
#define RESOURCE_PATH(resourceName, type)   [[NSBundle mainBundle] pathForResource:(resourceName) ofType:(type)]
#define SystemVersion_floatValue            ([[[UIDevice currentDevice] systemVersion] floatValue])
#define IS_FLAT_UI                          (([[[UIDevice currentDevice] systemVersion] floatValue]) >= 7.0)
#define APP_DELEGATE                        ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define IS_IPHONE4                          (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)480) < DBL_EPSILON)

// Notification
#define kDefaultHideNoticeIntervel 1.5
#define SHOW_NOTICE_NOTIFICATION @"SHOW_NOTICE_NOTIFICATION"
#define HIDE_NOTICE_NOTIFICATION @"HIDE_NOTICE_NOTIFICATION"
#define kNotice @"Notice"
#define kHideNoticeIntervel @"HideNoticeIntervel"
#define kDefaultErrorNotice @"加载失败,请稍后再试试.."
#define NOTIFICATION @"notification"
#define EDU_SYS_EMPTY_CLASSROOM_SELECTED_NOTIFICATION @"EDU_SYS_EMPTY_CLASSROOM_SELECTED_NOTIFICATION"

#define POST_NOTIFICATION(notificationName, infoDict) \
[[NSNotificationCenter defaultCenter] postNotificationName:(notificationName) object:nil userInfo:(infoDict)]

// HUD
#define HIDE_ALL_HUD [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

#define SHOW_WATING_HUD \
[MBProgressHUD hideAllHUDsForView:self.view animated:YES]; \
[MBProgressHUD showHUDAddedTo:self.view animated:YES];

#define SHOW_NOTICE_HUD(notice) \
[MBProgressHUD hideAllHUDsForView:self.view animated:YES]; \
MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES]; \
hud.labelText = (notice); \
hud.mode = MBProgressHUDModeText; \
dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, kDefaultHideNoticeIntervel * NSEC_PER_SEC); \
dispatch_after(popTime, dispatch_get_main_queue(), ^(void){ \
    [MBProgressHUD hideHUDForView:self.view animated:YES]; \
});

// User settings key
#define EDU_SYS_stuNum          @"EDU_SYS_stuNum"
#define EDU_SYS_password        @"EDU_SYS_password"
#define EDU_SYS_stuName         @"EDU_SYS_stuName"
#define EDU_SYS_server          @"EDU_SYS_server"
#define EDU_SYS_isSavedPassword @"EDU_SYS_isSavedPassword"
#define SEMESTER_START_DATE     @"SEMESTER_START_DATE"

#define Library_stuNum          @"Library_stuNum"
#define Library_ve              @"Library_ve"
#define Library_connectionTag   @"Library_connectionTag"
#define Library_password        @"Library_password"
#define Library_isSavedPassword @"Library_isSavedPassword"

#define CampusCard_stuNum           @"CampusCard_stuNum"
#define CampusCard_password         @"CampusCard_password"
#define CampusCard_ve               @"CampusCard_ve"
#define CampusCard_connectionTag    @"CampusCard_connectionTag"
#define CampusCard_isSavedPassword  @"CampusCard_isSavedPassword"

#endif
