//
//  TYBaseChartViewLayout.h
//  Meum
//
//  Created by fanrong on 2017/12/1.
//  Copyright © 2017年 huangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Charts/Charts.h>
#import "NSMutableAttributedString+Attributes.h"

@interface TYBaseChartViewLayout : NSObject<IChartAxisValueFormatter>

@property (nonatomic, weak, readonly) ChartYAxis *leftAxis;

@property (nonatomic, weak, readonly) ChartYAxis *rightAxis;

@property (nonatomic, weak, readonly) ChartXAxis *xAxis;

@property (nonatomic, weak, readonly) ChartLegend *legend;

@property (nonatomic, weak, readonly) CombinedChartData *combinedChartData;

@property (nonatomic, weak, readonly) CombinedChartView *combinedChartView;

- (void)configCombinedChartView:(CombinedChartView *)combinedChartView combinedChartData:(CombinedChartData *)combinedChartData complete:(void(^)(void))complete;

- (void)configDrawOrder;
- (void)configContentOffset;
- (void)configXAxis;
- (void)configLeftAxis;
- (void)configRightAxis;
- (void)configLegend;
- (void)configChartDescription;
- (void)configMark;
- (void)configChartView;

@end
