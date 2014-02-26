//
//  AboutViewController.m
//  iSCAU
//
//  Created by Alvin on 2/21/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "AboutViewController.h"
#import "UMFeedback.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)feedback:(id)sender {
    [UMFeedback showFeedback:self withAppkey:UM_CODE];
}

@end
