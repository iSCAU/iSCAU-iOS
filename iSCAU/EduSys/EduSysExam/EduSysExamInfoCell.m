//
//  EduSysExamInfoCell.m
//  iSCAU
//
//  Created by Alvin on 13-10-4.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "EduSysExamInfoCell.h"

#define EXAM_INFO_CAMPUS        @"campus"
#define EXAM_INFO_FORM          @"form"
#define EXAM_INFO_NAME          @"name"
#define EXAM_INFO_NAME_STUDENT  @"name_student"
#define EXAM_INFO_PLACE         @"place"
#define EXAM_INFO_SEAT_NUMBER   @"seat_number"
#define EXAM_INFO_TIME          @"time"

@interface EduSysExamInfoCell ()
@property (nonatomic, strong) IBOutlet CardStyleView    *cardStyleView;
@property (nonatomic, weak) IBOutlet UILabel          *labClassName;
@property (nonatomic, weak) IBOutlet UILabel          *labTime;
@property (nonatomic, weak) IBOutlet UILabel          *labPlace;
@property (nonatomic, weak) IBOutlet UILabel          *labSeatNumber;
@end

@implementation EduSysExamInfoCell

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

- (UITableViewCell *)configurateInfo:(NSDictionary *)info {
    
    self.labClassName.text = [info objectForKey:EXAM_INFO_NAME];
    
    self.labTime.text = [[NSString alloc] initWithFormat:@"时间: %@", [info objectForKey:EXAM_INFO_TIME]];
    
    self.labPlace.text = [NSString stringWithFormat:@"考试地点 : %@", [info objectForKey:EXAM_INFO_PLACE]];
    
    self.labSeatNumber.text = [NSString stringWithFormat:@"座位号 : %@", [info objectForKey:EXAM_INFO_SEAT_NUMBER]];
    
    return self;
}

@end
