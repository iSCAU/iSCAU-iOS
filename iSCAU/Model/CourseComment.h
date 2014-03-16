//
//  CourseComment.h
//  iSCAU
//
//  Created by Alvin on 3/15/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface CourseComment : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *courseId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) BOOL hasHomework;
@property (nonatomic, assign) BOOL isCheck;
@property (nonatomic, copy) NSString *examType;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *timeString;

- (NSString *)timeStamp;

@end
