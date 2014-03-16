//
//  CECourseCommentsViewController.m
//  iSCAU
//
//  Created by Alvin on 3/15/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "CECourseCommentsViewController.h"
#import "CECourseInfoCell.h"
#import "CECourseCommentCell.h"
#import "CEHttpClient.h"

#define HEIGHt_4_SECTION 30

@interface CECourseCommentsViewController ()

@property (nonatomic, strong) CourseInfo *courseInfo;
@property (nonatomic, strong) UIButton *btnWriteComment;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic) NSInteger page;
@property (nonatomic) NSInteger totalPage;
@property (nonatomic) NSInteger totalCount;
@property (nonatomic) BOOL      isReload;
@property (nonatomic) BOOL      isLoadMore;

@end

@implementation CECourseCommentsViewController

- (instancetype)initWithCourseInfo:(CourseInfo *)courseInfo
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    self.courseInfo = courseInfo;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;

    SET_DEFAULT_BACKGROUND_COLOR(self.tableView);
    
    // Pull to refresh
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];  
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];  
    [refresh addTarget:self action:@selector(reloadComments) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    CGFloat controlViewHeight = 44.0;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, controlViewHeight, 0);
    
    CGRect frame = CGRectZero;
    if (SystemVersion_floatValue >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    if (IS_IPHONE4) {
        frame = self.view.frame;
        frame.size.height -= (88.0 + 44.0f);
        self.view.frame = frame;
    } else {
        frame = self.view.frame;
        frame.size.height -= (20.f + 44.0f);
        self.view.frame = frame;
    }
    
    // ControlView
    self.btnWriteComment = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnWriteComment.frame = (CGRect) {
        0,
        self.view.height - controlViewHeight,
        self.view.width,
        controlViewHeight
    };
    [self.btnWriteComment setTitle:@"写评论" forState:UIControlStateNormal];
    self.btnWriteComment.backgroundColor = [UIColor whiteColor];
    [self.btnWriteComment setTitleColor:APP_DELEGATE.tintColor forState:UIControlStateNormal];
    self.btnWriteComment.layer.zPosition = 1000;        // Used to cover tableview's section
    [self.view insertSubview:self.btnWriteComment aboveSubview:self.tableView];
    
    self.comments = [NSMutableArray array];
    self.page = 1;
    
    [self reloadComments];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (self.comments.count > 0 && self.comments.count < self.totalCount) {
        return self.comments.count + 1;
    } else if (self.comments.count == self.totalCount) {
        return self.comments.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CECourseInfoCellIdentifier = @"CECourseInfoCellIdentifier";
        CECourseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CECourseInfoCellIdentifier];
        
        if (cell == nil) {
            NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"CECourseInfoCell" owner:self options:nil];
            cell = [cellArray objectAtIndex:0];
        }
        [cell setupWithCourseInfo:self.courseInfo];
        return cell;    
    } else {
        NSUInteger row = indexPath.row;
        if (row < self.comments.count) {
            static NSString *CECourseCommentCellIdentifier = @"CECourseCommentCellIdentifier";
            CECourseCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CECourseCommentCellIdentifier];
            if (cell == nil) {
                NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"CECourseCommentCell" owner:self options:nil];
                cell = [cellArray objectAtIndex:0];
            }
            [cell setupWithCourseComment:self.comments[row]];
            
            return cell;
        } else {
            static NSString *LoadMoreIdentifier = @"LoadMoreIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreIdentifier];
            if (cell == nil) {
                cell = [Tool loadMoreCellWithIdentifier:LoadMoreIdentifier];
            }
            if (self.comments.count < self.totalCount) {
                [self loadMoreComments];
            }
            return cell;
        }
    }
}

#pragma mark - TableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 126;
    }
    return ((indexPath.row < self.comments.count) ? [CECourseCommentCell heightWithComment:self.comments[indexPath.row]] : 44.0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return HEIGHt_4_SECTION;
}

#pragma mark - Course evaluation request

- (void)loadMoreComments
{
    if (self.isReload || self.isLoadMore || self.page >= self.totalPage) {
        return;
    }
    
    self.isLoadMore = YES;
    
    [[CEHttpClient shareInstance] 
     getCommentsWithCourseId:self.courseInfo.courseId
     page:self.page + 1
     success:^(NSData *responseData, int httpCode) {
         self.isLoadMore = NO;
         self.page++;
         
         NSError *error = nil;
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
         
         if (!error && [dict[CourseInfoStatusKey] isEqualToString:CourseInfoResultSuccess]) {
             NSArray *tmpComments = dict[CourseInfoCommentsKey];
             
             if (tmpComments.count > 0) {
                 for (NSDictionary *d in tmpComments) {
                     CourseComment *c = [MTLJSONAdapter modelOfClass:CourseComment.class fromJSONDictionary:d error:&error];
                     if (!error) {
                         [self.comments addObject:c];
                     }
                 }
                 [self.tableView reloadData];
                 [self.refreshControl endRefreshing];
             }
         }
     } 
     failure:^(NSData *responseData, int httpCode) {
         self.isLoadMore = NO;
         SHOW_NOTICE_HUD(@"错误..");
     }];
}

- (void)reloadComments
{
    if (self.isReload || self.isLoadMore) {
        return;
    }
    
    self.isReload = YES;
    
    [[CEHttpClient shareInstance] 
     getCommentsWithCourseId:self.courseInfo.courseId
     page:self.page
     success:^(NSData *responseData, int httpCode) {
         self.isReload = NO;
         
         NSError *error = nil;
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
         
         if (!error && [dict[CourseInfoStatusKey] isEqualToString:CourseInfoResultSuccess]) {
             
             self.page = 1;
             self.totalPage = [dict[CourseInfoSumPageKey] integerValue];
             self.totalCount = [dict[CourseInfoCountKey] integerValue];
             NSLog(@"t %d %d", self.totalPage, self.totalCount);
             
             NSArray *tmpComments = dict[CourseInfoCommentsKey];
             
             if (tmpComments.count > 0) {
                 
                 [self.comments removeAllObjects];
                 
                 for (NSDictionary *d in tmpComments) {
                     CourseComment *c = [MTLJSONAdapter modelOfClass:CourseComment.class fromJSONDictionary:d error:&error];
                     if (!error) {
                         [self.comments addObject:c];
                     }
                 }
                 [self.tableView reloadData];
                 [self.refreshControl endRefreshing];
             }
         }
     } 
     failure:^(NSData *responseData, int httpCode) {
         self.isReload = NO;
         SHOW_NOTICE_HUD(@"错误..");
     }];
}

#pragma mark - ScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect frame = self.btnWriteComment.frame;
    frame.origin.y = self.view.height - 44.0 + scrollView.contentOffset.y;
    self.btnWriteComment.frame = frame;
}

@end
