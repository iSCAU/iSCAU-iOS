//
//  EduSysClassTableEditedViewController.h
//  iSCAU
//
//  Created by Alvin on 2/20/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EduSysClassTableEditedViewController : UIViewController 

@property (strong, nonatomic) IBOutlet UIButton     *btn_time;
@property (strong, nonatomic) IBOutlet UITextField  *txtField_title;
@property (strong, nonatomic) IBOutlet UITextField  *txtField_teacher;
@property (strong, nonatomic) IBOutlet UITextField  *txtField_classroom;
@property (strong, nonatomic) IBOutlet UITextField  *txtField_startWeek;
@property (strong, nonatomic) IBOutlet UITextField  *txtField_endWeek;
@property (strong, nonatomic) NSMutableArray         *classes;
- (IBAction)textFiledReturnEditing:(id)sender;
- (IBAction)timeButtonPressed:(id)sender;

- (void)setupWithExistedClass:(NSDictionary *)dic andClassesOfTheDay:(NSArray *)classes;


@end
