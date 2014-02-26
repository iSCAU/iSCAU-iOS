//
//  EduSysMarksDetailViewController.m
//  iSCAU
//
//  Created by Alvin on 2/18/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "EduSysMarksDetailViewController.h"
#import "EduSysMarksDetailCell.h"

@interface EduSysMarksDetailViewController ()
@property (nonatomic, strong) NSArray *keyNameArray;
@end

@implementation EduSysMarksDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (IS_FLAT_UI) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.keyNameArray = [NSArray arrayWithObjects:@"name", @"goal", @"grade_point", @"credit", @"year", @"team", @"classify", @"college_hold", @"college_belong", @"code", nil];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.keyNameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *EduSysMarksDetailCellIdentifier = @"EduSysMarksDetailCellIdentifier";
    EduSysMarksDetailCell *cell = (EduSysMarksDetailCell *)[tableView dequeueReusableCellWithIdentifier:EduSysMarksDetailCellIdentifier];
    if (cell == nil) {
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"EduSysMarksDetailCell" owner:self options:nil];
        cell = [cellArray objectAtIndex:0];

        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    NSInteger row = indexPath.row;
    if (row < self.keyNameArray.count) {
        [cell configurateWithKey:self.keyNameArray[row] value:self.markInfo[self.keyNameArray[row]] index:row];
    }
    
    return cell;
}

@end
