//
//  CETAccountViewController.m
//  iSCAU
//
//  Created by Alvin on 3/18/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "CETAccountViewController.h"
#import "CETHttpClient.h"
#import "CETAccountsListViewController.h"
#import <SSKeychain/SSKeychain.h>
#import "CETResultViewController.h"
#import "CetMark.h"
#import "AZSideMenuViewController.h"

@interface CETAccountViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtCetNum;
@property (weak, nonatomic) IBOutlet UIButton *btnQueryMark;
@property (weak, nonatomic) IBOutlet UIButton *btnRememberAccount;
@end

@implementation CETAccountViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.frame = CGRectMake(0, 0, 80, 44);
    [btnClose setTitle:@"账号列表" forState:UIControlStateNormal];
    [btnClose setTitleColor:APP_DELEGATE.tintColor forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(displayAccountsList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btnClose];
    self.navigationItem.rightBarButtonItem = closeBarBtn;
    
    [self.txtUsername becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignAllFirstResponder) name:AZSideMenuStartPanningNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)resignAllFirstResponder {
    [self.txtUsername resignFirstResponder];
    [self.txtCetNum resignFirstResponder];
}

- (IBAction)rememberAccount:(id)sender 
{
    BOOL success = [SSKeychain setPassword:self.txtCetNum.text
                                forService:CETAccountServiceName 
                                   account:self.txtUsername.text];
    if (success) {
        SHOW_NOTICE_HUD(@"保存成功");
        NSLog(@"%@", [SSKeychain passwordForService:CETAccountServiceName account:self.txtUsername.text]);
    } else {
        SHOW_NOTICE_HUD(@"保存失败");
    }
}

- (IBAction)queryMark:(id)sender 
{
    SHOW_WATING_HUD;
    [[CETHttpClient shareInstance] queryMarksWithCetNum:self.txtCetNum.text 
                                               username:self.txtUsername.text
                                                success:^(NSData *responseData, int httpCode) {
                                                    if (httpCode == RequestSuccess) {
                                                        HIDE_ALL_HUD;
                                                        NSError *error = nil;
                                                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData 
                                                                                                             options:kNilOptions
                                                                                                               error:&error];
                                                        if (!error && dict[@"cet_marks"]) {
                                                            NSLog(@"%@", dict);
                                                            CetMark *mark = [MTLJSONAdapter modelOfClass:CetMark.class fromJSONDictionary:dict[@"cet_marks"] error:&error];
                                                            if (!error) {
                                                                CETResultViewController *resultViewController = [[CETResultViewController alloc] init];
                                                                resultViewController.mark = mark;
                                                                [self.navigationController pushViewController:resultViewController animated:YES];
                                                            }
                                                        } else {
                                                            NSLog(@"%@ %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding], error.localizedDescription);
                                                        }
                                                    }
                                                } failure:^(NSData *responseData, int httpCode) {
                                                    HIDE_ALL_HUD;
                                                }];
}

- (void)displayAccountsList
{
    CETAccountsListViewController *accountsList = [[CETAccountsListViewController alloc] init];
    accountsList.notificationName = @"CETAccountsListViewPopNotification";
    [self.navigationController pushViewController:accountsList animated:YES];
}

- (void)resetAccount:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo) {
        self.txtUsername.text = userInfo[CETAccountUsernameKey];
        self.txtCetNum.text = userInfo[CETAccountCetNumKey];
    }
}

@end
