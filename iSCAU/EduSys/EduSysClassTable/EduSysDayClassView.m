//
//  EduSysDayClassView.m
//  iSCAU
//
//  Created by Alvin on 13-10-7.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "EduSysDayClassView.h"

@implementation EduSysDayClassView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.collapseClick = [[CollapseClick alloc] initWithFrame:self.frame];
        self.collapseClick.CollapseClickDelegate = self;
        self.collapseClick.showsVerticalScrollIndicator = NO;
        [self addSubview:self.collapseClick];
        [self.collapseClick reloadCollapseClick];
    }
    return self;
}

#pragma mark - collapse click delegate

- (int)numberOfCellsForCollapseClick {
    return self.classArray.count;
}

- (NSString *)titleForCollapseClickAtIndex:(int)index {
    return [self.classArray[index] objectForKey:@"title"];
}

- (UIView *)viewForCollapseClickContentViewAtIndex:(int)index {
    UIFont *font = [UIFont systemFontOfSize:14];
    CGFloat offset = 10.0f;
    NSLineBreakMode lineBreakMode = NSLineBreakByWordWrapping;
    NSString *content = [self.classArray[index] objectForKey:@"content"];
    CGSize infoSize = [content sizeWithFont:font
                          constrainedToSize:CGSizeMake(self.width - offset * 2, MAXFLOAT)
                              lineBreakMode:lineBreakMode];
    UILabel *labInfo = [[UILabel alloc] initWithFrame:CGRectMake(offset, 0, self.width - offset * 2, infoSize.height)];
    labInfo.font = font;
    labInfo.text = content;
    labInfo.textColor = [UIColor darkGrayColor];
    labInfo.lineBreakMode = lineBreakMode;
    labInfo.backgroundColor = [UIColor clearColor];
    labInfo.numberOfLines = 0;
    
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, infoSize.height + 5)];
    infoView.backgroundColor = [UIColor clearColor];
    [infoView addSubview:labInfo];
    
    return infoView;
}

-(UIColor *)colorForCollapseClickTitleViewAtIndex:(int)index {
    return [UIColor clearColor];
}

-(UIColor *)colorForTitleLabelAtIndex:(int)index {
    return [UIColor blackColor];
}

@end
