//
//  FMonthView.m
//  FCalendar
//
//  Created by Thinh on 7/13/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import "FMonthView.h"
#import "FDateUtility.h"
#import "FDayView.h"

@interface FMonthView ()
@property (strong, nonatomic) NSMutableArray *arrDays;
@property (strong, nonatomic) NSMutableArray *arrDayViews;
@property (strong, nonatomic) NSDateFormatter *formatter;
@property (strong, nonatomic) UIColor *dayOffColor;
@property (strong, nonatomic) FDayView *dayViewSelected;
@property (copy, nonatomic) void(^completionBlock)(NSDate* dateSelected,NSInteger swapView);
@end

@implementation FMonthView

#pragma mark - Init
- (id)initWithCalendar:(NSCalendar*)calendar showDayOff:(BOOL)showDayOff dayViewHeight:(CGFloat)height {
    self = [super init];
    if (self) {
        //init code
        self.arrDays = [[NSMutableArray alloc] init];
        self.arrDayViews = [[NSMutableArray alloc] init];
        [self setBackgroundColor:[UIColor grayColor]];
        self.calendar = calendar;
        self.showDayOff = showDayOff;
        self.dayViewHeight = height;
        //Set DateFormatter
        self.formatter = [[NSDateFormatter alloc] init];
        [self.formatter setDateFormat:@"dd"];
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
    //day start in current calendar
    NSDate *beginDateInCurrentCalendar = [NSDate dateBeginningOfMonth:self.month inCalendar:self.calendar];
    //Add day to Array
    [self.arrDays removeAllObjects];
    [self.arrDayViews removeAllObjects];
    NSInteger tag = 0;
    FDayView *preDayView;
    for (NSInteger i = 0; i < 6; i++) {
        for (NSInteger j = 0; j < 7; j++) {
            NSDate *date = [beginDateInCurrentCalendar dateByAddingTimeInterval:(86400 * tag)];
            [self.arrDays addObject:date];
            FDayView *dayView = [[FDayView alloc] init];
            [self addSubview:dayView];
            //DayView Layout
            [dayView setTranslatesAutoresizingMaskIntoConstraints:NO];
            CGFloat scaleMultiplier = 1.0 / 7.0;
            [self addConstraint:[NSLayoutConstraint constraintWithItem:dayView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:scaleMultiplier constant:-(SPACE_VALUE *2)]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:dayView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:scaleMultiplier constant:(self.dayViewHeight - (SPACE_VALUE * 2))]];
            if (j == 0) {
                [self addConstraint:[NSLayoutConstraint constraintWithItem:dayView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:(SPACE_VALUE * 2)]];
            } else {
                preDayView = [self.arrDayViews objectAtIndex:tag - 1];
                [self addConstraint:[NSLayoutConstraint constraintWithItem:dayView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:preDayView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:(SPACE_VALUE * 2)]];
            }
            if (i == 0) {
                [self addConstraint:[NSLayoutConstraint constraintWithItem:dayView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:(SPACE_VALUE * 2)]];
            } else {
                preDayView = [self.arrDayViews objectAtIndex:(i - 1)*7];
                [self addConstraint:[NSLayoutConstraint constraintWithItem:dayView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:preDayView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:(SPACE_VALUE * 2)]];
            }
            if ([date inSameMonthWithDate:self.month]) {
                [dayView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            } else {
                [dayView setTitleColor:self.dayOffColor forState:UIControlStateNormal];
            }
            //Hightlight today
            if ([date isEqualWithDate:[NSDate date]]) {
                [dayView setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            FCalendarSingleton *singleton = [FCalendarSingleton sharedInstance];
            if ([date isEqualWithDate:singleton.dateSelected] && [self.month inSameMonthWithDate:singleton.dateSelected]) {
                [dayView.layer setBorderWidth:1];
                self.dayViewSelected = dayView;
            }
            [dayView setTitle:[self.formatter stringFromDate:date] forState:UIControlStateNormal];
            dayView.tag = tag;
            [dayView addTarget:self action:@selector(dayViewClick:) forControlEvents:UIControlEventTouchUpInside];
            tag++;
            [self.arrDayViews addObject:dayView];
            [self layoutSubviews];
        }
    }
}

- (void)reloadDayView {
    [self.arrDays removeAllObjects];
    NSDate *beginDateInCurrentCalendar = [NSDate dateBeginningOfMonth:self.month inCalendar:self.calendar];
    NSUInteger index = 0;
    for (FDayView *dayView in self.arrDayViews) {
        NSDate *date = [beginDateInCurrentCalendar dateByAddingTimeInterval:(86400 * index)];
        [self.arrDays addObject:date];
        if ([date inSameMonthWithDate:self.month]) {
            [dayView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        } else {
            [dayView setTitleColor:self.dayOffColor forState:UIControlStateNormal];
        }
        //Hightlight today
        if ([date isEqualWithDate:[NSDate date]]) {
            [dayView setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        FCalendarSingleton *singleton = [FCalendarSingleton sharedInstance];
        if ([date isEqualWithDate:singleton.dateSelected] && [self.month inSameMonthWithDate:singleton.dateSelected]) {
            [dayView.layer setBorderWidth:1];
            self.dayViewSelected = dayView;
        } else {
            [dayView.layer setBorderWidth:0];
        }
        [dayView setTitle:[self.formatter stringFromDate:date] forState:UIControlStateNormal];
        index++;
    }
}

- (void)dayViewClick:(FDayView*)sender {
    [sender.layer setBorderWidth:1];
    [self.dayViewSelected.layer setBorderWidth:0];
    self.dayViewSelected = sender;
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
        self.completionBlock(date,-1);
    }
}

- (void)didSelectDateWithCompletion:(void (^)(NSDate*, NSInteger))callBackBlock {
    self.completionBlock = callBackBlock;
}

@end
