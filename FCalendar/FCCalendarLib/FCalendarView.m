//
//  FCalendarView.m
//  FCalendar
//
//  Created by Thinh on 7/13/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import "FCalendarView.h"
#import "InfinityScrollView.h"

@interface FCalendarView ()
@property (strong, nonatomic) NSMutableArray *monthViews;
@end

@implementation FCalendarView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.frame = rect;
    [self initScrollView:rect];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self initScrollView:frame];
    }
    return self;
}

- (void)initScrollView:(CGRect)frame {
    self.monthViews = [[NSMutableArray alloc] init];
    //Create scrollview
    InfinityScrollView *scrollView = [[InfinityScrollView alloc] initWithFrame:frame];
    [scrollView setPagingEnabled:YES];
    [scrollView setScrollEnabled:YES];
    scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    scrollView.delegate = self;
    [scrollView setContentSize:CGSizeMake(frame.size.width * 3, frame.size.height)];
    [self addSubview:scrollView];
    /* Create 3 FmonthView */
    for (int i = 0; i < 3; i++) {
        FMonthView *view = [[FMonthView alloc] initWithFrame:CGRectMake(frame.size.width * i, 0, frame.size.width, frame.size.height)];
        [scrollView addSubview:view];
        //fake data
        [view setNumberOfCellForCollectionView:(i + 7)];
        [self.monthViews addObject:view];
    }
    //Set offset to center
    [scrollView setContentOffset:CGPointMake(frame.size.width, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    scrollView.userInteractionEnabled = YES;
    CGFloat currentOffsetX = [scrollView contentOffset].x;
    NSLog(@"current offset : %f",currentOffsetX);
    //Check current offset and swap view
    if (currentOffsetX == 0) {
        scrollView.userInteractionEnabled = NO;
        [self swapView:0 secondView:1];
    } else if (currentOffsetX == self.frame.size.width*2) {
        scrollView.userInteractionEnabled = NO;
        [self swapView:1 secondView:2];
    }
    [scrollView setContentOffset:CGPointMake(320, 0)];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //Check if scroll is animates or not to disable scroll
    if (scrollView.contentOffset.x == self.frame.size.width) {
        scrollView.userInteractionEnabled = YES;
    } else {
        scrollView.userInteractionEnabled = NO;
    }
}

- (void)swapView:(NSUInteger)firstIndex secondView:(NSUInteger)secondIndex {
    //Swap view
    FMonthView *view1 = ((FMonthView*)[self.monthViews objectAtIndex:firstIndex]);
    FMonthView *view2 = ((FMonthView*)[self.monthViews objectAtIndex:secondIndex]);
    CGRect currentFrame = view1.frame;
    view1.frame = view2.frame;
    view2.frame = currentFrame;
    [self.monthViews exchangeObjectAtIndex:firstIndex withObjectAtIndex:secondIndex];
}

@end
