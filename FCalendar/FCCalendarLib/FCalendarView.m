//
//  FCalendarView.m
//  FCalendar
//
//  Created by Thinh on 7/13/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import "FCalendarView.h"
#import "InfinityScrollView.h"
#import "FDateUtility.h"
#import "WeekView.h"

@interface FCalendarView ()
@property (strong, nonatomic) NSMutableArray *monthViews;
@property (strong, nonatomic) InfinityScrollView *scrollView;
@property (strong, nonatomic) NSDateFormatter *monthFormatter;
@end

@implementation FCalendarView
#pragma mark - Init
- (void)drawRect:(CGRect)rect {
    [self createUIWithFrame:rect];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUIWithFrame:frame];
    }
    return self;
}

- (void)createUIWithFrame:(CGRect)frame {
    [self initData];
    //Create WeekView
    WeekView *weekView = [[WeekView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, WEEKVIEW_HEIGHT)];
    [weekView setBackgroundColor:[UIColor blueColor]];
    [weekView setCurrentCalendar:self.calendar];
    [self addSubview:weekView];
    //Create Scroll View
    [self initScrollView:CGRectMake(0, frame.origin.y + WEEKVIEW_HEIGHT, frame.size.width, frame.size.height - WEEKVIEW_HEIGHT)];
}

- (void)initData {
    self.monthViews = [[NSMutableArray alloc] init];
    //Create calendar
    if (!self.calendarIndentifier) {
        self.calendar = [NSCalendar currentCalendar];
    } else {
        self.calendar = [NSCalendar calendarWithIdentifier:self.calendarIndentifier];
    }
    if (!self.monthDisplay) {
        self.monthDisplay = [NSDate date];
    }
    self.monthFormatter = [[NSDateFormatter alloc] init];
    [self.monthFormatter setDateFormat:@"MM/yyyy"];
    self.calendar.firstWeekday = 2;
}

- (void)initScrollView:(CGRect)frame {
    //Create scrollview
    self.scrollView = [[InfinityScrollView alloc] initWithFrame:frame];
    [self.scrollView setPagingEnabled:YES];
    self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.scrollView.delegate = self;
    [self.scrollView setContentSize:CGSizeMake(frame.size.width * 3, frame.size.height)];
    [self addSubview:self.scrollView];
    /* Create 3 FmonthView */
    for (int i = 0; i < 3; i++) {
        FMonthView *view = [[FMonthView alloc] initWithFrame:CGRectMake(frame.size.width * i, 0, frame.size.width, frame.size.height)];
        view.calendar = self.calendar;
        switch (i) {
            case 0:
                [view setMonthDisplay:[self.monthDisplay previousMonth]];
                break;
            case 1:
                [view setMonthDisplay:self.monthDisplay];
                break;
            default:
                [view setMonthDisplay:[self.monthDisplay nextMonth]];
                break;
        }
        [self.scrollView addSubview:view];
        //fake data
        [self.monthViews addObject:view];
    }
    //Set offset to center
    [self.scrollView setContentOffset:CGPointMake(frame.size.width, 0) animated:YES];
}
#pragma mark - Change month
- (void)goToMonth:(NSDate*)month {
    //Later
}
- (void)goToNextMonth {
    [self swapCurrentViewWithViewAtIndex:2];
}

- (void)goToPreviousMonth {
    [self swapCurrentViewWithViewAtIndex:0];
}

#pragma mark - Scroll View Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    scrollView.userInteractionEnabled = YES;
    CGFloat currentOffsetX = [scrollView contentOffset].x;
    //Check current offset and swap view
    if (currentOffsetX == 0) {
        [self goToPreviousMonth];
    } else if (currentOffsetX == self.frame.size.width*2) {
        [self goToNextMonth];
    }
    [scrollView setContentOffset:CGPointMake(self.frame.size.width, 0)];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //Check if scroll is animates or not to disable scroll
    scrollView.userInteractionEnabled = (scrollView.contentOffset.x == self.frame.size.width) ? YES : NO;
}

#pragma mark - Swap Month View
- (void)swapCurrentViewWithViewAtIndex:(NSUInteger)index {
    self.scrollView.userInteractionEnabled = NO;
    //Swap view
    FMonthView *view1 = ((FMonthView*)[self.monthViews objectAtIndex:1]);
    FMonthView *view2 = ((FMonthView*)[self.monthViews objectAtIndex:index]);
    FMonthView *view3;
    CGRect currentFrame = view1.frame;
    //Change frame
    view1.frame = view2.frame;
    view2.frame = currentFrame;
    if (index > 1) { // If swipe to right
        view1.month = [view2.month nextMonth];
        [view1 drawDate];
        view3 = ((FMonthView*)[self.monthViews objectAtIndex:0]);
        view3.month = [view2.month previousMonth];
    } else { // If swipe to left
        view1.month = [view2.month previousMonth];
        [view1 drawDate];
        view3 = ((FMonthView*)[self.monthViews objectAtIndex:2]);
        view3.month = [view2.month nextMonth];
    }
    [view3 drawDate];
    [self.monthViews exchangeObjectAtIndex:1 withObjectAtIndex:index];
    NSLog(@"CUrrent month %@:",[self.monthFormatter stringFromDate:((FMonthView*)[self.monthViews objectAtIndex:1]).month]);
}

@end
