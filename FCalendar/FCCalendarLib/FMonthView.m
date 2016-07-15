//
//  FMonthView.m
//  FCalendar
//
//  Created by Thinh on 7/13/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import "FMonthView.h"

@interface FMonthView ()
@property (assign, nonatomic) int numberOfCell;
@end

@implementation FMonthView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //init code
        self.numberOfCell = 0;
        //Create collection view flow layout
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(frame.size.width / 7.0 - 5.0, frame.size.height / 5.0 - 3.0);
        flowLayout.minimumInteritemSpacing = 5.0;
        flowLayout.minimumLineSpacing = 3.0;
        // create collectionview
        self.collectionViewCalendar = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        [self addSubview:self.collectionViewCalendar];
        self.collectionViewCalendar.backgroundColor = [UIColor whiteColor];
        [self.collectionViewCalendar registerClass:UICollectionViewCell.self forCellWithReuseIdentifier:@"DayCell"];
        self.collectionViewCalendar.delegate = self;
        self.collectionViewCalendar.dataSource = self;
    }
    return self;
}

#pragma CollectionView implementation
- (void)setNumberOfCellForCollectionView:(int)numberOfCell {
    self.numberOfCell = numberOfCell;
    [self.collectionViewCalendar reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberOfCell;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionViewCalendar dequeueReusableCellWithReuseIdentifier:@"DayCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor grayColor];
    //Add label
    UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
    label.text = [NSString stringWithFormat:@"%d",indexPath.row];
    [cell.contentView addSubview:label];
    return cell;
}

@end
