//
//  EduSysWeekClassTableView.m
//  iSCAU
//
//  Created by Alvin on 13-10-6.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "EduSysWeekClassTableView.h"

CGFloat HORIZONTAL_HEADER_ITEM_HEIGHT = 25.0f;
CGFloat HORIZONTAL_HEADER_ITEM_WIDTH = 60.0f;

CGFloat VERTICAL_HEADER_ITEM_HEIGHT = 50.0f;
CGFloat VERTICAL_HEADER_ITEM_WIDTH = 25.0f;

@implementation EduSysWeekClassTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.weekdayArray = @[@"星期一", @"星期一", @"星期一", @"星期一", @"星期一", @"星期一", @"星期一",];
        self.classTimeArray = @[@"一", @"一", @"一", @"一", @"一", @"一", @"一", @"一", @"一", @"一", @"一", @"一"];
        [self setupView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame classes:(NSArray *)classes {
    self = [super initWithFrame:frame];
    if (self) {
        self.classesArray = [[NSMutableArray alloc] initWithArray:classes copyItems:YES];
        self.weekdayArray = @[@"星期一", @"星期一", @"星期一", @"星期一", @"星期一", @"星期一", @"星期一",];
        self.classTimeArray = @[@"一", @"一", @"一", @"一", @"一", @"一", @"一", @"一", @"一", @"一", @"一", @"一"];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.headerWeekDay = [[UIScrollView alloc] initWithFrame:CGRectMake(VERTICAL_HEADER_ITEM_WIDTH, 0, self.width - VERTICAL_HEADER_ITEM_WIDTH, HORIZONTAL_HEADER_ITEM_HEIGHT)];
    self.headerWeekDay.contentSize = CGSizeMake(self.weekdayArray.count * HORIZONTAL_HEADER_ITEM_WIDTH, HORIZONTAL_HEADER_ITEM_HEIGHT);
    self.headerWeekDay.delegate = self;
    self.headerWeekDay.bounces = NO;
    self.headerWeekDay.showsHorizontalScrollIndicator = NO;
    self.headerWeekDay.showsVerticalScrollIndicator = NO;
    [self addSubview:self.headerWeekDay];
    
    for (int i = 0; i < self.weekdayArray.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * HORIZONTAL_HEADER_ITEM_WIDTH, 0, HORIZONTAL_HEADER_ITEM_WIDTH, HORIZONTAL_HEADER_ITEM_HEIGHT)];
        label.text = self.weekdayArray[i];
        label.backgroundColor = (i % 2 == 0) ? [UIColor yellowColor] : [UIColor blueColor];
        label.adjustsFontSizeToFitWidth = YES;
        [self.headerWeekDay addSubview:label];
    }
    
    self.headerClassTime = [[UIScrollView alloc] initWithFrame:CGRectMake(0, HORIZONTAL_HEADER_ITEM_HEIGHT, VERTICAL_HEADER_ITEM_WIDTH, self.height - HORIZONTAL_HEADER_ITEM_HEIGHT)];
    self.headerClassTime.contentSize = CGSizeMake(VERTICAL_HEADER_ITEM_WIDTH, self.classTimeArray.count * VERTICAL_HEADER_ITEM_HEIGHT);
    self.headerClassTime.delegate = self;
    self.headerClassTime.bounces = NO;
    self.headerClassTime.showsHorizontalScrollIndicator = NO;
    self.headerClassTime.showsVerticalScrollIndicator = NO;
    [self addSubview:self.headerClassTime];
    
    for (int i = 0; i < self.classTimeArray.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, i * VERTICAL_HEADER_ITEM_HEIGHT, VERTICAL_HEADER_ITEM_WIDTH, VERTICAL_HEADER_ITEM_HEIGHT)];
        label.text = [NSString stringWithFormat:@"%d", i];
        label.backgroundColor = (i % 2 == 0) ? [UIColor yellowColor] : [UIColor blueColor];
        label.adjustsFontSizeToFitWidth = YES;
        [self.headerClassTime addSubview:label];
    }
    
    self.classTable = [[UIScrollView alloc] initWithFrame:CGRectMake(VERTICAL_HEADER_ITEM_WIDTH, HORIZONTAL_HEADER_ITEM_HEIGHT, self.width - VERTICAL_HEADER_ITEM_WIDTH, self.height - HORIZONTAL_HEADER_ITEM_HEIGHT)];
    self.classTable.contentSize = CGSizeMake(self.weekdayArray.count * HORIZONTAL_HEADER_ITEM_WIDTH, self.classTimeArray.count * VERTICAL_HEADER_ITEM_HEIGHT);
    self.classTable.delegate = self;
    self.classTable.bounces = NO;
    self.classTable.showsHorizontalScrollIndicator = NO;
    self.classTable.showsVerticalScrollIndicator = NO;
    [self addSubview:self.classTable];
}

#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    if (scrollView == self.headerWeekDay) {
        [self.classTable setContentOffset:CGPointMake(offset.x, self.classTable.contentOffset.y)];
    } else if (scrollView == self.headerClassTime) {
        [self.classTable setContentOffset:CGPointMake(self.classTable.contentOffset.x, offset.y)];
    } else {
        [self.headerWeekDay setContentOffset:CGPointMake(offset.x, 0)];
        [self.headerClassTime setContentOffset:CGPointMake(0, offset.y)];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
