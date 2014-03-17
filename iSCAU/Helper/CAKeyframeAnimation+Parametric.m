//
//  CAKeyframeAnimation+Parametric.m
//  shuzi
//
//  Created by Alvin on 13-9-26.
//  Copyright (c) 2013年 Ifanr. All rights reserved.
//

#import "CAKeyframeAnimation+Parametric.h"

@implementation CAKeyframeAnimation (Parametric)

+ (id)animationWithKeyPath:(NSString *)path
                 fromValue:(double)fromValue
                   toValue:(double)toValue {
    
    double (^function)(double) = ^double(double position) {
        double coeff = 6.0;
        double offset = exp(-coeff);
        double scale = 1.0 / (1.0 - offset);
        return 1.0 - scale * (exp(position * -coeff) - offset);
    };
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:path];
    NSUInteger steps = 1000;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:steps];
    double time = 0.0;
    double timeStep = 1.0 / ((double)(steps));
    for (NSUInteger i = 0; i < steps; ++i) {
        double value = fromValue + (function(time)) * (toValue - fromValue);
        [values addObject:[NSNumber numberWithDouble:value]];
        time += timeStep;
    }
    
    animation.calculationMode = kCAAnimationLinear;
    
    [animation setValues:values];
    return animation;
}

@end
