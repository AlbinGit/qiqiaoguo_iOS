//
//  BLUCircleMoreCell.m
//  Blue
//
//  Created by Bowen on 3/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUCircleMoreCell.h"

static const

@interface BLUCircleMoreCell ()

@property (nonatomic, strong) UIButton *moreButton;

@end

@implementation BLUCircleMoreCell

#pragma mark - Life Circle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        _moreButton = [UIButton makeThemeButtonWithType:BLUButtonTypeDefault];
        _moreButton.titleFont = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge);
        _moreButton.titleColor = [UIColor whiteColor];
        _moreButton.backgroundColor = BLUThemeMainColor;
        _moreButton.borderColor = BLUThemeMainColor;
        _moreButton.borderWidth = 1.0;
        _moreButton.cornerRadius = BLUThemeHighActivityCornerRadius;
        _moreButton.title = NSLocalizedString(@"circle.more-circle-cell.more-label.more circles", @"All circles");
        _moreButton.userInteractionEnabled = NO;
        [self.contentView addSubview:_moreButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _moreButton.frame = CGRectMake(BLUThemeMargin * 2, BLUThemeMargin * 2, self.contentView.width - BLUThemeMargin * 4, 44);
    self.cellSize = CGSizeMake(self.contentView.width, 44 + BLUThemeMargin * 4);
}

@end
