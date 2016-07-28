//
//  WeekCell.m
//  FCalendar
//
//  Created by Thinh on 7/19/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import "WeekCell.h"

@implementation WeekCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lbDayNumber = [[UILabel alloc] init];
        
        [self addSubview:self.lbDayNumber];
        [self.lbDayNumber setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lbDayNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lbDayNumber attribute: NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lbDayNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lbDayNumber attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
        
        [self.lbDayNumber setTextColor:[UIColor whiteColor]];
        [self.lbDayNumber setBackgroundColor:[UIColor blueColor]];
        [self.lbDayNumber setTextAlignment:NSTextAlignmentCenter];
        
    }
    return self;
}
@end
