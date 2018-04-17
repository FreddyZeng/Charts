//
//  TYBloodRealTimeChartViewLayout.m
//  Meum
//
//  Created by fanrong on 2017/12/1.
//  Copyright © 2017年 huangwei. All rights reserved.
//

#import "TYBloodRealTimeChartViewLayout.h"
#import "TYUIKitDemo-Swift.h"
#import "TYCalendarManage.h"
#import "DateTools.h"

//国际化
#define ICXLocalize(key)                NSLocalizedString(key, nil)

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface TYBloodRealTimeChartViewLayout()<IChartAxisValueFormatter>

@property (nonatomic, assign) NSDate *beginDate;

@end

@implementation TYBloodRealTimeChartViewLayout

- (void)configDrawOrder {
    self.combinedChartView.drawOrder = @[
                                         @(CombinedChartDrawOrderLine)
                                         ];
}
- (void)configContentOffset {
    [self.combinedChartView setViewPortOffsetsWithLeft:46 top:18 right:54 bottom:50];
}
- (void)configXAxis {
    [super configXAxis];
    self.xAxis.labelTextColor = UIColorFromRGB(0xA1A7B5);
    self.xAxis.labelFont = [UIFont systemFontOfSize:11];
    self.xAxis.valueFormatter = self; // 设置X轴的label格式配置delegate方法
    self.xAxis.yOffset = 24;// 设置y偏移
    self.xAxis.axisMinimum = self.combinedChartData.xMin;// 设置X轴最小值
    self.xAxis.axisMaximum = self.combinedChartData.xMax;// 设置X轴最大值
    self.xAxis.enabled = YES;
    self.xAxis.drawLabelsEnabled = YES;
    self.xAxis.drawGridLinesEnabled = YES;
    self.xAxis.gridColor = UIColorFromRGB(0x374562);
    [self.xAxis setLabelCount:5 force:YES];// 是否设置强制渲染label个数
}
- (void)configLeftAxis {
    [super configLeftAxis];
    self.leftAxis.valueFormatter = self;// 设置
    ChartLimitLine *limitLine = [[ChartLimitLine alloc] initWithLimit:7.9];// 创建极限线位置
    limitLine.lineWidth = 1.0;// 极限线宽度
    limitLine.lineBottomSpaceColor = [UIColor clearColor];// 极限线底部区域颜色
    limitLine.lineDashLengths = @[@(1),@(0),@(1)];// 极限线虚线
    limitLine.lineColor = UIColorFromRGB(0xFE6A78 );// 极限线颜色
    ChartLimitLine *limitLine2 = [[ChartLimitLine alloc] initWithLimit:3.9];
    limitLine2.lineWidth = 1.0;
    limitLine2.lineBottomSpaceColor = [UIColor clearColor];
    limitLine2.lineDashLengths = @[@(1),@(0),@(1)];
    limitLine2.lineColor = UIColorFromRGB(0xF5A623);
    [self.leftAxis addLimitLine:limitLine];
    [self.leftAxis addLimitLine:limitLine2];
    
    self.leftAxis.granularity = 1;// 轴的间隙
    self.leftAxis.lineLastSpace = 100;// 轴最后的延长线
    self.leftAxis.axisMaximum = 21;// 轴的最大值
    self.leftAxis.axisMinimum = 0;// 轴的最小值
    self.leftAxis.enabled = YES;
    self.leftAxis.xOffset = 10; // 水平偏移
    self.leftAxis.labelFont = [UIFont systemFontOfSize:11];// label字体
    [self.leftAxis setLabelCount:22 force:YES]; // 强制渲染label个数
    self.leftAxis.labelTextColor = UIColorFromRGB(0xA1A7B5);// label的颜色
    
    self.leftAxis.drawZeroLineEnabled = NO;
    self.leftAxis.drawGridLinesEnabled = NO;
}

- (void)configLegend {
    self.legend.enabled = NO;
}

- (void)configChartView {
    [super configChartView];
    self.combinedChartView.noDataText =ICXLocalize(@"XFit_DataShow_noData");
    self.combinedChartView.noDataFont = [UIFont fontWithName:@"PingFangSC-Regular" size:19];
    self.combinedChartView.noDataTextColor =  [UIColor colorWithRed:132/255.0 green:139/255.0 blue:158/255.0 alpha:1/1.0];
    
    self.combinedChartView.pinchZoomEnabled = YES;
    self.combinedChartView.scaleXEnabled = YES;
    self.combinedChartView.scaleYEnabled = YES;
}

- (void)configMark {
    if (self.noMark) {
        return;
    }
    if (self.combinedChartView.marker) {
        return;
    }
    TYMarkerView *marker = [[TYMarkerView alloc]
                            initWithColor: UIColorFromRGB(0x3B5471)
                            font: [UIFont systemFontOfSize:10.0]
                            textColor: UIColorFromRGB(0xffffff)
                            insets: UIEdgeInsetsMake(5.0, 4, 10.0, 4)];
    marker.delegate = self;
    marker.chartView = self.combinedChartView;
    self.combinedChartView.marker = marker;
}

- (NSAttributedString *)tyMarkerViewRefreshContentAttStringWithMark:(TYMarkerView *)mark entry:(ChartDataEntry *)entry highlight:(ChartHighlight *)highlight {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:entry.x];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[date formattedDateWithFormat:@"HH:mm"]];
    NSMutableAttributedString *nString = [[NSMutableAttributedString alloc] initWithString:@"\n"];
    [attString appendAttributedString:nString];
    
    NSMutableAttributedString *yString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f",entry.y]];
    [attString appendAttributedString:yString];
    [attString addFont:[UIFont systemFontOfSize:11] substring:attString.string];
    [attString addColor:[UIColor whiteColor] substring:attString.string];
    [attString addAlignment:NSTextAlignmentCenter substring:attString.string];
    return attString;
}

- (NSString * _Nonnull)stringForValue:(double)value axis:(ChartAxisBase * _Nullable)axis {
    if ([axis isKindOfClass:[ChartXAxis class]]) {
        // 返回X轴的label内容
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:value];
        NSString *dateString = [date formattedDateWithFormat:@"HH:mm"];
        
        if ([dateString isEqualToString:@"00:00"]) {
            if ([date isEqualToDate:self.beginDate]) {
                return @"00:00";
            }else {
                return @"24:00";
            }
        }
        return dateString;
    }else {
        // 返回Y轴的label内容
        NSInteger y = (NSInteger)value;
        if (![@[@(3),@(9),@(15),@(21)] containsObject:@(y)]) {
            return @"";
        }
        return [NSString stringWithFormat:@"%li",y];
    }
    return @"";
}



- (CombinedChartData *)getDayDataWithRedXArr:(NSArray *)RedXArr RedYArr:(NSArray *)RedYArr blueXArr:(NSArray *)blueXArr blueYArr:(NSArray *)blueYArr greenXArr:(NSArray *)greenXArr greenYArr:(NSArray *)greenYArr {
    NSMutableArray *values1 = [[NSMutableArray alloc] init];
    NSMutableArray *values2 = [[NSMutableArray alloc] init];
    NSMutableArray *values3 = [[NSMutableArray alloc] init];
    
    
    for (NSInteger i = 0; i < RedXArr.count; ++i) {
        [values1 addObject:[[ChartDataEntry alloc] initWithX:[RedXArr[i] doubleValue] y:[RedYArr[i] doubleValue]]];
    }
    for (NSInteger i = 0; i < blueXArr.count; ++i) {
        [values2 addObject:[[ChartDataEntry alloc] initWithX:[blueXArr[i] doubleValue] y:[blueYArr[i] doubleValue]]];
    }
    for (NSInteger i = 0; i < greenXArr.count; ++i) {
        [values3 addObject:[[ChartDataEntry alloc] initWithX:[greenXArr[i] doubleValue] y:[greenYArr[i] doubleValue]]];
    }
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithValues:values1 label:@"red"];
    
    set1.drawIconsEnabled = NO;
    set1.drawValuesEnabled = NO;
    set1.highlightEnabled = YES;
    
    set1.lineWidth = 0.0;
    set1.drawCirclesEnabled = YES;
    set1.circleRadius = 3.0;
    set1.circleColors = @[UIColorFromRGB(0xFE6A78)];
    set1.drawCircleHoleEnabled = NO;
    set1.drawHorizontalHighlightIndicatorEnabled = NO;
    set1.drawVerticalHighlightIndicatorEnabled = NO;
    
    LineChartDataSet *set2 = [[LineChartDataSet alloc] initWithValues:values2 label:@"blue"];
    
    set2.drawIconsEnabled = NO;
    set2.drawValuesEnabled = NO;
    set2.highlightEnabled = YES;
    
    set2.lineWidth = 0.0;
    set2.drawCirclesEnabled = YES;
    set2.circleRadius = 3.0;
    set2.circleColors = @[UIColorFromRGB(0x74D669)];
    set2.drawCircleHoleEnabled = NO;
    set2.drawHorizontalHighlightIndicatorEnabled = NO;
    set2.drawVerticalHighlightIndicatorEnabled = NO;
    
    LineChartDataSet *set3 = [[LineChartDataSet alloc] initWithValues:values3 label:@"green"];
    
    set3.drawIconsEnabled = NO;
    set3.drawValuesEnabled = NO;
    set3.highlightEnabled = YES;
    
    set3.lineWidth = 0.0;
    set3.drawCirclesEnabled = YES;
    set3.circleRadius = 3.0;
    set3.circleColors = @[UIColorFromRGB(0xF5A623)];
    set3.drawCircleHoleEnabled = NO;
    set3.drawHorizontalHighlightIndicatorEnabled = NO;
    set3.drawVerticalHighlightIndicatorEnabled = NO;
    
    double timeStamp = [RedXArr.firstObject doubleValue];
    
    if (RedXArr.count > 0) {
        timeStamp = [RedXArr.firstObject doubleValue];
    }else if (greenXArr.count > 0) {
        timeStamp = [greenXArr.firstObject doubleValue];
    }else {
        timeStamp = [blueXArr.firstObject doubleValue];
    }
    NSDate *curDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    
    // 显示日期
    LineChartDataSet *timeSet = nil;
    NSDate *dayBengin = [[TYCalendarManage shareManage] converDateToDayBegin:curDate];
    
    NSMutableArray *timeValues = [[NSMutableArray alloc] init];
    
    [timeValues addObject:[[ChartDataEntry alloc] initWithX:[dayBengin timeIntervalSince1970] y:0.0]];
    [timeValues addObject:[[ChartDataEntry alloc] initWithX:[[dayBengin dateByAddingHours:6] timeIntervalSince1970] y:3.0]];
    [timeValues addObject:[[ChartDataEntry alloc] initWithX:[[dayBengin dateByAddingHours:12] timeIntervalSince1970] y:3.0]];
    [timeValues addObject:[[ChartDataEntry alloc] initWithX:[[dayBengin dateByAddingHours:18] timeIntervalSince1970] y:3.0]];
    [timeValues addObject:[[ChartDataEntry alloc] initWithX:[[dayBengin dateByAddingHours:24] timeIntervalSince1970] y:21.0]];
    
    self.beginDate = dayBengin;
    
    timeSet = [[LineChartDataSet alloc] initWithValues:timeValues label:@"timeSet"];
    
    timeSet.highlightEnabled = NO;
    timeSet.lineWidth = 0.0;
    timeSet.drawCirclesEnabled = NO;
    timeSet.drawValuesEnabled = NO;
    
    CombinedChartData *data = [[CombinedChartData alloc] init];
    data.lineData = [[LineChartData alloc] initWithDataSets:@[set1,set2,set3,timeSet]];
    return data;
}
@end
