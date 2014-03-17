//
//  CECourseCommentCell.m
//  iSCAU
//
//  Created by Alvin on 3/15/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "CECourseCommentCell.h"
#import "CardStyleView.h"

CGFloat const CECourseCommentCellHeight = 136.f;
CGFloat const CommentLabelFontSize = 15.f;

@interface CECourseCommentCell ()

@property (nonatomic, strong) CourseComment *comment;

@property (weak, nonatomic) IBOutlet UILabel *labUsername;
@property (weak, nonatomic) IBOutlet UILabel *labTimestamp;
@property (weak, nonatomic) IBOutlet UILabel *labHasHomework;
@property (weak, nonatomic) IBOutlet UILabel *labIsCheck;
@property (weak, nonatomic) IBOutlet UILabel *labExamType;
@property (weak, nonatomic) IBOutlet UILabel *labComment;
@property (weak, nonatomic) IBOutlet CardStyleView *cardStyleView;
@property (weak, nonatomic) IBOutlet UIImageView *imgHasHomework;
@property (weak, nonatomic) IBOutlet UIImageView *imgIsCheck;

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

- (CECourseCommentCell *)setupWithCourseComment:(CourseComment *)comment
{
    self.comment = comment;
    
    if (comment && [comment isKindOfClass:[CourseComment class]]) {
                
        self.labUsername.text = comment.userName;
        self.labTimestamp.text = [comment timeStamp];
        self.labExamType.text = [NSString stringWithFormat:@"考试类型: %@", comment.examType];
        self.labComment.text = comment.comment;
        
        CGSize maxSize = CGSizeMake(280, MAXFLOAT);
        CGFloat commentLabelHeight = [comment.comment sizeWithFont:[UIFont systemFontOfSize:CommentLabelFontSize] constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping].height;
        
        CGRect frame = self.labComment.frame;
        CGFloat heightDifference = commentLabelHeight - frame.size.height;
        frame.size.height = frame.size.height + heightDifference;
        self.labComment.frame = frame;
        
        frame = self.cardStyleView.frame;
        frame.size.height += heightDifference;
        self.cardStyleView.frame = frame;
        
        frame = self.frame;
        frame.size.height += heightDifference;
        self.frame = frame;
        
        NSString *checkImageName = @"check.png";
        NSString *x_markImageName = @"x-mark.png";
        self.imgHasHomework.image = [UIImage imageNamed:(self.comment.hasHomework ? checkImageName : x_markImageName)];
        self.imgIsCheck.image = [UIImage imageNamed:(self.comment.isCheck ? checkImageName : x_markImageName)];
    }
    return self;
}

+ (CGFloat)heightWithComment:(CourseComment *)comment
{
    CGSize maxSize = CGSizeMake(280, MAXFLOAT);
    CGFloat commentLabelHeight = [comment.comment sizeWithFont:[UIFont systemFontOfSize:CommentLabelFontSize] constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping].height;
    CGFloat heightDifference = commentLabelHeight - 27.0;
    
    return CECourseCommentCellHeight + heightDifference;
}

@end
