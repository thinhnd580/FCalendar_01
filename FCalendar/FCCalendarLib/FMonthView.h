//
//  FMonthView.h
//  FCalendar
//
//  Created by Thinh on 7/13/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCalendarView.h"

@interface FMonthView : UIView

@property (strong, nonatomic) NSCalendar *calendar;
@property (assign, nonatomic) CGFloat dayViewHeight;
@property (strong, nonatomic) NSDate *month;
@property (assign, nonatomic) BOOL showDayOff;
- (id)initWithCalendar:(NSCalendar*)calendar showDayOff:(BOOL)showDayOff dayViewHeight:(CGFloat)height;
- (void)didSelectDateWithCompletion:(void(^)(NSDate* dateSelected,NSInteger swapView))callBackBlock;
- (void)createView;
- (void)reloadDayView;
@end
