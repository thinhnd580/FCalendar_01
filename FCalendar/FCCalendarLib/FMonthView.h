//
//  FMonthView.h
//  FCalendar
//
//  Created by Thinh on 7/13/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCalendarView.h"

@interface FMonthView : UIView <UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionViewCalendar;
@property (strong, nonatomic) NSCalendar *calendar;
@property (strong, nonatomic) NSDate *month;
- (void)setMonthDisplay:(NSDate*)month;
- (void)drawDate;

@end
