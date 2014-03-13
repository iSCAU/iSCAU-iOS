//
//  LibListNowViewController.m
//  iSCAU
//
//  Created by Alvin on 13-9-11.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "LibListNowViewController.h"
#import "LibHttpClient.h"
#import "CardStyleView.h"
#import "LibListNowCell.h"
#import "UIImage+Tint.h"

@interface LibListNowViewController ()

@property (nonatomic, strong) UIView *selectedBackgroundView;
@property (nonatomic) BOOL isReloading;
@property (nonatomic, weak) IBOutlet UITableView *tableListNow;
@property (nonatomic, strong) NSMutableArray *booksArray;

@end

@implementation LibListNowViewController

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
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    if (IS_FLAT_UI) {
        btnClose.frame = CGRectMake(0, 0, 45, 44);
    } else {
        btnClose.frame = CGRectMake(0, 0, 55, 44);
        btnClose.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    [btnClose setImage:[[UIImage imageNamed:@"refresh.png"] imageWithTintColor:APP_DELEGATE.tintColor] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btnClose];
    self.navigationItem.rightBarButtonItem = closeBarBtn;
    
    if (IS_IPHONE4) {
        self.view.frame = CGRectMake(0, 0, 320.0, 480 - 44 - 20.0);
    }
    
    SET_DEFAULT_BACKGROUND_COLOR(self.tableListNow);
    
    self.booksArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    [self reloadData];
}

- (void)reloadData {
    if ([Tool stuNum].length < 1 || [Tool libPwd].length < 1) {
        SHOW_NOTICE_HUD(@"请先填写对应账号密码哦");
        return;
    }
    if (self.isReloading) {
        return;
    }
    self.isReloading = YES;
    SHOW_WATING_HUD;
    [[LibHttpClient shareInstance] 
     libListNowSuccess:^(NSData *responseData, NSInteger httpCode){
         self.isReloading = NO;
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
         if (httpCode == 200) {
             HIDE_ALL_HUD;
             NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:[dict objectForKey:@"books"]];
             if (temp.count > 0) {
                 self.booksArray = temp;
                 [self.tableListNow reloadData];
             }
         }
     } failure:^(NSData *responseData, NSInteger httpCode){
         self.isReloading = NO;
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.booksArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *LibListNowCellIndentifier = @"LibListNowCellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LibListNowCellIndentifier];
    if (cell == nil) {
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"LibListNowCell" owner:self options:nil];
        cell = [cellArray objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [(LibListNowCell *)cell configurateInfo:self.booksArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
