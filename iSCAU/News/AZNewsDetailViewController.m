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

@end

@implementation AZNewsDetailViewController

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
    
    if (IS_FLAT_UI) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

    self.articleView = [[AZArticleView alloc] initWithFrame:self.view.frame];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
