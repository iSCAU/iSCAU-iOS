//
//  LibHttpClient.h
//  iSCAU
//
//  Created by Alvin on 13-9-11.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "BaseHttpClient.h"

@interface LibHttpClient : BaseHttpClient

+ (instancetype)shareInstance;

- (void)libLoginSuccess:(SuccessedBlock)success
                failure:(ErrorBlock)failure;

- (void)libSearchBooksWithTitle:(NSString *)title
                           page:(NSInteger)page
                        success:(SuccessedBlock)success
                        failure:(ErrorBlock)failure;

- (void)libGetBookDetailWithAddress:(NSString *)address
                            success:(SuccessedBlock)success
                            failure:(ErrorBlock)failure;

- (void)libListNowSuccess:(SuccessedBlock)success
                  failure:(ErrorBlock)failure;

- (void)libListHistorySuccess:(SuccessedBlock)success
                      failure:(ErrorBlock)failure;

- (void)libRenewWithBarcode:(NSString *)barcode
                  checkCode:(NSString *)checkCode
                    Success:(SuccessedBlock)success
                    failure:(ErrorBlock)failure;

@end