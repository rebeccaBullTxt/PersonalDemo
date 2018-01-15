//
//  CalendarView.h
//  Seller
//
//  Created by 崔忠海 on 2016/10/11.
//  Copyright © 2016年 bfme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarView : UIView
@property (nonatomic, copy) void(^calendarBlock)(NSInteger day, NSInteger month, NSInteger year, NSInteger week);

@property (nonatomic, strong) NSDate *today;
@property (nonatomic, strong) NSDate *date;

@end
