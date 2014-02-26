//
//  EduSysPickClassInfoCell.m
//  iSCAU
//
//  Created by Alvin on 2/17/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "EduSysPickClassInfoCell.h"

@interface EduSysPickClassInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labPlace;
@property (weak, nonatomic) IBOutlet UILabel *labTeacher;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UILabel *labWeekRange;
@property (weak, nonatomic) IBOutlet UILabel *labHoursWeek;
@property (weak, nonatomic) IBOutlet UILabel *labCredit;
@property (weak, nonatomic) IBOutlet UILabel *labCampus;
@property (weak, nonatomic) IBOutlet UILabel *labClassify;
@property (weak, nonatomic) IBOutlet UILabel *labCollegeBelong;
@property (weak, nonatomic) IBOutlet UILabel *labTeachingMaterial;

@end

@implementation EduSysPickClassInfoCell

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

#define kCampus @"campus"
#define kClassify @"classify"
#define kCollegeBelong @"college_belong"
#define kCredit @"credit"
#define kHoursWeek @"hours_week"
#define kName @"name"
#define kNameTeacher @"name_teacher"
#define kPlace @"place"
#define kTeachingMaterial @"teaching_material"
#define kTime @"time"
#define kWeekRange @"week_range"

- (UITableViewCell *)configurateInfo:(NSDictionary *)info {

    self.labTitle.text = info[kName];
    self.labClassify.text = [NSString stringWithFormat:@"课程类别: %@", info[kClassify]];
    self.labCampus.text = [NSString stringWithFormat:@"校区: %@", info[kCampus]];
    self.labCollegeBelong.text = [NSString stringWithFormat:@"课程归属: %@", info[kCollegeBelong]];
    self.labCredit.text = [NSString stringWithFormat:@"学分: %@", info[kCredit]];
    self.labHoursWeek.text = [NSString stringWithFormat:@"周学时: %@", info[kHoursWeek]];
    self.labTeacher.text = [NSString stringWithFormat:@"教师: %@", info[kNameTeacher]];
    self.labPlace.text = [NSString stringWithFormat:@"课室: %@", info[kPlace]];
    self.labTeachingMaterial.text = [NSString stringWithFormat:@"教材采购: %@", info[kTeachingMaterial]];
    self.labTime.text = [NSString stringWithFormat:@"上课时间:  %@", info[kTime]];
    self.labWeekRange.text = [NSString stringWithFormat:@"学时: %@", info[kWeekRange]];
    
    return self;
}

@end
