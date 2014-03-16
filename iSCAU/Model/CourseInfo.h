//
//  CourseInfo.h
//  iSCAU
//
//  Created by Alvin on 3/14/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface CourseInfo : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *courseId;
@property (nonatomic, copy) NSString *courseName;
@property (nonatomic, copy) NSString *teacher;
@property (nonatomic, copy) NSString *property;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *liked;
@property (nonatomic, copy) NSString *disliked;
//@property (nonatomic, copy) NSString *commentCount;

@end
