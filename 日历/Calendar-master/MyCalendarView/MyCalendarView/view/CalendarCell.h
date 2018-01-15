//
//  CalendarCell.h
//  Seller
//
//  Created by 崔忠海 on 2016/10/11.
//  Copyright © 2016年 bfme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarCell : UICollectionViewCell

@property (nonatomic, copy) NSString *itemText;
@property (nonatomic, strong) UIColor *itemTextColor;
@property (nonatomic, assign) NSInteger type; // -1昨天  0不可选 1 今天 2 明天

@end
