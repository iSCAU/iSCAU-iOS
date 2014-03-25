//
//  AZNewsDetailViewController.m
//  iSCAU
//
//  Created by Alvin on 2/17/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "AZNewsDetailViewController.h"
#import "AZArticleView.h"

@interface AZNewsDetailViewController ()

@property (nonatomic, strong) AZArticleView *articleView;
@property (nonatomic, strong) Notice *notice;

@end

@implementation AZNewsDetailViewController

- (instancetype)initWithNotice:(Notice *)notice
{
    self = [super init];
    
    self.notice = notice;
    
    return self;
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
    
    if (IS_FLAT_UI) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

    self.articleView = [[AZArticleView alloc] initWithFrame:self.view.bounds];
    [self.articleView setupWithNotice:self.notice];
    [self.view addSubview:self.articleView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
