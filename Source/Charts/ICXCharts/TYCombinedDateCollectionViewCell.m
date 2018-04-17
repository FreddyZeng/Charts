//
//  TYCombinedDateCollectionViewCell.m
//  Meum
//
//  Created by fanrong on 2017/11/6.
//  Copyright © 2017年 huangwei. All rights reserved.
//

#import "TYCombinedDateCollectionViewCell.h"
#import "Masonry.h"
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



@implementation TYCombinedDateCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI);
        [self.contentView setTransform:transform];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.selected) {
        self.contentView.backgroundColor = UIColorFromRGB(0X2AA9F7);
        self.titleLabel.textColor = [UIColor whiteColor];
    }else if (self.userInteractionEnabled == NO) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = UIColorFromRGB(0xc2c7cb);
    }else {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = UIColorFromRGB(0x7A7D80);
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.contentView.backgroundColor = UIColorFromRGB(0X2AA9F7);
        self.titleLabel.textColor = [UIColor whiteColor];
    }else {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = UIColorFromRGB(0x7A7D80);
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromRGB(0x7A7D80);
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
