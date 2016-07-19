//
//  FMonthView.m
//  FCalendar
//
//  Created by Thinh on 7/13/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import "FMonthView.h"
#import "DayCell.h"
#import "FDateUtility.h"

@interface FMonthView ()
@property (strong, nonatomic) NSMutableArray *arrDays;
@property (strong, nonatomic) NSDateFormatter *formatter;
@property (strong, nonatomic) NSDateFormatter *formatterMonth;
@end

@implementation FMonthView

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //init code
        self.arrDays = [[NSMutableArray alloc] init];
        [self addCollectionViewWithFrame:frame];
    }
    return self;
}

- (void)addCollectionViewWithFrame:(CGRect)frame {
    //Create collection view flow layout
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(frame.size.width / 7.0 - (SPACE_VALUE * 3), frame.size.height / 5.0 - SPACE_VALUE);
    flowLayout.minimumInteritemSpacing = SPACE_VALUE;
    flowLayout.minimumLineSpacing = SPACE_VALUE;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, SPACE_VALUE, 0, SPACE_VALUE);
    // create collectionview
    self.collectionViewCalendar = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    [self addSubview:self.collectionViewCalendar];
    self.collectionViewCalendar.backgroundColor = [UIColor whiteColor];
    [self.collectionViewCalendar registerClass:DayCell.self forCellWithReuseIdentifier:@"DayCell"];
    self.collectionViewCalendar.delegate = self;
    self.collectionViewCalendar.dataSource = self;
}

- (void)drawDate {
    //Set DateFormatter
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"dd/MM/yyyy"];
    //Create datecompoment of firstday in month
    NSDateComponents *firstDayInMonthComp = [self.calendar components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:self.month];
    [firstDayInMonthComp setDay:1];
    //Get NSDate form first day in month compoment above
    NSDate *firstDayInMonthDate  = [self.calendar dateFromComponents:firstDayInMonthComp];
    //Get first weekday in month to caculate day start in current calendar
    NSInteger firstWeekDayInMonth = [self.calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayInMonthDate];
    //day start in current calendar
    NSDate *beginDateInCurrentCalendar =  [firstDayInMonthDate dateByAddingTimeInterval:-(86400 * (firstWeekDayInMonth - 1))];
    //Add day to Array
    [self.arrDays removeAllObjects];
    for (NSInteger i = 0; i<36; i++) {
        NSDate *date = [beginDateInCurrentCalendar dateByAddingTimeInterval:(86400 * i)];
        [self.arrDays addObject:date];
    }
    [self.formatter setDateFormat:@"dd"];
    //Reload Collection View
    [self.collectionViewCalendar reloadData];
}

- (void)setMonthDisplay:(NSDate*)month {
    self.month = month;
    [self drawDate];
}

#pragma mark - CollectionView implementation
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 35;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DayCell *cell = [self.collectionViewCalendar dequeueReusableCellWithReuseIdentifier:@"DayCell" forIndexPath:indexPath];
    NSDate *date = (NSDate*)[self.arrDays objectAtIndex:indexPath.row];
    cell.lbDayNumber.text = [self.formatter stringFromDate:date];
    if (![self.month inSameMonthWithDate:date]) {
        [cell.lbDayNumber setTextColor:[UIColor grayColor]];
    } else {
        [cell.lbDayNumber setTextColor:[UIColor blackColor]];
    }
    return cell;
}

@end
