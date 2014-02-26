//
//  LibListNowCell.m
//  iSCAU
//
//  Created by Alvin on 13-9-28.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "LibListNowCell.h"
#import "LibHttpClient.h"
#import "UIButton+Bootstrap.h"

@interface LibListNowCell ()
@property (nonatomic, strong) NSDictionary *bookDict;
@property (nonatomic, weak) IBOutlet CardStyleView    *cardStyleView;
@property (nonatomic, weak) IBOutlet UILabel          *labTitle;
@property (nonatomic, weak) IBOutlet UILabel          *labBarcode;
@property (nonatomic, weak) IBOutlet UILabel          *labLocation;
@property (nonatomic, weak) IBOutlet UILabel          *labBotime;
@property (nonatomic, weak) IBOutlet UILabel          *labRetime;
@property (nonatomic, weak) IBOutlet UILabel          *labRenew;
@property (weak, nonatomic) IBOutlet UIButton *btnRenew;
- (IBAction)renew:(id)sender;

@end

@implementation LibListNowCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UITableViewCell *)configurateInfo:(NSDictionary *)info {
    
    self.bookDict = [[NSDictionary alloc] initWithDictionary:info];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.labTitle.text = [info objectForKey:TITLE];
    
    self.labBarcode.text = [[NSString alloc] initWithFormat:@"索书号 : %@", [info objectForKey:BARCODE_NUMBER]];

    self.labLocation.text = [NSString stringWithFormat:@"馆藏地 : %@", [info objectForKey:COLLECTION_PLACE]];
    
    NSDateFormatter *barFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dotFormatter = [[NSDateFormatter alloc] init];
    [barFormatter setDateFormat:@"yyyy-MM-dd"];
    [dotFormatter setDateFormat:@"yy.M.d"];
    
    NSString *trimedText = [[info objectForKey:BORROW_DATE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSDate *bodate = [barFormatter dateFromString:trimedText];
    self.labBotime.text = [NSString stringWithFormat:@"借出日期 : %@", [dotFormatter stringFromDate:bodate]];

    trimedText = [[info objectForKey:SHOULD_RETURN_DATE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSDate *redate = [barFormatter dateFromString:trimedText];
    self.labRetime.text = [NSString stringWithFormat:@"归还日期 : %@", [dotFormatter stringFromDate:redate]];
    
    self.labRenew.text = [NSString stringWithFormat:@"续借量: %@",[info objectForKey:RENEW_TIME]];

    [self.btnRenew setTitle:@"续借" forState:UIControlStateNormal];
    [self.btnRenew infoStyle];

    return self;
}

- (IBAction)renew:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_NOTICE_NOTIFICATION 
                                                        object:nil 
                                                      userInfo:@{ kNotice : @"请稍等.." }];
    [LibHttpClient libRenewWithBarcode:self.bookDict[BARCODE_NUMBER]
                             checkCode:self.bookDict[CHECK_CODE] 
                               Success:^(NSData *responseData, int httpCode) {
                                   if (httpCode == 200) {
                                       [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_NOTICE_NOTIFICATION 
                                                                                           object:nil 
                                                                                         userInfo:@{ 
                                                                                                    kNotice : @"续借成功!", 
                                                                                                    kHideNoticeIntervel : @(1) 
                                                                                                    }
                                        ];
                                   }
                               } failure:^(NSData *responseData, int httpCode) {
                                   [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_NOTICE_NOTIFICATION 
                                                                                       object:nil 
                                                                                     userInfo:nil];
                               }];
}

@end
