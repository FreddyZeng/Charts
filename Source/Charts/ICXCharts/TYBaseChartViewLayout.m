//
//  TYBaseChartViewLayout.m
//  Meum
//
//  Created by fanrong on 2017/12/1.
//  Copyright © 2017年 huangwei. All rights reserved.
//

#import "TYBaseChartViewLayout.h"

//国际化
#define ICXLocalize(key)                NSLocalizedString(key, nil)

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static dispatch_queue_t chartsQueue = nil;
@interface TYBaseChartViewLayout()
@property (nonatomic, weak) ChartYAxis *leftAxis;

@property (nonatomic, weak) ChartYAxis *rightAxis;

@property (nonatomic, weak) ChartXAxis *xAxis;

@property (nonatomic, weak) CombinedChartData *combinedChartData;

@property (nonatomic, weak) CombinedChartView *combinedChartView;

@property (nonatomic, weak) ChartLegend *legend;
@end

@implementation TYBaseChartViewLayout

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chartsQueue = dispatch_queue_create("ChartLayoutQueue", nil);
    });
}

- (void)configCombinedChartView:(CombinedChartView *)combinedChartView combinedChartData:(CombinedChartData *)combinedChartData complete:(void(^)(void))complete {
    dispatch_async(chartsQueue, ^{
        self.combinedChartData = combinedChartData;
        self.combinedChartView = combinedChartView;
        self.leftAxis = combinedChartView.leftAxis;
        self.rightAxis = combinedChartView.rightAxis;
        self.xAxis = combinedChartView.xAxis;
        self.legend = combinedChartView.legend;
        [self configChartView];
        [self configDrawOrder];
        [self configLegend];
        [self configChartDescription];
        [self configXAxis];
        [self configLeftAxis];
        [self configRightAxis];
        [self configMark];
        [self configContentOffset];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete();
            }
        });
    });
}

/**
 渲染列表，子类最好按需渲染，提高性能
 */
- (void)configDrawOrder {
    self.combinedChartView.drawOrder = @[
                                         @(CombinedChartDrawOrderBar),
                                         @(CombinedChartDrawOrderBubble),
                                         @(CombinedChartDrawOrderCandle),
                                         @(CombinedChartDrawOrderLine),
                                         @(CombinedChartDrawOrderScatter)
                                         ];
}

/**
 设置view的 内容边距
 */
- (void)configContentOffset {
    [self.combinedChartView setViewPortOffsetsWithLeft:0 top:0 right:0 bottom:0];
}

/**
 配置X轴的属性
 */
- (void)configXAxis {
    ChartXAxis *xAxis = self.xAxis;
    xAxis.drawGridLinesEnabled = NO;// 是否画格子线
    xAxis.labelPosition = XAxisLabelPositionBottom;// x轴的label位置
    xAxis.labelFont = [UIFont systemFontOfSize:8];// x轴label 的字体大小
    xAxis.labelTextColor = UIColorFromRGB(0xA1A7B5);// x轴label 的字体颜色
    xAxis.labelCount = 24;// x轴的label个数。这个是大概个数
    xAxis.drawAxisLineEnabled = NO;// 是否画 X轴线
    xAxis.granularityEnabled = YES;// 是否开启 粒度
}
- (void)configLeftAxis {
    ChartYAxis *leftAxis = self.leftAxis;
    leftAxis.drawGridLinesEnabled = YES;// 是否画Y轴的格子线
    leftAxis.labelFont = [UIFont systemFontOfSize:12];
    leftAxis.labelTextColor = UIColorFromRGB(0xA1A7B5);
    leftAxis.drawAxisLineEnabled = NO;
    leftAxis.gridLineDashLengths = @[@2];
    leftAxis.labelCount = 3;
    leftAxis.granularityEnabled = YES;
    
    NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
    leftAxisFormatter.minimumFractionDigits = 0;
    leftAxisFormatter.maximumFractionDigits = 0;
    leftAxisFormatter.multiplier = @1;// 设置 Y轴的精确到小数点(一般不用这个处理)
    //        leftAxisFormatter.negativeSuffix = @"k";
    //        leftAxisFormatter.positiveSuffix = @"k";
    leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
}
- (void)configRightAxis {
    self.rightAxis.enabled = NO;
}
- (void)configLegend {
    self.legend.enabled = NO;
}

- (void)configChartDescription {
    self.combinedChartView.chartDescription.enabled = NO;
}

- (void)configMark {
    YMarkerView *marker = [[YMarkerView alloc]
                           initWithColor: UIColorFromRGB(0x2AA9F7)
                           font: [UIFont systemFontOfSize:12.0]
                           textColor: UIColor.whiteColor
                           insets: UIEdgeInsetsMake(5.0, 0.0, 10.0, 5.0)
                           xAxisValueFormatter: nil];
    marker.chartView = self.combinedChartView;
    marker.minimumSize = CGSizeMake(32.f, 19.f);
    marker.offset = CGPointMake(0, -2);
    marker.arrowSize = CGSizeMake(10, 6);
    self.combinedChartView.marker = marker;
}

- (void)configChartView {
    self.combinedChartView.drawValueAboveBarEnabled = NO;
    self.combinedChartView.doubleTapToZoomEnabled = NO;
    self.combinedChartView.highlightFullBarEnabled = YES;
    self.combinedChartView.pinchZoomEnabled = NO;
    self.combinedChartView.scaleXEnabled = NO;
    self.combinedChartView.scaleYEnabled = NO;
    
    self.combinedChartView.rightAxis.enabled = NO;
    
    self.combinedChartView.noDataFont = [UIFont systemFontOfSize:12];
    self.combinedChartView.noDataTextColor = UIColorFromRGB(0xA1A7B5);
    self.combinedChartView.noDataText = ICXLocalize(@"TYPub_noData");
}


- (NSString * _Nonnull)stringForValue:(double)value axis:(ChartAxisBase * _Nullable)axis SWIFT_WARN_UNUSED_RESULT {
    NSException *exception = [[NSException alloc] initWithName:@"" reason:@"TYBaseChartViewLayout subClass must implementation IChartAxisValueFormatter" userInfo:nil];
    [exception raise];
    return @"";
}

@end
