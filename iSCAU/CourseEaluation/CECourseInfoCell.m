//
//  CECourseInfoCell.m
//  iSCAU
//
//  Created by Alvin on 3/15/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "CECourseInfoCell.h"
#import "CEHttpClient.h"
#import "UIImage+Tint.h"

CGFloat const animationDuration = 1.f;
CGFloat const CECourseInfoCellHeight = 116.f;

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

- (void)awakeFromNib
{
    CGFloat borderWidth = 1.f;
    CGFloat cornerRadius = 2.f;
    CGFloat borderColorAlpha = 0.2;
    
    self.btnLike.layer.borderWidth = borderWidth;
    self.btnLike.layer.borderColor = [UIColor colorWithWhite:0 alpha:borderColorAlpha].CGColor;
    self.btnLike.layer.cornerRadius = cornerRadius;
    
    self.btnDislike.layer.borderWidth = borderWidth;
    self.btnDislike.layer.borderColor = [UIColor colorWithWhite:0 alpha:borderColorAlpha].CGColor;
    self.btnDislike.layer.cornerRadius = cornerRadius;
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
        
        if ([APP_DELEGATE.likedCourses indexOfObject:self.courseInfo.courseId] != NSNotFound) {
            [self.btnLike setImage:[UIImage imageNamed:@"liked.png"] forState:UIControlStateNormal];
        } else if ([APP_DELEGATE.dislikedCourses indexOfObject:self.courseInfo.courseId] != NSNotFound) {
            [self.btnLike setImage:[UIImage imageNamed:@"disliked.png"] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)liked:(id)sender 
{    
    if ([APP_DELEGATE.likedCourses indexOfObject:self.courseInfo.courseId] != NSNotFound) {
        return;
    }
    
    POST_NOTIFICATION(SHOW_NOTICE_NOTIFICATION, @{ kNotice : @"请稍等.."});
    [[CEHttpClient shareInstance] 
     likedTheCourseWithCourseId:self.courseInfo.courseId
     userName:[Tool stuNum] 
     success:^(NSData *responseData, int httpCode) {
         POST_NOTIFICATION(HIDE_NOTICE_NOTIFICATION, nil);
         
         NSError *error = nil;
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
         if (error) {
             NSLog(@"error %@ %@", error.localizedDescription, [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
         }
         if ([dict[CourseInfoStatusKey] isEqualToString:CourseInfoResultSuccess]) {
             [self displayEvaluateAnimationAndIsLiked:YES];         
         }
     } 
     failure:^(NSData *responseData, int httpCode) {
         POST_NOTIFICATION(HIDE_NOTICE_NOTIFICATION, @{ kNotice : @"哎呀，评价失败了"});
     }];
}

- (IBAction)disliked:(id)sender 
{
    if ([APP_DELEGATE.dislikedCourses indexOfObject:self.courseInfo.courseId] != NSNotFound) {
        return;
    }
    
    POST_NOTIFICATION(SHOW_NOTICE_NOTIFICATION, @{ kNotice : @"请稍等.."});
    [[CEHttpClient shareInstance] 
     dislikedTheCourseWithCourseId:self.courseInfo.courseId
     userName:[Tool stuNum] 
     success:^(NSData *responseData, int httpCode) {
         POST_NOTIFICATION(HIDE_NOTICE_NOTIFICATION, nil);
         
         NSError *error = nil;
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
         if (error) {
             NSLog(@"error %@ %@", error.localizedDescription, [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
         }
         if ([dict[CourseInfoStatusKey] isEqualToString:CourseInfoResultSuccess]) {
            [self displayEvaluateAnimationAndIsLiked:NO];
         }
     } 
     failure:^(NSData *responseData, int httpCode) {
         POST_NOTIFICATION(HIDE_NOTICE_NOTIFICATION, @{ kNotice : @"哎呀，评价失败了"});
     }];
}

- (void)displayEvaluateAnimationAndIsLiked:(BOOL)isLiked
{
    UILabel *noticeLabel = [[UILabel alloc] init];
    CGFloat noticeLabelWidth = 40.f;
    CGFloat noticeLabelHeight = 20.f;
    if (isLiked) {
        noticeLabel.frame = (CGRect){
            self.btnLike.origin.x + 10,
            self.btnLike.origin.y - 5,
            noticeLabelWidth,
            noticeLabelHeight
        };
    } else {
        noticeLabel.frame = (CGRect){
            self.btnDislike.origin.x + 10,
            self.btnDislike.origin.y - 5,
            noticeLabelWidth,
            noticeLabelHeight
        };
    }
    noticeLabel.textColor = isLiked ? [UIColor greenColor] : [UIColor redColor];
    noticeLabel.text = isLiked ? @"+1" : @"-1";
    noticeLabel.alpha = 1;
    noticeLabel.font = [UIFont italicSystemFontOfSize:18];
    noticeLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:noticeLabel];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame = noticeLabel.frame;
                         frame.origin.y -= 30;
                         noticeLabel.frame = frame;
                         noticeLabel.alpha = 0;
                         
                         if (isLiked) {
                             NSInteger likedCount = [self.btnLike.currentTitle integerValue];
                             self.courseInfo.liked = [NSString stringWithFormat:@"%d", ++likedCount];
                             [self.btnLike setTitle:self.courseInfo.liked forState:UIControlStateNormal];
                             [self.btnLike setImage:[UIImage imageNamed:@"liked.png"] forState:UIControlStateNormal];
                             [APP_DELEGATE.likedCourses addObject:self.courseInfo.courseId];
                         } else {
                             NSInteger dislikedCount = [self.btnDislike.titleLabel.text integerValue];
                             self.courseInfo.disliked = [NSString stringWithFormat:@"%d", ++dislikedCount];
                             [self.btnDislike setTitle:self.courseInfo.disliked forState:UIControlStateNormal];
                             [self.btnDislike setImage:[UIImage imageNamed:@"disliked.png"] forState:UIControlStateNormal];
                             [APP_DELEGATE.dislikedCourses addObject:self.courseInfo.courseId];
                         }
                     } completion:^(BOOL finished) {
                         if (finished) {
                            [noticeLabel removeFromSuperview];
                         }
                     }];
}

@end
