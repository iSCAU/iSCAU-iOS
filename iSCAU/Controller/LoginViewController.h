//
//  LoginViewController.h
//  iSCAU
//
//  Created by Alvin on 13-8-20.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic, assign) BOOL isShonwByPresent;
@property (nonatomic, weak) IBOutlet UITextField  *txtStuNum;
@property (nonatomic, weak) IBOutlet UITextField  *txtStuPwd;
@property (nonatomic, weak) IBOutlet UITextField  *txtLibPwd;

@end
