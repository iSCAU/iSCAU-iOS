//
//  EduSysHttpClient.h
//  iSCAU
//
//  Created by Alvin on 13-9-10.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "BaseHttpClient.h"

@interface EduSysHttpClient : BaseHttpClient

- (void)eduSysLoginWithStuNum:(NSString *)stuNum
                          pwd:(NSString *)pwd
                       server:(NSString *)server
                      success:(SuccessedBlock)success
                      failure:(ErrorBlock)failure;

- (void)eduSysGetClassTableSuccess:(SuccessedBlock)success
                           failure:(ErrorBlock)failure;

- (void)eduSysGetExamSuccess:(SuccessedBlock)success
                     failure:(ErrorBlock)failure;

- (void)eduSysGetMarksInfoSuccess:(SuccessedBlock)success
                          failure:(ErrorBlock)failure;

- (void)eduSysGetMarksWithYear:(NSString *)year
                         tearm:(NSString *)term
                       success:(SuccessedBlock)success
                       failure:(ErrorBlock)failure;

- (void)eduSysGetPickClassInfoSuccess:(SuccessedBlock)success
                              failure:(ErrorBlock)failure;

- (void)eduSysGetEmptyClassroomInfoSuccessWithXQ:(NSString *)xq 
                                            jslb:(NSString *)jslb 
                                          ddlKsz:(NSString *)ddlKsz 
                                          ddlJsz:(NSString *)ddlJsz
                                             xqj:(NSString *)xqj 
                                             dsz:(NSString *)dsz 
                                             sjd:(NSString *)sjd  
                                         success:(SuccessedBlock)success 
                                         failure:(ErrorBlock)failure;

- (void)eduSysGetEmptyClassroomParamsSuccess:(SuccessedBlock)success
                                     failure:(ErrorBlock)failure;

@end
