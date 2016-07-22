//
//  WeekView.m
//  FCalendar
//
//  Created by Thinh on 7/19/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import "WeekView.h"
#import "WeekCell.h"

@implementation WeekView

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData:frame];
    }
    return self;
}

- (void)initData:(CGRect)frame {
    self.arrWeekDayString = [[NSMutableArray alloc] init];
    //Create collection view flow layout
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((frame.size.width / 7.0) - (SPACE_VALUE * 2), frame.size.height);
    flowLayout.minimumInteritemSpacing = SPACE_VALUE;
    flowLayout.minimumLineSpacing = SPACE_VALUE;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, SPACE_VALUE, 0, SPACE_VALUE);
    //Create collectionview
    self.collectionViewWeek = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    [self.collectionViewWeek registerClass:UICollectionViewCell.self forCellWithReuseIdentifier:@"WeekCell"];
    [self.collectionViewWeek setBackgroundColor:[UIColor yellowColor]];
    [self addSubview:self.collectionViewWeek];
    self.collectionViewWeek.dataSource = self;
    self.collectionViewWeek.delegate = self;
}

-(void)setCurrentCalendar:(NSCalendar*)calendar {
    self.calendar = calendar;
    [self.arrWeekDayString removeAllObjects];
    //Create datecompoment of firstday in month
    NSDateComponents *firstDayInMonthComp = [self.calendar components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:[NSDate date]];
    [firstDayInMonthComp setDay:1];
    //Get NSDate form first day in month compoment above
    NSDate *firstDayInMonthDate  = [self.calendar dateFromComponents:firstDayInMonthComp];
    NSInteger firstWeekDayInMonth = [self.calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayInMonthDate];
    //day start in current calendar
    NSDate *beginDateInCurrentCalendar =  [firstDayInMonthDate dateByAddingTimeInterval:-(86400 * (firstWeekDayInMonth - 1))];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"EEE"];
    for (int i = 0; i < 7; i++) {
        NSDate *date = [beginDateInCurrentCalendar dateByAddingTimeInterval:(86400 * i)];
        [self.arrWeekDayString addObject:[formatter stringFromDate:date]];
    }
    [self.collectionViewWeek reloadData];
}

#pragma mark - CollectionView implementation
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WeekCell *cell = (WeekCell*)[self.collectionViewWeek dequeueReusableCellWithReuseIdentifier:@"WeekCell" forIndexPath:indexPath];
    //Add label
    UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.text = [self.arrWeekDayString objectAtIndex:indexPath.row];
    [cell addSubview:label];
    return cell;
}

@end
