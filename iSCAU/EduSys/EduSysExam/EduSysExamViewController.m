//
//  EduSysExamViewController.m
//  iSCAU
//
//  Created by Alvin on 13-9-10.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "EduSysExamViewController.h"
#import "EduSysHttpClient.h"
#import "EduSysExamInfoCell.h"
#import "UIImage+Tint.h"

#define CELL_HEIGHT 122
#define EXAM_INFO_CAMPUS        @"campus"
#define EXAM_INFO_FORM          @"form"
#define EXAM_INFO_NAME          @"name"
#define EXAM_INFO_NAME_STUDENT  @"name_student"
#define EXAM_INFO_PLACE         @"place"
#define EXAM_INFO_SEAT_NUMBER   @"seat_number"
#define EXAM_INFO_TIME          @"time"

@interface EduSysExamViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) BOOL isReloading;
@property (nonatomic, weak) IBOutlet UITableView *tableExamInfo;
@property (nonatomic, strong) NSMutableArray *examInfoArray;
@end

@implementation EduSysExamViewController

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
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    if (IS_FLAT_UI) {
        btnClose.frame = CGRectMake(0, 0, 45, 44);
    } else {
        btnClose.frame = CGRectMake(0, 0, 55, 44);
        btnClose.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    [btnClose setImage:[[UIImage imageNamed:@"refresh.png"] imageWithTintColor:APP_DELEGATE.tintColor] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btnClose];
    self.navigationItem.rightBarButtonItem = closeBarBtn;
    
    self.examInfoArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    SET_DEFAULT_BACKGROUND_COLOR(self.tableExamInfo);
    [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData {
    if (self.isReloading) {
        return;
    }
    if ([Tool stuNum].length < 1 || [Tool stuPwd].length < 1) {
        SHOW_NOTICE_HUD(@"请先填写对应账号密码哦");
        return;
    }
    
    SHOW_WATING_HUD;
    self.isReloading = YES;
    [EduSysHttpClient eduSysGetExamSuccess:^(NSData *responseData, int httpCode){
        self.isReloading = NO;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:NULL];
        if (httpCode == 200) {
            HIDE_ALL_HUD;
            self.examInfoArray = dict[@"exam"];
            [self.tableExamInfo reloadData];
        }
    }failure:^(NSData *responseData, int httpCode){
        self.isReloading = NO;
    }];
}

#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.examInfoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *EduSysExamInfoCellIndentifier = @"EduSysExamInfoCellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EduSysExamInfoCellIndentifier];
    if (cell == nil) {
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"EduSysExamInfoCell" owner:self options:nil];
        cell = [cellArray objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    [(EduSysExamInfoCell *)cell configurateInfo:self.examInfoArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
