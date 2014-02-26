//
//  InfoViewController.h
//  iSCAU
//
//  Created by Alvin on 13-9-12.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import <CollapseClick/CollapseClick.h>

typedef NS_ENUM(NSUInteger, InfoType) {
    InfoTypeBusAndTelphone = 1,
    InfoTypeCommunity,
    InfoTypeGuarianServes,
    InfoTypeLifeInfomation,
    InfoTypeStudyInformation
};

@interface InfoViewController : UIViewController <CollapseClickDelegate>

@property (nonatomic, assign) InfoType      infoType;
@property (nonatomic, strong) NSArray       *infoArray;
@property (nonatomic, strong) CollapseClick *collapseClick;

@end
