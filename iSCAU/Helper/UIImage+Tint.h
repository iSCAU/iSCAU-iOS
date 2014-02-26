//
//  UIImage+Tint.h
//  LifeTime
//
//  Created by Alvin on 13-8-28.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tint)

- (UIImage *)imageWithTintColor:(UIColor *)tintColor;
- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;
+ (UIImage *)imageWithName:(NSString *)name tintColor:(UIColor *)tintColor;

+ (UIImage *)imageWithColor:(UIColor *)color;

@end
