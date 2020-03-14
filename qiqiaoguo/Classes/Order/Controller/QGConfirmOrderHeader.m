//
//  QGConfirmOrderHeader.m
//  qiqiaoguo
//
//  Created by cws on 16/7/25.
//
//

#import "QGConfirmOrderHeader.h"

@implementation QGConfirmOrderHeader
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UIView *superview = self.contentView;
        superview.backgroundColor = [UIColor whiteColor];
        
        _storeNameLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        
        UIView *bottomLine = [UIView new];
        bottomLine.backgroundColor = QGCellbottomLineColor;
        
        [superview addSubview:bottomLine];
        [superview addSubview:_storeNameLabel];

        [self.storeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(superview);
            make.left.equalTo(superview).offset(BLUThemeMargin * 4);
        }];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@(QGOnePixelLineHeight));
        }];
        
    }
    return self;
}

+ (CGFloat)ConfirmOrderHeaderHeight {
    return 40.0;
}


@end
