//
//  CECommentWritingViewController.m
//  iSCAU
//
//  Created by Alvin on 3/16/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "CECommentWritingViewController.h"
#import "CEHttpClient.h"
#import "UIImage+Tint.h"
#import "UIButton+Bootstrap.h"
#import "CAKeyframeAnimation+Parametric.h"

@interface CECommentWritingViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *backgroundScrollView;
@property (weak, nonatomic) IBOutlet UILabel *labUsername;
@property (weak, nonatomic) IBOutlet UISwitch *switchIsCheck;
@property (weak, nonatomic) IBOutlet UISwitch *switchHasHomework;
@property (weak, nonatomic) IBOutlet UITextField *txtExamType;
@property (weak, nonatomic) IBOutlet UITextView *txtComment;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@end

@implementation CECommentWritingViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    
    if (IS_IPHONE4) {
        CGRect frame = self.view.frame;
        frame.size.height -= IPHONE_DEVICE_LENGTH_DIFFERENCE;
        self.view.frame = frame;
        
        self.backgroundScrollView.frame = self.view.bounds;
        
        frame = self.txtComment.frame;
        frame.size.height -= IPHONE_DEVICE_LENGTH_DIFFERENCE;
        self.txtComment.frame = frame;
        
        frame = self.btnSubmit.frame;
        frame.origin.y -= IPHONE_DEVICE_LENGTH_DIFFERENCE;
        self.btnSubmit.frame = frame;
    }
     
    // left close button
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.frame = CGRectMake(0, 0, 45, 44);
    [btnClose setTitle:@"关闭" forState:UIControlStateNormal];
    [btnClose setTitleColor:APP_DELEGATE.tintColor forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btnClose];
    self.navigationItem.leftBarButtonItem = closeBarBtn;
    
    // right finish button
    UIButton *btnFinished = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFinished.frame = CGRectMake(0, 0, 45, 44);
    [btnFinished setTitle:@"完成" forState:UIControlStateNormal];
    [btnFinished setTitleColor:APP_DELEGATE.tintColor forState:UIControlStateNormal];
    [btnFinished addTarget:self action:@selector(finished) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *finishedBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btnFinished];
    self.navigationItem.rightBarButtonItem = finishedBarBtn;
    
    //
    [self.btnSubmit customStyle:APP_DELEGATE.tintColor];
    //
    [self.txtComment defaultRoundRectBorder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text field and text view delegate

- (void)keyboardWillShow:(NSNotification *)notification
{    
    NSDictionary *userInfo = notification.userInfo;
    
    NSValue *frameValue = userInfo[UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [frameValue CGRectValue];
    
    NSValue *animationDurationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    CGFloat editingHeight = self.view.height - keyboardRect.size.height;
    self.backgroundScrollView.contentSize = self.view.size;
    
    [UIView animateWithDuration:animationDuration
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            
                            // change scrollview indicator inset
                            CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
                            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
                            self.backgroundScrollView.contentInset = contentInsets;
                            self.backgroundScrollView.scrollIndicatorInsets = contentInsets;

                            CGRect txtRect = CGRectZero;
                            
                            if (self.txtUsername.isFirstResponder) {
                                txtRect = (CGRect) {
                                    0,
                                    self.txtUsername.origin.y - 10,
                                    self.view.width,
                                    editingHeight
                                };
                            } else if (self.txtExamType.isFirstResponder) {
                                txtRect = (CGRect) {
                                    0,
                                    self.txtExamType.origin.y - 10,
                                    self.view.width,
                                    editingHeight
                                };
                            } else if (self.txtComment.isFirstResponder) {
                                txtRect = (CGRect) {
                                    0,
                                    self.txtComment.origin.y - 10,
                                    self.view.width,
                                    editingHeight
                                };
                            }
                            [self.backgroundScrollView scrollRectToVisible:txtRect animated:YES];
                        }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    
    NSValue *animationDurationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         UIEdgeInsets contentInsets = UIEdgeInsetsZero;
                         self.backgroundScrollView.contentInset = contentInsets;
                         self.backgroundScrollView.scrollIndicatorInsets = contentInsets;
                     }];
}

- (void)finished
{
    [self.txtExamType resignFirstResponder];
    [self.txtComment resignFirstResponder]; 
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submit:(id)sender 
{
    [self finished];
    if ([self.txtUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1 ||
        [self.txtExamType.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1 || 
        [self.txtComment.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
        SHOW_NOTICE_HUD(@"要填写的内容都不能为空哦");
        return;
    }
    
    SHOW_WATING_HUD;
    
    [[CEHttpClient shareInstance] 
     addCommentWithCourseId:self.course.courseId
     userName:self.txtUsername.text
     isCheck:self.switchIsCheck.isOn 
     hasHomework:self.switchHasHomework.isOn 
     examType:self.txtExamType.text
     comment:self.txtComment.text
     success:^(NSData *responseData, int httpCode) {
         SHOW_NOTICE_HUD(@"评论成功!");
         
         double delayInSeconds = 2.0;
         dispatch_time_t deplayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
         dispatch_after(deplayTime, dispatch_get_main_queue(), ^(void){
             [self back];
         });
     } failure:^(NSData *responseData, int httpCode) {
         SHOW_NOTICE_HUD(@"评论失败了..");
     }];
}
@end
