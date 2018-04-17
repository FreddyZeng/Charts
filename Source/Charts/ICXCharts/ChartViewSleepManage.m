//
//  ChartViewSleepManage.m
//  Meum
//
//  Created by fanrong on 2017/11/3.
//  Copyright © 2017年 huangwei. All rights reserved.
//

#import "ChartViewSleepManage.h"

//国际化
#define ICXLocalize(key)                NSLocalizedString(key, nil)

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB_A(rgbValue, a)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

static ChartViewSleepManage *share = nil;

@interface ChartViewSleepManage()
    
@property (nonatomic, assign) ChartViewSleepTimeType type;

@property (nonatomic, weak) ChartYAxis *leftAxis;

@property (nonatomic, weak) ChartYAxis *rightAxis;

@property (nonatomic, weak) ChartXAxis *xAxis;

@property (nonatomic, weak) CombinedChartData *combinedChartData;

@property (nonatomic, weak) CombinedChartView *combinedChartView;
@end

@implementation ChartViewSleepManage


- (void)configCombinedChartView:(CombinedChartView *)combinedChartView combinedChartData:(CombinedChartData *)combinedChartData type:(ChartViewSleepTimeType)type complete:(void(^)(void))complete {
    self.type = type;
    [super configCombinedChartView:combinedChartView combinedChartData:combinedChartData complete:complete];
}

- (void)configLegend {
        self.combinedChartView.legend.enabled = YES;
        ChartLegendEntry *deepSleep = [[ChartLegendEntry alloc] initWithLabel:ICXLocalize(@"Band_DeepSleep") form:ChartLegendFormSquare formSize:10.0 formLineWidth:0.0 formLineDashPhase:0.0 formLineDashLengths:nil formColor:UIColorFromRGB(0x2AA9F7)];
        ChartLegendEntry *lightSleep = [[ChartLegendEntry alloc] initWithLabel:ICXLocalize(@"Band_LightSleep") form:ChartLegendFormSquare formSize:10.0 formLineWidth:0.0 formLineDashPhase:0.0 formLineDashLengths:nil formColor:UIColorFromRGB(0x374562)];
        ChartLegendEntry *sober = [[ChartLegendEntry alloc] initWithLabel:ICXLocalize(@"Band_Sober") form:ChartLegendFormSquare formSize:10.0 formLineWidth:0.0 formLineDashPhase:0.0 formLineDashLengths:nil formColor:UIColorFromRGB(0xFE6A78)];
        
        [self.combinedChartView.legend setCustomWithEntries:@[deepSleep, lightSleep, sober]];
        [self.combinedChartView.legend setPosition:ChartLegendPositionAboveChartCenter];
        self.combinedChartView.legend.textColor = UIColorFromRGB_A(0xffffff,0.62);
        self.combinedChartView.legend.font = [UIFont systemFontOfSize:12];
        self.combinedChartView.legend.xOffset = -10;
}

- (void)configDrawOrder {
    
    switch (self.type) {
        case ChartViewSleepMonth:
        case ChartViewSleepWeek:
        {
            self.combinedChartView.drawOrder = @[
                                                 @(CombinedChartDrawOrderBar)
                                                 ];
        }
            break;
        default:
        {
            self.combinedChartView.drawOrder = @[
                                                 @(CombinedChartDrawOrderLine)
                                                 ];
        }
            break;
    }
}

- (void)configContentOffset {
    switch (self.type) {
        case ChartViewSleepMonth:
        {
            [self.combinedChartView setViewPortOffsetsWithLeft:21 top:32 right:21 bottom:36];
        }
            break;
        case ChartViewSleepWeek:
            [self.combinedChartView setViewPortOffsetsWithLeft:41 top:32 right:40 bottom:36];
            break;
        default:
        {
            [self.combinedChartView setViewPortOffsetsWithLeft:15 top:25 right:15 bottom:36];
        }
            break;
    }
}

- (void)configXAxis {
    self.xAxis.enabled = YES;
    self.xAxis.valueFormatter = self;
    switch (self.type) {
        case ChartViewSleepMonth:
        {
            self.xAxis.axisMaximum = self.combinedChartData.barData.entryCount - 1 + 0.125;
            self.xAxis.axisMinimum = -0.125;
            self.xAxis.labelFont = [UIFont systemFontOfSize:8];
            self.xAxis.labelCount = self.xAxis.axisMaximum - self.xAxis.axisMinimum;
            self.xAxis.yOffset = 9;
        }
            break;
        case ChartViewSleepWeek:
        {
            self.xAxis.axisMaximum = 6.125;
            self.xAxis.axisMinimum = -0.125;
            self.xAxis.labelFont = [UIFont systemFontOfSize:12];
            self.xAxis.labelCount = self.xAxis.axisMaximum - self.xAxis.axisMinimum;
            self.xAxis.yOffset = 10;
        }
            break;
        default:
        {
            self.xAxis.axisMaximum = self.combinedChartData.lineData.xMax;
            self.xAxis.axisMinimum = self.combinedChartData.lineData.xMin;
            self.xAxis.labelFont = [UIFont systemFontOfSize:12];
            self.xAxis.labelCount = self.xAxis.axisMaximum - self.xAxis.axisMinimum;
            self.xAxis.yOffset = 10;
        }
            break;
    }
}

- (void)configLeftAxis {
    self.leftAxis.spaceTop = 5;
    self.leftAxis.enabled = NO;
    if (self.type == 0) {
        self.leftAxis.enabled = YES;
        self.leftAxis.axisMaximum = 100;
        self.leftAxis.axisMinimum = 0;
        self.leftAxis.drawLabelsEnabled = NO;
        self.leftAxis.drawGridLinesEnabled = NO;
    }else {
        self.leftAxis.axisMaximum = self.combinedChartData.yMax;
        self.leftAxis.axisMinimum = 0;
    }
}

- (void)configRightAxis {
    self.rightAxis.enabled = NO;
}

- (NSString * _Nonnull)stringForValue:(double)value axis:(ChartAxisBase * _Nullable)axis {
    switch (self.type) {
        case ChartViewSleepMonth:
        {
            NSInteger index = @(value).integerValue;
            if (index % 2 == 1) {
                return @"";
            }
            if (index <= self.combinedChartData.barData.entryCount - 1 && index >= 0) {
                return [NSString stringWithFormat:@"%02ld",(long)index + 1];
            }
            return @"";
        }
        case ChartViewSleepWeek:
            switch (@(value).integerValue) {
                case 0:
                    return @"MON";
                    break;
                case 1:
                    return @"TUE";
                    break;
                case 2:
                    return @"WED";
                    break;
                case 3:
                    return @"THR";
                    break;
                case 4:
                    return @"FRI";
                    break;
                case 5:
                    return @"SAT";
                    break;
                case 6:
                    return @"SUN";
                    break;
                default:
                    break;
            }
            return @"";
        default:
            if (value == self.xAxis.axisMinValue) {
                return @"";
            }else if (value == self.xAxis.axisMaximum) {
                return @"";
            }
            return @"";
    }
}

- (void)configChartView {
    [super configChartView];
    self.combinedChartView.noDataText = ICXLocalize(@"Band_YouDon'tHaveAnySleepData");
    self.combinedChartView.noDataFont = [UIFont systemFontOfSize:14];
    [self.combinedChartView setHighlightFullBarEnabled:YES];
}

- (void)configMark {
    [super configMark];
    TYMarkerView *marker = [[TYMarkerView alloc]
                            initWithColor: UIColorFromRGB(0xffffff)
                            font: [UIFont systemFontOfSize:10.0]
                            textColor: UIColorFromRGB(0x34353B)
                            insets: UIEdgeInsetsMake(5.0, 4, 10.0, 4)];
    marker.chartView = self.combinedChartView;
    marker.minimumSize = CGSizeMake(32.f, 19.f);
    marker.offset = CGPointMake(0, -3);
    marker.arrowSize = CGSizeMake(10, 6);
    self.combinedChartView.marker = marker;
}
    
@end
