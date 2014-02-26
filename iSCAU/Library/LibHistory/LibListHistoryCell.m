//
//  LibListHistoryCell.m
//  iSCAU
//
//  Created by Alvin on 13-10-4.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "LibListHistoryCell.h"

@interface LibListHistoryCell ()

@property (nonatomic, weak) IBOutlet CardStyleView    *cardStyleView;
@property (nonatomic, weak) IBOutlet UILabel          *labTitle;
@property (nonatomic, weak) IBOutlet UILabel          *labBarcode;
@property (nonatomic, weak) IBOutlet UILabel          *labLocation;
@property (nonatomic, weak) IBOutlet UILabel          *labBotime;
@property (nonatomic, weak) IBOutlet UILabel          *labRetime;

@end

@implementation LibListHistoryCell

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
    
    trimedText = [[info objectForKey:RETURN_DATE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSDate *redate = [barFormatter dateFromString:trimedText];
    self.labRetime.text = [NSString stringWithFormat:@"归还日期 : %@", [dotFormatter stringFromDate:redate]];
        
    return self;
}

@end
