//
//  EduSysMarksViewController.m
//  iSCAU
//
//  Created by Alvin on 13-9-10.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "EduSysMarksViewController.h"
#import "EduSysHttpClient.h"
#import "EduSysMarkCell.h"
#import "AppDelegate.h"
#import "UIButton+Bootstrap.h"
#import "EduSysMarksDetailViewController.h"

#define HEADER_HEIGHT   25
#define CELL_HEIGHT     55
#define kGoals  @"goals"
#define kParams @"params"
#define kParamsKey @"key"
#define kParamsValue @"value"

static NSString *CREDIT = @"credit";
static NSString *GOAL = @"goal";
static NSString *GRADE_POINT = @"grade_point";

@interface EduSysMarksViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    CGFloat averageCredit;
    CGFloat totalMarks;
}

@property (nonatomic) BOOL isReloading;
@property (nonatomic, assign) NSInteger schoolYearIndex;
@property (nonatomic, assign) NSInteger semesterIndex;
@property (nonatomic, strong) UIControl *paramsBackgroundView;
@property (nonatomic, strong) NSMutableArray      *marksArray;
@property (nonatomic, strong) NSArray             *schoolYearArray;
@property (nonatomic, strong) NSArray             *semesterArray;

@property (nonatomic, weak) IBOutlet UIView              *paramsSelectorView;
@property (nonatomic, weak) IBOutlet UITableView         *tableMarks;
@property (weak, nonatomic) IBOutlet UILabel *labSchoolYear;
@property (weak, nonatomic) IBOutlet UILabel *labSemester;

@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdateParams;
@property (weak, nonatomic) IBOutlet UIPickerView *selectionPicker;

@end

@implementation EduSysMarksViewController

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
    
    self.navigationItem.title = @"成绩";
    UIBarButtonItem *btnShowParams = [[UIBarButtonItem alloc] initWithTitle:@"时间选择" style:UIBarButtonItemStylePlain target:self action:@selector(showParamsView)];
    self.navigationItem.rightBarButtonItem = btnShowParams;
    
    CGRect frame = self.selectionPicker.frame;
    frame.size.height = 162.f;
    self.selectionPicker.frame = frame;
        
    UIWindow *applicationWindow = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    frame = self.paramsSelectorView.frame;
    frame.origin.y = applicationWindow.bounds.size.height;
    self.paramsSelectorView.frame = frame;
    [applicationWindow addSubview:self.paramsSelectorView];
    
    [self.btnUpdateParams successStyle];
    [self.btnSearch successStyle];
    
    averageCredit = 0;
    totalMarks = 0;
    
    self.schoolYearArray = [Tool schoolYear];
    self.schoolYearIndex = 0;
    self.semesterArray = [Tool semester];
    self.semesterIndex = 0;
    
    if (!self.schoolYearArray || !self.semesterArray) {
        [self updateParams:nil];
    }
    
    [self setupParams];
    [self loadLocalMarks];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

- (void)showParamsView {
    UIWindow *applicationWindow = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    if (self.paramsBackgroundView == nil) {
        self.paramsBackgroundView = [[UIControl alloc] initWithFrame:self.view.bounds];
    }
    self.paramsBackgroundView.backgroundColor = [UIColor blackColor];
    self.paramsBackgroundView.alpha = 0.0;
    [self.paramsBackgroundView addTarget:self action:@selector(hideParamsView) forControlEvents:UIControlEventTouchUpInside];
    [applicationWindow insertSubview:self.paramsBackgroundView belowSubview:self.paramsSelectorView];
    
    CGRect frame = self.paramsSelectorView.frame;
    frame.origin.y = applicationWindow.bounds.size.height;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.paramsSelectorView.frame = CGRectMake(0, applicationWindow.bounds.size.height - self.paramsSelectorView.height, self.paramsSelectorView.width, self.paramsSelectorView.height);
                         
                         self.paramsBackgroundView.alpha = 0.3;
                     }];
}

- (void)hideParamsView {
    if (self.paramsBackgroundView != nil) {
        UIWindow *applicationWindow = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
        [UIView animateWithDuration:0.3
                         animations:^{
                             CGRect frame = self.paramsSelectorView.frame;
                             frame.origin.y = applicationWindow.bounds.size.height;
                             self.paramsSelectorView.frame = frame;
                             
                             self.paramsBackgroundView.alpha = 0.0;
                         }completion:^(BOOL finished){
                             [self.paramsBackgroundView removeFromSuperview];
                         }];
    }
}

// 刷新时间参数
- (void)updateParams:(id)sender {
    [self hideParamsView];
    
    if ([Tool stuNum].length < 1 || [Tool stuPwd].length < 1) {
        SHOW_NOTICE_HUD(@"请先填写对应账号密码哦");
        return;
    }
    
    SHOW_NOTICE_HUD(@"努力加载参数中...");
    [EduSysHttpClient eduSysGetMarksInfoSuccess:^(NSData *responseData, NSInteger httpCode){
        if (httpCode == 200) {
            HIDE_ALL_HUD;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
            NSArray *paramsArray = dict[kParams];
            if (paramsArray == nil || paramsArray.count < 2) return;
            self.schoolYearArray = paramsArray[0][kParamsValue];
            self.semesterArray = paramsArray[1][kParamsValue];
            
            if (self.schoolYearArray && self.semesterArray) {
                [Tool setSchoolYear:self.schoolYearArray];
                [Tool setSemester:self.semesterArray];
                [self setupParams];
            }
        }
    } failure:nil];
}

- (void)loadLocalMarks {    
    NSData *localMarksData = [[NSData alloc] initWithContentsOfFile:[PathHelper marksCacheFileName]];
    [self parseMarksInfo:localMarksData];
}

- (void)saveMarksDataToLocal:(NSData *)marksData {
    [marksData writeToFile:[PathHelper marksCacheFileName] atomically:YES];
}

// 请求成绩数据
- (IBAction)getMarks:(id)sender {
    if ([Tool stuNum].length < 1 || [Tool stuPwd].length < 1) {
        SHOW_NOTICE_HUD(@"请先填写对应账号密码哦");
        return;
    }

    [self hideParamsView];
    if (self.schoolYearIndex < self.schoolYearArray.count &&
        self.semesterIndex < self.semesterArray.count) {
        SHOW_WATING_HUD;
        self.isReloading = YES;
        [EduSysHttpClient eduSysGetMarksWithYear:self.schoolYearArray[self.schoolYearIndex]
                                           tearm:self.semesterArray[self.semesterIndex]
                                         success:^(NSData *responseData, int httpCode){
                                             self.isReloading = NO;
                                             if (httpCode == 200) {
                                                 HIDE_ALL_HUD;
                                                 [self parseMarksInfo:responseData];
                                                 [self saveMarksDataToLocal:responseData];
                                             }
                                         }
                                         failure:^(NSData *responseData, int httpCode){
                                             self.isReloading = NO;
                                         }];
    }
}

- (void)parseMarksInfo:(NSData *)data {
    if (data == nil) return;
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    if (dict[kGoals] == nil) return;
    
    self.marksArray = dict[kGoals];
    [self calculateMarks];
    [self.tableMarks reloadData];
}

- (void)setupParams {
    if (self.schoolYearArray.count > 0 && self.semesterArray.count > 0) {
        self.labSchoolYear.text = self.schoolYearArray[0];
        self.schoolYearIndex = 0;
        
        self.labSemester.text = self.semesterArray[0];
        self.semesterIndex = 0;
        
        [self.selectionPicker reloadAllComponents];
    }
}

- (void)calculateMarks {
    
    averageCredit = 0;
    totalMarks  = 0;
    
    CGFloat totalCredit = 0;
    
    for (NSDictionary *dict in self.marksArray) {
        //计算总学分和绩点
        float credit = [[dict objectForKey:CREDIT] floatValue];
        float gpa = [[dict objectForKey:GRADE_POINT] floatValue];
        totalMarks += (credit * gpa);
        totalCredit += credit;
    }
    averageCredit = totalMarks / totalCredit;
}

#pragma mark - table view data source delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.marksArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, HEADER_HEIGHT)];
    headerSectionView.backgroundColor = [UIColor colorFromHexRGB:@"FFFFFF" alpha:0.9];
    
    CGFloat fontSize = 13;
    
    UILabel *labAverageCredits = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, HEADER_HEIGHT)];
    labAverageCredits.backgroundColor = [UIColor clearColor];
    labAverageCredits.font = [UIFont systemFontOfSize:fontSize];
    labAverageCredits.text = [NSString stringWithFormat:@"平均绩点：%.2f", averageCredit];
    labAverageCredits.textColor = APP_DELEGATE.tintColor;
    [headerSectionView addSubview:labAverageCredits];
    
    UILabel *labTotalMarks = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 150, HEADER_HEIGHT)];
    labTotalMarks.backgroundColor = [UIColor clearColor];
    labTotalMarks.font = [UIFont systemFontOfSize:fontSize];
    labTotalMarks.text = [NSString stringWithFormat:@"学分绩点总和：%.2f", totalMarks];
    labTotalMarks.textColor = APP_DELEGATE.tintColor;
    [headerSectionView addSubview:labTotalMarks];
        
    return headerSectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *EduSysMarkCellIndentifier = @"EduSysMarkCellEduSysMarkCellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EduSysMarkCellIndentifier];
    if (cell == nil) {
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"EduSysMarkCell" owner:self options:nil];
        cell = [cellArray objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [(EduSysMarkCell *)cell configurateInfo:self.marksArray[indexPath.row] index:indexPath.row];

    return cell;
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [Tool calculateSizeWithString:[self.marksArray[indexPath.row] objectForKey:@"name"] font:[UIFont boldSystemFontOfSize:15] constrainWidth:270.0];
    if (size.height > 20) {
        return CELL_HEIGHT + size.height / 2;
    }
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EduSysMarksDetailViewController *marksDetailViewController = [[EduSysMarksDetailViewController alloc] init];
    marksDetailViewController.markInfo = self.marksArray[indexPath.row];
    [self.navigationController pushViewController:marksDetailViewController animated:YES];
}

#pragma mark - picker view delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        self.labSchoolYear.text = self.schoolYearArray[row];
        self.schoolYearIndex = row;
    }
    else if (component == 1) {
        self.labSemester.text = self.semesterArray[row];
        self.semesterIndex = row;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0 && self.schoolYearArray.count > 0) {
        return self.schoolYearArray[row];
    }
    else if (component == 1 && self.semesterArray.count > 0) {
        return self.semesterArray[row];
    }
    return nil;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger numberOfRows = 0;
    if (component == 0 && self.schoolYearArray.count > 0) {
        numberOfRows = self.schoolYearArray.count;
    }
    else if (component == 1 && self.semesterArray.count > 0) {
        numberOfRows = self.semesterArray.count;
    }
    return numberOfRows;
}

@end
