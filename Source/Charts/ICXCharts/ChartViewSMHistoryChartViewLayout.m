//
//  ChartViewSMHistoryManage.m
//  Meum
//
//  Created by fanrong on 2017/11/27.
//  Copyright © 2017年 huangwei. All rights reserved.
//

#import "ChartViewSMHistoryChartViewLayout.h"
#import "DateTools.h"
#import "TYCalendarManage.h"

//国际化
#define ICXLocalize(key)                NSLocalizedString(key, nil)

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



@interface ChartViewSMHistoryChartViewLayout()<TYMarkerViewDelegate, IChartAxisValueFormatter>

@property (nonatomic, assign) NSInteger type;

@end

@implementation ChartViewSMHistoryChartViewLayout

- (void)configCombinedChartView:(CombinedChartView *)combinedChartView combinedChartData:(CombinedChartData *)combinedChartData type:(NSInteger)type complete:(void(^)(void))complete {
    self.type = type;
    [super configCombinedChartView:combinedChartView combinedChartData:combinedChartData complete:complete];
}

- (void)configContentOffset {
    [self.combinedChartView setViewPortOffsetsWithLeft:55 top:60 right:35 bottom:36];
}

- (void)configDrawOrder {
    self.combinedChartView.drawOrder = @[@(CombinedChartDrawOrderLine)
                                         ];
}

- (void)configLeftAxis {
    [super configLeftAxis];
    self.leftAxis.xOffset = 20;
    self.leftAxis.granularityEnabled = YES;
    self.leftAxis.granularity = 20.0;
    self.leftAxis.axisMinimum = 0;
    [self.leftAxis setLabelCount:5 force:YES];
    self.leftAxis.valueFormatter = self;
    switch (self.type) {
        case 2:
        {
            self.leftAxis.lineFirstSpace = 9;
            self.leftAxis.lineLastSpace = 12;
            break;
        }
        case 1:
        {
            self.leftAxis.lineFirstSpace = 13;
            self.leftAxis.lineLastSpace = 12;
            break;
        }
        default:
        {
            self.leftAxis.lineFirstSpace = 12;
            self.leftAxis.lineLastSpace = 15;
            break;
        }
    }
}

- (void)configXAxis {
    [super configXAxis];
    self.xAxis.granularity = 1.0;
    self.xAxis.valueFormatter = self;
    self.xAxis.labelFont = [UIFont systemFontOfSize:12];
    self.xAxis.labelTextColor = UIColorFromRGB(0xA1A7B5);
    switch (self.type) {
        case 2:
        {
            [self.xAxis setLabelCount:2 force:YES];
            break;
        }
        case 1:
        {
            [self.xAxis setLabelCount:7 force:YES];
            break;
        }
        default:
        {
            [self.xAxis setLabelCount:3 force:YES];
            break;
        }
    }
    self.xAxis.avoidFirstLastClippingEnabled = NO;
}

- (void)configMark {
    if (self.combinedChartView.marker) {
         TYMarkerView *marker = (TYMarkerView *)self.combinedChartView.marker;
        marker.delegate = self;
        return;
    }
    
    TYMarkerView *marker = [[TYMarkerView alloc]
                            initWithColor: UIColorFromRGB(0x525B6C)
                            font: [UIFont systemFontOfSize:10.0]
                            textColor: UIColorFromRGB(0x34353B)
                            insets: UIEdgeInsetsMake(5.0, 4, 10.0, 4)];
    marker.delegate = self;
    marker.chartView = self.combinedChartView;
    marker.minimumSize = CGSizeMake(70.f, 44.f);
    marker.offset = CGPointMake(0, -3);
    marker.arrowSize = CGSizeMake(10, 6);
    self.combinedChartView.marker = marker;
}


- (NSAttributedString *)tyMarkerViewRefreshContentAttStringWithMark:(TYMarkerView *)mark entry:(ChartDataEntry *)entry highlight:(ChartHighlight *)highlight {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:entry.x];
    
    NSString *xString = nil;
    if (self.type == 0) {
        
        xString = [date formattedDateWithFormat:[NSString stringWithFormat:@"%@\nHH:mm:ss",ICXLocalize(@"XFit_history_dateyyyyMMdd")]];
    }else {
        xString = [date formattedDateWithFormat:ICXLocalize(@"XFit_history_dateyyyyMMdd")];
    }
    
    NSString *yString = [NSString stringWithFormat:@"%.1f", entry.y];
    if (self.showMarkInt) {
        yString = [NSString stringWithFormat:@"%.0f", entry.y];
    }
    
    NSMutableAttributedString *xAttString = [[NSMutableAttributedString alloc] initWithString:xString];
    NSMutableAttributedString *lineAttString = [[NSMutableAttributedString alloc] initWithString:@"\n"];
    NSMutableAttributedString *yAttString = [[NSMutableAttributedString alloc] initWithString:yString];
    [yAttString addColor:[UIColor whiteColor] substring:yAttString.string];
    [yAttString addFont:[UIFont systemFontOfSize:20] substring:yAttString.string];
    
    [lineAttString addFont:[UIFont systemFontOfSize:20] substring:yAttString.string];
    
    [xAttString addColor:UIColorFromRGB(0xffffff) substring:xAttString.string];
    [xAttString addFont:[UIFont systemFontOfSize:10] substring:xAttString.string];

    [yAttString appendAttributedString:lineAttString];
    [yAttString appendAttributedString:xAttString];
    
    [yAttString addAlignment:NSTextAlignmentCenter substring:yAttString.string];
    return yAttString;
}

+ (CombinedChartData *)getHeartDayDataWithXArr:(NSArray *)xArr yArr:(NSArray *)yArr type:(NSInteger)type gradientColors:(NSArray<UIColor *> *)gradientColors {
    if (xArr.count == 0) {
        return nil;
    }
    xArr = [xArr copy];
    yArr = [yArr copy];
    
    NSMutableArray *values1 = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < xArr.count; ++i) {
        [values1 addObject:[[ChartDataEntry alloc] initWithX:[xArr[i] doubleValue] y:[yArr[i] doubleValue] icon: [UIImage imageNamed:@"icon"]]];
    }
    
    UIColor *circleColor = gradientColors.firstObject;
    UIColor *highlightHollowFillColor = circleColor;
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithValues:values1 label:@"DataSet 1"];
    
    set1.drawIconsEnabled = NO;
    set1.drawValuesEnabled = NO;
    set1.highlightEnabled = YES;
    set1.highlightColor = circleColor;
    
    set1.lineWidth = 2;
    set1.colors = @[circleColor];
    
    set1.drawCirclesEnabled = YES;
    set1.circleRadius = 4.0;
    set1.circleColors = @[circleColor];
    
    set1.drawCircleHoleEnabled = YES;
    set1.circleHoleRadius = 2.0;
    set1.circleHoleColor = [UIColor whiteColor];
    set1.highlightLineDashLengths = @[@(1), @(0), @(1)];
    
    set1.highlightHollowFillColor = highlightHollowFillColor;
    
    set1.drawHorizontalHighlightIndicatorEnabled = NO;
    set1.drawVerticalHighlightIndicatorEnabled = NO;
    
    NSArray *colors = @[(id)gradientColors.lastObject.CGColor,
                                (id)gradientColors.firstObject.CGColor
                                ];
    CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)colors, nil);
    
    set1.fillAlpha = 0.4f;
    set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
    set1.drawFilledEnabled = YES;
    
    CGGradientRelease(gradient);
    
    double timeStamp = [xArr.firstObject doubleValue];
    NSDate *curDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    
    // 显示日期
    LineChartDataSet *set2 = nil;
    
    switch (type) {
        case 2:
        {// 月
            set1.circleRadius = 2.0;
            set1.drawCircleHoleEnabled = NO;
            
            if (xArr.count == 1) {
                set1.drawCirclesEnabled = YES;
            }else {
                set1.drawCirclesEnabled = NO;
            }
            
            set1.drawHorizontalHighlightIndicatorEnabled = YES;
            set1.drawVerticalHighlightIndicatorEnabled = YES;
            
            NSDate *monthBengin = [[TYCalendarManage shareManage] converDateToMonthBegin:curDate];
            NSDate *monthEnd = [[TYCalendarManage shareManage] converDateToMonthEnd:curDate];
            monthEnd = [[TYCalendarManage shareManage] converDateToDayBegin:monthEnd];
            
            NSMutableArray *values2 = [[NSMutableArray alloc] init];
            
            [values2 addObject:[[ChartDataEntry alloc] initWithX:[monthBengin timeIntervalSince1970] y:0.0]];
            [values2 addObject:[[ChartDataEntry alloc] initWithX:[monthEnd timeIntervalSince1970] y:0.0]];
            set2 = [[LineChartDataSet alloc] initWithValues:values2 label:@"DataSet 2"];
            break;
        }
        case 1:
        {// 周
            NSDate *weekBengin = [[TYCalendarManage shareManage] converDateToWeekBegin:curDate];
            NSDate *weekEnd = [[TYCalendarManage shareManage] converDateToWeekEnd:curDate];
            weekEnd = [[TYCalendarManage shareManage] converDateToDayBegin:weekEnd];
            
            NSMutableArray *values2 = [[NSMutableArray alloc] init];
            
            [values2 addObject:[[ChartDataEntry alloc] initWithX:[weekBengin timeIntervalSince1970] y:0.0]];
            [values2 addObject:[[ChartDataEntry alloc] initWithX:[weekEnd timeIntervalSince1970] y:0.0]];
            set2 = [[LineChartDataSet alloc] initWithValues:values2 label:@"DataSet 2"];
            break;
        }
        default:
        {// 日
            NSDate *dayBengin = [[TYCalendarManage shareManage] converDateToDayBegin:curDate];
            NSDate *dayEnd = [dayBengin dateByAddingDays:1];
            dayEnd = [dayEnd dateBySubtractingSeconds:1];
            
            NSMutableArray *values2 = [[NSMutableArray alloc] init];
            
            [values2 addObject:[[ChartDataEntry alloc] initWithX:[dayBengin timeIntervalSince1970] y:0.0]];
            [values2 addObject:[[ChartDataEntry alloc] initWithX:[dayEnd timeIntervalSince1970] y:0.0]];
            set2 = [[LineChartDataSet alloc] initWithValues:values2 label:@"DataSet 2"];
            break;
        }
    }
    
    set2.highlightEnabled = NO;
    set2.lineWidth = 0.0;
    set2.drawCirclesEnabled = NO;
    set2.drawValuesEnabled = NO;
    
    CombinedChartData *data = [[CombinedChartData alloc] init];
    data.lineData = [[LineChartData alloc] initWithDataSets:@[set1,set2]];
    return data;
}

- (NSString * _Nonnull)stringForValue:(double)value axis:(ChartAxisBase * _Nullable)axis {
    if ([axis isKindOfClass:[ChartXAxis class]]) {
        switch (self.type) {
            case 2:
            {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:value];
                return [NSString stringWithFormat:ICXLocalize(@"XFit_history_dated"), date.day];
                break;
            }
            case 1:
            {
                NSArray *weekArr = @[@"SUN",@"MON",@"TUE",@"WED",@"THR",@"FRI",@"SAT"];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:value];
                return weekArr[date.weekday - 1];
                break;
            }
            default:
            {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:value];
                NSString *dateString = [date formattedDateWithFormat:@"H:mm"];
                if ([dateString isEqualToString:@"11:59"]) {
                    return @"12:00";
                }
                return dateString;
                break;
            }
        }
    }else {
        NSInteger valueInt = value;
        return [NSString stringWithFormat:@"%li",valueInt];
    }
    return @"";
}

@end
