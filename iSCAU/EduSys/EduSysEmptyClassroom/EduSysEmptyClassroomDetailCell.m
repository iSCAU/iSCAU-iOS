//
//  EduSysEmptyClassroomDetailCell.m
//  iSCAU
//
//  Created by Alvin on 2/18/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "EduSysEmptyClassroomDetailCell.h"
#import "UIImage+ImageWithColor.h"

#define kNumber @"number"
#define kType @"type"
#define kSeatClass @"seat_class"

@interface EduSysEmptyClassroomDetailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgIndicator;
@property (weak, nonatomic) IBOutlet UILabel *labClassroom;
@property (weak, nonatomic) IBOutlet UILabel *labSeatCount;
@property (weak, nonatomic) IBOutlet UILabel *labClassroomType;

@end

@implementation EduSysEmptyClassroomDetailCell

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

- (UITableViewCell *)configurateWithClassroomInfo:(NSDictionary *)classroomInfo 
                                            index:(NSInteger)index {
    self.labClassroom.text = classroomInfo[kNumber];
    
    self.labSeatCount.text = [NSString stringWithFormat:@"座位数: %@", classroomInfo[kSeatClass]];
    
    self.labClassroomType.text = [NSString stringWithFormat:@"教室类别: %@", classroomInfo[kType]];
    
    self.imgIndicator.image = [UIImage imageWithColor:[Tool indicatorColorAtIndex:index]];

    return self;
}

@end
