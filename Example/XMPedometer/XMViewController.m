//
//  XMViewController.m
//  XMPedometer
//
//  Created by ixmwl on 05/06/2019.
//  Copyright (c) 2019 ixmwl. All rights reserved.
//

#import "XMViewController.h"
#import "XMPedometerManager.h"
@interface XMViewController ()
@property (weak, nonatomic) IBOutlet UITextView *pedometerDataTextView;

@end

@implementation XMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Do any additional setup after loading the view, typically from a nib.
    self.pedometerDataTextView.layer.borderWidth = 1;
    self.pedometerDataTextView.layer.borderColor = [UIColor greenColor].CGColor;
    self.pedometerDataTextView.layer.shadowOffset = CGSizeMake(-1, 1);
    self.pedometerDataTextView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.pedometerDataTextView.layer.shadowOpacity = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getDataFromPedometer {
    [[XMPedometerManager sharedManager] xm_startPedometerUpdatesFromTodayWithHandler:^(NSNumber * _Nonnull numberOfSteps, NSNumber * _Nonnull distance, NSError * _Nonnull error) {
        NSLog(@"从计步器获取数据 步数：%@, 距离：%@", numberOfSteps, distance);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.pedometerDataTextView.text = [NSString stringWithFormat:@"从计步器获取数据 步数：%@, 距离：%@", numberOfSteps, distance];
        });
        
    }];
}

- (void)getLatestSevenDatesDataFromPedometer {
    [[XMPedometerManager sharedManager] xm_queryPedometerDataForTheLatestSevenDaysWithHandler:^(NSArray<NSDictionary *> * _Nonnull infoArr, NSError * _Nonnull error) {
        NSLog(@"从计步器获取近七天数据: %@", infoArr);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.pedometerDataTextView.text = [NSString stringWithFormat:@"从计步器获取近七天数据: %@",infoArr];
        });
    }];
}

- (IBAction)getTodayData:(id)sender {
}
- (IBAction)getLatest7DaysData:(id)sender {
}

@end
