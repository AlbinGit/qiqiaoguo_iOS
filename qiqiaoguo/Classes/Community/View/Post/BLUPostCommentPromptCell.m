//
//  BLUPostCommentPromptCell.m
//  Blue
//
//  Created by Bowen on 22/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostCommentPromptCell.h"

@interface BLUPostCommentPromptCell ()

@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) BLUSolidLine *solidLine;

@end

@implementation BLUPostCommentPromptCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

//        self.backgroundColor = [UIColor ];

        _promptLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _promptLabel.text = NSLocalizedString(@"post-comment-prompt-cell.prompt-label.text", @"There is no comment");

        _commentButton = [UIButton makeThemeButtonWithType:BLUButtonTypeBorderedRoundRect];
        _commentButton.title = NSLocalizedString(@"post-comment-prompt-cell.comment-button.title", @"Comment");
        _commentButton.contentEdgeInsets = UIEdgeInsetsMake(BLUThemeMargin , BLUThemeMargin, BLUThemeMargin, BLUThemeMargin);
        _commentButton.userInteractionEnabled = NO;

        _solidLine = [BLUSolidLine new];
        _solidLine.backgroundColor = BLUThemeSubTintBackgroundColor;

        [self.contentView addSubview:_solidLine];
        [self.contentView addSubview:_promptLabel];
        [self.contentView addSubview:_commentButton];

        return self;
    }
    return nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _solidLine.frame = CGRectMake(0, -1, self.contentView.width, BLUThemeOnePixelHeight);

    [_promptLabel sizeToFit];
    _promptLabel.frame = CGRectMake(0, BLUThemeMargin * 4, _promptLabel.width, _promptLabel.height);
    _promptLabel.centerX = self.contentView.centerX;

    [_commentButton sizeToFit];
    _commentButton.frame = CGRectMake(0, _promptLabel.bottom + BLUThemeMargin * 2, _commentButton.width, _commentButton.height);
    _commentButton.centerX = self.contentView.centerX;

    self.cellSize = CGSizeMake(self.contentView.width, _commentButton.bottom + BLUThemeMargin * 4);
}

@end
