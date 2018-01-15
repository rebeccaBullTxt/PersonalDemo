//
//  MyOwnTime.m
//  UIButton倒计时设置
//
//  Created by 刘渊 on 2018/1/14.
//  Copyright © 2018年 刘渊. All rights reserved.
//

#import "MyOwnTime.h"
#import "Date.h"
@implementation MyOwnTime

+ (NSTimeInterval)getDayBeginTimeWithTime:(NSTimeInterval)time{
    NSDate *anyDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSTimeInterval interval = [anyDate  getIntervalTimeZone];//当前时区的时间戳
    int mod = ((int)(time+interval-57600)) % 86400;  //时间戳从1970/1/1 8:0:0 开始  目标时区今天已经过去多少秒  1097
    NSTimeInterval d = (int)time - mod ;  //
    return d;
}
  
+ (NSTimeInterval)getMonthBeginTimeWithTime:(NSTimeInterval)time
{
    int daycount = [self getMonthDay:time];
    
    NSTimeInterval monthBegin = [self getDayBeginTimeWithTime:time - (daycount-1) * 24 * 3600];
    
    NSLog(@"month begin: %.0f", monthBegin);
    
    return monthBegin;
}

    
+ (int)getMonthDay:(NSTimeInterval)time
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    int day = (int)[components day];
    
    return day;
}
@end
