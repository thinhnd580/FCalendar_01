//
//  FCalendarView.h
//  FCalendar
//
//  Created by Thinh on 7/13/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMonthView.h"

@interface FCalendarView : UIView <UIScrollViewDelegate>

@property (assign, nonatomic) CGRect frame;
@property (assign, nonatomic) CGRect frameForMonthView;
@property (strong, nonatomic) FMonthView *displayedMonthView;

@end
