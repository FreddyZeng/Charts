//
//  ChartViewSportManage.h
//  Meum
//
//  Created by fanrong on 2017/11/2.
//  Copyright © 2017年 huangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYBaseChartViewLayout.h"

typedef NS_ENUM(NSInteger, ChartViewSportTimeType) {
    ChartViewSportDay = 0,
    ChartViewSportWeek,
    ChartViewSportMonth
};

@interface ChartViewSportManage : TYBaseChartViewLayout

- (void)configCombinedChartView:(CombinedChartView *)combinedChartView combinedChartData:(CombinedChartData *)combinedChartData type:(ChartViewSportTimeType)type complete:(void(^)(void))complete;
@end
