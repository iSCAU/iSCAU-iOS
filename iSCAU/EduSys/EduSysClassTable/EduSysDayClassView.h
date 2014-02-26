//
//  EduSysDayClassView.h
//  iSCAU
//
//  Created by Alvin on 13-10-7.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CollapseClick/CollapseClick.h>

@interface EduSysDayClassView : UIView <CollapseClickDelegate>

@property (nonatomic, strong) NSMutableArray *classArray;
@property (nonatomic, strong) CollapseClick *collapseClick;

@end
