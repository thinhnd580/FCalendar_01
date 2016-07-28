//
//  FDayView.m
//  FCalendar
//
//  Created by Thinh on 7/21/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import "FDayView.h"

@implementation FDayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData {
    [self setBackgroundColor:[UIColor whiteColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(2, 2, 0, 0)];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.layer setBorderColor:[UIColor redColor].CGColor];
    //CreateSubView
    self.subview = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height *2 / 3, self.bounds.size.width - 5, self.bounds.size.height / 3)];
    [self.subview setBackgroundColor:[UIColor blueColor]];
    [self addSubview:self.subview];
    [self.subview setHidden:YES];
}

- (void)showSubView:(BOOL)show {
    [self.subview setHidden:(show ? NO : YES)];
}

@end
