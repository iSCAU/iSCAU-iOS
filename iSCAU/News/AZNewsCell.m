//
//  AZNewsCell.m
//  iSCAU
//
//  Created by Alvin on 2/17/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "AZNewsCell.h"
#import "UIImage+Tint.h"

#define kTime @"time"
#define kTitle @"title"
#define kURL @"url"

@interface AZNewsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgIndicator;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgClock;
@property (weak, nonatomic) IBOutlet UILabel *labTime;

@end

@implementation AZNewsCell

- (void)awakeFromNib {
    
}

- (UITableViewCell *)configurateInfo:(NSDictionary *)info index:(NSInteger)index {
    
    CGFloat originY = 10;
    
    self.labTitle.text = info[kTitle];
    CGFloat titleHeight = [Tool heightForNewsTitle:info[kTitle]];
    CGRect frame = self.labTitle.frame;
    frame.size.height = titleHeight;
    self.labTitle.frame = frame;
    
    originY += titleHeight + 5;
    frame = self.imgClock.frame;
    frame.origin.y = originY + 3;
    self.imgClock.frame = frame;
    
    self.labTime.text = info[kTime];
    frame = self.labTime.frame;
    frame.origin.y = originY;
    self.labTime.frame = frame;
    
    self.imgIndicator.image = [UIImage imageWithColor:[Tool indicatorColorAtIndex:index]];
    
    return self;
}

@end
