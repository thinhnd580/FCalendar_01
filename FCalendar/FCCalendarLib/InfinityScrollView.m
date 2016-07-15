//
//  InfinityScrollView.m
//  FCalendar
//
//  Created by Thinh on 7/14/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import "InfinityScrollView.h"

@implementation InfinityScrollView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setShowsHorizontalScrollIndicator:NO];
    }
    return self;
}

@end
