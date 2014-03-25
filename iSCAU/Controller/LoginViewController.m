//
//  LoginViewController.m
//  iSCAU
//
//  Created by Alvin on 13-8-20.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "LoginViewController.h"
#import <FPBrandColors/UIColor+FPBrandColor.h>
#import "AZSideMenuViewController.h"
#import "SelectionViewController.h"
#import "UIImage+Tint.h"

NSString * const SelectServerNotification = @"SelectServerNotification";
NSString * const SelectServerKey = @"SelectServerKey";
NSString * const ExperienceAccount = @"ilovescau";
NSString * const ExperiencePwd = @"ilovescau";

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnServer;
@property (nonatomic, weak) IBOutlet UITextField  *txtStuNum;
@property (nonatomic, weak) IBOutlet UITextField  *txtStuPwd;
@property (nonatomic, weak) IBOutlet UITextField  *txtLibPwd;

@end

@implementation LoginViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isShonwByPresent = NO;
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
    [btnClose setImage:[[UIImage imageNamed:@"BackButton.png"] imageWithTintColor:APP_DELEGATE.tintColor] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btnClose];
    self.navigationItem.leftBarButtonItem = closeBarBtn;

    // Do any additional setup after loading the view from its nib.
    self.txtStuNum.text = [Tool stuNum];
    self.txtStuPwd.text = [Tool stuPwd];
    self.txtLibPwd.text = [Tool libPwd];
    
    [self.btnServer setTitle:[Tool server] forState:UIControlStateNormal];
    [self.btnServer setTitle:[Tool server] forState:UIControlStateHighlighted];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 200 * NSEC_PER_MSEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        [self.txtStuNum becomeFirstResponder];
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignAllFirstResponder) name:AZSideMenuStartPanningNotification object:nil];
}

- (void)back {
    if (self.isShonwByPresent) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self resignAllFirstResponder];
        [[AZSideMenuViewController shareMenu] openMenuAnimated];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

- (void)resignAllFirstResponder {
    [self.txtStuNum resignFirstResponder];
    [self.txtStuPwd resignFirstResponder];
    [self.txtLibPwd resignFirstResponder];
}

- (IBAction)selectServer:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectedServer:) name:SelectServerNotification object:nil];
    SelectionViewController *serverSelectViewController = [[SelectionViewController alloc] init];
    serverSelectViewController.notificationName = SelectServerNotification;
    serverSelectViewController.selectionKey = SelectServerKey;
    serverSelectViewController.selections = @[@"1", @"2", @"3", @"4", @"5", @"6"];
    [self.navigationController pushViewController:serverSelectViewController animated:YES];
}

- (IBAction)experienceAccount:(id)sender {
    self.txtStuNum.text = ExperienceAccount;
    self.txtStuPwd.text = ExperiencePwd;
    [self save];
}

- (void)didSelectedServer:(NSNotification *)notification {
    NSDictionary *resultDict = notification.userInfo;
    if (resultDict[SelectServerKey]) {
        NSString *server = resultDict[SelectServerKey];
        [Tool setServer:server];
        [self.btnServer setTitle:server forState:UIControlStateNormal];
        [self.btnServer setTitle:server forState:UIControlStateHighlighted];
    }
}

- (void)save {
    [Tool setStuNum:self.txtStuNum.text
              andStuPwd:self.txtStuPwd.text
              andLibPwd:self.txtLibPwd.text
             andCardPwd:nil];
    [self resignAllFirstResponder];
    SHOW_NOTICE_HUD(@"保存成功");
}

@end
