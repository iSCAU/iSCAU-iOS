//
//  CardStyleView.m
//  iSCAU
//
//  Created by Alvin on 13-9-12.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "CardStyleView.h"

@implementation CardStyleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGFloat radius = 2;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, radius, 0);
    
    CGMutablePathRef path = createRoundedRectForRect(rect, radius);
    CGContextAddPath(context, path);
    
    // 描边
    CGContextSetLineWidth(context, 0.2);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithR:0 g:0 b:0 a:0.5].CGColor);
    
    // 填充颜色
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1);
    CGContextDrawPath(context, kCGPathFillStroke);
}

CGMutablePathRef createRoundedRectForRect(CGRect rect, CGFloat radius) {
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMidX(rect) + 0.5, CGRectGetMinY(rect) + 0.5);
    
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect) - 0.5, CGRectGetMinY(rect) + 0.5, CGRectGetMaxX(rect) - 0.5, CGRectGetMaxY(rect) -0.5, radius);
    
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect) - 0.5, CGRectGetMaxY(rect) - 0.5, CGRectGetMinX(rect) - 0.5, CGRectGetMaxY(rect) - 0.5, radius);
    
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect) + 0.5, CGRectGetMaxY(rect) - 0.5, CGRectGetMinX(rect) + 0.5, CGRectGetMinY(rect) + 0.5, radius);
    
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect) + 0.5, CGRectGetMinY(rect) + 0.5, CGRectGetMaxX(rect) - 0.5, CGRectGetMinY(rect) - 0.5, radius);
    CGPathCloseSubpath(path);
    
    return path;
}


@end
