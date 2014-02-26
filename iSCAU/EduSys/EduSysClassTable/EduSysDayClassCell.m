//
//  EduSysDayClassCell.m
//  iSCAU
//
//  Created by Alvin on 13-10-7.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "EduSysDayClassCell.h"
#import "UIImage+ImageWithColor.h"

static NSString *CLASSNAME = @"classname";
static NSString *DAY = @"day";
static NSString *DSZ = @"dsz";
static NSString *END_WEEK = @"endWeek";
static NSString *LOCATION = @"location";
static NSString *NODE = @"node";
static NSString *STR_WEEK = @"strWeek";
static NSString *TEACHER = @"teacher";

@interface EduSysDayClassCell ()

@property (nonatomic, weak) IBOutlet UILabel *labClassName;
@property (nonatomic, weak) IBOutlet UILabel *labTime;
@property (nonatomic, weak) IBOutlet UILabel *labLocation;
@property (nonatomic, weak) IBOutlet UIView  *sepView;
@property (weak, nonatomic) IBOutlet UILabel *labTeacher;
@property (weak, nonatomic) IBOutlet UIImageView *imgIndicator;

@end

@implementation EduSysDayClassCell

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

- (UITableViewCell *)configurateInfo:(NSDictionary *)info index:(NSInteger)index {
    
    NSString *className = [info objectForKey:CLASSNAME];
    
    CGSize size = [Tool calculateSizeWithString:className font:[UIFont boldSystemFontOfSize:15] constrainWidth:270.0];
    self.labClassName.text = className;
    
    NSString *infoText = [NSString stringWithFormat:@"%@-%@周 %@节", [info objectForKey:STR_WEEK], [info objectForKey:END_WEEK], [info objectForKey:NODE]];
    if (![[info objectForKey:@"dsz"] isEqual:[NSNull null]]) {
        infoText = [NSString stringWithFormat:@"%@-%@周 %@节 %@", [info objectForKey:STR_WEEK], [info objectForKey:END_WEEK], [info objectForKey:NODE], [info objectForKey:DSZ]];
    }
    
    self.labTime.text = infoText;
    
    self.labLocation.text = [NSString stringWithFormat:@"%@", info[LOCATION]];
    
    self.labTeacher.text = [NSString stringWithFormat:@"%@", info[TEACHER]];
    
    if (size.height > 20) {
        CGRect frame = self.labClassName.frame;
        frame.size.height += size.height / 2;
        self.labClassName.frame = frame;
        
        frame = self.labTime.frame;
        frame.origin.y += size.height / 2;
        self.labTime.frame = frame;
        
        frame = self.labLocation.frame;
        frame.origin.y += size.height / 2;
        self.labLocation.frame = frame;
        
        frame = self.sepView.frame;
        frame.origin.y += size.height / 2;
        self.sepView.frame = frame;
    }
    
    self.imgIndicator.image = [UIImage imageWithColor:[Tool indicatorColorAtIndex:index]];
    
    return self;
}

@end
