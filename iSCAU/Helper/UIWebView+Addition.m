//
//  UIWebView+Addition.m
//  ifanr
//
//  Created by Alvin on 13-11-11.
//
//

#import "UIWebView+Addition.h"
#import <objc/runtime.h>

static char transparentKey;

@implementation UIWebView (Addition)


- (void)setTransparent:(BOOL)transparent {
    
    // clear UIWebView background shadow
    if ([self.subviews count] > 0 && SystemVersion_floatValue < 7.0) {
        // hide the shadows
        for (UIView* shadowView in [[[self subviews] objectAtIndex:0] subviews]) {
            [shadowView setHidden:YES];
        }
        // show the content
        [[[[[self subviews] objectAtIndex:0] subviews] lastObject] setHidden:NO];
    }
    
    objc_setAssociatedObject(self, &transparentKey, @(transparent), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)transparent {
    return (BOOL)objc_getAssociatedObject(self, &transparentKey);
}

- (CGSize)windowSize {
    CGSize size;
    size.width = [[self stringByEvaluatingJavaScriptFromString:@"window.innerWidth"] integerValue];
    size.height = [[self stringByEvaluatingJavaScriptFromString:@"window.innerHeight"] integerValue];
    return size;
}

- (CGPoint)scrollOffset {
    CGPoint pt;
    pt.x = [[self stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] integerValue];
    pt.y = [[self stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] integerValue];
    return pt;
}



@end
