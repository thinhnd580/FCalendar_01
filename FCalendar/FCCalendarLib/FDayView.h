//
//  FDayView.h
//  FCalendar
//
//  Created by Thinh on 7/21/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDayView : UIButton
@property (strong, nonatomic) UIView *subview;
- (void)showSubView:(BOOL)show;
@end
