//
//  CETResultViewController.m
//  iSCAU
//
//  Created by Alvin on 3/18/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "CETResultViewController.h"

@interface CETResultViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labSchool;
@property (weak, nonatomic) IBOutlet UILabel *labTotalMark;
@property (weak, nonatomic) IBOutlet UILabel *labType;
@property (weak, nonatomic) IBOutlet UILabel *labListening;
@property (weak, nonatomic) IBOutlet UILabel *labReading;
@property (weak, nonatomic) IBOutlet UILabel *labWriting;
@property (weak, nonatomic) IBOutlet UILabel *labTime;

@end

@implementation CETResultViewController

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
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.mark) {
        self.labName.text = self.mark.name;
        self.labSchool.text = self.mark.school;
        self.labTotalMark.text = self.mark.totalMark;
        self.labListening.text = self.mark.listening;
        self.labReading.text = self.mark.reading;
        self.labWriting.text = self.mark.writing;
        self.labTime.text = [NSString stringWithFormat:@"考试时间: %@", self.mark.examTime];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
