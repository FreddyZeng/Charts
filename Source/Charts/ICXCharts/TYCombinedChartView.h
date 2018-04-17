//
//  TYCombinedChartView.h
//  Meum
//
//  Created by fanrong on 2017/11/6.
//  Copyright © 2017年 huangwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Charts/Charts.h>

NS_ASSUME_NONNULL_BEGIN

@class TYCombinedChartView;
@protocol TYCombinedChartViewDataSource<NSObject>
- (BOOL)getIsCanSelectStateWithDateCellectionView:(TYCombinedChartView *)combinedChartView indexPath:(NSIndexPath *)indexPath;
- (NSInteger)getDataCountWithDateCellectionView:(TYCombinedChartView *)combinedChartView;

- (NSString *)getTitleWithDateCellectionView:(TYCombinedChartView *)combinedChartView indexPath:(NSIndexPath *)indexPath;

- (void)tyCombinedChartView:(TYCombinedChartView *)tyCombinedChartView combinedChartView:(CombinedChartView *)combinedChartView dateViewIndexPath:(NSIndexPath *)indexPath;

@end


@protocol TYCombinedChartViewDelegate<NSObject>
@optional

- (void)tyCombinedChartView:(TYCombinedChartView *)tyCombinedChartView didSelectDateViewIndexPath:(NSIndexPath *)indexPath;


- (void)tyChartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight;

@end


@interface TYCombinedChartView : UIView

@property (nonatomic, strong, readonly) UICollectionView *chartCollectionView;

@property (nonatomic, strong, readonly) UICollectionView *dateCollectionView;

@property (nonatomic, weak) id<TYCombinedChartViewDataSource> dataSource;
@property (nonatomic, weak) id<TYCombinedChartViewDelegate> delegate;

- (CombinedChartView *)getCurSelectCombinedChartView;

- (NSIndexPath *)getCurSelectDateViewIndexPath;

- (void)updatehartCollectionViewItemSize;

- (void)reloadView;

@end

NS_ASSUME_NONNULL_END
