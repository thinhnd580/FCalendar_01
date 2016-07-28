//
//  ViewController.m
//  FCalendar
//
//  Created by Thinh on 7/13/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import "ViewController.h"
#import "FCalendarView.h"
#import "FDateUtility.h"

@interface ViewController () <FCalendarDelegate>
@property (weak, nonatomic) IBOutlet FCalendarView *calView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.calView setDataWithCalendar:nil monthDisplay:[NSDate date] dateSelected:nil showDayOff:YES dayViewHeight:-1];
    self.calView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Calendar delegate
- (void)didSelectDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSLog(@"Date Selected : %@",[formatter stringFromDate:date]);
}

@end
