//
//  BaseViewController.m
//  iSCAU
//
//  Created by Alvin on 2/22/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "BaseViewController.h"
#import "MobClick.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

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
	// Do any additional setup after loading the view.
    if (IS_FLAT_UI) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    // 友盟通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNotice:) name:SHOW_NOTICE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideNotice:) name:HIDE_NOTICE_NOTIFICATION object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:SHOW_NOTICE_NOTIFICATION];
    [[NSNotificationCenter defaultCenter] removeObserver:HIDE_NOTICE_NOTIFICATION];
}

- (void)showNotice:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (info[kNotice]) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = info[kNotice];
    }
    
    if (info[kHideNoticeIntervel]) {
        float intervel = [info[kHideNoticeIntervel] floatValue];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, intervel * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }
}

- (void)hideNotice:(NSNotification *)notification {
    HIDE_ALL_HUD;
}

#pragma mark - UMeng notification

- (void)onlineConfigCallBack:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UMOnlineConfigDidFinishedNotification object:nil];
    
    // 公告
    NSString *note = [MobClick getConfigParams:@"notification"];
    if (![note isEqualToString:@"0"]) {
        NSString *notification = [[NSUserDefaults standardUserDefaults] objectForKey:NOTIFICATION];
        if (![note isEqualToString:notification]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"公告" message:note delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"不再显示", nil];
            alert.tag = 1;
            [alert show];
        }
    }
    
    // 更新
    NSString *update = [MobClick getConfigParams:@"update"];
    if ([update isEqualToString:@"1"]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [MobClick checkUpdate:@"有新版本可用" cancelButtonTitle:@"忽略此更新" otherButtonTitles:@"立刻前往下载"];
        });
    } else if ([update isEqualToString:@"2"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"有新版本可用" message:@"有重大更新，请立刻下载，点击\"好的\"后iSCAU将退出" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        alert.tag = 2;
        [alert show];
    }
}

#pragma mark - alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // 公告不再显示
    if (alertView.tag == 1 && buttonIndex == 1) {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def removeObjectForKey:NOTIFICATION];
        [def setObject:[alertView message] forKey:NOTIFICATION];
        [def synchronize];
    } else if (alertView.tag == 2 && buttonIndex == 0) {
        exit(0);
    }
}

@end
