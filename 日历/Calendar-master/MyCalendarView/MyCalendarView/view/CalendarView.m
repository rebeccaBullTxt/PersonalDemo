//
//  CalendarView.m
//  Seller
//
//  Created by 崔忠海 on 2016/10/11.
//  Copyright © 2016年 bfme. All rights reserved.
//

#import "CalendarView.h"

#import "CalendarCell.h"

#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)

#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)

#define  kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define  kScreenHeight [UIScreen mainScreen].bounds.size.height

#define FMHex(rgbValue) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])

#define kNavigationBarBGColor FMHex(0xfd70a4)
#define kViewBGColor FMHex(0xf0f0f0)

#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define UIColorFromRGB(rgbValue) UIColorFromRGBA(rgbValue, 1.0)

#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

@interface CalendarView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITableViewDataSource, UITableViewDelegate>
{
    UIView *yearBackView;
    UIButton *yearButton;
    UILabel *yearLabel;
    
    UIView *monthBackView;
    UIButton *monthButton;
    UILabel *monthLabel;
    
    UICollectionView *myCollectionView;
    UIButton *leftButton;
    UIButton *rightButton;
    
    NSArray *weekDayArray;
    CalendarCell *selectedCell;
    
    UITableView *yearTableView;
    NSMutableArray *yearArray;
    
    UITableView *monthTableView;
    NSArray *monthArray;
    
    NSInteger selectedDay;
    NSInteger selectedMonth;
    NSInteger selectedYear;
}

@end

NSString *const CalendarCellIdentifier = @"CalendarCellIdentifier";

@implementation CalendarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)prepareDataArray:(NSDate *)date
{
    monthArray = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12"];
    weekDayArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    NSInteger currentYear = [self year:date];
    yearArray = [NSMutableArray array];
    for (NSInteger i = currentYear ; i >= 2000; i--) {
        [yearArray addObject:[NSString stringWithFormat:@"%li", (long)i]];
    }
}

- (void)setToday:(NSDate *)today
{
    _today = today;
    [self prepareDataArray:today];
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    selectedYear = [self year:date];
    selectedMonth = [self month:date];
    
    [yearLabel setText:[NSString stringWithFormat:@"%li年" ,(long)selectedYear]];
    [monthLabel setText:[NSString stringWithFormat:@"%li月", (long)selectedMonth]];
    [myCollectionView reloadData];
}

#pragma mark -
- (void)createSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    yearBackView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 110, 26)];
    [self addSubview:yearBackView];
    ViewBorderRadius(yearBackView, 5, 1, kNavigationBarBGColor);

    yearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    yearButton.frame = CGRectMake(110-26, 0, 26, 26);
    [yearButton setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [yearButton setImage:[UIImage imageNamed:@"up"] forState:UIControlStateSelected];
    [yearButton addTarget:self action:@selector(selectYearView) forControlEvents:UIControlEventTouchUpInside];
    [yearBackView addSubview:yearButton];
    
    yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110-26, 26)];
    yearLabel.textAlignment = NSTextAlignmentCenter;
    yearLabel.font = [UIFont systemFontOfSize:13];
    [yearBackView addSubview:yearLabel];
    
    monthBackView = [[UIView alloc] initWithFrame:CGRectMake(150, 20, 110, 26)];
    [self addSubview:monthBackView];
    ViewBorderRadius(monthBackView, 5, 1, kNavigationBarBGColor);

    monthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    monthButton.frame = CGRectMake(110-26, 0, 26, 26);
    [monthButton setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [monthButton setImage:[UIImage imageNamed:@"up"] forState:UIControlStateSelected];
    [monthButton  addTarget:self action:@selector(selectMonthView) forControlEvents:UIControlEventTouchUpInside];
    [monthBackView addSubview:monthButton];
    
    monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110-26, 26)];
    monthLabel.textAlignment = NSTextAlignmentCenter;
    monthLabel.font = [UIFont systemFontOfSize:13];
    [monthBackView addSubview:monthLabel];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 5, 0);
    layout.itemSize = CGSizeMake(25, 25);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //设置collectionView的属性
    myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, MaxY(yearBackView)+15, 240, 210) collectionViewLayout:layout];
    myCollectionView.backgroundColor = [UIColor whiteColor];
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    [self addSubview:myCollectionView];
    
    [myCollectionView registerNib:[UINib nibWithNibName:@"CalendarCell" bundle:nil] forCellWithReuseIdentifier:CalendarCellIdentifier];
    
    CGFloat space = (280-86*2-50)/2;
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(space, MaxY(myCollectionView), 86, 37);
    [leftButton setImage:[UIImage imageNamed:@"calendar_l"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftButton];
    
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(MaxX(leftButton)+50, MaxY(myCollectionView), 86, 37);
    [rightButton setImage:[UIImage imageNamed:@"calendar_r"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightButton];
}

- (void)leftButtonClick:(UIButton *)sender
{
//    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^(void) {
//        self.date = [self lastMonth:self.date];
//    } completion:nil];
    self.date = [self lastMonth:self.date];
}

- (void)rightButtonClick:(UIButton *)sender
{
//    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^(void) {
//        self.date = [self nextMonth:self.date];
//    } completion:nil];
    self.date = [self nextMonth:self.date];
}

- (void)selectYearView
{
    [monthTableView removeFromSuperview];
    monthButton.selected = NO;
    yearButton.selected = !yearButton.selected;
    if (yearButton.selected) {
        if (!yearTableView) {
            yearTableView = [[UITableView alloc] initWithFrame:CGRectMake(X(yearBackView), MaxY(yearBackView), WIDTH(yearBackView), HEIGHT(myCollectionView)+10) style:UITableViewStylePlain];
            yearTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            yearTableView.dataSource = self;
            yearTableView.delegate = self;
            ViewBorderRadius(yearTableView, 5, 1, kNavigationBarBGColor);
        }
        [self addSubview:yearTableView];
    } else {
        [yearTableView removeFromSuperview];
    }
}

- (void)selectMonthView
{
    [yearTableView removeFromSuperview];
    yearButton.selected = NO;
    monthButton.selected = !monthButton.selected;
    if (monthButton.selected) {
        if (!monthTableView) {
            monthTableView = [[UITableView alloc] initWithFrame:CGRectMake(X(monthBackView), MaxY(monthBackView), WIDTH(monthBackView), HEIGHT(myCollectionView)+10) style:UITableViewStylePlain];
            monthTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            monthTableView.dataSource = self;
            monthTableView.delegate = self;
            ViewBorderRadius(monthTableView, 5, 1, kNavigationBarBGColor);
        }
        [self addSubview:monthTableView];
    } else {
        [monthTableView removeFromSuperview];
    }
}

#pragma mark - TableViewDelegate and TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == yearTableView) {
        return yearArray.count;
    }
    return monthArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 29;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (tableView == yearTableView) {
        cell.textLabel.text = yearArray[indexPath.row];
    } else {
        cell.textLabel.text = monthArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == yearTableView) {
        NSInteger year = [yearArray[indexPath.row] integerValue];
        NSInteger count = year - selectedYear;
        self.date = [self setYear:self.date count:count];
    } else {
        NSInteger month = [monthArray[indexPath.row] integerValue];
        NSInteger count = month - selectedMonth;
        self.date = [self setMonth:self.date count:count];
    }
    [tableView removeFromSuperview];
    yearButton.selected = NO;
    monthButton.selected = NO;
}

#pragma -mark collectionView delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return weekDayArray.count;
    } else {
        return 42;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CalendarCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.section == 0) {
        cell.itemText = weekDayArray[indexPath.item];
        cell.itemTextColor = FMHex(0x333333);
        cell.type = 0;
    } else {
        NSInteger daysInThisMonth = [self totaldaysInMonth:_date];
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        
        if (i < firstWeekday) {
            cell.itemText = @"";
            cell.type = 0;
        } else if (i > firstWeekday + daysInThisMonth - 1) {
            cell.itemText = @"";
            cell.type = 0;
        } else {
            day = i - firstWeekday + 1;
            cell.itemText = [NSString stringWithFormat:@"%li",(long)day];
            cell.itemTextColor = FMHex(0x333333);
            cell.type = -1;
            //this month
            if ([_today isEqualToDate:_date]) {
                if (day == [self day:_date]) {
                    cell.itemTextColor = [UIColor whiteColor];
                    cell.type = 1;
                    cell.backgroundColor = kNavigationBarBGColor;
                    selectedDay = day;
                    selectedCell = cell;
                } else if (day > [self day:_date]) {
                    cell.itemTextColor = FMHex(0xcbcbcb);
                    cell.type = 2;
                }
            } else if ([_today compare:_date] == NSOrderedAscending) {
                cell.itemTextColor = FMHex(0xcbcbcb);
                cell.type = 2;
            }
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [yearTableView removeFromSuperview];
    [monthTableView removeFromSuperview];
    yearButton.selected = NO;
    monthButton.selected = NO;
    
    if (indexPath.section == 1) {
        CalendarCell *cell = (CalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if ([cell isEqual:selectedCell]) {
            if (self.calendarBlock) {
                NSInteger week = indexPath.item/7+1;
                self.calendarBlock([cell.itemText integerValue], selectedMonth, selectedYear, week);
//                [self removeFromSuperview];
            }
            return;
        } else {
            if (cell.type == -1 || cell.type == 1) {
                cell.itemTextColor = [UIColor whiteColor];
                cell.backgroundColor = kNavigationBarBGColor;
                selectedCell.itemTextColor = FMHex(0x333333);
                selectedCell.backgroundColor = [UIColor whiteColor];
                selectedCell = cell;
                selectedDay = [cell.itemText integerValue];
                
                NSInteger week = indexPath.item/7+1;
                
                if (self.calendarBlock) {
                    self.calendarBlock([cell.itemText integerValue], selectedMonth, selectedYear, week);
//                    [self removeFromSuperview];
                }
            }
        }
    }
}

#pragma mark - date
- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}

- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}


- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

//- (NSInteger)totaldaysInThisMonth:(NSDate *)date{
//    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
//    return totaldaysInMonth.length;
//}

- (NSInteger)totaldaysInMonth:(NSDate *)date {
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

- (NSDate *)setMonth:(NSDate *)date count:(NSInteger)count
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = count;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate *)setYear:(NSDate *)date count:(NSInteger)count
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = count;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}


- (NSDate *)lastMonth:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate *)nextMonth:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
