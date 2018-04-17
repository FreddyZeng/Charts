//
//  TYCombinedChartView.m
//  Meum
//
//  Created by fanrong on 2017/11/6.
//  Copyright © 2017年 huangwei. All rights reserved.
//

#import "TYCombinedChartView.h"
#import "TYCombinedDateCollectionViewCell.h"
#import "TYCombinedChartViewCollectionViewCell.h"
#import "Masonry.h"

//国际化
#define ICXLocalize(key)                NSLocalizedString(key, nil)

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



static CGFloat DateItemWidth = 40.0;
static CGFloat DateItemHeight = 40.0;

#define NormalColor [UIColor colorWithRed:218/255.0 green:223/255.0 blue:227/255.0 alpha:1/1.0]

@interface TYCombinedChartView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *chartCollectionView;

@property (nonatomic, strong) UICollectionView *dateCollectionView;

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *chartViewMapArr;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *dateViewSelectStateArr;

@end

@implementation TYCombinedChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.dateCollectionView];
        [self addSubview:self.chartCollectionView];
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
        
        [self.dateCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.height.equalTo(@(DateItemHeight + 0.5));
            make.left.equalTo(@30);
            make.right.equalTo(@-30);
        }];
        [self.chartCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.bottom.equalTo(self.dateCollectionView.mas_top);
        }];
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.dateCollectionView);
            make.left.equalTo(self);
            make.right.equalTo(self.dateCollectionView.mas_left);
        }];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.dateCollectionView);
            make.right.equalTo(self);
            make.left.equalTo(self.dateCollectionView.mas_right);
        }];
    }
    return self;
}

- (void)updatehartCollectionViewItemSize {
    if ([self.chartCollectionView.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.chartCollectionView.collectionViewLayout;
        layout.itemSize = CGSizeMake(self.frame.size.width - DateItemWidth, self.frame.size.height - DateItemHeight);
    }
}

- (void)reloadView {
    NSInteger dateViewCount = 0;
    if ([self.dataSource respondsToSelector:@selector(getDataCountWithDateCellectionView:)]) {
        dateViewCount = [self.dataSource getDataCountWithDateCellectionView:self];
    }
    
    for (NSInteger i = 0; i < dateViewCount; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        if ([self.dataSource respondsToSelector:@selector(getIsCanSelectStateWithDateCellectionView:indexPath:)]) {
            BOOL isCanSelect = [self.dataSource getIsCanSelectStateWithDateCellectionView:self indexPath:indexPath];
            [self.dateViewSelectStateArr addObject:@(isCanSelect)];
            
            if (isCanSelect) {
                [self.chartViewMapArr addObject:indexPath];
            }
        }
    }
    
    if (self.dateViewSelectStateArr.count < 1) {
        return;
    }
    
    [self.chartCollectionView reloadData];
    [self.dateCollectionView reloadData];
    
    [self selectChartViewIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animate:NO callDelegate:NO];
}

- (void)selectChartViewIndexPath:(NSIndexPath *)indexPath animate:(BOOL)animate callDelegate:(BOOL)callDelegate {
    
    if (!(indexPath.item < self.chartViewMapArr.count)) {
        return;
    }
    
    NSIndexPath *dateViewSelectIndexPath = self.chartViewMapArr[indexPath.item];
    
    [self.chartCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    [self.dateCollectionView selectItemAtIndexPath:dateViewSelectIndexPath animated:animate scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    if (callDelegate) {
        if ([self.dataSource respondsToSelector:@selector(tyCombinedChartView: combinedChartView:dateViewIndexPath:)]) {
            if (dateViewSelectIndexPath.item != NSNotFound) {
                TYCombinedChartViewCollectionViewCell *cell = (TYCombinedChartViewCollectionViewCell *)[self.chartCollectionView cellForItemAtIndexPath:indexPath];
                cell.chartView.delegate = self;
                [self.dataSource tyCombinedChartView:self combinedChartView:cell.chartView dateViewIndexPath:dateViewSelectIndexPath];
            }
        }
    }
}

- (void)clickLeft {
    NSIndexPath *indexPath = [self.chartCollectionView indexPathsForSelectedItems].firstObject;
    NSInteger nextRightIndex = indexPath.item + 1;
    if (nextRightIndex < self.chartViewMapArr.count) {
        [self selectChartViewIndexPath:[NSIndexPath indexPathForItem:nextRightIndex inSection:0] animate:YES callDelegate:YES];
    }
}

- (void)clickRight {
    NSIndexPath *indexPath = [self.chartCollectionView indexPathsForSelectedItems].firstObject;
    NSInteger nextLeftIndex = indexPath.item - 1;
    if (0 <= nextLeftIndex) {
        [self selectChartViewIndexPath:[NSIndexPath indexPathForItem:nextLeftIndex inSection:0] animate:YES callDelegate:YES];
    }
}

- (CombinedChartView *)getCurSelectCombinedChartView {
    NSIndexPath *dateViewIndexPath = [self getCurSelectDateViewIndexPath];
    NSInteger chartViewSelectIndex = [self.chartViewMapArr indexOfObject:dateViewIndexPath];
    NSIndexPath *chartViewIndexPath = [NSIndexPath indexPathForItem:chartViewSelectIndex inSection:0];
     TYCombinedChartViewCollectionViewCell *cell = (TYCombinedChartViewCollectionViewCell *)[self.chartCollectionView cellForItemAtIndexPath:chartViewIndexPath];
    return cell.chartView;
}

- (NSIndexPath *)getCurSelectDateViewIndexPath {
    return [[self.dateCollectionView indexPathsForSelectedItems] firstObject];
}


- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight {
    if ([self.delegate respondsToSelector:@selector(tyChartValueSelected:entry:highlight:)]) {
        [self.delegate tyChartValueSelected:chartView entry:entry highlight:highlight];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.chartCollectionView) {
        return self.chartViewMapArr.count;
    }else {
        return self.dateViewSelectStateArr.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.chartCollectionView) {
        TYCombinedChartViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TYCombinedChartViewCollectionViewCell" forIndexPath:indexPath];
        
        if ([self.dataSource respondsToSelector:@selector(tyCombinedChartView: combinedChartView:dateViewIndexPath:)]) {
            NSIndexPath *dateIndexPath = self.chartViewMapArr[indexPath.item];
            if (dateIndexPath.item != NSNotFound) {
                cell.chartView.delegate = self;
                [self.dataSource tyCombinedChartView:self combinedChartView:cell.chartView dateViewIndexPath:dateIndexPath];
            }
        }
        return cell;
    }else {
        TYCombinedDateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TYCombinedDateCollectionViewCell" forIndexPath:indexPath];
        
        cell.titleLabel.text = @"";
        if ([self.dataSource respondsToSelector:@selector(getTitleWithDateCellectionView:indexPath:)]) {
            NSString *title = [self.dataSource getTitleWithDateCellectionView:self indexPath:indexPath];
             cell.titleLabel.text = title;
        }
        
        cell.userInteractionEnabled = YES;
        cell.titleLabel.textColor = UIColorFromRGB(0x7A7D80);
        
         BOOL isCanSelect = [self.dateViewSelectStateArr[indexPath.item] boolValue];
        
        if (isCanSelect) {
            cell.userInteractionEnabled = YES;
            cell.titleLabel.textColor = UIColorFromRGB(0x7A7D80);
        }else {
            cell.userInteractionEnabled = NO;
            cell.titleLabel.textColor = UIColorFromRGB(0xc2c7cb);
        }
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.dateCollectionView) {
        BOOL isCanSelect = [self.dateViewSelectStateArr[indexPath.item] boolValue];
        if (!isCanSelect == YES) {
            return NO;
        }
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.dateCollectionView) {
        BOOL isCanSelect = [self.dateViewSelectStateArr[indexPath.item] boolValue];
        
        if (!isCanSelect) {
            return;
        }
        
        NSInteger willSelectCharViewIndex = [self.chartViewMapArr indexOfObject:indexPath];
        NSIndexPath *willSelectChartViewIndexPath = [NSIndexPath indexPathForItem:willSelectCharViewIndex inSection:0];

        [self selectChartViewIndexPath:willSelectChartViewIndexPath animate:YES callDelegate:YES];
    }
}


#pragma mark - getter

- (UIButton *)leftButton
{
    if (!_leftButton)
    {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(0, 0, 0, 0);
        _leftButton.backgroundColor = NormalColor;
        [_leftButton setImage:[UIImage imageNamed:@"leftArrow"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(clickLeft) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton
{
    if (!_rightButton)
    {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(0, 0, 0, 0);
        _rightButton.backgroundColor = NormalColor;
        [_rightButton setImage:[UIImage imageNamed:@"rightArrow"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(clickRight) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
- (UICollectionView *)chartCollectionView {
    if (!_chartCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height - DateItemHeight);
        flowLayout.minimumLineSpacing = 0.0;
        flowLayout.minimumInteritemSpacing = 10;
        _chartCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _chartCollectionView.backgroundColor = [UIColor clearColor];
        _chartCollectionView.showsHorizontalScrollIndicator = NO;
        _chartCollectionView.showsVerticalScrollIndicator = NO;
        _chartCollectionView.pagingEnabled = YES;
        _chartCollectionView.dataSource = self;
        _chartCollectionView.delegate = self;
        _chartCollectionView.alwaysBounceHorizontal = YES;
        _chartCollectionView.scrollEnabled = NO;
        [_chartCollectionView registerClass:[TYCombinedChartViewCollectionViewCell class] forCellWithReuseIdentifier:@"TYCombinedChartViewCollectionViewCell"];
    }
    return _chartCollectionView;
}

- (UICollectionView *)dateCollectionView {
    if (!_dateCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0.0;
        flowLayout.minimumInteritemSpacing = 0.0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(DateItemWidth, DateItemHeight);
        _dateCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _dateCollectionView.backgroundColor = [UIColor clearColor];
        _dateCollectionView.showsHorizontalScrollIndicator = NO;
        _dateCollectionView.showsVerticalScrollIndicator = NO;
        _dateCollectionView.dataSource = self;
        _dateCollectionView.delegate = self;
        _dateCollectionView.alwaysBounceHorizontal = YES;
        _dateCollectionView.backgroundColor = NormalColor;
        [_dateCollectionView registerClass:[TYCombinedDateCollectionViewCell class] forCellWithReuseIdentifier:@"TYCombinedDateCollectionViewCell"];
        CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI);
        [_dateCollectionView setTransform:transform];
    }
    return _dateCollectionView;
}

/// 映射到 dateView的 IndexPath
- (NSMutableArray<NSIndexPath *> *)chartViewMapArr {
    if (!_chartViewMapArr) {
        _chartViewMapArr = [[NSMutableArray<NSIndexPath *> alloc] init];
    }
    return _chartViewMapArr;
}

- (NSMutableArray<NSNumber *> *)dateViewSelectStateArr {
    if (!_dateViewSelectStateArr) {
        _dateViewSelectStateArr = [[NSMutableArray<NSNumber *> alloc] init];
    }
    return _dateViewSelectStateArr;
}





@end
