//
//  DayCell.m
//  FCalendar
//
//  Created by Thinh on 7/15/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import "DayCell.h"

@implementation DayCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lbDayNumber = [[UILabel alloc] initWithFrame:self.bounds];
        [self.lbDayNumber setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.lbDayNumber];
    }
    return self;
}

@end
