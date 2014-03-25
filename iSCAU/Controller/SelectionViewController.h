//
//  SelectionViewController.h
//  iSCAU
//
//  Created by Alvin on 2/19/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectionViewController : UITableViewController

@property (nonatomic, copy) NSString *notificationName;
@property (nonatomic, copy) NSString *selectionKey;
@property (nonatomic, strong) NSArray *selections;

@end
