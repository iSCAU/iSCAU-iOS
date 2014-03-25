//
//  AZNewsCell.h
//  iSCAU
//
//  Created by Alvin on 2/17/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notice.h"

@interface AZNewsCell : UITableViewCell

- (UITableViewCell *)configurateInfo:(Notice *)notice index:(NSInteger)index;

@end
