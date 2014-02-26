//
//  UIWebView+Addition.h
//  ifanr
//
//  Created by Alvin on 13-11-11.
//
//

#import <UIKit/UIKit.h>

@interface UIWebView (Addition)

- (void)setTransparent:(BOOL)transparent;
- (BOOL)transparent;

- (CGSize)windowSize;
- (CGPoint)scrollOffset;

@end
