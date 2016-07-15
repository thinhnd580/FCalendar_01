//
//  FMonthView.h
//  FCalendar
//
//  Created by Thinh on 7/13/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMonthView : UIView <UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionViewCalendar;
- (void)setNumberOfCellForCollectionView:(int)numberOfCell;

@end
