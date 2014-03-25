//
//  CetMark.h
//  iSCAU
//
//  Created by Alvin on 3/19/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface CetMark : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *school;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *cetNum;
@property (nonatomic, copy) NSString *examTime;
@property (nonatomic, copy) NSString *totalMark;
@property (nonatomic, copy) NSString *listening;
@property (nonatomic, copy) NSString *reading;
@property (nonatomic, copy) NSString *writing;

@end
