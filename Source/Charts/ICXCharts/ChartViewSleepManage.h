//
//  ChartViewSleepManage.h
//  Meum
//
//  Created by fanrong on 2017/11/3.
//  Copyright © 2017年 huangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYBaseChartViewLayout.h"
#import <Charts/Charts.h>

typedef NS_ENUM(NSInteger, ChartViewSleepTimeType) {
    ChartViewSleepDay = 0,
    ChartViewSleepWeek,
    ChartViewSleepMonth
};

@interface ChartViewSleepManage : TYBaseChartViewLayout
    
- (void)configCombinedChartView:(CombinedChartView *)combinedChartView combinedChartData:(CombinedChartData *)combinedChartData type:(ChartViewSleepTimeType)type complete:(void(^)(void))complete;
    
@end
