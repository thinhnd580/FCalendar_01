//
//  FCalendarView.h
//  FCalendar
//
//  Created by Thinh on 7/13/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMonthView.h"
#import "FCalendarSingleton.h"

//Change This value to custom calendar
#define INFOVIEW_HEIGHT 40.0
#define WEEKVIEW_HEIGHT 25.0
#define SPACE_VALUE 0.25

@protocol FCalendarDelegate <NSObject>
- (void)didSelectDate:(NSDate*)date;
- (void)didScrollToMonth:(NSDate*)date;
@end

@interface FCalendarView : UIView <UIScrollViewDelegate>

@property (assign, nonatomic) CGFloat dayViewHeight;
@property (strong, nonatomic) NSCalendar *calendar;
@property (strong, nonatomic) NSDate *monthDisplay;
@property (strong, nonatomic) NSDate *dateSelected;
@property (assign, nonatomic) BOOL showDayOff;
@property (weak, nonatomic) id<FCalendarDelegate> delegate;
- (id)initWithFrame:(CGRect)frame calendar:(NSCalendar*)calendar monthDisplay:(NSDate*)month dateSelected:(NSDate*)date showDayOff:(BOOL)showDayOff dayViewHeight:(CGFloat)height;
- (void)moveToNextMonth;
- (void)moveToPreviousMonth;

@end
