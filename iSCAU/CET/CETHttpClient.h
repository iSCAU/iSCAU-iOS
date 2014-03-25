//
//  CETHttpClient.h
//  iSCAU
//
//  Created by Alvin on 3/18/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "BaseHttpClient.h"

@interface CETHttpClient : BaseHttpClient

- (void)queryMarksWithCetNum:(NSString *)cetNum 
                    username:(NSString *)username 
                     success:(SuccessedBlock)success 
                     failure:(ErrorBlock)failure;

@end
