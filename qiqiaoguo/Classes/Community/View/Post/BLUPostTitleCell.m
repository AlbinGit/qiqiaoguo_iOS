//
//  BLUPostTitleCell.m
//  Blue
//
//  Created by Bowen on 11/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUPostTitleCell.h"
#import "BLUPost.h"
#import "BLUCircle.h"

@interface BLUPostTitleCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *circleButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) BLUPost *post;
@property (nonatomic, strong) BLUSolidLine *solidLine;

@end

@implementation BLUPostTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *superview = self.contentView;
        superview.backgroundColor = BLUThemeMainTintBackgroundColor;
    
        // Title
        _titleLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _titleLabel.numberOfLines = 0;
        [superview addSubview:_titleLabel];
        
        // Cicle
        _circleButton = [UIButton makeThemeButtonWithType:BLUButtonTypeBorderedRoundRect];
        _circleButton.titleFont = _titleLabel.font;
        _circleButton.contentEdgeInsets = UIEdgeInsetsMake(BLUThemeMargin, BLUThemeMargin, BLUThemeMargin, BLUThemeMargin);
        [_circleButton addTarget:self action:@selector(transitToCircleAction:) forControlEvents:UIControlEventTouchUpInside];
        [superview addSubview:_circleButton];
        
        // Comment
        _commentButton = [UIButton makeThemeButtonWithType:BLUButtonTypeDefault];
        _commentButton.tintColor = BLUThemeSubTintContentForegroundColor;
        _commentButton.titleFont = _circleButton.titleFont;
        _commentButton.translatesAutoresizingMaskIntoConstraints = NO;
        _commentButton.image = [BLUCurrentTheme postCommentIcon];
        [_commentButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        [superview addSubview:_commentButton];
        
        // Solid line
        _solidLine = [BLUSolidLine new];
        _solidLine.backgroundColor = BLUThemeSubTintBackgroundColor;
        [superview addSubview:_solidLine];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    
    UIView *superview = self.contentView;
    
    CGFloat leftToCell = BLUThemeMargin * 3;
    CGFloat topToCell = BLUThemeMargin * 3;
    CGFloat margin = BLUThemeMargin * 3;
   
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview).offset(topToCell);
        make.left.equalTo(superview).offset(leftToCell);
        make.right.equalTo(superview).offset(-leftToCell);
    }];
    
    [_circleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(margin);
        make.left.equalTo(_titleLabel);
    }];
    
    [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superview).offset(-leftToCell);
        make.centerY.equalTo(_circleButton);
    }];
    
    [_solidLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_circleButton.mas_bottom).offset(margin);
        make.left.right.equalTo(superview);
        make.height.equalTo(@(margin));
    }];
 
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView layoutSubviews];
    self.cellSize = CGSizeMake(self.contentView.width, _solidLine.bottom);
}

- (void)setModel:(id)model {
    self.post = (BLUPost *)model;
    self.titleLabel.text = self.post.title;
    self.commentButton.title = [NSString stringWithFormat:@" %@", @(self.post.commentCount)];
    self.circleButton.title = self.post.circle.name;
}

- (void)transitToCircleAction:(id)sender {
    if ([self.circleTransitionDelegate respondsToSelector:@selector(shouldTransitToCircle:fromView:sender:)]) {
        BLUCircle *circle = self.post.circle;
        if (circle) {
            NSDictionary *circleInfo = @{BLUCircleKeyCircle: circle};
            [self.circleTransitionDelegate shouldTransitToCircle:circleInfo fromView:self sender:sender];
        }
    }
}

- (void)commentAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(postTitleCell:didCommentPost:)]) {
        if (self.post) {
            [self.delegate postTitleCell:self didCommentPost:self.post];
        }
    }
}

@end
