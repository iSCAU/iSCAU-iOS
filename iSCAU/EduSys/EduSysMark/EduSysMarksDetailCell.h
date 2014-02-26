//
//  EduSysMarksDetailCell.h
//  iSCAU
//
//  Created by Alvin on 2/18/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EduSysMarksDetailCell : UITableViewCell
- (UITableViewCell *)configurateWithKey:(NSString *)key 
                                  value:(NSString *)value 
                                  index:(NSInteger)index;
@end
