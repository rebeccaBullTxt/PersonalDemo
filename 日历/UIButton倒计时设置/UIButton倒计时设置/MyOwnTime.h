//
//  MyOwnTime.h
//  UIButton倒计时设置
//
//  Created by 刘渊 on 2018/1/14.
//  Copyright © 2018年 刘渊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOwnTime : NSObject
+ (NSTimeInterval)getDayBeginTimeWithTime:(NSTimeInterval)time;

+ (NSTimeInterval)getMonthBeginTimeWithTime:(NSTimeInterval)time;

+ (int)getMonthDay:(NSTimeInterval)time;

@end
