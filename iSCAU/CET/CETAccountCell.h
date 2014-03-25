//
//  CETAccountCell.h
//  iSCAU
//
//  Created by Alvin on 3/18/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const CETAccountUsernameKey;
extern NSString * const CETAccountCetNumKey;

@interface CETAccountCell : UITableViewCell

- (CETAccountCell *)setupCellWithAccountDict:(NSDictionary *)dict;
+ (CGFloat)cellHeight;

@end
