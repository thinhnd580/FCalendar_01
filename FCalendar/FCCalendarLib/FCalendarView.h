//
//  FCalendarView.h
//  FCalendar
//
//  Created by Thinh on 7/13/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMonthView.h"

#define WEEKVIEW_HEIGHT 25.0
#define SPACE_VALUE 3.0

@interface FCalendarView : UIView <UIScrollViewDelegate>

@property (strong, nonatomic) NSCalendar *calendar;
@property (strong, nonatomic) NSDate *monthDisplay;
@property (strong, nonatomic) NSString *calendarIndentifier;

@end
