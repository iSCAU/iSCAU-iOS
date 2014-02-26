//
//  CollapseClickCell.m
//  CollapseClick
//
//  Created by Ben Gordon on 2/28/13.
//  Copyright (c) 2013 Ben Gordon. All rights reserved.
//

#import "CollapseClickCell.h"

@implementation CollapseClickCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (CollapseClickCell *)newCollapseClickCellWithTitle:(NSString *)title index:(int)index content:(UIView *)content {
    NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"CollapseClickCell" owner:nil options:nil];
    CollapseClickCell *cell = [[CollapseClickCell alloc] initWithFrame:CGRectMake(0, 0, 320, kCCHeaderHeight)];
    cell = [views objectAtIndex:0];
    
    // Initialization Here
    cell.TitleLabel.text = title;
    cell.index = index;
    cell.TitleButton.tag = index;
    cell.ContentView.frame = CGRectMake(cell.ContentView.frame.origin.x, cell.ContentView.frame.origin.y, cell.ContentView.frame.size.width, content.frame.size.height);
    cell.indicatorView.backgroundColor = [self indicatorColorAtIndex:index];
    [cell.ContentView addSubview:content];
    
    return cell;
}

+ (UIColor *)indicatorColorAtIndex:(NSInteger)index {
    NSInteger colorIndex = index % 4;
    switch (colorIndex) {
        case 0:
            return [self colorFromHexRGB:@"0x0140ca" alpha:1];
        case 1:
            return [self colorFromHexRGB:@"0x16a61e" alpha:1];
        case 2:
            return [self colorFromHexRGB:@"0xdd1812" alpha:1];
        case 3:
            return [self colorFromHexRGB:@"0xfcca03" alpha:1];
        default:
            return [self colorFromHexRGB:@"0x0140ca" alpha:1];
    }
    return [self colorFromHexRGB:@"0x0140ca" alpha:1];
}

+ (UIColor *) colorFromHexRGB:(NSString *) inColorString alpha:(CGFloat)alpha
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:alpha];
    return result;
}

@end
