//
//  CETAccountCell.m
//  iSCAU
//
//  Created by Alvin on 3/18/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "CETAccountCell.h"

NSString * const CETAccountUsernameKey = @"CETAccountUsernameKey";
NSString * const CETAccountCetNumKey = @"CETAccountCetNumKey";

@interface CETAccountCell ()

@property (weak, nonatomic) IBOutlet UILabel *labUsername;
@property (weak, nonatomic) IBOutlet UILabel *labCetNum;

@end

@implementation CETAccountCell

- (CETAccountCell *)setupCellWithAccountDict:(NSDictionary *)dict
{
    if (dict) {
        self.labUsername.text = dict[CETAccountUsernameKey];
        self.labCetNum.text = dict[CETAccountCetNumKey];
    }
    return self;
}

+ (CGFloat)cellHeight
{
    return 55.f;
}

@end
