//
//  LibSearchBooksDetailCell.m
//  iSCAU
//
//  Created by Alvin on 2/19/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "LibSearchBooksDetailCell.h"

@interface LibSearchBooksDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *libCollectionPlace;
@property (weak, nonatomic) IBOutlet UILabel *libBooksStatus;
@property (weak, nonatomic) IBOutlet UILabel *libBarcodeNumber;
@property (weak, nonatomic) IBOutlet UILabel *libSerialNumber;
@property (weak, nonatomic) IBOutlet UILabel *libYearTitle;
@end

@implementation LibSearchBooksDetailCell

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
    self.contentView.backgroundColor = [UIColor clearColor];
    
    if (info.count > 0) {
        self.libCollectionPlace.text = [NSString stringWithFormat:@"馆藏地: %@", info[COLLECTION_PLACE]];
        self.libBooksStatus.text = [NSString stringWithFormat:@"借出状态: %@", info[BOOK_STATUS]];
        self.libSerialNumber.text = [NSString stringWithFormat:@"序列号: %@", info[SERIAL_NUMBER]];
        self.libBarcodeNumber.text = [NSString stringWithFormat:@"%@", info[BARCODE_NUMBER]];
        self.libYearTitle.text = [NSString stringWithFormat:@"年份: %@", info[YEAR_TITLE]];
    }
    
    return self;
}

@end
