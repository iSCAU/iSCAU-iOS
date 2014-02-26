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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    if (yOffset < -kImageOriginHight) {
        CGRect f = self.headerImageView.frame;
        f.origin.y = yOffset;
        f.size.height =  -yOffset;
        self.headerImageView.frame = f;
    }
}

- (void)loadNews {
    if (!self.isLoading) {
        self.isLoading = YES;
        [AZNewsHttpClient newsGetListWithPage:self.page + 1 success:^(NSData *responseData, int httpCode) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
            if (httpCode == 200 && dict && dict[@"notice"]) {
                ++self.page;
                [self.news addObjectsFromArray:dict[@"notice"]];
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

#pragma mark - Table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.news.count > 0 && self.news.count < self.totalNewsCount) {
        return self.news.count + 1;
    } else if (self.news.count == self.totalNewsCount) {
        return self.totalNewsCount;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.news.count > 0 && indexPath.row == self.news.count && self.news.count < self.totalNewsCount) {
        return 44.f;
    } else {
        CGFloat titleHeight = [Tool heightForNewsTitle:self.news[indexPath.row][@"title"]];
        return titleHeight + 40;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

@end
