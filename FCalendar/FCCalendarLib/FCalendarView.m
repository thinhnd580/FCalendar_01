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
@property (strong, nonatomic) FMonthView *monthViewNextMonth;
@property (strong, nonatomic) FMonthView *monthViewPreViousMonth;
@property (strong, nonatomic) UIButton *btnPreviousMonth;
@property (strong, nonatomic) UIButton *btnNextMonth;
@property (strong, nonatomic) WeekView *weekView;
@property (strong, nonatomic) UIView *infoView;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UILabel *lbInfor;
@property (strong, nonatomic) NSDateFormatter *formatter;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeLeft;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeRight;
@property (strong, nonatomic) NSMutableArray *monthViews;
@property (copy, nonatomic) void(^callBackBlock)(NSDate* dateSelected,NSInteger swapView);
@end

@implementation FCalendarView
#pragma mark - Init
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

- (void)setDataWithCalendar:(NSCalendar*)calendar monthDisplay:(NSDate*)month dateSelected:(NSDate*)date showDayOff:(BOOL)showDayOff dayViewHeight:(CGFloat)height {
    self.monthViews = [[NSMutableArray alloc] init];
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
    [self createUIWithFrame:self.bounds];
}

- (void)createUIWithFrame:(CGRect)frame {
    //Create Month Label
    self.infoView = [[UIView alloc] init];
    [self.infoView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.infoView setBackgroundColor:[UIColor yellowColor]];
    [self addSubview:self.infoView];
    // Contraint InfoView
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.infoView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.infoView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:INFOVIEW_HEIGHT]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.infoView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.infoView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    [self.infoView addSubview:self.lbInfor];
    [self.lbInfor setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.infoView addConstraint:[NSLayoutConstraint constraintWithItem:self.lbInfor attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.infoView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.infoView addConstraint:[NSLayoutConstraint constraintWithItem:self.lbInfor attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.infoView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self.infoView addConstraint:[NSLayoutConstraint constraintWithItem:self.lbInfor attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.infoView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    [self.infoView addConstraint:[NSLayoutConstraint constraintWithItem:self.lbInfor attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.infoView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
    //Create 2 button to change month
    //Button next month
    self.btnPreviousMonth = [[UIButton alloc] init];
    [self.btnPreviousMonth setTitle:@"<" forState:UIControlStateNormal];
    [self.btnPreviousMonth setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.btnPreviousMonth addTarget:self action:@selector(moveToPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
    //Button previous month
    self.btnNextMonth = [[UIButton alloc] init];
    [self.btnNextMonth setTitle:@">" forState:UIControlStateNormal];
    [self.btnNextMonth setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.btnNextMonth addTarget:self action:@selector(moveToNextMonth) forControlEvents:UIControlEventTouchUpInside];
    //Add 2 buttons
    [self.infoView addSubview:self.btnNextMonth];
    [self.infoView addSubview:self.btnPreviousMonth];
    [self.btnNextMonth setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.btnPreviousMonth setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.infoView addConstraint:[NSLayoutConstraint constraintWithItem:self.btnPreviousMonth attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.infoView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.infoView addConstraint:[NSLayoutConstraint constraintWithItem:self.btnPreviousMonth attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.infoView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self.infoView addConstraint:[NSLayoutConstraint constraintWithItem:self.btnPreviousMonth attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.infoView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    [self.btnPreviousMonth addConstraint:[NSLayoutConstraint constraintWithItem:self.btnPreviousMonth attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.btnPreviousMonth attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    [self.btnNextMonth setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.infoView addConstraint:[NSLayoutConstraint constraintWithItem:self.btnNextMonth attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.infoView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.infoView addConstraint:[NSLayoutConstraint constraintWithItem:self.btnNextMonth attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.infoView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self.infoView addConstraint:[NSLayoutConstraint constraintWithItem:self.btnNextMonth attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.infoView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
    [self.btnNextMonth addConstraint:[NSLayoutConstraint constraintWithItem:self.btnNextMonth attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.btnNextMonth attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    //Create WeekView
    self.weekView = [[WeekView alloc] init];
    [self.weekView setCurrentCalendar:self.calendar];
    [self addSubview:self.weekView];
    [self.weekView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.weekView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.infoView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.weekView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.infoView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.weekView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.infoView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
    [self.weekView addConstraint:[NSLayoutConstraint constraintWithItem:self.weekView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:WEEKVIEW_HEIGHT]];
    //Create main calendar
    [self addCalendarView];
}

- (void)addCalendarView {
    self.lbInfor.text = [self.formatter stringFromDate:self.monthDisplay];
    //Swipe Recognize
    self.swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    self.swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    // Setting the swipe direction.
    [self.swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    //Pan Recognizer
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handelPan:)];
    [panRecognizer setMaximumNumberOfTouches:1];
    [self addGestureRecognizer:panRecognizer];
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
    CGRect frame = self.containerView.bounds;
    //create containerView
    self.containerView = [[UIView alloc] init];
    [self.containerView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.containerView];
    [self.containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.weekView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    //Create 3 Monthview for reuse
    for (NSUInteger i=0; i<3; i++) {
        FMonthView *monthView = [[FMonthView alloc] initWithCalendar:self.calendar showDayOff:self.showDayOff dayViewHeight:self.dayViewHeight];
        switch (i) {
            case 0:
                monthView.month = [self.monthDisplay previousMonth];
                frame.origin.x = -(frame.size.width);
                break;
            case 1:
                monthView.month = self.monthDisplay;
                frame.origin.x = 0;
                break;
            case 2:
                monthView.month = [self.monthDisplay nextMonth];
                frame.origin.x = frame.size.width;
                break;
            default:
                break;
        }
        //Layout container view
        [self.containerView addSubview:monthView];
        [monthView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:monthView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:monthView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
        [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:monthView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
        [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:monthView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
        monthView.frame = frame;
        [self.containerView layoutSubviews];
        [monthView createView];
        [self.monthViews addObject:monthView];
        [monthView didSelectDateWithCompletion:^(NSDate *dateSelected, NSInteger swapView) {
            [self reloadMonthView];
            if (swapView == 0) {
                [self moveToPreviousMonth];
            }
            if (swapView == 2) {
                [self moveToNextMonth];
            }
            if ([self.delegate respondsToSelector:@selector(didSelectDate:)]) {
                [self.delegate didSelectDate:dateSelected];
            }
        }];
    }
    [self setMonthViewPositionWithTranslate:CGPointMake(0, 0)];
    self.monthView = ((FMonthView*)[self.monthViews objectAtIndex:1]);
}

#pragma mark - Swipe handler
- (void)handelPan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translate = [recognizer translationInView:self];
    [self setMonthViewPositionWithTranslate:translate];
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (self.monthView.frame.origin.x > (self.bounds.size.width / 3) || ([recognizer velocityInView:self].x > 600.0)) {
            [self handleSwipe:self.swipeRight];
        } else if (self.monthView.frame.origin.x < -(self.bounds.size.width / 3)  || ([recognizer velocityInView:self].x < (-600.0))) {
            [self handleSwipe:self.swipeLeft];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                [self setMonthViewPositionWithTranslate:CGPointMake(0, 0)];
            }];
        }
    }
}

-(void)handleSwipe:(UISwipeGestureRecognizer *)recognizer {
    NSUInteger index;
    FMonthView *monthViewRemain;
    CGRect firstFrame;
    CGRect secondFrame;
    CGRect monthViewRemainFrame;
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        self.monthDisplay = [self.monthDisplay previousMonth];
        index = 0;
        monthViewRemain = [self.monthViews objectAtIndex:2];
        monthViewRemainFrame = firstFrame = CGRectMake(self.containerView.bounds.size.width, 0, self.containerView.bounds.size.width, self.containerView.bounds.size.height);
        secondFrame = CGRectMake(-self.containerView.bounds.size.width, 0, self.containerView.bounds.size.width, self.containerView.bounds.size.height);
    } else {
        self.monthDisplay = [self.monthDisplay nextMonth];
        index = 2;
        monthViewRemain = [self.monthViews objectAtIndex:0];
        monthViewRemainFrame = firstFrame = CGRectMake(-self.containerView.bounds.size.width, 0, self.containerView.bounds.size.width, self.containerView.bounds.size.height);
        secondFrame = CGRectMake(self.containerView.bounds.size.width, 0, self.containerView.bounds.size.width, self.containerView.bounds.size.height);
    }
    self.lbInfor.text = [self.formatter stringFromDate:self.monthDisplay];
    [UIView animateWithDuration:0.2 animations:^{
        [self.btnNextMonth setUserInteractionEnabled:NO];
        [self.btnPreviousMonth setUserInteractionEnabled:NO];
        FMonthView *monthViewWillReplace = (FMonthView*)[self.monthViews objectAtIndex:index];
        monthViewWillReplace.frame = self.containerView.bounds;
        self.monthView.frame = firstFrame;
        monthViewRemain.frame = monthViewRemainFrame;
    } completion:^(BOOL finished) {
        self.monthView.frame = secondFrame;
        self.monthView = (FMonthView*)([self.monthViews objectAtIndex:index]);
        [self.monthViews exchangeObjectAtIndex:index withObjectAtIndex:1];
        [self reloadMonthView];
        [self.btnNextMonth setUserInteractionEnabled:YES];
        [self.btnPreviousMonth setUserInteractionEnabled:YES];
    }];
    if ([self.delegate respondsToSelector:@selector(didScrollToMonth:)]) {
        // The object does implement the method, so you can safely call it.
        [self.delegate didScrollToMonth:self.monthDisplay];
    }
}

#pragma mark - Call to change MonthView
- (void)moveToNextMonth {
    [self handleSwipe:self.swipeLeft];
}
- (void)moveToPreviousMonth {
    [self handleSwipe:self.swipeRight];
}

- (void)reloadMonthView {
    FMonthView *preMonthView = [self.monthViews objectAtIndex:0];
    FMonthView *nextMonthView = [self.monthViews objectAtIndex:2];
    preMonthView.month = [self.monthDisplay previousMonth];
    nextMonthView.month = [self.monthDisplay nextMonth];
    [preMonthView reloadDayView];
    [nextMonthView reloadDayView];
//    [self setMonthViewPositionWithTranslate:CGPointMake(0, 0)];
}

- (void)setMonthViewPositionWithTranslate:(CGPoint)translate {
    // index 0 is first monthview
    // indeo 2 is last monthview
    CGRect frame = self.monthView.frame;
    frame.origin.x = translate.x;
    self.monthView.frame = frame;
    CGRect frame0 = self.containerView.bounds;
    CGRect frame2 = self.containerView.bounds;
    frame0.origin.x = -(self.bounds.size.width) + translate.x;
    frame2.origin.x = self.bounds.size.width + translate.x;
    ((FMonthView*)[self.monthViews objectAtIndex:2]).frame = frame2;
    ((FMonthView*)[self.monthViews objectAtIndex:0]).frame = frame0;
}

@end
