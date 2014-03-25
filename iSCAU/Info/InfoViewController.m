//
//  InfoViewController.m
//  iSCAU
//
//  Created by Alvin on 13-9-12.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

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
        
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;

    if (IS_FLAT_UI) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if (IS_IPHONE4) {
        self.view.height = 416.f;
    }
    
    NSData *infoData = nil;
    NSString *jsonPath = nil;
    switch (self.infoType) {
        case InfoTypeBusAndTelphone:
            jsonPath = [[NSBundle mainBundle] pathForResource:@"Bus&Telphone" ofType:@"json"];
            break;
        case InfoTypeCommunity:
            jsonPath = [[NSBundle mainBundle] pathForResource:@"CommunityInformation" ofType:@"json"];
            break;
        case InfoTypeGuarianServes:
            jsonPath = [[NSBundle mainBundle] pathForResource:@"GuardianServes" ofType:@"json"];
            break;
        case InfoTypeLifeInfomation:
            jsonPath = [[NSBundle mainBundle] pathForResource:@"LifeInformation" ofType:@"json"];
            break;
        case InfoTypeStudyInformation:
            jsonPath = [[NSBundle mainBundle] pathForResource:@"StudyInformation" ofType:@"json"];
            break;
        default:
            break;
    }
    infoData = [NSData dataWithContentsOfFile:jsonPath];
    if (infoData) {
        self.infoArray = [NSJSONSerialization JSONObjectWithData:infoData options:kNilOptions error:nil];
    }
    
    self.collapseClick = [[CollapseClick alloc] initWithFrame:self.view.bounds];
    self.collapseClick.CollapseClickDelegate = self;
    self.collapseClick.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.collapseClick];
    [self.collapseClick reloadCollapseClick];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collapse click delegate

- (int)numberOfCellsForCollapseClick {
    return self.infoArray.count;
}

- (NSString *)titleForCollapseClickAtIndex:(int)index {
    return [self.infoArray[index] objectForKey:@"title"];
}

- (UIView *)viewForCollapseClickContentViewAtIndex:(int)index {
    UIFont *font = [UIFont systemFontOfSize:14];
    CGFloat offset = 10.0f;
    NSLineBreakMode lineBreakMode = NSLineBreakByWordWrapping;
    NSString *content = [self.infoArray[index] objectForKey:@"content"];
    CGSize infoSize = [content sizeWithFont:font
                          constrainedToSize:CGSizeMake(self.view.width - offset * 2, MAXFLOAT)
                              lineBreakMode:lineBreakMode];
    UILabel *labInfo = [[UILabel alloc] initWithFrame:CGRectMake(offset, 0, self.view.width - offset * 2, infoSize.height)];
    labInfo.font = font;
    labInfo.text = content;
    labInfo.textColor = [UIColor darkGrayColor];
    labInfo.lineBreakMode = lineBreakMode;
    labInfo.backgroundColor = [UIColor clearColor];
    labInfo.numberOfLines = 0;
    
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, infoSize.height + 5)];
    infoView.backgroundColor = [UIColor clearColor];
    [infoView addSubview:labInfo];
    
    return infoView;
}

-(UIColor *)colorForCollapseClickTitleViewAtIndex:(int)index {
    return [UIColor clearColor];
}

-(UIColor *)colorForTitleLabelAtIndex:(int)index {
    return [UIColor blackColor];
}

@end
