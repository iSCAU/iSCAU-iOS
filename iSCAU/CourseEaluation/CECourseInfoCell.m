//
//  CECourseInfoCell.m
//  iSCAU
//
//  Created by Alvin on 3/15/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "CECourseInfoCell.h"

@interface CECourseInfoCell ()

@property (nonatomic, strong) CourseInfo *courseInfo;
@property (weak, nonatomic) IBOutlet UILabel *labCourseName;
@property (weak, nonatomic) IBOutlet UILabel *labTeacher;
@property (weak, nonatomic) IBOutlet UILabel *labProperty;
@property (weak, nonatomic) IBOutlet UILabel *labScore;
@property (weak, nonatomic) IBOutlet UILabel *labCommentCount;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIButton *btnDislike;

@end

@implementation CECourseInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setupWithCourseInfo:(CourseInfo *)courseInfo
{
    if (courseInfo) {
        self.courseInfo = courseInfo;
        
        self.labCourseName.text = self.courseInfo.courseName;
        self.labTeacher.text = self.courseInfo.teacher;
        self.labProperty.text = self.courseInfo.property;
        self.labScore.text = [NSString stringWithFormat:@"%@绩点", self.courseInfo.score];
        [self.btnLike setTitle:self.courseInfo.liked forState:UIControlStateNormal];
        [self.btnLike setTitle:self.courseInfo.liked forState:UIControlStateHighlighted];
        [self.btnDislike setTitle:self.courseInfo.disliked forState:UIControlStateNormal];
        [self.btnDislike setTitle:self.courseInfo.disliked forState:UIControlStateHighlighted];
        self.labCommentCount.text = [NSString stringWithFormat:@"0评论"];
    }
}

- (IBAction)liked:(id)sender {
}

- (IBAction)disliked:(id)sender {
}


@end
