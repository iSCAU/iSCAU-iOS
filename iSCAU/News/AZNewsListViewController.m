//
//  AZNewsListViewController.m
//  iSCAU
//
//  Created by Alvin on 2/17/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "AZNewsListViewController.h"
#import "AZNewsHttpClient.h"
#import "AZNewsCell.h"
#import "Notice.h"
#import "AZNewsDetailViewController.h"

#define yOffsetRate  0.5

@interface AZNewsListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) BOOL isLoading;
@property (nonatomic) NSInteger page;
@property (nonatomic) NSInteger totalNewsCount;
@property (nonatomic, strong) NSMutableArray *news;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableNews;

@end

static CGFloat kImageOriginHight = 180.f;

@implementation AZNewsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.news = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.headerImageView = [[UIImageView alloc] initWithFrame:(CGRect) {
        0,
        -kImageOriginHight,
        self.view.width,
        kImageOriginHight
    }];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.image = [UIImage imageNamed:@"news_list_header.png"];
    
    self.tableNews.contentInset = UIEdgeInsetsMake(kImageOriginHight, 0, 0, 0);
    [self.tableNews addSubview:self.headerImageView];
    
    self.page = 0;
    [self loadNews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNotice:) name:SHOW_NOTICE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideNotice:) name:HIDE_NOTICE_NOTIFICATION object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;
    if (yOffset < -kImageOriginHight) {
        CGRect f = self.headerImageView.frame;
        f.origin.y = yOffset;
        f.size.height =  -yOffset;
        self.headerImageView.frame = f;
    }
}

- (void)loadNews 
{
    if (!self.isLoading) {
        self.isLoading = YES;
        [[AZNewsHttpClient shareInstance] newsGetListWithPage:self.page + 1 success:^(NSData *responseData, int httpCode) {
            
            NSError *error = nil;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData 
                                                                 options:kNilOptions 
                                                                   error:&error];
            if (!error && httpCode == RequestSuccess && dict && dict[@"notice"]) {
                ++self.page;
                
                for (NSDictionary *d in dict[@"notice"]) {
                     Notice *notice = [MTLJSONAdapter modelOfClass:Notice.class fromJSONDictionary:d error:&error];
                    [self.news addObject:notice];
                }

                if (self.page == 1) {
                    self.totalNewsCount = [dict[@"count"] integerValue];
                }
                
                [self.tableNews reloadData];
                self.isLoading = NO;
            }
        } failure:^(NSData *responseData, int httpCode) {
            self.isLoading = NO;
        }];
    }
}

#pragma mark - Notice

- (void)showNotice:(NSNotification *)notification 
{
    NSDictionary *info = notification.userInfo;
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (info[kNotice]) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = info[kNotice];
    }
    
    if (info[kHideNoticeIntervel]) {
        float intervel = [info[kHideNoticeIntervel] floatValue];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, intervel * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }
}

- (void)hideNotice:(NSNotification *)notification 
{
    HIDE_ALL_HUD;
}

#pragma mark - Table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (self.news.count > 0 && self.news.count < self.totalNewsCount) {
        return self.news.count + 1;
    } else if (self.news.count == self.totalNewsCount) {
        return self.totalNewsCount;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (self.news.count > 0 && indexPath.row == self.news.count && self.news.count < self.totalNewsCount) {
        return 44.f;
    } else {
        Notice *notice = self.news[indexPath.row];
        CGFloat titleHeight = [Tool heightForNewsTitle:notice.title];
        return titleHeight + 40;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (self.news.count > 0 && indexPath.row == self.news.count && self.news.count < self.totalNewsCount) {
        static NSString *LoadMoreIdentifier = @"LoadMoreIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreIdentifier];
        NSInteger tagActivityView = 1100;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreIdentifier];
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityView.center = cell.contentView.center;
            [activityView startAnimating];
            activityView.tag = tagActivityView;
            [cell.contentView addSubview:activityView];
        }
        UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[cell.contentView viewWithTag:tagActivityView];
        [activityView startAnimating];
        
        // 加载下页内容
        [self loadNews];
        
        return cell;
        
    } else {
        static NSString *NewsCellIdentifier = @"NewsCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsCellIdentifier];
        if (cell == nil) {
            NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"AZNewsCell" owner:self options:nil];
            cell = [cellArray objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        [(AZNewsCell *)cell configurateInfo:self.news[indexPath.row] index:indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.news.count) {
        Notice *notice = self.news[indexPath.row];
        SHOW_WATING_HUD;
        [[AZNewsHttpClient shareInstance] newsGetContentWithURL:notice.url
                                                        success:^(NSData *responseData, int httpCode) {
                                                            if (httpCode == RequestSuccess) {
                                                                HIDE_ALL_HUD;
                                                                NSError *error = nil;
                                                                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
                                                                if (error || !dict[@"content"]) {
                                                                    
                                                                } else {
                                                                    notice.content = dict[@"content"];
                                                                    AZNewsDetailViewController *noticeDetailViewController = [[AZNewsDetailViewController alloc] initWithNotice:notice];
                                                                    [self.navigationController pushViewController:noticeDetailViewController animated:YES];
                                                                }
                                                            }
                                                        } failure:^(NSData *responseData, int httpCode) {
                                                            
                                                        }];
    }
}

@end
