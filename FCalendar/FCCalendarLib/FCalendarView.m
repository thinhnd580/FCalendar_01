//
//  FCalendarView.m
//  FCalendar
//
//  Created by Thinh on 7/13/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import "FCalendarView.h"
#import "FDateUtility.h"
#import "WeekView.h"

@interface FCalendarView ()
@property (strong, nonatomic) FMonthView *monthView;
@property (strong, nonatomic) WeekView *weekView;
@property (strong, nonatomic) UIView *infoView;
@property (strong, nonatomic) UILabel *lbInfor;
@property (strong, nonatomic) NSDateFormatter *formatter;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeLeft;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeRight;
@property (copy, nonatomic) void(^callBackBlock)(NSDate* dateSelected,NSInteger swapView);
@end

@implementation FCalendarView
#pragma mark - Init
- (void)drawRect:(CGRect)rect {
    [self createUIWithFrame:rect];
}

- (id)initWithFrame:(CGRect)frame calendar:(NSCalendar*)calendar monthDisplay:(NSDate*)month dateSelected:(NSDate*)date showDayOff:(BOOL)showDayOff dayViewHeight:(CGFloat)height {
    self = [super initWithFrame:frame];
    if (self) {
        //Set data
        self.calendar = calendar;
        self.monthDisplay = month;
        self.dateSelected = date;
        self.showDayOff = showDayOff;
        self.dayViewHeight = height;
        [self setBackgroundColor:[UIColor whiteColor]];
        if (!self.calendar) {
            self.calendar = [NSCalendar currentCalendar];
            self.calendar.firstWeekday = 2;
        }
        if (!self.monthDisplay) {
            self.monthDisplay = [NSDate date];
        }
        if (self.dateSelected) {
            self.monthDisplay = self.dateSelected;
            ((FCalendarSingleton*)[FCalendarSingleton sharedInstance]).dateSelected = self.dateSelected;
        }
        //Create Date formatter and label
        self.formatter = [[NSDateFormatter alloc] init];
        [self.formatter setDateFormat:@"MMMM yyyy"];
        self.lbInfor = [[UILabel alloc] init];
        [self.lbInfor setTextAlignment:NSTextAlignmentCenter];
    }
    return self;
}

- (void)createUIWithFrame:(CGRect)frame {
    [self setBackgroundColor:[UIColor whiteColor]];
    //Create Month Label
    self.infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, INFOVIEW_HEIGHT)];
    [self addSubview:self.infoView];
    self.lbInfor.frame = self.infoView.bounds;
    [self.infoView addSubview:self.lbInfor];
    //Create WeekView
    self.weekView = [[WeekView alloc] initWithFrame:CGRectMake(0, INFOVIEW_HEIGHT, frame.size.width, WEEKVIEW_HEIGHT)];
    [self.weekView setCurrentCalendar:self.calendar];
    [self addSubview:self.weekView];
    //Create main calendar
    [self addCalendarView];
}

- (void)addCalendarView {
    //Swipe Recognize
    self.swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    self.swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    // Setting the swipe direction.
    [self.swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    // Adding the swipe gesture on image view
    [self addGestureRecognizer:self.swipeLeft];
    [self addGestureRecognizer:self.swipeRight];
    //create block
    __weak typeof(self) weakSelf = self;
    self.callBackBlock = ^(NSDate *date, NSInteger swapIndex){
        if (swapIndex == 0) {
            [weakSelf handleSwipe:weakSelf.swipeRight];
        } else if (swapIndex == 2) {
            [weakSelf handleSwipe:weakSelf.swipeLeft];
        }
        if (weakSelf.delegate) {
            [weakSelf.delegate didSelectDate:date];
        }
    };
    [self addNewMonthView];
    [self addSubview:self.monthView];
}

-(void)handleSwipe:(UISwipeGestureRecognizer *)recognizer {
    //Animation
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    //Swipe handle
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        transition.subtype = kCATransitionFromLeft;
        self.monthDisplay = [self.monthView.month previousMonth];
    }
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        transition.subtype = kCATransitionFromRight;
        self.monthDisplay = [self.monthView.month nextMonth];
    }
    [self.layer addAnimation:transition forKey:nil];
    [self addNewMonthView];
    //remove subview
    for (UIView *view in self.subviews) {
        if (view != self.weekView && view != self.infoView) {
            [view removeFromSuperview];
        }
    }
    [self addSubview:self.monthView];
}

- (void)addNewMonthView {
    self.monthView = [[FMonthView alloc] initWithFrame:CGRectMake(0, self.bounds.origin.y + WEEKVIEW_HEIGHT + INFOVIEW_HEIGHT, self.bounds.size.width , self.bounds.size.height - WEEKVIEW_HEIGHT - INFOVIEW_HEIGHT) calendar:self.calendar showDayOff:self.showDayOff dayViewHeight:self.dayViewHeight];
    self.monthView.month = self.monthDisplay;
    self.lbInfor.text = [self.formatter stringFromDate:self.monthDisplay];
    [self.monthView createView];
    [self.monthView didSelectDateWithCompletion:self.callBackBlock];
}

@end
