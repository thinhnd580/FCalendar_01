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

- (BOOL)isEqualWithDate :(NSDate*)date {
    if (date == nil) {
        return NO;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    if ([[formatter stringFromDate:self] isEqualToString:[formatter stringFromDate:date]]) {
        return YES;
    }
    return NO;
}

+ (NSDate*)dateBeginningOfMonth:(NSDate*)month inCalendar:(NSCalendar*)calendar {
    //Create datecompoment of firstday in month
    NSDateComponents *firstDayInMonthComp = [calendar components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:month];
    [firstDayInMonthComp setDay:1];
    //Get NSDate form first day in month compoment above
    NSDate *firstDayInMonthDate  = [NSDate firstDateInMonth:month];
    //Get first weekday in month to caculate day start in current calendar
    NSInteger firstWeekDayInMonth = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayInMonthDate];
    //day start in current calendar
    NSDate *beginDateInCurrentCalendar = [firstDayInMonthDate dateByAddingTimeInterval:-(86400 * (firstWeekDayInMonth - 1))];
    return beginDateInCurrentCalendar;
}

+ (NSDate*)firstDateInMonth:(NSDate*)month {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    NSString *monthStr = [formatter stringFromDate:month];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearStr = [formatter stringFromDate:month];
    [formatter setDateFormat:@"yyyy/dd/MM"];
    return [formatter dateFromString:[NSString stringWithFormat:@"%@/1/%@",yearStr,monthStr]];
}

@end
