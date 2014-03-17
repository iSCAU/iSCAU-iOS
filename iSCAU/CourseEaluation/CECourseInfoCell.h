//
//  CECourseInfoCell.h
//  iSCAU
//
//  Created by Alvin on 3/15/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseInfo.h"

extern CGFloat const CECourseInfoCellHeight;

@interface CECourseInfoCell : UITableViewCell

- (void)setupWithCourseInfo:(CourseInfo *)courseInfo;

@end
