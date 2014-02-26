//
//  UIButton+Bootstrap.h
//  LoveqFM
//
//  Created by Alvin on 1/13/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Bootstrap)

- (void)bootstrapStyle;
- (void)defaultStyle;
- (void)successStyle;
- (void)infoStyle;
- (void)warningStyle;
- (void)dangerStyle;
- (void)customStyle:(UIColor *)tintColor;

@end
