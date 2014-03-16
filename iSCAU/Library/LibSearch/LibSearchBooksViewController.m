//
//  LibSearchBooksViewController.m
//  iSCAU
//
//  Created by Alvin on 13-9-11.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "LibSearchBooksViewController.h"
#import "LibHttpClient.h"
#import "CardStyleView.h"
#import "LibSearchBooksCell.h"
#import "LibSearchBooksDetailViewController.h"
#import "AZSideMenuViewController.h"

#define kTitle  1000
#define kAuthor 1001
#define kPress  1002
#define kSerial 1003

@interface LibSearchBooksViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> 
{    
    NSInteger totalCount;
    NSInteger currentPage;
    NSInteger totalPage;
    NSMutableArray *array;
    NSString *bookName;
    BOOL isLoading;
    BOOL isSearchingBooks;
}

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet    UITableView         *tableSearch;
@property (nonatomic, strong) NSMutableArray *books;

@end

@implementation LibSearchBooksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // ----- 初始化 -----
    array = [[NSMutableArray alloc] init];
    currentPage = 0;
    totalPage = 0;
    
    if (IS_IPHONE4) {
        self.view.frame = CGRectMake(0, 0, self.view.width, 480 - 44 - 20.0);
    }
    
    self.books = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(resignResponder) 
                                                 name:AZSideMenuStartPanningNotification 
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AZSideMenuStartPanningNotification object:nil];
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 44;
    } else if (indexPath.row - 1 == self.books.count) {
        return 50;
    } else {
        return 120;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((self.books.count < totalCount) ? self.books.count + 1 : self.books.count) + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    if (row == 0) {
        static NSString *SearchBarIdentifier = @"SearchBarIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchBarIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchBarIdentifier];
            self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
            self.searchBar.placeholder = @"请输入书名或关键词";
            self.searchBar.delegate = self;
            [cell.contentView addSubview:self.searchBar];
        }
        return cell;
    }
    if (self.books.count > 0 && self.books.count + 1 == row) {
        static NSString *LoadMoreIdentifier = @"LoadMoreIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreIdentifier];
        NSInteger tagActivityView = 1100;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityView.center = cell.contentView.center;
            [activityView startAnimating];
            activityView.tag = tagActivityView;
            [cell.contentView addSubview:activityView];
        }
        UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[cell.contentView viewWithTag:tagActivityView];
        [activityView startAnimating];
        
        // 加载下页内容
        ++currentPage;
        isLoading = YES;
        isSearchingBooks = NO;
        [self searchBook];
        
        return cell;
    }
    
    static NSString *LibrarySearchBooksViewIdentifier = @"LibrarySearchBooksViewIdentifier";
    LibSearchBooksCell *cell = [tableView dequeueReusableCellWithIdentifier:LibrarySearchBooksViewIdentifier];

    if (cell == nil) {
        cell = [[LibSearchBooksCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LibrarySearchBooksViewIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *info = [self.books objectAtIndex:row - 1];

    UILabel *labTitle = (UILabel *)[cell.contentView viewWithTag:kTitle];
    labTitle.text = [info objectForKey:TITLE];
    
    UILabel *labAuthor = (UILabel *)[cell.contentView viewWithTag:kAuthor];
    labAuthor.text = [[NSString alloc] initWithFormat:@"作者  : %@", [info objectForKey:AUTHOR]];

    UILabel *labPress = (UILabel *)[cell.contentView viewWithTag:kPress];
    labPress.text = [NSString stringWithFormat:@"出版社 : %@", [info objectForKey:PRESS]];

    UILabel *labSerial = (UILabel *)[cell.contentView viewWithTag:kSerial];
    labSerial.text = [NSString stringWithFormat:@"编号 : %@", [info objectForKey:SERIAL_NUMBER]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    if (row == totalCount || row == 0) {
        return;
    } else if (row == (self.books.count + 1)) {

    } else {
        SHOW_WATING_HUD;
        [[LibHttpClient shareInstance] 
         libGetBookDetailWithAddress:self.books[row - 1][URL] 
         success:^(NSData *responseData, int httpCode) {
             NSDictionary *detailInfos = [NSJSONSerialization JSONObjectWithData:responseData 
                                                                         options:kNilOptions
                                                                           error:nil];
             if (httpCode == 200 && detailInfos && detailInfos[@"details"]) {
                 HIDE_ALL_HUD;
                 LibSearchBooksDetailViewController *detailViewController = [[LibSearchBooksDetailViewController alloc] init];
                 if (detailInfos[@"details"] && [detailInfos[@"details"][0] isKindOfClass:[NSNull class]]) {
                     SHOW_NOTICE_HUD(@"没有详细信息呢");
                 } else {
                     detailViewController.detailInfos = detailInfos[@"details"];
                     detailViewController.bookName = self.books[row - 1][TITLE];
                     [self.navigationController pushViewController:detailViewController animated:YES];
                 }
             }
         } failure:nil];
    }
}

- (void)searchBook {
    [[LibHttpClient shareInstance]
     libSearchBooksWithTitle:bookName
     page:currentPage
    success:^(NSData *responseData, NSInteger httpCode){
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        isLoading = NO;
        if (httpCode == 200) {
            // 查找结果数
            totalCount = [[dict objectForKey:@"count"] integerValue];
            totalPage = totalCount / 10;
            if ((totalCount % 10) > 0) totalPage++;
            
            if (isSearchingBooks) {
                [self.books removeAllObjects];
                self.books = nil;
                self.books = [[NSMutableArray alloc] initWithArray:[dict objectForKey:@"books"]];
            } else {
                [self.books addObjectsFromArray:[[NSMutableArray alloc] initWithArray:[dict objectForKey:@"books"]]];
            }
            isSearchingBooks = NO;
            [self.tableSearch reloadData];
        }                                       
    }
    failure:^(NSData *responseData, NSInteger httpCode){
        isSearchingBooks = NO;
        isLoading = NO;
    }];
}

#pragma mark - searchbar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    currentPage = 1;
    
    bookName = searchBar.text;
    isSearchingBooks = YES;
    [self searchBook];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    // 改变searchbar取消按钮的文字
    for (UIView *subview in searchBar.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *cancelBtn = (UIButton *)subview;
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

#pragma mark - Custom

- (void)resignResponder {
    [self.searchBar resignFirstResponder];
}


@end
