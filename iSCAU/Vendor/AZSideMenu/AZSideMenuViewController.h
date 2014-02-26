//
//  AZSideMenuViewController.h
//  iSCAU
//
//  Created by Alvin on 1/18/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const AZSideMenuStartPanningNotification;

@class AZSideMenuViewController;

@protocol AZSideMenuDelegate <NSObject>
@required
- (UITableView *)tableViewForSideMenu:(AZSideMenuViewController *)sideMenu;
- (UIViewController *)sideMenu:(AZSideMenuViewController *)sideMenu viewControllerAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (CGFloat)widthControllerForSideMenu:(AZSideMenuViewController *)sideMenu;
- (CGFloat)minScaleControllerForSideMenu:(AZSideMenuViewController *)sideMenu;
- (CGFloat)minScaleTableViewForSideMenu:(AZSideMenuViewController *)sideMenu;
- (CGFloat)minAlphaTableViewForSideMenu:(AZSideMenuViewController *)sideMenu;
@end

@interface AZSideMenuViewController : UIViewController

@property (nonatomic, weak) id<AZSideMenuDelegate> delegate;
@property (nonatomic, strong, readonly) UIViewController *currentViewController;
@property (nonatomic, assign, readonly) BOOL isMenuOpened;
@property (nonatomic, assign) BOOL isMenuOnRight;
@property (nonatomic, weak) UITableView *tableView;

+ (instancetype)shareMenu;
- (void)openMenuAnimated;
- (void)closeMenuAnimated;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)panGesture:(UIPanGestureRecognizer *)sender;

@end
