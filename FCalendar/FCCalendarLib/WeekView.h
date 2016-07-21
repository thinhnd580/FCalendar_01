//
//  WeekView.h
//  FCalendar
//
//  Created by Thinh on 7/19/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCalendarView.h"

@interface WeekView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionViewWeek;
@property (strong, nonatomic) NSCalendar *calendar;
@property (strong, nonatomic) NSMutableArray *arrWeekDayString;
-(void)setCurrentCalendar:(NSCalendar*)calendar;

@end
