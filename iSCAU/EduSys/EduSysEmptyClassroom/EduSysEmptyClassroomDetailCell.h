//
//  EduSysEmptyClassroomDetailCell.h
//  iSCAU
//
//  Created by Alvin on 2/18/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EduSysEmptyClassroomDetailCell : UITableViewCell
- (UITableViewCell *)configurateWithClassroomInfo:(NSDictionary *)classroomInfo
                                            index:(NSInteger)index;
@end
