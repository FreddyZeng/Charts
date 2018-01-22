//
//  ChartViewHeartManage.h
//  Meum
//
//  Created by fanrong on 2017/11/3.
//  Copyright © 2017年 huangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Charts/Charts.h>
#import "TYBaseChartViewLayout.h"

typedef NS_ENUM(NSInteger, ChartViewHeartTimeType) {
    ChartViewHeartDay = 0,
    ChartViewHeartWeek,
    ChartViewHeartMonth
};

@interface ChartViewHeartManage : TYBaseChartViewLayout
    
- (void)configCombinedChartView:(CombinedChartView *)combinedChartView combinedChartData:(CombinedChartData *)combinedChartData type:(ChartViewHeartTimeType)type complete:(void(^)(void))complete;
    
@end
