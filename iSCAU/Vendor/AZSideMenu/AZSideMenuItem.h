//
//  AZSideMenuItem.h
//  iSCAU
//
//  Created by Alvin on 1/18/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZSideMenuItem : NSObject

@property (copy, readwrite, nonatomic) NSString *title;
@property (strong, readwrite, nonatomic) UIImage *image;
@property (strong, readwrite, nonatomic) UIImage *highlightedImage;
@property (assign, readwrite, nonatomic) NSInteger tag;
@property (unsafe_unretained, readwrite, nonatomic) Class refClass;
@property (copy, readwrite, nonatomic) id(^action)(AZSideMenuItem *item);

@property (strong, readwrite, nonatomic) NSArray *subItems;

- (id)initWithTitle:(NSString *)title 
              class:(Class)refClass;
- (id)initWithTitle:(NSString *)title 
              class:(Class)refClass 
             action:(id(^)(AZSideMenuItem *item))action;
- (id)initWithTitle:(NSString *)title 
              image:(UIImage *)image 
   highlightedImage:(UIImage *)highlightedImage 
              class:(Class)refClass;
- (id)initWithTitle:(NSString *)title 
              image:(UIImage *)image 
   highlightedImage:(UIImage *)highlightedImage 
              class:(Class)refClass 
             action:(id(^)(AZSideMenuItem *item))action;

@end
