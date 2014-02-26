//
//  SelectionViewController.m
//  iSCAU
//
//  Created by Alvin on 2/19/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "SelectionViewController.h"

@interface SelectionViewController ()

@end

@implementation SelectionViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.selections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SelectionCellIdentifier = @"SelectionCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectionCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SelectionCellIdentifier];
        
        CALayer *bottomBorder = [CALayer layer];
        CGFloat originX = 15.f;
        bottomBorder.frame = (CGRect) {
            originX,
            cell.height - 1,
            cell.width - originX,
            1
        };
        bottomBorder.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
        [cell.layer addSublayer:bottomBorder];
        
        UILabel *labSelection = [[UILabel alloc] initWithFrame:(CGRect) {
            originX,
            0,
            cell.width - originX,
            cell.height
        }];
        labSelection.font = [UIFont systemFontOfSize:17];
        labSelection.tag = 1001;
        [cell.contentView addSubview:labSelection];
    }
    
    if (indexPath.row < self.selections.count) {
        UILabel *labselection = (UILabel *)[cell.contentView viewWithTag:1001];
        labselection.text = self.selections[indexPath.row];
    }
    
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName object:nil userInfo:@{ self.selectionKey : self.selections[indexPath.row]}];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
