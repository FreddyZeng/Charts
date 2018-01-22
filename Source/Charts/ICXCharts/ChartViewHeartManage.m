//
//  ChartViewHeartManage.m
//  Meum
//
//  Created by fanrong on 2017/11/3.
//  Copyright © 2017年 huangwei. All rights reserved.
//

#import "ChartViewHeartManage.h"
#import "TYUIKitDemo-Swift.h"
#import <Foundation/Foundation.h>
#import "DateTools.h"

//国际化
#define ICXLocalize(key)                NSLocalizedString(key, nil)

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]//国际化

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB_A(rgbValue, a)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]


static ChartViewHeartManage *share = nil;

@interface ChartViewHeartManage()<ChartViewDelegate>
    
@property (nonatomic, assign) ChartViewHeartTimeType type;

@property (nonatomic, weak) ChartYAxis *leftAxis;

@property (nonatomic, weak) ChartYAxis *rightAxis;

@property (nonatomic, weak) ChartXAxis *xAxis;

@property (nonatomic, weak) CombinedChartData *combinedChartData;

@property (nonatomic, weak) CombinedChartView *combinedChartView;
@end

@implementation ChartViewHeartManage

- (void)configCombinedChartView:(CombinedChartView *)combinedChartView combinedChartData:(CombinedChartData *)combinedChartData type:(ChartViewHeartTimeType)type complete:(void(^)(void))complete {
    self.type = type;
    [super configCombinedChartView:combinedChartView combinedChartData:combinedChartData complete:complete];
}


- (void)configLegend {
    self.combinedChartView.legend.enabled = YES;
    ChartLegendEntry *maxHeart = [[ChartLegendEntry alloc] initWithLabel:ICXLocalize(@"Band_MaximumHeartRate") form:ChartLegendFormSquare formSize:10.0 formLineWidth:0.0 formLineDashPhase:0.0 formLineDashLengths:nil formColor:UIColorFromRGB(0x74D669)];
    ChartLegendEntry *minHeart = [[ChartLegendEntry alloc] initWithLabel:ICXLocalize(@"Band_MinimumHeartRate") form:ChartLegendFormSquare formSize:10.0 formLineWidth:0.0 formLineDashPhase:0.0 formLineDashLengths:nil formColor:UIColorFromRGB(0xFEA66A)];
    
    [self.combinedChartView.legend setCustomWithEntries:@[maxHeart, minHeart]];
    [self.combinedChartView.legend setPosition:ChartLegendPositionAboveChartCenter];
    self.combinedChartView.legend.textColor = UIColorFromRGB_A(0xffffff,0.62);
    self.combinedChartView.legend.font = [UIFont systemFontOfSize:12];
    self.combinedChartView.legend.xOffset = -10;
    
    if (self.type == ChartViewHeartDay) {
        self.combinedChartView.legend.xOffset = -8;
        maxHeart.formColor = [UIColor clearColor];
        minHeart.formColor = [UIColor clearColor];
        
        maxHeart.label = [NSString stringWithFormat:ICXLocalize(@"Band_BigmumHeartRate%li"), (NSInteger)self.combinedChartData.lineData.yMax];
        minHeart.label = [NSString stringWithFormat:ICXLocalize(@"Band_SmallmumHeartRate%li"), (NSInteger)self.combinedChartData.lineData.yMin];
        self.combinedChartView.legend.textColor = [UIColor whiteColor];
        minHeart.formSize = 0.0;
        maxHeart.formSize = 0.0;
    }
}

- (void)configDrawOrder {
    
    switch (self.type) {
        case ChartViewHeartMonth:
        case ChartViewHeartWeek:
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
        case ChartViewHeartDay:
        case ChartViewHeartWeek:
            [self.combinedChartView setViewPortOffsetsWithLeft:34 top:32 right:21 bottom:36];
            break;
            
        default:
            [self.combinedChartView setViewPortOffsetsWithLeft:34 top:32 right:21 bottom:36];
            break;
    }
}

- (void)configXAxis {
    self.xAxis.enabled = YES;
    self.xAxis.valueFormatter = self;
    switch (self.type) {
        case ChartViewHeartMonth:
        {
            self.xAxis.axisMaximum = self.combinedChartData.barData.entryCount + 0.345;
            self.xAxis.axisMinimum = -0.345;
            self.xAxis.labelFont = [UIFont systemFontOfSize:8];
            self.xAxis.labelCount = self.xAxis.axisMaximum - self.xAxis.axisMinimum;
            self.xAxis.yOffset = 9;
        }
            break;
        case ChartViewHeartWeek:
        {
            self.xAxis.axisMaximum = 6.345;
            self.xAxis.axisMinimum = -0.345;
            self.xAxis.labelFont = [UIFont systemFontOfSize:12];
            self.xAxis.labelCount = self.xAxis.axisMaximum - self.xAxis.axisMinimum;
            self.xAxis.yOffset = 10;
        }
            break;
        default:
        {
            [self.xAxis resetCustomAxisMin];
            [self.xAxis resetCustomAxisMax];
            self.xAxis.labelCount = self.xAxis.axisMaximum - self.xAxis.axisMinimum;
            self.xAxis.labelFont = [UIFont systemFontOfSize:12];
            self.xAxis.yOffset = 10;
        }
            break;
    }
}

- (void)configLeftAxis {
    self.leftAxis.spaceTop = 5;
    self.leftAxis.enabled = YES;
    [self.leftAxis setLabelCount:3 force:YES];
    self.leftAxis.labelFont = [UIFont systemFontOfSize:11];
    self.leftAxis.valueFormatter = self;
    
    switch (self.type) {
        case ChartViewHeartMonth:
        {
            self.leftAxis.axisMinimum = 0;
            self.leftAxis.axisMaximum = self.combinedChartData.barData.yMax;
        }
            break;
        case ChartViewHeartWeek:
        {
            self.leftAxis.axisMinimum = 0;
            self.leftAxis.axisMaximum = self.combinedChartData.barData.yMax;
        }
            break;
        default:
        {
            self.leftAxis.axisMinimum = (NSInteger)self.combinedChartData.lineData.yMin - 5;
            self.leftAxis.axisMaximum = (NSInteger)self.combinedChartData.lineData.yMax + 5;
        }
            break;
    }
}

- (void)configRightAxis {
    self.rightAxis.enabled = NO;
}

- (NSString * _Nonnull)stringForValue:(double)value axis:(ChartAxisBase * _Nullable)axis {
    if ([axis isKindOfClass:[ChartXAxis class]]) {
        switch (self.type) {
            case ChartViewHeartMonth:
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
            case ChartViewHeartWeek:
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
            {
                return @"";
            }
        }
    }else {
      return  [NSString stringWithFormat:@"%ld",(NSInteger)value];
    }
}

- (void)configChartView {
    [super configChartView];
    self.combinedChartView.noDataText = ICXLocalize(@"Band_YouDon'tHaveAnyHeartRateData");
    self.combinedChartView.noDataFont = [UIFont systemFontOfSize:14];
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
