//
//  EduSysMarksDetailCell.m
//  iSCAU
//
//  Created by Alvin on 2/18/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "EduSysMarksDetailCell.h"
#import "UIImage+ImageWithColor.h"

@interface EduSysMarksDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *labInfoKey;
@property (weak, nonatomic) IBOutlet UILabel *labInfoValue;
@property (weak, nonatomic) IBOutlet UIImageView *imgIndicator;

@end

@implementation EduSysMarksDetailCell

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

+ (NSString *)mapKeys:(NSString *)key {
    NSDictionary *keyMapping = @{ @"classify": @"课程性质",
                                  @"code": @"课程代码",
                                  @"college_belong": @"课程归属",
                                  @"college_hold": @"开课学院",
                                  @"credit": @"学分",
                                  @"flag_minor": @"", 
                                  @"flag_restudy": @"重修标记",
                                  @"goal": @"成绩",
                                  @"goal_restudy": @"重修记录",
                                  @"grade_point": @"绩点",
                                  @"name": @"名称",
                                  @"team": @"学期", @"year": @"学年" };
    return keyMapping[key];
}

- (UITableViewCell *)configurateWithKey:(NSString *)key value:(NSString *)value index:(NSInteger)index {
    
    self.labInfoKey.text = [EduSysMarksDetailCell mapKeys:key];
    self.labInfoValue.text = value;
    self.imgIndicator.image = [UIImage imageWithColor:[Tool indicatorColorAtIndex:index]];
    
    return self;
}

@end
