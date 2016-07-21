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
@property (weak, nonatomic) IBOutlet UIView *calView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    FCalendarView *calendar = [[FCalendarView alloc] initWithFrame:self.calView.bounds calendar:nil monthDisplay:nil dateSelected:[NSDate date] showDayOff:YES dayViewHeight:-1];
    calendar.delegate = self;
    [self.calView addSubview:calendar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
