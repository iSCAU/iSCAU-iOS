//
//  EduSysClassTableViewController.h
//  iSCAU
//
//  Created by Alvin on 13-9-11.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "EduBaseViewController.h"
#import <ASIHTTPRequest/ASIHTTPRequest.h>
#import "EduSysDayClassTableView.h"
#import "EduSysWeekClassTableView.h"
#import "PopoverView.h"

@interface EduSysClassTableViewController : EduBaseViewController <PopoverViewDelegate>

@property (nonatomic, strong) EduSysDayClassTableView *dayTableView;
@property (nonatomic, strong) EduSysWeekClassTableView *weekTableView;

@property (nonatomic, strong) NSMutableArray *classesMon;
@property (nonatomic, strong) NSMutableArray *classesTue;
@property (nonatomic, strong) NSMutableArray *classesWed;
@property (nonatomic, strong) NSMutableArray *classesThus;
@property (nonatomic, strong) NSMutableArray *classesFri;
@property (nonatomic, strong) NSMutableArray *classesSat;
@property (nonatomic, strong) NSMutableArray *classesSun;

- (void)setupData;

@end
