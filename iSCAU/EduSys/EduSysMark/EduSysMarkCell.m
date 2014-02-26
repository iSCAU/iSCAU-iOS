//
//  EduSysMarkCell.m
//  iSCAU
//
//  Created by Alvin on 13-9-30.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "EduSysMarkCell.h"
#import "UIImage+ImageWithColor.h"

#define IS_CH_SYMBOL(chr) ((int)(chr)>127)

static NSString *NAME = @"name";
static NSString *GOAL = @"goal";
static NSString *GRADE_POINT = @"grade_point";
static NSString *greenColor = @"0x27AE60";
static NSString *redColor = @"0xC0392B";

@interface EduSysMarkCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgIndicator;
@property (nonatomic, weak) IBOutlet UILabel *labClassName;
@property (nonatomic, weak) IBOutlet UILabel *labGpa;
@property (nonatomic, weak) IBOutlet UILabel *labMarks;
@property (nonatomic, weak) IBOutlet UIView  *sepView;
@end

@implementation EduSysMarkCell

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
    
    NSString *className = [info objectForKey:NAME];
    
    CGSize size = [Tool calculateSizeWithString:className font:[UIFont boldSystemFontOfSize:15] constrainWidth:270.0];
    self.labClassName.text = className;
    
    self.labGpa.text = [[NSString alloc] initWithFormat:@"绩点: %@", [info objectForKey:GRADE_POINT]];
    
    self.labMarks.text = [NSString stringWithFormat:@"成绩 : %@", [info objectForKey:GOAL]];
    
    if (size.height > 20) {
        CGRect frame = self.labClassName.frame;
        frame.size.height += size.height / 2;
        self.labClassName.frame = frame;

        frame = self.labGpa.frame;
        frame.origin.y += size.height / 2;
        self.labGpa.frame = frame;
        
        frame = self.labMarks.frame;
        frame.origin.y += size.height / 2;
        self.labMarks.frame = frame;
        
        frame = self.sepView.frame;
        frame.origin.y += size.height / 2;
        self.sepView.frame = frame;
    }
    
    self.imgIndicator.image = [UIImage imageWithColor:[Tool indicatorColorAtIndex:index]];
    
    return self;
}

@end
