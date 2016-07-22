//
//  FMonthView.m
//  FCalendar
//
//  Created by Thinh on 7/13/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import "FMonthView.h"
#import "FDateUtility.h"

@interface FMonthView ()
@property (strong, nonatomic) NSMutableArray *arrDays;
@property (strong, nonatomic) NSDateFormatter *formatter;
@property (strong, nonatomic) UIColor *dayOffColor;
@property (strong, nonatomic) UIButton *btnSelected;
@property (copy, nonatomic) void(^completionBlock)(NSDate* dateSelected,NSInteger swapView);
@end

@implementation FMonthView

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame calendar:(NSCalendar*)calendar showDayOff:(BOOL)showDayOff dayViewHeight:(CGFloat)height {
    self = [super initWithFrame:frame];
    if (self) {
        //init code
        self.arrDays = [[NSMutableArray alloc] init];
        [self setBackgroundColor:[UIColor blackColor]];
        self.calendar = calendar;
        self.showDayOff = showDayOff;
        self.dayViewHeight = height;
    }
    return self;
}

- (void)createView {
    if (!self.calendar) {
        self.calendar = [NSCalendar currentCalendar];
    }
    if (self.showDayOff) {
        self.dayOffColor = [UIColor grayColor];
    } else {
        self.dayOffColor = [UIColor clearColor];
    }
    if (self.dayViewHeight < 0) {
        self.dayViewHeight = (self.bounds.size.height / 6);
    }
    //Set DateFormatter
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"dd"];
    //Create datecompoment of firstday in month
    NSDateComponents *firstDayInMonthComp = [self.calendar components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:self.month];
    [firstDayInMonthComp setDay:1];
    //Get NSDate form first day in month compoment above
    NSDate *firstDayInMonthDate  = [self.calendar dateFromComponents:firstDayInMonthComp];
    //Get first weekday in month to caculate day start in current calendar
    NSInteger firstWeekDayInMonth = [self.calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayInMonthDate];
    //day start in current calendar
    NSDate *beginDateInCurrentCalendar = [firstDayInMonthDate dateByAddingTimeInterval:-(86400 * (firstWeekDayInMonth - 1))];
    //Add day to Array
    [self.arrDays removeAllObjects];
    NSInteger tag = 0;
    for (NSInteger i = 0; i < 6; i++) {
        for (NSInteger j = 0; j < 7; j++) {
            NSDate *date = [beginDateInCurrentCalendar dateByAddingTimeInterval:(86400 * tag)];
            [self.arrDays addObject:date];
            //create Day with uibutton type
            UIButton *btnDay = [[UIButton alloc] initWithFrame:CGRectMake((self.bounds.size.width / 7) * j, self.dayViewHeight * i, (self.bounds.size.width / 7), self.dayViewHeight - 0.5)];
            [btnDay setBackgroundColor:[UIColor whiteColor]];
            //Set dayview color
            if ([date inSameMonthWithDate:self.month]) {
                [btnDay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            } else {
                [btnDay setTitleColor:self.dayOffColor forState:UIControlStateNormal];
            }
            //Hightlight today
            if ([date isEqualWithDate:[NSDate date]]) {
                [btnDay setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            FCalendarSingleton *singleton  = [FCalendarSingleton sharedInstance];
            if ([date isEqualWithDate:singleton.dateSelected] && [self.month inSameMonthWithDate:singleton.dateSelected]) {
                [btnDay.layer setBorderWidth:0.5];
                self.btnSelected = btnDay;
            }
            [btnDay setTitle:[self.formatter stringFromDate:date] forState:UIControlStateNormal];
            btnDay.tag = tag;
            [btnDay addTarget:self action:@selector(dayViewClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btnDay];
            tag++;
        }
    }
}

- (void)dayViewClick:(UIButton*)sender {
    [self.btnSelected.layer setBorderWidth:0];
    self.btnSelected = sender;
    NSDate *date = [self.arrDays objectAtIndex:sender.tag];
    if (!self.showDayOff && ![date inSameMonthWithDate:self.month]) {
        return;
    }
    FCalendarSingleton *singleton = [FCalendarSingleton sharedInstance];
    singleton.dateSelected = date;
    if (![date inSameMonthWithDate:self.month]) {
        if (sender.tag > 28) {
            self.completionBlock(date,2);
        }
        if (sender.tag < 7) {
            self.completionBlock(date,0);
        }
    } else {
        [self.btnSelected.layer setBorderWidth:0.5];
        self.completionBlock(date,-1);
    }
}

- (void)didSelectDateWithCompletion:(void (^)(NSDate*, NSInteger))callBackBlock {
    self.completionBlock = callBackBlock;
}

@end
