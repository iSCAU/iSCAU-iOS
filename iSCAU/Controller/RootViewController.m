//
//  RootViewController.m
//  iSCAU
//
//  Created by Alvin on 2/23/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "RootViewController.h"
#import "AZSideMenuItem.h"

// EduSys
#import "EduSysClassTableViewController.h"
#import "EduSysMarksViewController.h"
#import "EduSysExamViewController.h"
#import "EduSysEmptyClassroomViewController.h"
#import "EduSysPickClassInfoViewController.h"

// Lib
#import "LibSearchBooksViewController.h"
#import "LibListNowViewController.h"
#import "LibListHistoryViewController.h"

// Info
#import "InfoViewController.h"
#import "AZNewsListViewController.h"
#import "ImageCropper.h"

// CourseEvaluation
#import "CESearchCourseViewController.h"

// CET
#import "CETAccountViewController.h"

// Other
#import "AboutViewController.h"
#import "LoginViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)setupItems
{
    // 教务系统
    AZSideMenuItem *eduSysClassTable = [[AZSideMenuItem alloc] initWithTitle:@"课程表" class:[EduSysClassTableViewController class]];
    AZSideMenuItem *eduSysMarks = [[AZSideMenuItem alloc] initWithTitle:@"成绩查询" class:[EduSysMarksViewController class]];
    AZSideMenuItem *eduSysExam = [[AZSideMenuItem alloc] initWithTitle:@"考试信息" class:[EduSysExamViewController class]];
    AZSideMenuItem *eduSysPickClassInfo = [[AZSideMenuItem alloc] initWithTitle:@"已选选修" class:[EduSysPickClassInfoViewController class]];
    AZSideMenuItem *eduSysEmptyClassroom = [[AZSideMenuItem alloc] initWithTitle:@"查询空课室" class:[EduSysEmptyClassroomViewController class]];
    
    AZSideMenuItem *eduSys = [[AZSideMenuItem alloc] initWithTitle:@"教务系统 >" class:[EduSysClassTableViewController class]];
    eduSys.subItems = @[eduSysClassTable, eduSysMarks, eduSysExam, eduSysPickClassInfo, eduSysEmptyClassroom];
    
    // 图书馆系统
    AZSideMenuItem *libSearch = [[AZSideMenuItem alloc] initWithTitle:@"搜索图书" class:[LibSearchBooksViewController class]];
    AZSideMenuItem *libListNow = [[AZSideMenuItem alloc] initWithTitle:@"已借书籍" class:[LibListNowViewController class]];
    AZSideMenuItem *libListHistory = [[AZSideMenuItem alloc] initWithTitle:@"历史借阅" class:[LibListHistoryViewController class]];
    
    AZSideMenuItem *lib = [[AZSideMenuItem alloc] initWithTitle:@"图书馆  >" class:[LibSearchBooksViewController class]];
    lib.subItems = @[libSearch, libListNow, libListHistory];
    
    // 信息
    AZSideMenuItem *infoBusAndTelphone = [[AZSideMenuItem alloc] initWithTitle:@"校巴线路与常用电话" class:[InfoViewController class] action:^(AZSideMenuItem *item) {
        InfoViewController *viewController = [[InfoViewController alloc] init];
        viewController.infoType = InfoTypeBusAndTelphone;
        viewController.title = item.title;
        return viewController;
    }];
    AZSideMenuItem *infoCommunityInformation = [[AZSideMenuItem alloc] initWithTitle:@"社区服务" class:nil action:^(AZSideMenuItem *item) {
        InfoViewController *viewController = [[InfoViewController alloc] init];
        viewController.infoType = InfoTypeCommunity;
        viewController.title = item.title;
        return viewController;
    }];
    AZSideMenuItem *infoGuardianServes = [[AZSideMenuItem alloc] initWithTitle:@"家长服务" class:nil action:^(AZSideMenuItem *item) {
        InfoViewController *viewController = [[InfoViewController alloc] init];
        viewController.infoType = InfoTypeGuarianServes;
        viewController.title = item.title;
        return viewController;
    }];
    AZSideMenuItem *infoLifeInformation = [[AZSideMenuItem alloc] initWithTitle:@"生活服务" class:nil action:^(AZSideMenuItem *item) {
        InfoViewController *viewController = [[InfoViewController alloc] init];
        viewController.infoType = InfoTypeLifeInfomation;
        viewController.title = item.title;
        return viewController;
    }];
    AZSideMenuItem *infoStudyInformation = [[AZSideMenuItem alloc] initWithTitle:@"学习指南" class:nil action:^(AZSideMenuItem *item) {
        InfoViewController *viewController = [[InfoViewController alloc] init];
        viewController.infoType = InfoTypeStudyInformation;
        viewController.title = item.title;
        return viewController;
    }];
    
    AZSideMenuItem *semeter = [[AZSideMenuItem alloc] initWithTitle:@"校历" class:nil action:^(AZSideMenuItem *item) {
        ImageCropper *viewController = [[ImageCropper alloc] initWithImage:[UIImage imageNamed:@"semester.jpg"]];
        return viewController;
    }];
    
    
    AZSideMenuItem *info = [[AZSideMenuItem alloc] initWithTitle:@"资讯  >" class:nil];
    info.subItems = @[semeter, 
                      infoStudyInformation,
                      infoLifeInformation, 
                      infoGuardianServes,
                      infoCommunityInformation, 
                      infoBusAndTelphone
                      ];
    
    
    // 评课
    AZSideMenuItem *courseEvaluation = [[AZSideMenuItem alloc] initWithTitle:@"评课" class:[CESearchCourseViewController class]];
    
    
    // 新闻
    AZSideMenuItem *news = [[AZSideMenuItem alloc] initWithTitle:@"校园新闻" class:[AZNewsListViewController class]];
    
    // 四六级
    AZSideMenuItem *cet = [[AZSideMenuItem alloc] initWithTitle:@"四六级成绩" class:nil action:^(AZSideMenuItem *item) {
        CETAccountViewController *viewController = [[CETAccountViewController alloc] init];
        viewController.title = item.title;
        return viewController;
    }];
    
    // 其它
    AZSideMenuItem *more = [[AZSideMenuItem alloc] initWithTitle:@"帐号设置" class:nil action:^(AZSideMenuItem *item) {
        LoginViewController *viewController = [[LoginViewController alloc] init];
        viewController.title = item.title;
        return viewController;
    }];
    
    // 关于
    AZSideMenuItem *about = [[AZSideMenuItem alloc] initWithTitle:@"关于我们" class:nil action:^(AZSideMenuItem *item) {
        AboutViewController *viewController = [[AboutViewController alloc] init];
        viewController.title = item.title;
        return viewController;
    }];
    
    return [[NSArray alloc] initWithObjects:eduSys, lib, courseEvaluation, info, news, cet, more, about, nil];
}

@end
