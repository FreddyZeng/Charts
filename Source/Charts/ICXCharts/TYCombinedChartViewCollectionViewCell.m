//
//  TYCombinedChartViewCollectionViewCell.m
//  Meum
//
//  Created by fanrong on 2017/11/6.
//  Copyright © 2017年 huangwei. All rights reserved.
//

#import "TYCombinedChartViewCollectionViewCell.h"
#import "TYUIKitDemo-Swift.h"
#import "Masonry.h"

//国际化
#define ICXLocalize(key)                NSLocalizedString(key, nil)

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation TYCombinedChartViewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.chartView];
        [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (CombinedChartView *)chartView {
    if (!_chartView) {
        _chartView =  [[CombinedChartView alloc] initWithFrame:CGRectZero];
        _chartView.drawValueAboveBarEnabled = NO;
        _chartView.doubleTapToZoomEnabled = NO;
        _chartView.highlightFullBarEnabled = YES;
        _chartView.pinchZoomEnabled = NO;
        _chartView.scaleXEnabled = NO;
        _chartView.scaleYEnabled = NO;
        
        ChartDescription *description = _chartView.chartDescription;
        description.enabled = NO;
        
        ChartLegend *legend= _chartView.legend;
        legend.enabled = NO;
        
        ChartXAxis *xAxis = _chartView.xAxis;
        xAxis.drawGridLinesEnabled = NO;
        xAxis.labelPosition = XAxisLabelPositionBottom;
        xAxis.labelFont = [UIFont systemFontOfSize:8];
        xAxis.labelTextColor = UIColorFromRGB(0xA1A7B5);
        xAxis.labelCount = 24;
        xAxis.drawAxisLineEnabled = NO;
        
        ChartYAxis *leftAxis = _chartView.leftAxis;
        leftAxis.drawGridLinesEnabled = YES;
        leftAxis.labelFont = [UIFont systemFontOfSize:12];
        leftAxis.labelTextColor = UIColorFromRGB(0xA1A7B5);
        leftAxis.drawAxisLineEnabled = NO;
        leftAxis.gridLineDashLengths = @[@2];
        leftAxis.labelCount = 3;
        leftAxis.axisMinimum = 0;
        
        NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
        leftAxisFormatter.minimumFractionDigits = 0;
        leftAxisFormatter.maximumFractionDigits = 0;
        leftAxisFormatter.multiplier = @1;
        //        leftAxisFormatter.negativeSuffix = @"k";
        //        leftAxisFormatter.positiveSuffix = @"k";
        leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
        
        _chartView.rightAxis.enabled = NO;
        
        _chartView.noDataFont = [UIFont systemFontOfSize:12];
        _chartView.noDataTextColor = UIColorFromRGB(0xA1A7B5);
        _chartView.noDataText = ICXLocalize(@"Band_noData");
        
        YMarkerView *marker = [[YMarkerView alloc]
                                initWithColor: UIColorFromRGB(0x2AA9F7)
                                font: [UIFont systemFontOfSize:12.0]
                                textColor: UIColor.whiteColor
                                insets: UIEdgeInsetsMake(5.0, 0.0, 10.0, 5.0)
                                xAxisValueFormatter: nil];
        marker.chartView = _chartView;
        marker.minimumSize = CGSizeMake(32.f, 19.f);
        marker.offset = CGPointMake(0, -2);
        marker.arrowSize = CGSizeMake(10, 6);
        _chartView.marker = marker;
        _chartView.data = [CombinedChartData new];
    }
    return _chartView;
}

@end
