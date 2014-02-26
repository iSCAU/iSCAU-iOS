//
//  AZSideMenuViewController.m
//  iSCAU
//
//  Created by Alvin on 1/18/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "AZSideMenuViewController.h"
#import "UIImage+ImageWithColor.h"

#import "MobClick.h"

NSString * const AZSideMenuStartPanningNotification = @"AZSideMenuStartPanningNotification"; 

#define WIDTH_OPENED (35.f)
#define MIN_SCALE_CONTROLLER (0.7f)
#define MIN_SCALE_TABLEVIEW (0.8f)
#define MIN_ALPHA_TABLEVIEW (0.01f)
#define DELTA_OPENING (160.f)

@interface AZSideMenuViewController () <UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGPoint startLocation;
@property (nonatomic, assign) CGPoint lastLocation;

@property (nonatomic, assign) CGFloat widthOpened;
@property (nonatomic, assign) CGFloat minScaleController;
@property (nonatomic, assign) CGFloat minScaleTableView;
@property (nonatomic, assign) CGFloat minAlphaTableView;

@end

@implementation AZSideMenuViewController

+ (instancetype)shareMenu
{
    static AZSideMenuViewController *controller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[AZSideMenuViewController alloc] init];
    });
    return controller;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
    if ([self.delegate respondsToSelector:@selector(tableViewForSideMenu:)]) {
        self.tableView = [self.delegate tableViewForSideMenu:self];
    }
    
    self.widthOpened = WIDTH_OPENED;
    self.minAlphaTableView = MIN_ALPHA_TABLEVIEW;
    self.minScaleTableView = MIN_SCALE_TABLEVIEW;   
    self.minScaleController = MIN_SCALE_CONTROLLER;
    
    if ([self.delegate respondsToSelector:@selector(widthControllerForSideMenu:)]) {
        self.widthOpened = [self.delegate widthControllerForSideMenu:self];
    }
    if ([self.delegate respondsToSelector:@selector(minAlphaTableViewForSideMenu:)]) {
        self.minAlphaTableView = [self.delegate minAlphaTableViewForSideMenu:self];
    }
    if ([self.delegate respondsToSelector:@selector(minScaleTableViewForSideMenu:)]) {
        self.minScaleTableView = [self.delegate minScaleTableViewForSideMenu:self];
    }
    if ([self.delegate respondsToSelector:@selector(minScaleControllerForSideMenu:)]) {
        self.minScaleController = [self.delegate minScaleControllerForSideMenu:self];
    }
    
    _isMenuOpened = false;
    [self openViewControllerAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIWindow *frontWindow = [[UIApplication sharedApplication] keyWindow];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    panGesture.delegate = self;
    [frontWindow addGestureRecognizer:panGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (self.isMenuOpened)
        [self closeMenuAnimated];
}

#pragma mark - Gestures

- (void)panGesture:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.startLocation = [sender locationInView:self.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:AZSideMenuStartPanningNotification object:nil];
    } 
    else if (sender.state == UIGestureRecognizerStateEnded &&
               (self.isMenuOpened || ((self.startLocation.x < DELTA_OPENING && !self.isMenuOnRight) || (self.startLocation.x > self.currentViewController.view.frame.size.width - DELTA_OPENING && self.isMenuOnRight)))) {
        CGFloat dx = self.lastLocation.x - self.startLocation.x;
        
        if (self.isMenuOnRight) {
            if ((self.isMenuOpened && dx > 0.f) ||
                self.view.frame.origin.x > 3 * self.view.frame.size.width / 4) {
                [self closeMenuAnimated];
            } else {
                [self openMenuAnimated];
            }
        } else {
            if ((self.isMenuOpened && dx < 0.f) || self.view.frame.origin.x < self.view.frame.size.width / 4) {
                [self closeMenuAnimated];
            } else {
                [self openMenuAnimated];
            }
        }
    }
    else if (sender.state == UIGestureRecognizerStateChanged && 
             (self.isMenuOpened || ((self.startLocation.x < DELTA_OPENING && !self.isMenuOnRight) || (self.startLocation.x > self.currentViewController.view.frame.size.width - DELTA_OPENING && self.isMenuOnRight)))) {
        [self menuDragging:sender];
    }
}

- (void)menuDragging:(UIPanGestureRecognizer *)sender
{
    CGPoint stopLocation = [sender locationInView:self.view];
    self.lastLocation = stopLocation;
    
    CGFloat dx = stopLocation.x - self.startLocation.x;
    CGFloat distance = dx;
    CGFloat width = (self.isMenuOnRight) ? (-self.view.frame.size.width + self.widthOpened) : (self.view.frame.size.width - self.widthOpened);
    CGFloat scaleController = 1 - ((self.view.frame.origin.x / width) * (1 - self.minScaleController));
    CGFloat scaleTableView = 1 - ((1 - self.minScaleTableView) + ((self.view.frame.origin.x / width) * (-1 + self.minScaleTableView)));
    CGFloat alphaTableView = 1 - ((1 - self.minAlphaTableView) + ((self.view.frame.origin.x / width) * (-1 + self.minAlphaTableView)));
    
    if (scaleTableView < self.minScaleTableView) {
        scaleTableView = self.minScaleTableView;
    }
    if (scaleController > 1.f) {
        scaleController = 1.f;
    }
    
    self.tableView.transform = CGAffineTransformMakeScale(scaleTableView, scaleTableView);
    self.tableView.alpha = alphaTableView;
    self.currentViewController.view.transform = CGAffineTransformMakeScale(scaleController, scaleController);
    
    CGRect frame = self.view.frame;
    frame.origin.x = frame.origin.x + distance;
    
    if (self.isMenuOnRight) {
        if (frame.origin.x < -frame.size.width) {
            frame.origin.x = -frame.size.width;
        }
        if (frame.origin.x > 0.f) {
            frame.origin.x = 0.f;
        }
    } else {
        if (frame.origin.x > frame.size.width) {
            frame.origin.x = frame.size.width;
        }
        if (frame.origin.x < 0.f) {
            frame.origin.x = 0.f;
        }
    }
    self.view.frame = frame;
    
    frame = self.currentViewController.view.frame;
    if (self.isMenuOnRight) {
        frame.origin.x = self.view.frame.size.width - frame.size.width;
    } else {
        frame.origin.x = 0.f;
    }
    self.currentViewController.view.frame = frame;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch 
{
    if (self.isMenuOpened) {
        return true;
    }
    return false;
}

#pragma mark - Menu

- (void)openViewControllerAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(sideMenu:viewControllerAtIndexPath:)]) {
        BOOL firstTime = false;
        if (self.currentViewController == nil) {
            firstTime = true;
        }
        
        _currentViewController = [self.delegate sideMenu:self viewControllerAtIndexPath:indexPath];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenuAnimated)];
        tapGesture.delegate = self;
        [self.currentViewController.view addGestureRecognizer:tapGesture];
        
        CGRect frame = self.view.frame;
        frame.origin = CGPointZero;
        self.currentViewController.view.frame = frame;
        
        frame = self.view.frame;
        frame.origin = CGPointZero;
        self.view.frame = frame;
        
        self.currentViewController.view.autoresizesSubviews = true;
        self.currentViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.currentViewController.view.layer.masksToBounds = NO;
        self.currentViewController.view.layer.shadowOffset = CGSizeMake(1, 1);
        self.currentViewController.view.layer.shadowRadius = 5;
        self.currentViewController.view.layer.shadowOpacity = 0.5;
        self.currentViewController.view.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.currentViewController.view.bounds] CGPath];
        
        [self.view addSubview:self.currentViewController.view];
        [self addChildViewController:self.currentViewController];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [self.view addGestureRecognizer:panGesture];
        
        if (!firstTime) {
            [self openingAnimation];
        }
    }
}

- (void)openingAnimation
{
    self.currentViewController.view.transform = CGAffineTransformMakeScale(self.minScaleController, self.minScaleController);
    
    CGRect frame = self.view.frame;
    if (self.isMenuOnRight) {
        frame.origin.x = -frame.size.height + self.widthOpened;
    } else {
        frame.origin.x = frame.size.height - self.widthOpened;
    }
    self.view.frame = frame;
    
    self.tableView.alpha = 1.f;
    self.tableView.transform = CGAffineTransformMakeScale(1.f, 1.f);
    
    frame = self.currentViewController.view.frame;
    if (self.isMenuOnRight) {
        frame.origin.x = self.view.frame.size.width - frame.size.width;
    } else {
        frame.origin.x = 0.f;
    }
    
    self.currentViewController.view.frame = frame;
    [self closeMenuAnimated];
}

#pragma mark - Actions
- (void)openMenuAnimated
{
    [UIView animateWithDuration:0.3f animations:^{
        
        self.currentViewController.view.transform = CGAffineTransformMakeScale(self.minScaleController, self.minScaleController);
        
        CGRect frame = self.view.frame;
        
        if (self.isMenuOnRight)
            frame.origin.x = -frame.size.width + self.widthOpened;
        else
            frame.origin.x = frame.size.width - self.widthOpened;
        
        self.view.frame = frame;
        
        self.tableView.alpha = 1.f;
        
        self.tableView.transform = CGAffineTransformMakeScale(1.f, 1.f);
        
        frame = self.currentViewController.view.frame;
        if (self.isMenuOnRight)
            frame.origin.x = self.view.frame.size.width - frame.size.width;
        else
            frame.origin.x = 0.f;
        self.currentViewController.view.frame = frame;
    }];
    
    _isMenuOpened = TRUE;
}

- (void)closeMenuAnimated
{
    [UIView animateWithDuration:0.3f animations:^{
        
        self.currentViewController.view.transform = CGAffineTransformMakeScale(1.f, 1.f);
        
        CGRect frame = self.view.frame;
        frame.origin.x = 0.f;
        self.view.frame = frame;
        
        self.tableView.alpha = self.minAlphaTableView;
        
        self.tableView.transform = CGAffineTransformMakeScale(self.minScaleTableView, self.minScaleTableView);
        
        frame = self.currentViewController.view.frame;
        frame.origin.x = 0.f;
        self.currentViewController.view.frame = frame;
    }];
    
    _isMenuOpened = FALSE;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.currentViewController.view removeFromSuperview];
    [self.currentViewController removeFromParentViewController];
    [self openViewControllerAtIndexPath:indexPath];
}


#pragma mark - Setters

- (void)setIsMenuOnRight:(BOOL)isMenuOnRight
{
    if (self.view.superview == nil)
        _isMenuOnRight = isMenuOnRight;
}

@end
