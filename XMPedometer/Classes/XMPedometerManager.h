/**
 * 作者：刘灿
 * 创建时间：2019/04/30 09:35
 * 版本：[1.0, 2019/04/30]
 * 版权：iXMWL
 * 描述：获取计步数据
 */

#import <Foundation/Foundation.h>


#pragma mark - 常量申明
#if !defined(__cplusplus)
#define BIM_EXTERN extern __attribute__((visibility("default")))
#else
#define BIM_EXTERN extern "C" __attribute__((visibility("default")))
#endif

typedef NSString * kPedometerIdentier;

BIM_EXTERN kPedometerIdentier const kPedometerIdentifierIndex;
BIM_EXTERN kPedometerIdentier const kPedometerIdentifierNumberOfSteps;
BIM_EXTERN kPedometerIdentier const kPedometerIdentifierDistance;
BIM_EXTERN kPedometerIdentier const kPedometerIdentifierDate;




#pragma mark - PedometerManager 管理工具

@interface XMPedometerManager : NSObject
/**
 单例方法，使用时注意增加在info.plist文件中NSMotionUsageDescription key
 
 @return XMPedometerManager
 */
+ (instancetype)sharedManager;

#pragma mark - 数据动态更新
/**
 从今日零点开始计步, 返回步数和里程

 @param handler handler 回调行走步数，行走公里，如果有错误，会回调错误信息, 如果设备不支持计步，会返回错误码-666，否则error为nil 数据回调在子线程
 */
- (void)xm_startPedometerUpdatesFromTodayWithHandler:(void(^)(NSNumber *numberOfSteps, NSNumber *distance, NSError *error))handler;


/*!
 * 从某一时间开始计步, 返回步数和里程
 * @param fromDate 计步开始时间
 * @param handler 回调行走步数，行走公里，如果有错误，会回调错误信息，如果设备不支持计步，会返回错误码-666，否则error为nil 数据回调在子线程
 */

/**
 从某一时间开始计步, 返回步数和里程

 @param fromDate 计步开始时间
 @param handler 回调行走步数，行走公里，如果有错误，会回调错误信息，如果设备不支持计步，会返回错误码-666，否则error为nil 数据回调在子线程
 */
- (void)xm_startPedometerUpdatesFromDate:(NSDate *)fromDate
                             withHandler:(void (^)(NSNumber *numberOfSteps, NSNumber *distance, NSError *error))handler;

#pragma mark - 查询数据


/**
 查询前七天数据

 @param handler 回调前七天数据数组，数组中的元素为字典，包含距离今天的时间下标，行走步数，行走公里，如果有错误，会回调错误信息，如果设备不支持计步，会返回错误码-666，否则error为nil 数据回调在子线程
 */
- (void)xm_queryPedometerDataForTheLatestSevenDaysWithHandler:(void(^)(NSArray<NSDictionary *> * infoArr, NSError *error))handler;

/**
 查询前几天数据

 @param index 注意: index > 7后数据数据数据不准确，规定只能查询七天内的数据
 @param handler 回调前几天数据数组，数组中的元素为字典，包含距离今天的时间下标，行走步数，行走公里，如果有错误，会回调错误信息，如果设备不支持计步，会返回错误码-666，否则error为nil 数据回调在子线程
 */
- (void)xm_queryPedometerDataBeforeTodayWithIndex:(NSInteger)index
                                      withHandler:(void (^)(NSArray<NSDictionary *> *infoArr, NSError *error))handler;

/**
 查询某个时间段的数据

 @param start 开始时间
 @param end 结束时间
 @param handler 回调行走步数，行走公里，如果有错误，会回调错误信息，如果设备不支持计步，会返回错误码-666，否则error为nil 数据回调在子线程
 */
- (void)xm_queryPedometerDataFromDate:(NSDate *)start
                               toDate:(NSDate *)end
                          withHandler:(void(^)(NSNumber *numberOfSteps, NSNumber *distance, NSError *error))handler;

@end


#pragma mark - 时间工具类
@interface NSDate (XMTool)
/**
 获取今天凌晨0点时间
 
 @return date
 */
+ (NSDate *)getTodayStartDate;


/**
 获取距离前几天的凌晨0点时间
 
 @param index 前几天
 @return date
 */
+ (NSDate *)getDateBeforeTodayAtIndex:(NSInteger)index;


/**
 去除时差
 
 @param date 时间
 @return date
 */
+ (NSDate *)nowDateAtZoneWithDate:(NSDate *)date;

@end


