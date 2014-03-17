//
//  CAKeyframeAnimation+Parametric.h
//  shuzi
//
//  Created by Alvin on 13-9-26.
//  Copyright (c) 2013年 Ifanr. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAKeyframeAnimation (Parametric)

+ (id)animationWithKeyPath:(NSString *)path
                 fromValue:(double)fromValue
                   toValue:(double)toValue;
@end
