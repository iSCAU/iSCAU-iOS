//
//  EduSysDayClassTableView.m
//  iSCAU
//
//  Created by Alvin on 13-10-6.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "EduSysDayClassTableView.h"
#import "EduSysDayClassCell.h"
#import "EduSysClassTableEditedViewController.h"
#import "EduSysClassTableViewController.h"
#import "AZSideMenuViewController.h"

CGFloat HEADER_DAY_SELECTER_WIDTH = 320.0 / 7;
CGFloat HEADER_DAY_SELECTER_HEIGHT = 30;
CGFloat INDICATOR_INDEXT = 5.0f;
CGFloat CELL_HEIGHT = 55.0f;

static NSString *CLASSNAME = @"classname";
static NSString *DAY = @"day";
static NSString *DSZ = @"dsz";
static NSString *END_WEEK = @"endWeek";
static NSString *LOCATION = @"location";
static NSString *NODE = @"node";
static NSString *STR_WEEK = @"strWeek";
static NSString *TEACHER = @"teacher";

#define TABLE_VIEW_TAG_BASE 3000

@interface EduSysDayClassTableView()

@property (nonatomic) BOOL isScrollingWeekday;

@end

@implementation EduSysDayClassTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.currentIndex = 0;
        self.isEditing = NO;
        
        self.backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, HEADER_DAY_SELECTER_HEIGHT, self.width, self.height - HEADER_DAY_SELECTER_HEIGHT)];
        self.backgroundScrollView.contentSize = CGSizeMake(self.width * 7, self.backgroundScrollView.height);
        self.backgroundScrollView.showsHorizontalScrollIndicator = NO;
        self.backgroundScrollView.showsVerticalScrollIndicator = NO;
        self.backgroundScrollView.delegate = self;
        self.backgroundScrollView.pagingEnabled = YES;
        self.backgroundScrollView.bounces = NO;
        [self addSubview:self.backgroundScrollView];
        
        self.dayIndicator = [[UIView alloc] initWithFrame:CGRectMake(INDICATOR_INDEXT, HEADER_DAY_SELECTER_HEIGHT - 3, HEADER_DAY_SELECTER_WIDTH - INDICATOR_INDEXT * 2, 3)];
        self.dayIndicator.backgroundColor = [UIColor redColor];
        [self addSubview:self.dayIndicator];
        
        NSArray *weekdayText = @[@"MON", @"TUE", @"WED", @"THU", @"FRI", @"SAT", @"SUN"];
        for (NSInteger i = 0; i < 7; ++i) {
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(i * HEADER_DAY_SELECTER_WIDTH, 0, HEADER_DAY_SELECTER_WIDTH, HEADER_DAY_SELECTER_HEIGHT)];
            lab.backgroundColor = [UIColor clearColor];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = [UIColor darkTextColor];
            lab.alpha = 0.5;
            lab.text = weekdayText[i];
            lab.font = [UIFont systemFontOfSize:14];
            lab.tag = 1000 + i;
            [self addSubview:lab];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i * HEADER_DAY_SELECTER_WIDTH, 0, HEADER_DAY_SELECTER_WIDTH, HEADER_DAY_SELECTER_HEIGHT);
            btn.backgroundColor = [UIColor clearColor];
            btn.tag = 2000 + i;
            [btn addTarget:self action:@selector(selectWeekday:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            UITableView *classTable = [[UITableView alloc] initWithFrame:CGRectMake(i * self.width, 0, self.width, self.backgroundScrollView.height)];
            classTable.delegate = self;
            classTable.dataSource = self;
            classTable.showsHorizontalScrollIndicator = NO;
            classTable.showsVerticalScrollIndicator = NO;
            classTable.backgroundColor = [UIColor clearColor];
            classTable.tag = TABLE_VIEW_TAG_BASE + i;
            classTable.allowsSelectionDuringEditing = YES;
            classTable.separatorStyle = UITableViewCellSelectionStyleNone;
            [self.backgroundScrollView addSubview:classTable];
        }
        
        // 右拉返回手势
        [self.backgroundScrollView.panGestureRecognizer addTarget:self action:@selector(handleScrollViewPan:)];
    }
    return self;
}

- (void)enterEditingMode {
    self.isEditing = YES;
    
    for (NSInteger i = 0; i < 7; ++i) {
        UITableView *tableView = (UITableView *)[self.backgroundScrollView viewWithTag:TABLE_VIEW_TAG_BASE + i];
        [tableView setEditing:YES animated:YES];
    }
}

- (void)cancleEdit {
    self.isEditing = NO;
    
    for (NSInteger i = 0; i < 7; ++i) {
        UITableView *tableView = (UITableView *)[self.backgroundScrollView viewWithTag:TABLE_VIEW_TAG_BASE + i];
        [tableView setEditing:NO animated:YES];
    }
}

// 移到当天课程表
- (void)getWeekday{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit) fromDate:date];
    NSInteger weekday = [comps weekday];    //周日是1,周一是2..
    
    NSInteger today = weekday - 1 > 0 ? weekday - 1 : 7;
    CGRect frame = self.backgroundScrollView.frame;
    frame.origin.x = (today - 1) * self.width;

    [self changeDayIndicater:today - 1];
    [self.backgroundScrollView scrollRectToVisible:frame animated:YES];
}

- (void)reloadClassTableWithClasses:(NSArray *)classes_ {
    self.classes = [NSMutableArray arrayWithArray:classes_];
    
    [self sortedClasses];
    for (NSInteger i = 0; i < 7; ++i) {
        UITableView *tableView = (UITableView *)[self.backgroundScrollView viewWithTag:TABLE_VIEW_TAG_BASE + i];
        [tableView reloadData];
    }
    [self getWeekday];
}

- (void)selectWeekday:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag - 2000;
    [self changeDayIndicater:tag];
    
    CGRect frame = self.backgroundScrollView.frame;
    frame.origin.x = tag * self.width;
    [self.backgroundScrollView scrollRectToVisible:frame animated:YES];
}

- (void)changeDayIndicater:(NSInteger)index {
    if (index == self.currentIndex) return;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         UILabel *currentLab = (UILabel *)[self viewWithTag:1000 + self.currentIndex];
                         currentLab.alpha = 0.5;
                         
                         UILabel *newLab = (UILabel *)[self viewWithTag:1000 + index];
                         newLab.alpha = 1;
                         
                         self.currentIndex = index;
                         
                         CGRect frame = self.dayIndicator.frame;
                         frame.origin.x = index * HEADER_DAY_SELECTER_WIDTH + INDICATOR_INDEXT;
                         self.dayIndicator.frame = frame;
                     }
                     completion:^(BOOL finished) {
                     }];
}

#pragma mark - table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.classes[tableView.tag - TABLE_VIEW_TAG_BASE] count];
}

#pragma mark - table view data source delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *EduSysDayClassCellIndentifier = @"EduSysDayClassCellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EduSysDayClassCellIndentifier];
    if (cell == nil) {
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"EduSysDayClassCell" owner:self options:nil];
        cell = [cellArray objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [(EduSysDayClassCell *)cell configurateInfo:self.classes[tableView.tag - TABLE_VIEW_TAG_BASE][indexPath.row] index:indexPath.row];
    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSMutableArray *array = [self parseClassesData:[self loadLocalClassesData]];
        NSInteger index = -1;
        NSDictionary *theDic = self.classes[tableView.tag - TABLE_VIEW_TAG_BASE][indexPath.row];

        for (NSDictionary *dict in array) {
            ++index;
            if ([dict[CLASSNAME] isEqualToString:theDic[CLASSNAME]] &&
                [dict[LOCATION] isEqualToString:theDic[LOCATION]]) {
                break;
            }
        }
        if (index < array.count) {
            [array removeObjectAtIndex:index];
        }
        
        NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:@"classes"];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
        [data writeToFile:[PathHelper classTableFileName] atomically:YES];
        
        [self.classes[tableView.tag - TABLE_VIEW_TAG_BASE] removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [Tool calculateSizeWithString:[self.classes[tableView.tag - TABLE_VIEW_TAG_BASE][indexPath.row] objectForKey:CLASSNAME] font:[UIFont boldSystemFontOfSize:15] constrainWidth:270.0];
    if (size.height > 20) {
        return CELL_HEIGHT + size.height / 2;
    }
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEditing) {
        NSDictionary *classDict = self.classes[tableView.tag - TABLE_VIEW_TAG_BASE][indexPath.row];
        EduSysClassTableEditedViewController *editViewController = [[EduSysClassTableEditedViewController alloc] init];
        [editViewController setupWithExistedClass:classDict andClassesOfTheDay:self.classes[tableView.tag - TABLE_VIEW_TAG_BASE]];
        [[self viewController].navigationController pushViewController:editViewController animated:YES];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEditing) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x > 0) {
        self.isScrollingWeekday = YES;
    }
    if (!self.isScrollingWeekday && scrollView.contentOffset.x <= 0) {
        [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y)];
        return;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
    self.isScrollingWeekday = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.backgroundScrollView) {
        NSInteger page = floor((scrollView.contentOffset.x - self.width / 2) / self.width) + 1;
        [self changeDayIndicater:page];
    }
}

#pragma mark - sort

// 课程排序,根据开始节进行排序
- (void)sortedClasses {
    for (int i = 0; i < 7; i++) {
        NSInteger right = [self.classes[i] count] >= 1 ? [self.classes[i] count]-1 : 0;
        [self quicksortClasses:self.classes[i] 
                       andLeft:0 
                      andRight:right];
    }
}

- (NSInteger)getTheClassFirstTime:(NSDictionary *)dic{
    NSInteger i = 0;
    NSString *node = dic[NODE];
    NSArray *temp = [node componentsSeparatedByString:@","];
    if (temp && temp.count > 0) {
        i = [temp[0] integerValue];
    }
    return i;
}

- (void)quicksortClasses:(NSMutableArray *)theArray
                 andLeft:(NSInteger)l
                andRight:(NSInteger)r{
    NSInteger i, j;
    NSDictionary *dic = nil;
    if (l < r) {
        i = l;
        j = r;
        dic = theArray[i];
        do {
            while (([self getTheClassFirstTime:theArray[j]] > [self getTheClassFirstTime:dic]) 
                   && (i < j)) {
                --j;
            }
            if (i < j) {
                theArray[i] = theArray[j];
                i++;
            }
            while ([self getTheClassFirstTime:theArray[i]] < [self getTheClassFirstTime:dic] 
                   && (i < j)) {
                i++;
            }
            if (i < j) {
                theArray[j] = theArray[i];
                j--;
            }
        } while (i != j);
        theArray[i] = dic;
        [self quicksortClasses:theArray andLeft:l andRight:i-1];
        [self quicksortClasses:theArray andLeft:i+1 andRight:r];
    }
}

- (NSDictionary *)loadLocalClassesData {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[PathHelper classTableFileName]];
}

- (void)saveClassesDataToLocal:(NSDictionary *)classesDict {
    [classesDict writeToFile:[PathHelper classTableFileName] atomically:YES];
}

- (NSMutableArray *)parseClassesData:(NSDictionary *)classesInfo {
    if (classesInfo == nil) return nil;
    return [NSMutableArray arrayWithArray:[classesInfo objectForKey:@"classes"]];
}

// 处理标题面板拉出的手势
- (void)handleScrollViewPan:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            if (!self.isScrollingWeekday && self.backgroundScrollView.contentOffset.x <= 0) {
                [[AZSideMenuViewController shareMenu] panGesture:panGesture];
            }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if (!self.isScrollingWeekday) {
                [[AZSideMenuViewController shareMenu] panGesture:panGesture];
            }
            break;
        default:
            break;
    }
}

@end
