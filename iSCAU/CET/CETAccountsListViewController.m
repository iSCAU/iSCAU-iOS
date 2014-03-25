//
//  CETAccountsListViewController.m
//  iSCAU
//
//  Created by Alvin on 3/18/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "CETAccountsListViewController.h"
#import <SSKeychain/SSKeychain.h>
#import "CETAccountCell.h"

NSString * const CETAccountServiceName = @"CETAccountServiceName";

@interface CETAccountsListViewController ()

@property (nonatomic, strong) NSMutableArray *accounts;

@end

@implementation CETAccountsListViewController

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

    self.navigationItem.title = @"账号列表";

    NSArray *accounts = [SSKeychain accountsForService:CETAccountServiceName];
    if (accounts.count > 0) {
        self.accounts = [NSMutableArray array];
        for (id a in accounts) {
            if ([a isKindOfClass:[NSDictionary class]]) {
                NSDictionary *accountDict = @{ CETAccountUsernameKey : a[kSSKeychainAccountKey],
                                               CETAccountCetNumKey : [SSKeychain passwordForService:CETAccountServiceName account:a[kSSKeychainAccountKey]]};
                [self.accounts addObject:accountDict];
            }
        }
        [self.tableView reloadData];
        
        self.navigationItem.rightBarButtonItem = [Tool barButtonItemWithName:@"编辑" target:self selector:@selector(enterEditingMode)];
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
    return self.accounts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CETAccountCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CETAccountCellIdentifier = @"CETAccountCellIdentifier";
    CETAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:CETAccountCellIdentifier];
    if (cell == nil) {
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"CETAccountCell" owner:self options:nil];
        cell = [cellArray objectAtIndex:0];
    }
    
    cell = [cell setupCellWithAccountDict:self.accounts[indexPath.row]];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [SSKeychain deletePasswordForService:CETAccountServiceName account:self.accounts[indexPath.row][CETAccountUsernameKey]];
        [self.accounts removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName object:nil userInfo:self.accounts[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Action

- (void)enterEditingMode
{
    [self.tableView setEditing:YES animated:YES];
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [Tool barButtonItemWithName:@"完成" target:self selector:@selector(stopEditingMode)];
}

- (void)stopEditingMode
{
    [self.tableView setEditing:NO animated:YES];
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [Tool barButtonItemWithName:@"编辑" target:self selector:@selector(enterEditingMode)];
}

@end
