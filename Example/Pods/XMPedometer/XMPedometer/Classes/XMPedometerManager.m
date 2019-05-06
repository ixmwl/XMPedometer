//
//  BIMPedometerManager.m
//  StepDemo
//
//  Created by 刘灿 on 2019/4/30.
//  Copyright © 2019 Epoint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "XMPedometerManager.h"
#define kCustomErrorDomain @"com.github.ixmwl"

kPedometerIdentier const kPedometerIdentifierIndex = @"kPedometerIdentifierIndex";
kPedometerIdentier const kPedometerIdentifierNumberOfSteps = @"kPedometerIdentifierNumberOfSteps";
kPedometerIdentier const kPedometerIdentifierDistance = @"kPedometerIdentifierDistance";
kPedometerIdentier const kPedometerIdentifierDate = @"kPedometerIdentifierDate";


#pragma mark - 计步管理工具类
@interface XMPedometerManager ()

@property (nonatomic, strong) CMPedometer *pedometer;

@end

@implementation XMPedometerManager

static XMPedometerManager *instance = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XMPedometerManager alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [super allocWithZone:zone];
        });
    }
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([CMPedometer isPaceAvailable]) {
            /// 创建计步器对象
            self.pedometer = [[CMPedometer alloc] init];
        }
    }
    return self;
}


- (void)xm_startPedometerUpdatesFromTodayWithHandler:(void(^)(NSNumber *numberOfSteps, NSNumber *distance, NSError *error))handler {
    [self xm_startPedometerUpdatesFromDate:[NSDate getTodayStartDate] withHandler:handler];
}

- (void)xm_startPedometerUpdatesFromDate:(NSDate *)fromDate withHandler:(void (^)(NSNumber *numberOfSteps, NSNumber *distance, NSError *error))handler {
    if (!self.pedometer) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"device does not support"};
        NSError *error = [[NSError alloc] initWithDomain:kCustomErrorDomain code:-666 userInfo:userInfo];
        handler(nil, nil, error);
        return;
    }
    [self.pedometer startPedometerUpdatesFromDate:fromDate withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
        if (handler) {
            if (error) {
                handler(nil, nil, error);
            } else {
                handler(pedometerData.numberOfSteps, @([pedometerData.distance integerValue] / 1000.0), nil);
            }
        }
    }];
}

- (void)xm_queryPedometerDataForTheLatestSevenDaysWithHandler:(void(^)(NSArray<NSDictionary *> * infoArr, NSError *error))handler {
    [self xm_queryPedometerDataBeforeTodayWithIndex:7 withHandler:handler];
}

- (void)xm_queryPedometerDataBeforeTodayWithIndex:(NSInteger)index withHandler:(void (^)(NSArray<NSDictionary *> *infoArr, NSError *error))handler {
    if (index <= 0) {
        return;
    }
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i < index; i++) {
        if (i == 0) {
            [self xm_queryPedometerDataFromDate:[NSDate getTodayStartDate] toDate:[NSDate date] withHandler:^(NSNumber *numberOfSteps, NSNumber *distance, NSError *error) {
                if (error) {
                    if (handler) {
                        handler(nil, error);
                    }
                } else {
                    NSDictionary *infoDict = @{kPedometerIdentifierIndex : @(i), kPedometerIdentifierNumberOfSteps : numberOfSteps, kPedometerIdentifierDistance : distance, kPedometerIdentifierDate : [NSDate nowDateAtZoneWithDate:[NSDate getTodayStartDate]]};
                    [arr addObject:infoDict];
                }
            }];
        } else {
            [self xm_queryPedometerDataFromDate:[NSDate getDateBeforeTodayAtIndex:i] toDate:[NSDate getDateBeforeTodayAtIndex:i-1] withHandler:^(NSNumber *numberOfSteps, NSNumber *distance, NSError *error) {
                if (error) {
                    if (handler) {
                        handler(nil, error);
                    }
                } else {
                    NSDictionary *infoDict = @{kPedometerIdentifierIndex : @(i), kPedometerIdentifierNumberOfSteps : numberOfSteps, kPedometerIdentifierDistance : distance, kPedometerIdentifierDate : [NSDate nowDateAtZoneWithDate:[NSDate getDateBeforeTodayAtIndex:i]]};
                    [arr addObject:infoDict];
                }
                if (arr.count == index) {
                    if (handler) {
                        handler(arr, nil);
                    }
                }
            }];
        }
    }
    
}

- (void)xm_queryPedometerDataFromDate:(NSDate *)start toDate:(NSDate *)end withHandler:(void(^)(NSNumber *numberOfSteps, NSNumber *distance, NSError *error))handler {
    if (!self.pedometer) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"device does not support"};
        NSError *error = [[NSError alloc] initWithDomain:kCustomErrorDomain code:-666 userInfo:userInfo];
        handler(nil, nil, error);
        return;
    }
    [self.pedometer queryPedometerDataFromDate:start toDate:end withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
        if (handler) {
            if (error) {
                handler(nil, nil, error);
            } else {
                handler(pedometerData.numberOfSteps, @([pedometerData.distance integerValue] / 1000.0), nil);
            }
        }
    }];
}


@end


#pragma mark - 时间管理工具
@implementation NSDate (BIMTool)
/// 获取今天凌晨0点时间
+ (NSDate *)getTodayStartDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *tDate = [dateFormatter dateFromString:dateStr];
    return tDate;
}

/// 获取距离前几天的凌晨0点时间
+ (NSDate *)getDateBeforeTodayAtIndex:(NSInteger)index {
    return [[NSDate alloc] initWithTimeInterval:(-60 * 60 * 24 * index) sinceDate:[self getTodayStartDate]];
}

/// 去除时差
+ (NSDate *)nowDateAtZoneWithDate:(NSDate *)date {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    return [date dateByAddingTimeInterval:interval];
}
@end
