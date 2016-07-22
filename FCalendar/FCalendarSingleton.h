//
//  FCalendarSingleton.h
//  FCalendar
//
//  Created by Thinh on 7/20/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCalendarSingleton : NSObject
@property (strong, nonatomic) NSDate *dateSelected;
+ (id)sharedInstance;
@end
