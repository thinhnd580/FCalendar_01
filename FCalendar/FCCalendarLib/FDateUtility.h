//
//  FDateUtility.h
//  FCalendar
//
//  Created by Thinh on 7/15/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (NextAndPreviousDate)

- (NSDate*)nextMonth;
- (NSDate*)previousMonth;
- (NSUInteger)numberOfDayInMonth;
- (BOOL)inSameMonthWithDate:(NSDate*)date;
- (BOOL)isEqualWithDate:(NSDate*)date;

@end
