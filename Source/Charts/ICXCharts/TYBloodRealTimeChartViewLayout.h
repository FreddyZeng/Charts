//
//  TYBloodRealTimeChartViewLayout.h
//  Meum
//
//  Created by fanrong on 2017/12/1.
//  Copyright © 2017年 huangwei. All rights reserved.
//

#import "TYBaseChartViewLayout.h"
#import "TYUIKitDemo-Swift.h"

@interface TYBloodRealTimeChartViewLayout : TYBaseChartViewLayout <TYMarkerViewDelegate>
@property(nonatomic,assign)BOOL noMark;
- (CombinedChartData *)getDayDataWithRedXArr:(NSArray *)RedXArr RedYArr:(NSArray *)RedYArr blueXArr:(NSArray *)blueXArr blueYArr:(NSArray *)blueYArr greenXArr:(NSArray *)greenXArr greenYArr:(NSArray *)greenYArr;

@end
