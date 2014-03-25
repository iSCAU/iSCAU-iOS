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
#define COURSE_EVALUATION @"http://api.huanongbao.com/course_comments/index.php?s=/Api"
//#define COURSE_EVALUATION @"http://127.0.0.1:8890/index.php?s=/Api"

#define SET_DEFAULT_BACKGROUND_COLOR(table) [(table) setBackgroundColor:[UIColor colorFromHexRGB:@"f2f0ed" alpha:1.0f]];
#define RESOURCE_PATH(resourceName, type)   [[NSBundle mainBundle] pathForResource:(resourceName) ofType:(type)]
#define SystemVersion_floatValue            ([[[UIDevice currentDevice] systemVersion] floatValue])
#define IS_FLAT_UI                          (([[[UIDevice currentDevice] systemVersion] floatValue]) >= 7.0)
#define APP_DELEGATE                        ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define IS_IPHONE4                          (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)480) < DBL_EPSILON)

#define IPHONE_DEVICE_LENGTH_DIFFERENCE 88.0f


// Notification
#define kDefaultHideNoticeIntervel 1.5
#define SHOW_NOTICE_NOTIFICATION                      @"SHOW_NOTICE_NOTIFICATION"
#define SUGGEST_LOGIN_AGAIN_NOTIFICATION              @"SUGGEST_LOGIN_AGAIN_NOTIFICATION"
#define HIDE_NOTICE_NOTIFICATION                      @"HIDE_NOTICE_NOTIFICATION"
#define kNotice                                       @"Notice"
#define kHideNoticeIntervel                           @"HideNoticeIntervel"
#define kDefaultErrorNotice                           @"加载失败,请稍后再试试.."
#define NOTIFICATION                                  @"notification"
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

#define HTML_WRAPPER @"<div class=\"titlearea\" style=\"margin-top:12px;color:rgb(183,183,183)\">%@</div><div class=\"authorAndPubDatePart\" style=\"font-family:Helvetica;font-size:12px;color:#cbcbcb;\"><span style=\" display:block; float:left;line-height:20px;padding-left:17px;margin-left:20px;background:url(%@) no-repeat 0 4;background-size:12px 12px;\">%@</span></div><div class=\"contentDetailarea\">%@</div><div class=\"spacetail\"></div>"
#define HTML_CSS @" <head><meta http-equiv=\"Content-type\" content=\"text/html;charset=utf-8\"/><meta id=\"viewport\" name=\"viewport\" content=\"width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no\"/> <style type=\"text/css\">html,body{background-color:rgb(244,244,244); padding:0; margin:0;} a,a:hover,a:link,a:visited,a:active{text-decoration:none;color:rgb(229,169,0);border:none;background:none;} p{line-} .ifanrspan{line-} #content{overflow-x: hidden; overflow-y: scroll; word-wrap: break-word; } .titlearea{font-family:Helvetica;font-size:22px;line-height:28px;padding:0 15px 3px 15px;font-weight:bold;} .contentDetailarea{width:290px;text-align:justify;float:left;word-wrap:break-word;display:block; margin-left:15px;margin-bottom:10px;line-height:24px;font-family:Helvetica;font-size:16px;} .spacetail{padding:0 0 40 0px;} articleTitle{display:block;margin-left:15px; width:290px;height:auto;font-family:Helvetica;font-size:22px;line-height:28px;font-weight:bold;} </style></head>"

#endif
