//
//  EduSysEmptyClassroomDetailViewController.m
//  iSCAU
//
//  Created by Alvin on 2/18/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "EduSysEmptyClassroomDetailViewController.h"
#import "EduSysEmptyClassroomDetailCell.h"

@interface EduSysEmptyClassroomDetailViewController ()

@end

@implementation EduSysEmptyClassroomDetailViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.emptyClassrooms.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *EduSysEmptyClassroomDetailCellIdentifier = @"EduSysEmptyClassroomDetailCellIdentifier";
    EduSysEmptyClassroomDetailCell *cell = (EduSysEmptyClassroomDetailCell *)[tableView dequeueReusableCellWithIdentifier:EduSysEmptyClassroomDetailCellIdentifier];
    if (cell == nil) {
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"EduSysEmptyClassroomDetailCell" owner:self options:nil];
        cell = [cellArray objectAtIndex:0];
    }
    [cell configurateWithClassroomInfo:self.emptyClassrooms[indexPath.row] index:indexPath.row];
    
    return cell;
}

@end
