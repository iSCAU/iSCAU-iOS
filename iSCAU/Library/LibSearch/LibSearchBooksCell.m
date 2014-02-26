//
//  LibSearchBooksCell.m
//  iSCAU
//
//  Created by Alvin on 2/16/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "LibSearchBooksCell.h"
#import "CardStyleView.h"

#define kTitle  1000
#define kAuthor 1001
#define kPress  1002
#define kSerial 1003

@implementation LibSearchBooksCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self = [self setupCell];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (LibSearchBooksCell *)setupCell {
    
    CGFloat contentOffsetX = 20.f;
    CGFloat origin = 5.0f;
    CGFloat detailLabelHeight = 20.f;
    CGFloat detailLabelPadding = 25.f;
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(contentOffsetX, origin, 280, 30)];
    labTitle.font = [UIFont boldSystemFontOfSize:16];
    labTitle.tag = kTitle;
    labTitle.backgroundColor = [UIColor clearColor];
    labTitle.textColor = APP_DELEGATE.tintColor;
    [self.contentView addSubview:labTitle];
    
    // ----- 分割线
    origin += 30;
    
    CALayer *titleSepLine = [CALayer layer];
    titleSepLine.frame = CGRectMake(contentOffsetX, origin, self.width - contentOffsetX, 1.0f);
    titleSepLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
    [self.layer addSublayer:titleSepLine];
    
    origin += 10;
    UILabel *labAuthor = [[UILabel alloc] initWithFrame:CGRectMake(contentOffsetX, origin, 280, detailLabelHeight)];
    labAuthor.font = [UIFont systemFontOfSize:13];
    labAuthor.textColor = [UIColor darkGrayColor];
    labAuthor.tag = kAuthor;
    labAuthor.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:labAuthor];

    origin += detailLabelPadding;
    UILabel *labPress = [[UILabel alloc] initWithFrame:CGRectMake(contentOffsetX, origin, 280, detailLabelHeight)];
    labPress.font = [UIFont systemFontOfSize:13];
    labPress.textColor = [UIColor darkGrayColor];
    labPress.tag = kPress;
    labPress.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:labPress];

    origin += detailLabelPadding;
    UILabel *labSerial = [[UILabel alloc] initWithFrame:CGRectMake(contentOffsetX, origin, 200, detailLabelHeight)];
    labSerial.font = [UIFont systemFontOfSize:13];
    labSerial.textColor = [UIColor darkGrayColor];
    labSerial.tag = kSerial;
    labSerial.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:labSerial];
    
    origin = 120 - 1;
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, origin, self.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
    [self.layer addSublayer:bottomBorder];
    
    return self;
}

@end
