//
//  ChartViewSportManage.m
//  Meum
//
//  Created by fanrong on 2017/11/2.
//  Copyright © 2017年 huangwei. All rights reserved.
//

#import "ChartViewSportManage.h"

//国际化
#define ICXLocalize(key)                NSLocalizedString(key, nil)

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static ChartViewSportManage *share = nil;

@interface ChartViewSportManage()

@property (nonatomic, assign) ChartViewSportTimeType type;

@property (nonatomic, weak) ChartYAxis *leftAxis;

@property (nonatomic, weak) ChartYAxis *rightAxis;

@property (nonatomic, weak) ChartXAxis *xAxis;

@property (nonatomic, weak) CombinedChartData *combinedChartData;

@property (nonatomic, weak) CombinedChartView *combinedChartView;

@property (nonatomic, weak) ChartLegend *legend;

@end

@implementation ChartViewSportManage

- (void)configCombinedChartView:(CombinedChartView *)combinedChartView combinedChartData:(CombinedChartData *)combinedChartData type:(ChartViewSportTimeType)type complete:(void(^)(void))complete {
    self.type = type;
    [self configCombinedChartView:combinedChartView combinedChartData:combinedChartData complete:complete];
}

- (void)configLegend {
    self.combinedChartView.legend.enabled = NO;
}

- (void)configDrawOrder {
    self.combinedChartView.drawOrder = @[
                                         @(CombinedChartDrawOrderBar)
                                         ];
}

- (void)configContentOffset {
    switch (self.type) {
        case ChartViewSportMonth:
        {
            [self.combinedChartView setViewPortOffsetsWithLeft:38 top:15 right:12 bottom:36];
        }
            break;
        case ChartViewSportWeek:
        default:
        {
            [self.combinedChartView setViewPortOffsetsWithLeft:38 top:15 right:26 bottom:36];
        }
            break;
    }
}

- (void)configXAxis {
    self.xAxis.enabled = YES;
    self.xAxis.valueFormatter = self;
    switch (self.type) {
        case ChartViewSportMonth:
        {
            self.xAxis.axisMaximum = self.combinedChartData.barData.entryCount - 0.5;
            self.xAxis.axisMinimum = -0.5;
            self.xAxis.labelFont = [UIFont systemFontOfSize:8];
            self.xAxis.labelCount = self.xAxis.axisMaximum - self.xAxis.axisMinimum;
            self.xAxis.yOffset = 9;
        }
            break;
        case ChartViewSportWeek:
        {
            self.xAxis.axisMaximum = 6.5;
            self.xAxis.axisMinimum = -0.5;
            self.xAxis.labelFont = [UIFont systemFontOfSize:12];
            self.xAxis.labelCount = self.xAxis.axisMaximum - self.xAxis.axisMinimum;
            self.xAxis.yOffset = 10;
        }
            break;
        default:
        {
            self.xAxis.axisMaximum = 24;
            self.xAxis.axisMinimum = -1;
            self.xAxis.labelFont = [UIFont systemFontOfSize:12];
            self.xAxis.labelCount = 24;
            self.xAxis.yOffset = 10;
        }
            break;
    }
}

- (void)configLeftAxis {
    self.leftAxis.enabled = YES;
    [self.leftAxis setLabelCount:3 force:YES];
    self.leftAxis.labelFont = [UIFont systemFontOfSize:11];
    self.leftAxis.valueFormatter = self;
    self.leftAxis.spaceTop = 5;
    switch (self.type) {
        case ChartViewSportMonth:
        {
            self.leftAxis.axisMinimum = 0;
            self.leftAxis.axisMaximum = self.combinedChartData.yMax + 0.5;
        }
            break;
        case ChartViewSportWeek:
        {
            self.leftAxis.axisMinimum = 0;
            self.leftAxis.axisMaximum = self.combinedChartData.yMax + 0.5;
        }
            break;
        default:
        {
            self.leftAxis.axisMinimum = 0;
            self.leftAxis.axisMaximum = self.combinedChartData.yMax + 0.5;
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
            case ChartViewSportMonth:
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
            case ChartViewSportWeek:
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
                        return @"SU";
                        break;
                    default:
                        break;
                }
                return @"";
            default:
                if (@(value).integerValue == 0) {
                    return @"0:00";
                }else if (@(value).integerValue == 11) {
                    return @"12:00";
                }else if (@(value).integerValue == 23) {
                    return @"23:59";
                }
                return @"";
        }
    }else {
        switch (self.type) {
            case ChartViewSportDay:
                return [NSString stringWithFormat:@"%li",(NSInteger)value];
                break;
            case ChartViewSportWeek:
                return [NSString stringWithFormat:@"%li",(NSInteger)value];
                break;
            case ChartViewSportMonth:
                return [NSString stringWithFormat:@"%li",(NSInteger)value];
                break;
                
            default:
                break;
        }
    }
}

- (void)configChartView {
    [super configChartView];
    self.combinedChartView.noDataText = ICXLocalize(@"Band_YouDon'tHaveAnySportsData");
    self.combinedChartView.noDataFont = [UIFont systemFontOfSize:14];
}

- (void)configMark {
    [super configMark];
    TYMarkerView *marker = [[TYMarkerView alloc]
                            initWithColor: UIColorFromRGB(0xffffff)
                            font: [UIFont systemFontOfSize:10.0]
                            textColor: UIColorFromRGB(0x34353B)
                            insets: UIEdgeInsetsMake(5.0, 4, 10.0, 4)];
    marker.minimumSize = CGSizeMake(32.f, 19.f);
    marker.offset = CGPointMake(0, -3);
    marker.arrowSize = CGSizeMake(10, 6);
    self.combinedChartView.marker = marker;
}

@end
