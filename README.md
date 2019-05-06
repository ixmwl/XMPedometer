# XMPedometer

一个基于CMPedometer实现的计步器,可以统计当天或者近7天步数以及里程
CMPedometer可以统计某段时间内用户步数,距离信息,甚至计算用户爬了多少级楼梯
注:此处还有一点需要注意:就是请在info.plist文件中加入你要访问用户健康和运动信息的描述
     
     
     
```ruby
Privacy - Motion Usage Description
```
## Requirements

* iOS 8.0+

## Installation安装

* **手动安装**
    下载DEMO后,将子文件夹XMPedometer拖入到项目中, 导入头文件XMPedometerManager.h开始使用,无需依赖其他框架

* **Cocoapods安装**

    ```ruby
    pod 'XMPedometer'
    ```
## Usage使用

* 获取当天计步数据

    ```ruby
    [[XMPedometerManager sharedManager] xm_startPedometerUpdatesFromTodayWithHandler:^(NSNumber * _Nonnull numberOfSteps, NSNumber * _Nonnull distance, NSError * _Nonnull error) {
        NSLog(@"从计步器获取数据 步数：%@, 距离：%@", numberOfSteps, distance);            
    }];
    ```
* 获取近7天计步数据

    ```ruby
    [[XMPedometerManager sharedManager] xm_queryPedometerDataForTheLatestSevenDaysWithHandler:^(NSArray<NSDictionary *> * _Nonnull infoArr, NSError * _Nonnull error) {
        NSLog(@"从计步器获取近七天数据: %@", infoArr);
    }];
    ```

## Author

ixmwl, ixmwl510@163.com

## License

    XMPedometer is available under the MIT license. See the LICENSE file for more info.


