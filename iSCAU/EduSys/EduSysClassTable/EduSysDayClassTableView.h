//
//  EduSysDayClassTableView.h
//  iSCAU
//
//  Created by Alvin on 13-10-6.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EduSysDayClassTableView : UIView <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) BOOL isEditing;

@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) UIView        *dayIndicator;

@property (nonatomic, assign) NSInteger         currentIndex;
@property (nonatomic, strong) NSMutableArray *classesMon;
@property (nonatomic, strong) NSMutableArray *classesTue;
@property (nonatomic, strong) NSMutableArray *classesWed;
@property (nonatomic, strong) NSMutableArray *classesThus;
@property (nonatomic, strong) NSMutableArray *classesFri;
@property (nonatomic, strong) NSMutableArray *classesSat;
@property (nonatomic, strong) NSMutableArray *classesSun;

@property (nonatomic, strong) NSMutableArray   *classes;

- (void)reloadClassTableWithClasses:(NSArray *)classes_;
- (void)enterEditingMode;
- (void)cancleEdit;

@end
