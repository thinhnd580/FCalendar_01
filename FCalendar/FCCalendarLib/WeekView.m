//
//  WeekView.m
//  FCalendar
//
//  Created by Thinh on 7/19/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import "WeekView.h"
#import "WeekCell.h"
#import "FDateUtility.h"

@implementation WeekView

#pragma mark - Init
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

- (void)layoutSubviews {
    NSLog(@"asdas");
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.collectionViewWeek.collectionViewLayout;
    if (flowLayout) {
        flowLayout.itemSize = CGSizeMake(((self.bounds.size.width - (SPACE_VALUE *2)) / 7.0) - SPACE_VALUE * 2, self.bounds.size.height);
    }
}

- (void)initData {
    self.arrWeekDayString = [[NSMutableArray alloc] init];
    //Create collection view flow layout
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, SPACE_VALUE, 0, SPACE_VALUE);
    //Create collectionview
    self.collectionViewWeek = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    [self.collectionViewWeek setBackgroundColor:[UIColor greenColor]];
    [self addSubview:self.collectionViewWeek];
    //Contraint
    [self.collectionViewWeek setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionViewWeek attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionViewWeek attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionViewWeek attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionViewWeek attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
    flowLayout.minimumInteritemSpacing = SPACE_VALUE;
    [self.collectionViewWeek registerClass:WeekCell.self forCellWithReuseIdentifier:@"WeekCell"];
    self.collectionViewWeek.dataSource = self;
    self.collectionViewWeek.delegate = self;
}

-(void)setCurrentCalendar:(NSCalendar*)calendar {
    self.calendar = calendar;
    [self.arrWeekDayString removeAllObjects];
    //day start in current calendar
    NSDate *beginDateInCurrentCalendar =  [NSDate dateBeginningOfMonth:[NSDate date] inCalendar:self.calendar];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"EE"];
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
    cell.lbDayNumber.text = [self.arrWeekDayString objectAtIndex:indexPath.row];
    return cell;
}

@end
