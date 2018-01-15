//
//  CalendarCell.m
//  Seller
//
//  Created by 崔忠海 on 2016/10/11.
//  Copyright © 2016年 bfme. All rights reserved.
//

#import "CalendarCell.h"

@interface CalendarCell ()

@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@end

@implementation CalendarCell

- (void)setItemText:(NSString *)itemText
{
    _itemText = itemText;
    self.itemLabel.text = itemText;
}

- (void)setItemTextColor:(UIColor *)itemTextColor
{
    _itemTextColor = itemTextColor;
    self.itemLabel.textColor = itemTextColor;
}

- (void)setType:(NSInteger)type
{
    _type = type;
}

- (void)awakeFromNib {
    // Initialization code
}

@end
