//
//  QGMessageListHeadView.m
//  qiqiaoguo
//
//  Created by cws on 16/7/4.
//
//

#import "QGMessageListHeadView.h"

@interface QGMessageListHeadView ()


@end

@implementation QGMessageListHeadView

- (instancetype)init {
    if (self = [super init]) {
        [self _config];
    }
    return self;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self _config];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {

    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.contentView);
    }];

    [super updateConstraints];
}

- (void)_config {
    
    self.contentView.backgroundColor = APPBackgroundColor;
    self.clipsToBounds = YES;
    
    // TitleLabel
    _timeLabel = [UILabel makeThemeLabelWithType:BLULabelTypeMainContent];
    _timeLabel.textColor = [UIColor colorFromHexString:@"999999"];
    _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_timeLabel];

}

@end
