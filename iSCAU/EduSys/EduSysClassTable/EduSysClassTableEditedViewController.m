//
//  EduSysClassTableEditedViewController.m
//  iSCAU
//
//  Created by Alvin on 2/20/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "EduSysClassTableEditedViewController.h"
#import <UI7Kit/UI7PickerView.h>

#define WEEKDAY     0
#define START_CLASS 1
#define END_CLASS   2
#define WEEK_TYPE   3
#define PICKER_HEIGHT 162

static NSString *CLASSNAME = @"classname";
static NSString *DAY = @"day";
static NSString *DSZ = @"dsz";
static NSString *END_WEEK = @"endWeek";
static NSString *LOCATION = @"location";
static NSString *NODE = @"node";
static NSString *STR_WEEK = @"strWeek";
static NSString *TEACHER = @"teacher";

@interface EduSysClassTableEditedViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate> {
    
    NSArray         *weekday;
    NSArray         *startClass;
    NSArray         *endClass;
    NSArray         *weekType;
    NSDictionary    *theDic;
    
    NSString        *day;
    NSString        *dsz;
    NSInteger       startClassIndex;
    NSInteger       endClassIndex;
    
    UIPickerView    *picker;
    UIBarButtonItem *doneBtn;
}

@end

@implementation EduSysClassTableEditedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 为TitleBar添加背景
    
    if (IS_FLAT_UI) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if (IS_IPHONE4) {
        self.view.frame = CGRectMake(0, 0, 320, 460);
    }
    
    self.classes = [NSMutableArray array];
    
    // 添加手势取消textField选中状态
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(textFiledReturnEditing:)];
    [recognizer addTarget:self action:@selector(dismissPicker:)];
    recognizer.delegate = self;
    recognizer.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:recognizer];
    
    weekday = [[NSArray alloc] initWithObjects:@"一", @"二", @"三", @"四", @"五", @"六", @"日", nil];
    startClass = [[NSArray alloc] initWithObjects:@"第1节", @"第2节", @"第3节", @"第4节", @"第5节", @"第6节", @"第7节", @"第8节", @"第9节", @"第10节", @"第11节", @"第12节", @"第13节", nil];
    endClass = [[NSArray alloc] initWithObjects:@"到第1节", @"到第2节", @"到第3节", @"到第4节", @"到第5节", @"到第6节", @"到第7节", @"到第8节", @"到第9节", @"到第10节", @"到第11节", @"到第12节", @"到第13节", nil];
    weekType = [[NSArray alloc] initWithObjects:@"每周", @"单周", @"双周", nil];
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height + PICKER_HEIGHT, self.view.frame.size.width, PICKER_HEIGHT)];
    picker.showsSelectionIndicator = YES;
    picker.delegate = self;
    picker.dataSource = self;
    [picker selectRow:0 inComponent:WEEKDAY animated:YES];
    [picker selectRow:0 inComponent:START_CLASS animated:YES];
    [picker selectRow:0 inComponent:END_CLASS animated:YES];
    [picker selectRow:0 inComponent:WEEK_TYPE animated:YES];
    [self.view addSubview:picker];
    
    startClassIndex = 0;
    endClassIndex = 0;
    day = weekday[0];
    dsz = @"";
    [self.btn_time setTitle:[NSString stringWithFormat:@"周%@ %d-%d节%@", day, startClassIndex+1, endClassIndex+1, dsz] forState:UIControlStateNormal];
    [self.btn_time setTitle:[NSString stringWithFormat:@"周%@ %d-%d节%@", day, startClassIndex+1, endClassIndex+1, dsz] forState:UIControlStateHighlighted];
    [self.btn_time setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    if (theDic != nil) {
        self.txtField_title.text = [NSString stringWithFormat:@"%@", theDic[@"classname"]];
        self.txtField_teacher.text = [NSString stringWithFormat:@"%@", theDic[@"teacher"]];
        self.txtField_classroom.text = [NSString stringWithFormat:@"%@", theDic[@"location"]];
        self.txtField_startWeek.text = [NSString stringWithFormat:@"%@", theDic[@"strWeek"]];
        self.txtField_endWeek.text = [NSString stringWithFormat:@"%@", theDic[@"endWeek"]];
        day = [NSString stringWithFormat:@"%@", theDic[@"day"]];
        
        NSString *temp_weekType = theDic[@"dsz"];
        if ([dsz isEqualToString:@"单周"]) {
            temp_weekType = @"(单)";
        } else if ([dsz isEqualToString:@"双周"]) {
            temp_weekType = @"(双)";
        } else {
            temp_weekType = @"";
        }
        
        NSString *temp_location = theDic[@"location"];
        if ([temp_location isEqualToString:@"null"]) {
            self.txtField_classroom.text = @"";
        }
        
        NSString *temp_day = theDic[@"day"];
        NSString *temp_node = @"";
        @try {
            NSArray *array = [theDic[@"node"] componentsSeparatedByString:@","];
            if ([array count] == 2) {
                startClassIndex = [array[0] integerValue] - 1;
                endClassIndex = [array[1] integerValue] - 1;
            }
            temp_node = [NSString stringWithFormat:@"周%@ %d-%d节%@", temp_day, startClassIndex + 1, endClassIndex + 1, temp_node];
        }
        @catch (NSException *exception) {
            temp_node = [NSString stringWithFormat:@"周%@ 1-2节%@", temp_day, temp_node];
        }
        [self.btn_time setTitle:temp_node forState:UIControlStateNormal];
        [self.btn_time setTitle:temp_node forState:UIControlStateHighlighted];
        [picker selectRow:startClassIndex inComponent:START_CLASS animated:YES];
        [picker selectRow:endClassIndex inComponent:END_CLASS animated:YES];
    }
    
    self.navigationItem.rightBarButtonItem = [Tool barButtonItemWithName:@"保存" target:self selector:@selector(saveBtnPressed)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - picker delegate

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case WEEKDAY:
            return [weekday count];
            break;
        case START_CLASS:
            return [startClass count];
            break;
        case END_CLASS:
            return [endClass count];
            break;
        case WEEK_TYPE:
            return [weekType count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case WEEKDAY:
            return [NSString stringWithFormat:@"周%@", weekday[row]];
            break;
        case START_CLASS:
            return startClass[row];
            break;
        case END_CLASS:
            return endClass[row];
            break;
        case WEEK_TYPE:
            return weekType[row];
            break;
        default:
            return @"";
            break;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    switch (component) {
        case WEEKDAY:
            return 60;
            break;
        case START_CLASS:
            return 80;
            break;
        case END_CLASS:
            return 100;
            break;
        case WEEK_TYPE:
            return 80;
            break;
        default:
            return 0;
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == START_CLASS) {
        startClassIndex = row;
        if (row > endClassIndex && row < endClass.count) {
            [pickerView selectRow:row inComponent:END_CLASS animated:YES];
            endClassIndex = row;
        }
    }
    if (component == END_CLASS) {
        endClassIndex = row;
        if (row < startClassIndex && row < endClass.count) {
            [pickerView selectRow:startClassIndex inComponent:END_CLASS animated:YES];
            endClassIndex = startClassIndex;
        }
    }
    if (component == WEEKDAY) {
        day = weekday[row];
    }
    if (component == WEEK_TYPE) {
        dsz = weekType[row];
    }
    NSString *temp_weekType = @"";
    if ([dsz isEqualToString:@"单周"]) {
        temp_weekType = @"(单)";
    } else if ([dsz isEqualToString:@"双周"]) {
        temp_weekType = @"(双)";
    }
    NSString *temp_node = [NSString stringWithFormat:@"周%@ %d-%d节%@", day, startClassIndex + 1, endClassIndex + 1, temp_weekType];
    [self.btn_time setTitle:temp_node forState:UIControlStateNormal];
    [self.btn_time setTitle:temp_node forState:UIControlStateHighlighted];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 4;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSInteger labelTag = 1000;
    NSString *text = @"";
    if (!view) {
        CGFloat width = 0;
        
        switch (component) {
            case WEEKDAY:
                width = 60;                
                break;
            case START_CLASS:
                width = 80;                
                break;
            case END_CLASS:
                width = 100;                
                break;
            case WEEK_TYPE:
                width = 80;                
                break;
            default:
                break;
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:(CGRect) {
            10,
            0,
            width,
            30
        }];
        label.tag = labelTag;
        label.backgroundColor = [UIColor clearColor];
        
        view = [[UIView alloc] initWithFrame:(CGRect) {
            CGPointZero,
            width,
            30
        }];
        view.backgroundColor = [UIColor clearColor];
        [view addSubview:label];
    }
    switch (component) {
        case WEEKDAY:
            text = [NSString stringWithFormat:@"周%@", weekday[row]];
            break;
        case START_CLASS:
            text = startClass[row];
            break;
        case END_CLASS:
            text = endClass[row];
            break;
        case WEEK_TYPE:
            text = weekType[row];
            break;
        default:
            text = @"";
            break;
    }
    UILabel *label = (UILabel *)[view viewWithTag:labelTag];
    label.text = text;
    return view;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30.f;
}

#pragma mark - Custom

- (void)setupWithExistedClass:(NSDictionary *)dic andClassesOfTheDay:(NSArray *)classes{
    theDic = dic;
    self.classes = [NSMutableArray arrayWithArray:classes];
}

- (void)textFiledReturnEditing:(id)sender{
    [self.txtField_classroom resignFirstResponder];
    [self.txtField_endWeek resignFirstResponder];
    [self.txtField_startWeek resignFirstResponder];
    [self.txtField_teacher resignFirstResponder];
    [self.txtField_title resignFirstResponder];
}

- (IBAction)timeButtonPressed:(id)sender{
    [self.txtField_classroom resignFirstResponder];
    [self.txtField_endWeek resignFirstResponder];
    [self.txtField_startWeek resignFirstResponder];
    [self.txtField_teacher resignFirstResponder];
    [self.txtField_title resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        picker.frame = CGRectMake(0, self.view.frame.size.height - PICKER_HEIGHT, self.view.width, PICKER_HEIGHT);
    }];
}

- (void)dismissPicker:(id)sender{
    [UIView animateWithDuration:0.3 animations:^{
        picker.frame = CGRectMake(0, self.view.frame.size.height + PICKER_HEIGHT, self.view.width, PICKER_HEIGHT);
    }];
}

- (void)saveBtnPressed {
    if ([self.txtField_title.text length] == 0) {
        SHOW_NOTICE_HUD(@"课程名称不能为空");
        return;
    } else if (![self isPureInt:self.txtField_startWeek.text] || ![self isPureInt:self.txtField_endWeek.text]) {
        SHOW_NOTICE_HUD(@"开始周或结束周应该为1-20的数字");
        return;
    } else if ([self.txtField_startWeek.text integerValue] > [self.txtField_endWeek.text integerValue]) {
        SHOW_NOTICE_HUD(@"开始周不应该大于结束周");
        return;
    } else {
        if ([dsz isEqualToString:@"双周"]) {
            dsz = @"双";
        } else if ([dsz isEqualToString:@"单周"]) {
            dsz = @"单";
        } else {
            dsz = @"";
        }
        NSString *temp_classname = self.txtField_title.text;
        NSString *temp_teacher = [self.txtField_teacher.text length] != 0 ? self.txtField_teacher.text : @"null";
        NSString *temp_classroom = [self.txtField_classroom.text length] != 0 ? self.txtField_classroom.text : @"";
        NSString *temp_node = [NSString stringWithFormat:@"%d,%d", startClassIndex+1, endClassIndex+1];
        NSString *temp_strWeek = self.txtField_startWeek.text;
        NSString *temp_endWeek = self.txtField_endWeek.text;
                
        if ([theDic count] != 0) {
            NSMutableArray *array = [self parseClassesData:[self loadLocalClassesData]];
            NSInteger index = -1;
            for (NSDictionary *dict in array) {
                ++index;
                if ([dict[CLASSNAME] isEqualToString:theDic[CLASSNAME]] &&
                    [dict[LOCATION] isEqualToString:theDic[LOCATION]]) {
                    break;
                }
            }

            if (index < array.count) {
                [array replaceObjectAtIndex:index withObject:@{ 
                                                               CLASSNAME: temp_classname, 
                                                               DAY: day, 
                                                               DSZ: dsz, 
                                                               END_WEEK: temp_endWeek, 
                                                               STR_WEEK: temp_strWeek, 
                                                               LOCATION: temp_classroom, 
                                                               NODE: temp_node, 
                                                               TEACHER: temp_teacher
                                                               }
                 ];
            }

            NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:@"classes"];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
            BOOL success = [data writeToFile:[PathHelper classTableFileName] atomically:YES];
            if (success) {
                SHOW_NOTICE_HUD(@"更新成功");
            } else {
                SHOW_NOTICE_HUD(@"更新失败");
            }
        } else {        // 添加课程表
            for (NSDictionary *c in self.classes) {
                if (c[NODE] && [c[NODE] isEqualToString:temp_node]) {
                    SHOW_NOTICE_HUD(@"存在冲突的课程,请再确认");
                    return;
                }
            }
            NSMutableArray *array = [self parseClassesData:[self loadLocalClassesData]];
            if (!array) {
                array = [NSMutableArray array];
            }
            [array addObject:@{ 
                              CLASSNAME: temp_classname, 
                              DAY: day, 
                              DSZ: dsz, 
                              END_WEEK: temp_endWeek, 
                              STR_WEEK: temp_strWeek, 
                              LOCATION: temp_classroom, 
                              NODE: temp_node, 
                              TEACHER: temp_teacher
                              }];
            NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:@"classes"];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
            BOOL success = [data writeToFile:[PathHelper classTableFileName] atomically:YES];
            if (success) {
                SHOW_NOTICE_HUD(@"更新成功");
            } else {
                SHOW_NOTICE_HUD(@"更新失败");
            }
        }
    }
}

// 检查字符串是否为纯数字
- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (NSDictionary *)loadLocalClassesData {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[PathHelper classTableFileName]];
}

- (void)saveClassesDataToLocal:(NSDictionary *)classesDict {
    [classesDict writeToFile:[PathHelper classTableFileName] atomically:YES];
}

- (NSMutableArray *)parseClassesData:(NSDictionary *)classesInfo {
    if (classesInfo == nil) return nil;
    return [NSMutableArray arrayWithArray:[classesInfo objectForKey:@"classes"]];
}

@end
