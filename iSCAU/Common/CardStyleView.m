//
//  CardStyleView.m
//  iSCAU
//
//  Created by Alvin on 13-9-12.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "CardStyleView.h"

@implementation CardStyleView

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 3;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithR:0 g:0 b:0 a:0.3].CGColor;
}

@end
