//
//  ViewController.m
//  MyCalendarView
//
//  Created by 崔忠海 on 2016/11/28.
//  Copyright © 2016年 BFMe. All rights reserved.
//

#import "ViewController.h"
#import "CalendarView.h"

#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, self.view.frame.size.width-60, 40)];
    label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:label];
    
    CalendarView *calendarView = [[CalendarView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-280)/2, self.view.frame.size.height-350, 280, 310)];
    calendarView.today = [NSDate date];
    calendarView.date = calendarView.today;
    calendarView.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year, NSInteger week){
        label.text = [NSString stringWithFormat:@"%li-%li-%li", year, month, day];
    };
    ViewBorderRadius(calendarView, 0, 1, [UIColor lightGrayColor]);
    [self.view addSubview:calendarView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
