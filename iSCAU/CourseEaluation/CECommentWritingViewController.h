//
//  CECommentWritingViewController.h
//  iSCAU
//
//  Created by Alvin on 3/16/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "CEBaseViewController.h"
#import "CourseInfo.h"

@interface CECommentWritingViewController : CEBaseViewController <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) CourseInfo *course;

@end
