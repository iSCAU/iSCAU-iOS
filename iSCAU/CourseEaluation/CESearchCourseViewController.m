//
//  CESearchCourseViewController.m
//  iSCAU
//
//  Created by Alvin on 3/14/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "CESearchCourseViewController.h"
#import "CEHttpClient.h"
#import "CourseInfo.h"
#import "AZSideMenuViewController.h"
#import "CECourseInfoCell.h"
#import "CECourseCommentsViewController.h"

CGFloat const SearchBarHeight = 44.f;

@interface CESearchCourseViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL isSearching;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, strong) NSMutableArray *courses;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableSearch;

@end

@implementation CESearchCourseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    SET_DEFAULT_BACKGROUND_COLOR(self.tableSearch);
    
    self.courses = [NSMutableArray array];
    self.currentPage = 0;
    self.totalPage = 0;
    
    if (IS_IPHONE4) {
        CGFloat windowHeight = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = (CGRect){
            CGPointZero,
            self.view.width,
            windowHeight - 44. - 20.
        };
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(resignResponder) 
                                                 name:AZSideMenuStartPanningNotification 
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return SearchBarHeight;
    } else if (indexPath.row - 1 == self.courses.count) {
        return 50;
    } else {
        return CECourseInfoCellHeight;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((self.courses.count < self.totalCount) ? self.courses.count + 1 : self.courses.count) + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    if (row == 0) {
        static NSString *SearchBarIdentifier = @"SearchBarIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchBarIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchBarIdentifier];
            self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, SearchBarHeight)];
            self.searchBar.placeholder = @"请输入老师名或课程名";
            self.searchBar.delegate = self;
            [cell.contentView addSubview:self.searchBar];
        }
        return cell;
    }
    if (self.courses.count > 0 && self.courses.count + 1 == row) {
        static NSString *LoadMoreIdentifier = @"LoadMoreIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreIdentifier];
        if (cell == nil) {
            cell = [Tool loadMoreCellWithIdentifier:LoadMoreIdentifier];
        }
        
        // 加载下页内容
        ++self.currentPage;
        self.isLoading = YES;
        self.isSearching = NO;
        [self searchCourse];
        
        return cell;
    }
    
    static NSString *CECourseInfoCellIdentifier = @"CECourseInfoCellIdentifier";
    CECourseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CECourseInfoCellIdentifier];
    
    if (cell == nil) {
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"CECourseInfoCell" owner:self options:nil];
        cell = [cellArray objectAtIndex:0];
    }

    [cell setupWithCourseInfo:self.courses[row - 1]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    if (row == self.totalCount || row == 0) {
        return;
    } else if (row == (self.courses.count + 1)) {
        
    } else {
        CECourseCommentsViewController *commentsVC = [[CECourseCommentsViewController alloc] initWithCourseInfo:self.courses[indexPath.row - 1]];
        [self.navigationController pushViewController:commentsVC animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self resignResponder];
}

#pragma mark - searchbar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.currentPage = 1;
    
    //    bookName = searchBar.text;
    self.isSearching = YES;
    [self searchCourse];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    // 改变searchbar取消按钮的文字
    for (UIView *subview in searchBar.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *cancelBtn = (UIButton *)subview;
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

#pragma mark - Custom

- (void)searchCourse
{
    [[CEHttpClient shareInstance] 
     searchCoursesWithKeyword:self.searchBar.text 
     success:^(NSData *responseData, int httpCode) {
         NSError *error = nil;
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
         
         if (!error && [dict[CourseInfoStatusKey] isEqualToString:CourseInfoResultSuccess]) {
             NSArray *tmpCourses = dict[CourseInfoCourseKey];
             if (tmpCourses.count > 0) {
                 if (self.isSearching) {
                     [self.courses removeAllObjects];
                     self.isSearching = NO;
                 }
                                  
                 for (NSDictionary *d in tmpCourses) {
                     CourseInfo *course = [MTLJSONAdapter modelOfClass:CourseInfo.class fromJSONDictionary:d error:&error];
                     [self.courses addObject:course];
                 }
                 [self.tableSearch reloadData];
             } else {
                 SHOW_NOTICE_HUD(@"没找到相应课程");
             }
         } else {
             SHOW_NOTICE_HUD(kDefaultErrorNotice);
         }
     } failure:^(NSData *responseData, int httpCode) {
         SHOW_NOTICE_HUD(kDefaultErrorNotice);
     }];
}

- (void)resignResponder {
    [self.searchBar resignFirstResponder];
}

@end
