//
//  FDateUtility.m
//  FCalendar
//
//  Created by Thinh on 7/15/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import "FDateUtility.h"

@implementation NSDate (NextAndPreviousDate)

- (NSDate*)nextMonth {
    NSCalendar *cal = [NSCalendar currentCalendar];
    return [cal dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:self options:0];
}

- (NSDate*)previousMonth {
    NSCalendar *cal = [NSCalendar currentCalendar];
    return [cal dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:self options:0];
}

- (NSUInteger)numberOfDayInMonth {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange dayRange = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return dayRange.length;
}

- (BOOL)inSameMonthWithDate:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    if ([[formatter stringFromDate:self] isEqualToString:[formatter stringFromDate:date]]) {
        return YES;
    }
    return NO;
}

@end
