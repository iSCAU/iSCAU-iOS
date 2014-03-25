//
//  AZNewsHttpClient.h
//  iSCAU
//
//  Created by Alvin on 2/17/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "BaseHttpClient.h"

@interface AZNewsHttpClient : BaseHttpClient

- (void)newsGetListWithPage:(NSInteger)page 
                    success:(SuccessedBlock)success
                    failure:(ErrorBlock)failure;

- (void)newsGetContentWithURL:(NSString *)url 
                      success:(SuccessedBlock)success
                      failure:(ErrorBlock)failure;
@end
