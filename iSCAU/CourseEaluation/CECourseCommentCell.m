//
//  CECourseCommentCell.m
//  iSCAU
//
//  Created by Alvin on 3/15/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "CECourseCommentCell.h"

@interface CECourseCommentCell ()

@property (nonatomic, strong) CourseComment *comment;

@property (weak, nonatomic) IBOutlet UILabel *labUsername;
@property (weak, nonatomic) IBOutlet UILabel *labTimestamp;
@property (weak, nonatomic) IBOutlet UILabel *labHasHomework;
@property (weak, nonatomic) IBOutlet UILabel *labIsCheck;
@property (weak, nonatomic) IBOutlet UILabel *labExamType;
@property (weak, nonatomic) IBOutlet UILabel *labComment;

@end

@implementation CECourseCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setupWithCourseComment:(CourseComment *)comment
{
    self.comment = comment;
    
    if (comment && [comment isKindOfClass:[CourseComment class]]) {
        
        NSLog(@"comment %@", comment);
        
        self.labUsername.text = comment.userName;
        self.labTimestamp.text = [comment timeStamp];
        self.labExamType.text = [NSString stringWithFormat:@"考试类型: %@", comment.examType];
        self.labComment.text = comment.comment;
        
//        CGSize maxSize = CGSizeMake(280, MAXFLOAT);
//        CGFloat commentLabelHeight = [comment.comment sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping].height;
        CGFloat commentLabelHeight = 27.f;
        
        CGRect frame = self.labComment.frame;
        CGFloat heightDifference = commentLabelHeight - frame.size.height;
        frame.size.height = commentLabelHeight;
        self.labComment.frame = frame;
        
        frame = self.frame;
        frame.size.height += heightDifference;
        self.frame = frame;
    }
}

+ (CGFloat)heightWithComment:(CourseComment *)comment
{
//    CGSize maxSize = CGSizeMake(280, MAXFLOAT);
//    CGFloat commentLabelHeight = [comment.comment sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping].height;
//    
//    CGFloat heightDifference = commentLabelHeight - 27.0;

//    return 150 + heightDifference;
    return 150;
}

@end
