//
//  ChartViewSMHistoryManage.h
//  Meum
//
//  Created by fanrong on 2017/11/27.
//  Copyright © 2017年 huangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Charts/Charts.h>
#import "TYBaseChartViewLayout.h"

@interface ChartViewSMHistoryChartViewLayout : TYBaseChartViewLayout

@property (nonatomic, assign) BOOL showMarkInt;
//type == 0 日，type==1 周, type = 2.月
- (void)configCombinedChartView:(CombinedChartView *)combinedChartView combinedChartData:(CombinedChartData *)combinedChartData type:(NSInteger)type complete:(void(^)(void))complete;

+ (CombinedChartData *)getHeartDayDataWithXArr:(NSArray *)xArr yArr:(NSArray *)yArr type:(NSInteger)type gradientColors:(NSArray<UIColor *> *)gradientColors;
@end
