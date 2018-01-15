//
//  ViewController.m
//  UIButton倒计时设置
//
//  Created by 刘渊 on 2018/1/14.
//  Copyright © 2018年 刘渊. All rights reserved.
//

#import "ViewController.h"
#import "MyOwnTime.h"
#import "ZQCountDownView.h"
@interface ViewController ()
    
@property (weak, nonatomic) IBOutlet ZQCountDownView *CurrentDayCountdown;
    @property (weak, nonatomic) IBOutlet ZQCountDownView *CurrentMonLeft;
    
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSTimeInterval currentInt = [[NSDate date]timeIntervalSince1970];
    
    NSTimeInterval dayStart = [MyOwnTime getDayBeginTimeWithTime:currentInt];
    NSTimeInterval dayend = dayStart + 3600 * 24 -1;
    
    _CurrentDayCountdown.themeColor = [UIColor whiteColor];
    _CurrentDayCountdown.textColor = [UIColor darkGrayColor];
    _CurrentDayCountdown.textFont = [UIFont boldSystemFontOfSize:20];
    _CurrentDayCountdown.countDownTimeInterval = dayend - currentInt;
    
    int dayCount = [MyOwnTime getMonthDay:currentInt];
    NSLog(@"%d",dayCount);
    //
   
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDate *now = [NSDate date];
//    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
//    NSDate *startDate = [calendar dateFromComponents:components];
//    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
