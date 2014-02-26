//
//  AZSideMenuItem.m
//  iSCAU
//
//  Created by Alvin on 1/18/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "AZSideMenuItem.h"

@implementation AZSideMenuItem

- (id)initWithTitle:(NSString *)title class:(Class)refClass;
{
    return [self initWithTitle:title image:nil highlightedImage:nil class:refClass action:nil];
}

- (id)initWithTitle:(NSString *)title class:(Class)refClass 
             action:(id(^)(AZSideMenuItem *))action {
    return [self initWithTitle:title image:nil highlightedImage:nil class:refClass action:action];
}

- (id)initWithTitle:(NSString *)title image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage class:(Class )refClass;
{
    return [self initWithTitle:title image:nil highlightedImage:nil class:refClass action:nil];
}

- (id)initWithTitle:(NSString *)title 
              image:(UIImage *)image 
   highlightedImage:(UIImage *)highlightedImage 
              class:(Class)refClass 
             action:(id(^)(AZSideMenuItem *))action
{
    self = [super init];
    if (!self)
        return nil;
    
    self.title = title;
    self.image = image;
    self.highlightedImage = highlightedImage;
    self.refClass = refClass;
    self.action = action;
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<title: %@ tag: %i %@>", self.title, self.tag, NSStringFromClass([self.refClass class])];
}

@end
