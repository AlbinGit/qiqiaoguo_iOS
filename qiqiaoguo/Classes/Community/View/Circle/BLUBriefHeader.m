//
//  BLUCircleBriefHeader.m
//  Blue
//
//  Created by Bowen on 3/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUBriefHeader.h"

CGFloat BLUBriefHeaderHeight = 40;

@interface BLUBriefHeader ()

@end

@implementation BLUBriefHeader

#pragma mark - Life Circle

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
   
//    [_toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
//    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(BLUThemeLeftMargin * 2);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.height.equalTo(@(1.0 / [UIScreen mainScreen].scale));
        make.left.equalTo(_titleLabel.mas_right).offset(BLUThemeLeftMargin * 2);
        make.right.equalTo(self.contentView).offset(- BLUThemeLeftMargin * 2);
    }];
    
    [super updateConstraints];
}

- (void)_config {
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;

    // TitleLabel
//    _titleLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:16];
//    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textColor = [UIColor colorFromHexString:@"#999999"];
//    _titleLabel.font = [UIFont systemFontOfSize:16];
//    _titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_titleLabel];
    
    // SeparateLine
    _separateLine = [BLUSolidLine new];
    _separateLine.backgroundColor =[UIColor colorFromHexString:@"#c1c1c1"];
    _separateLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_separateLine];
}

@end
