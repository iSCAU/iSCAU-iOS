//
//  CECourseCommentCell.h
//  iSCAU
//
//  Created by Alvin on 3/15/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseComment.h"

@interface CECourseCommentCell : UITableViewCell

- (CECourseCommentCell *)setupWithCourseComment:(CourseComment *)comment;

+ (CGFloat)heightWithComment:(CourseComment *)comment;

@end
